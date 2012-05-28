//
//  SuperDrawViewController.m
//  Draw
//
//  Created by  on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SuperDrawViewController.h"
#import "PPDebug.h"
#import "StableView.h"
#import "GameSession.h"
#import "GameSessionUser.h"
#import "DeviceDetection.h"
#import "AnimationManager.h"
#import "WordManager.h"
#import "DrawGameService.h"
#import "ChatMessageView.h"
#import "ExpressionManager.h"
#import "GameMessage.pb.h"

@interface SuperDrawViewController ()

- (void)showChatMessageViewOnUser:(NSString*)userId message:(NSString*)message;
- (void)showChatMessageViewOnUser:(NSString*)userId title:(NSString*)title expression:(UIImage*)expression;


@end

@implementation SuperDrawViewController

@synthesize turnNumberButton;
@synthesize popupButton;
@synthesize clockButton;
@synthesize privateChatController = _privateChatController;
@synthesize groupChatController = _groupChatController;
@synthesize word = _word;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    PPRelease(_word);
    PPRelease(clockButton);
    PPRelease(popupButton);
    PPRelease(turnNumberButton);
    PPRelease(avatarArray);
    PPRelease(_privateChatController);
    PPRelease(_groupChatController);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        drawGameService = [DrawGameService defaultService];    
        avatarArray = [[NSMutableArray alloc] init];
        shareImageManager = [ShareImageManager defaultManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [drawGameService registerObserver:self];    
    [self initRoundNumber];
    [self initAvatars];
    [self initPopButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_privateChatController dismiss:NO];
    [_groupChatController dismiss:NO];
    [super viewDidDisappear:animated];
}

#pragma mark - Timer 

- (void)resetTimer
{
    if (gameTimer && [gameTimer isValid]) {
        [gameTimer invalidate];
    }
    gameTimer = nil;
    retainCount = GAME_TIME;
}
- (void)updateClockButton
{
    NSString *clockString = [NSString stringWithFormat:@"%d",retainCount];
    [self.clockButton setTitle:clockString forState:UIControlStateNormal];
}

- (void)handleTimer:(NSTimer *)theTimer
{
    
}
- (void)startTimer
{
    [self resetTimer];
    [self updateClockButton];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

#pragma mark - Avatar views

#define AVATAR_VIEW_SPACE ([DeviceDetection isIPAD] ? 36.0 * 2 : 36.0)
- (void)adjustPlayerAvatars:(NSString *)quitUserId
{
    BOOL needMove = NO;
    AvatarView *removeAvatar = nil;
    
    for (AvatarView *aView in avatarArray) {
        if ([aView.userId isEqualToString:quitUserId]) {
            needMove = YES;
            removeAvatar = aView;
        }else if (needMove) {
            aView.center = CGPointMake(aView.center.x - AVATAR_VIEW_SPACE,
                                       aView.center.y);                
        }
    }
    if (removeAvatar) {
        [removeAvatar removeFromSuperview];
        [avatarArray removeObject:removeAvatar];
    }
}

- (void)cleanAvatars
{
    //remove all the old avatars
    for (AvatarView *view in avatarArray) {
        [view removeFromSuperview];
    }
    [avatarArray removeAllObjects];
    
}
- (void)updatePlayerAvatars
{
    [self cleanAvatars];
    GameSession *session = [[DrawGameService defaultService] session];
    int i = 0;
    for (GameSessionUser *user in session.userList) {
        AvatarType type = Guesser;
        if([user.userId isEqualToString:session.drawingUserId])
        {
            type = Drawer;
        }
        BOOL gender = user.gender;

        AvatarView *aView = [[AvatarView alloc] initWithUrlString:[user userAvatar] type:type gender:gender];
        [aView setUserId:user.userId];
        aView.delegate = self;
        
        //set center
        if ([DeviceDetection isIPAD]) {
            aView.center = CGPointMake(70 * 2 + AVATAR_VIEW_SPACE * i, 22 * 2.2);            
        }else{
            aView.center = CGPointMake(70 + AVATAR_VIEW_SPACE * i, 22);
        }
        
        [self.view addSubview:aView];
        [avatarArray addObject:aView];
        [aView release];
        ++ i;                                  
    }
}


- (AvatarView *)avatarViewForUserId:(NSString *)userId
{
    for (AvatarView *view in avatarArray) {
        if ([view.userId isEqualToString:userId]) {
            return view;
        }
    }
    return nil;
}


- (NSInteger)userCount
{
    GameSession *session = [[DrawGameService defaultService] session];
    return [session.userList count];
}


#pragma mark - pop up message


- (void)popGuessMessage:(NSString *)message userId:(NSString *)userId onLeftTop:(BOOL)onLeftTop
{
    AvatarView *player = [self avatarViewForUserId:userId];

    if (player == nil) {
        return;
    }
    CGFloat x = player.frame.origin.x;
    CGFloat y = player.frame.origin.y + player.frame.size.height;
    if (onLeftTop) {
        if ([DeviceDetection isIPAD]) {
            x = 10 * 2;//player.frame.origin.x;
            y = 55 * 2;//player.frame.origin.y + player.frame.size.height;            
        }else{
            x = 10;//player.frame.origin.x;
            y = 50;//player.frame.origin.y + player.frame.size.height;                        
        }
    }
    CGSize size = [message sizeWithFont:self.popupButton.titleLabel.font];
    
    if ([DeviceDetection isIPAD]) {
        [self.popupButton setFrame:CGRectMake(x, y, size.width + 20 * 2, size.height + 15 * 2)];
    }else{
        [self.popupButton setFrame:CGRectMake(x, y, size.width + 20, size.height + 15)];
    }
    [self.popupButton setTitle:message forState:UIControlStateNormal];
    [self.popupButton setHidden:NO];
    CAAnimation *animation = [AnimationManager missingAnimationWithDuration:5];
    [self.popupButton.layer addAnimation:animation forKey:@"DismissAnimation"];
    
}

- (void)popGuessMessage:(NSString *)message userId:(NSString *)userId
{
    [self popGuessMessage:message userId:userId onLeftTop:NO];
}

- (void)popUpRunAwayMessage:(NSString *)userId
{
    NSString *nickName = [[drawGameService session] getNickNameByUserId:userId];
    NSString *message = [NSString stringWithFormat:NSLS(@"kRunAway"),nickName];
    [self popGuessMessage:message userId:userId onLeftTop:YES];
}


- (void)addScore:(NSInteger)score toUser:(NSString *)userId
{
    AvatarView *avatarView = [self avatarViewForUserId:userId];
    [avatarView setScore:score];
}

- (void)initRoundNumber
{
    [self.turnNumberButton setTitle:[NSString stringWithFormat:@"%d",drawGameService.roundNumber] forState:UIControlStateNormal];
}

- (void)initPopButton
{
    [self.popupButton setBackgroundImage:[shareImageManager popupImage] 
                                forState:UIControlStateNormal];
    self.popupButton.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:self.popupButton];
}
- (void)initAvatars
{
    [self updatePlayerAvatars];
}

- (void)cleanData
{
    [self resetTimer];
    drawGameService.showDelegate = nil;
    drawGameService.drawDelegate = nil;
    [drawGameService unregisterObserver:self];

}

- (void)didReceiveGuessWord:(NSString*)wordText 
                guessUserId:(NSString*)guessUserId 
               guessCorrect:(BOOL)guessCorrect
                  gainCoins:(int)gainCoins
{
    if (!guessCorrect) {
        if ([LocaleUtils isTraditionalChinese]) {
            wordText = [WordManager changeToTraditionalChinese:wordText];                
        }
        [self popGuessMessage:wordText userId:guessUserId]; 
    }else{
        [self popGuessMessage:NSLS(@"kGuessCorrect") userId:guessUserId];
        [self addScore:gainCoins toUser:guessUserId];
    }
}

- (void)didGameReceiveChat:(GameMessage *)message
{
    NSString* content = [[message notification] chatContent];
    GameChatType chatType = [[message notification] chatType];
    
    if (chatType == GameChatTypeChatGroup) {
        if ([content hasPrefix:EXPRESSION_CHAT]) {
            NSString *key = [content stringByReplacingOccurrencesOfString:EXPRESSION_CHAT withString:NSLS(@"")];
            UIImage *image = [[ExpressionManager defaultManager] expressionForKey:key];  
            [self showChatMessageViewOnUser:[message userId] title:nil expression:image];
            //            [self userId:[message userId] popupImage:image title:nil];
        }else if ([content hasPrefix:NORMAL_CHAT]) {
            NSString *msg = [content stringByReplacingOccurrencesOfString:NORMAL_CHAT withString:NSLS(@"")];
            [self showChatMessageViewOnUser:[message userId] message:msg];
            //            [self userId:[message userId] popupMessage:msg];
        }
    }else {
        if ([content hasPrefix:EXPRESSION_CHAT]) {
            NSString *key = [content stringByReplacingOccurrencesOfString:EXPRESSION_CHAT withString:NSLS(@"")];
            UIImage *image = [[ExpressionManager defaultManager] expressionForKey:key]; 
            [self showChatMessageViewOnUser:[message userId] title:NSLS(@"kSayToYou:") expression:image];
            //            [self userId:[message userId] popupImage:image title:NSLS(@"kSayToYou")];
        }else if ([content hasPrefix:NORMAL_CHAT]) {
            NSString *msg = [content stringByReplacingOccurrencesOfString:NORMAL_CHAT withString:NSLS(@"")];
            [self showChatMessageViewOnUser:[message userId] message:[NSString stringWithFormat:NSLS(@"kSayToYou"), msg]];
            //            [self userId:[message userId] popupMessage:[NSString stringWithFormat:NSLS(@"kSayToYou"), msg]];
        }
    }
}


- (void)didClickOnAvatar:(NSString*)userId
{
    if (userId == nil || [[UserManager defaultManager] isMe:userId]) {
        return;
    }
    
    if (_privateChatController == nil) {
        _privateChatController = [[ChatController alloc] initWithChatType:GameChatTypeChatPrivate];
        _privateChatController.chatControllerDelegate = self;
    }
    [_privateChatController showInView:self.view messagesType:GameMessages selectedUserId:userId needAnimation:YES];
}

- (void)showGroupChatView
{
    if (_groupChatController == nil) {
        _groupChatController = [[ChatController alloc] initWithChatType:GameChatTypeChatGroup];
        _groupChatController.chatControllerDelegate = self;
    }
    [_groupChatController showInView:self.view messagesType:GameMessages selectedUserId:nil needAnimation:YES];
}

- (void)didSelectMessage:(NSString*)message toUser:(NSString *)userNickName
{
    NSString *string = [[NSString stringWithFormat:NSLS(@"kSayToXXX"), userNickName] stringByAppendingFormat:message];
    [self showChatMessageViewOnUser:[[DrawGameService defaultService] userId] message:string];
}

- (void)didSelectExpression:(UIImage*)expression toUser:(NSString *)userNickName
{
    NSString *title = [NSString stringWithFormat:NSLS(@"kSayToXXX"), userNickName];
    [self showChatMessageViewOnUser:[[DrawGameService defaultService] userId] title:title expression:expression];
}

- (void)showChatMessageViewOnUser:(NSString*)userId message:(NSString*)message
{
    AvatarView *player = [self avatarViewForUserId:userId];
    CGPoint origin = CGPointMake(player.frame.origin.x, player.frame.origin.y+player.frame.size.height);
    [ChatMessageView showMessage:message origin:origin superView:self.view];
}

- (void)showChatMessageViewOnUser:(NSString*)userId title:(NSString*)title expression:(UIImage*)expression
{
    AvatarView *player = [self avatarViewForUserId:userId];
    CGPoint origin = CGPointMake(player.frame.origin.x, player.frame.origin.y+player.frame.size.height);
    [ChatMessageView showExpression:expression title:title origin:origin superView:self.view];
}

@end
