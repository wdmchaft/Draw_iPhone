//
//  ShowDrawController.m
//  Draw
//
//  Created by  on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowDrawController.h"
#import "ShowDrawView.h"
#import "Paint.h"
#import "GameSessionUser.h"
#import "GameSession.h"
#import "Word.h"
#import "WordManager.h"
#import "LocaleUtils.h"
#import "AnimationManager.h"
#import "GameTurn.h"
#import "ResultController.h"
#import "HJManagedImageV.h"
#import "PPApplication.h"
#import "HomeController.h"
#import "DrawAction.h"
#import "StableView.h"
#import "ShareImageManager.h"
#import "RoomController.h"
#import "GameMessage.pb.h"
#import "PPDebug.h"
#import "ItemManager.h"
#import "AccountService.h"
#import "ItemShopController.h"
#import "DrawConstants.h"
#import "AudioManager.h"
#import "ConfigManager.h"
#import "CommonMessageCenter.h"


#define PAPER_VIEW_TAG 20120403
#define TOOLVIEW_CENTER (([DeviceDetection isIPAD]) ? CGPointMake(695, 920):CGPointMake(284, 424))
#define MOVE_BUTTON_FONT_SIZE (([DeviceDetection isIPAD]) ? 36.0 : 18.0)




@implementation ShowDrawController
@synthesize showView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize leftPageButton;
@synthesize rightPageButton;
@synthesize candidateString = _candidateString;
@synthesize drawBackground;
- (void)dealloc
{
    moveButton = nil;
    _shopController = nil;
    lastScaleTarget = nil;
    
    PPRelease(_candidateString);
    PPRelease(toolView);
    PPRelease(showView);
    PPRelease(scrollView);
    PPRelease(pageControl);
    PPRelease(leftPageButton);
    PPRelease(rightPageButton);
    PPRelease(drawBackground);
    [super dealloc];
}


#pragma mark - Constroction
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    self = [super init];
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [[WordManager defaultManager] clearWordBaseDictionary];
}


#pragma mark - init the buttons

#define TARGET_BASE_TAG 11
#define WRITE_BUTTON_TAG_END 18
#define CANDIDATE_BASE_TAG 21
#define CANDIDATE_END_TAG 56

#define RowNumber 2
#define CN_WORD_WIDTH (([DeviceDetection isIPAD])? 496:218) 
#define WORD_HEIGHT (([DeviceDetection isIPAD])? 75 * 2 : 75)
#define CN_WORD_FRAME (([DeviceDetection isIPAD])? CGRectMake(80, 845, CN_WORD_WIDTH, WORD_HEIGHT): CGRectMake(24, 385, CN_WORD_WIDTH, WORD_HEIGHT))
//#define CN_WORD_PAGE 2

#define EN_WORD_WIDTH (([DeviceDetection isIPAD])?  650 : 253)
#define EN_WORD_PAGE 1
#define EN_WORD_COUNT_PER_PAGE (([DeviceDetection isIPAD]) ? 16 : 14)
#define EN_WORD_FRAME (([DeviceDetection isIPAD])? CGRectMake(1*2, 845, EN_WORD_WIDTH, WORD_HEIGHT):CGRectMake(1, 385, EN_WORD_WIDTH, WORD_HEIGHT))
#define SCOROLLVIEW_SPACE (([DeviceDetection isIPAD])? 28 * 2: 28)


#define WORD_BUTTON_WIDTH (([DeviceDetection isIPAD])? 30 * 2: 30)
#define WORD_BUTTON_HEIGHT (([DeviceDetection isIPAD])? 30 * 2: 30)

#define ZOOM_SCALE 1.2

- (void)enablePageButton:(NSInteger)pageIndex
{
    leftPageButton.enabled = rightPageButton.enabled = YES;
    if (pageIndex == 0) {
        leftPageButton.enabled = NO;
    }
    if (pageIndex == pageControl.numberOfPages - 1) {
        rightPageButton.enabled = NO;
    }
}

//count is per page count, page is the total page count
- (void)resetWordButtons:(NSInteger)count page:(NSInteger)page
{
    CGFloat width = CN_WORD_WIDTH;
    CGFloat height = WORD_HEIGHT;
    if (page < 2) {
        pageControl.hidden = leftPageButton.hidden = rightPageButton.hidden = YES;
        [scrollView setFrame:EN_WORD_FRAME];       
        width = EN_WORD_WIDTH;
        height = WORD_HEIGHT;
    }else{
        [scrollView setFrame:CN_WORD_FRAME];       
        leftPageButton.hidden = rightPageButton.hidden = pageControl.hidden = NO;
        pageControl.center = CGPointMake(scrollView.center.x,scrollView.center.y + SCOROLLVIEW_SPACE);
        [self clickLeftPage:leftPageButton];
        pageControl.currentPage = 0;
        [self enablePageButton:0];
    }
    
    CGFloat contentWidth = width * page;
    [scrollView setContentSize:CGSizeMake(contentWidth, height)];
    pageControl.numberOfPages = page;
    int tag = CANDIDATE_BASE_TAG;
    for (int p = 0; p < page; ++ p) {
        CGFloat xStart = 7 + width * p;
        CGFloat yStart = 5;
        CGFloat xSpace = 5;
        CGFloat ySpace = 7;
        if ([DeviceDetection isIPAD]) {
             xStart = 7*2 + width * p;
             yStart = 5*2;
             xSpace = 20;
             ySpace = 7*2.2;
        }
        
        CGFloat x,y;
        for (int i = 0; i < count; ++ i) {
            UIButton *button = (UIButton *)[scrollView viewWithTag:tag ++];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[shareImageManager woodImage]
                              forState:UIControlStateNormal];
            
            if ([DeviceDetection isIPAD]) {
                [button.titleLabel setFont:[UIFont systemFontOfSize:18 * 2]];                
            }else{
                [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
            }
            
            x = xStart + (WORD_BUTTON_WIDTH + xSpace) * (i % (count / RowNumber));
            if (i < count / RowNumber) {
                y = yStart;
            }else{
                y = yStart + WORD_BUTTON_HEIGHT + ySpace;
            }
            button.frame = CGRectMake(x, y, WORD_BUTTON_WIDTH, WORD_BUTTON_HEIGHT);
            button.hidden = NO;
            button.enabled = NO;
        }
    }
    for (; tag <= CANDIDATE_END_TAG; ++ tag) {
        UIButton *button = (UIButton *)[scrollView viewWithTag:tag];
        [button setTitle:nil forState:UIControlStateNormal];
        button.hidden = YES;
    }
}

- (UIButton *)targetButton:(CGPoint)point
{
    
    for (int tag = TARGET_BASE_TAG; tag <= WRITE_BUTTON_TAG_END; ++ tag) {
        UIButton *button = (UIButton *)[self.view viewWithTag:tag];
        //can write
        if (button.hidden == NO && [[button titleForState:UIControlStateNormal] length] == 0) {
            //distance
            if ([DrawUtils distanceBetweenPoint:point point2:button.center] < button.frame.size.width) {
                return button;
            }
        }
    }
    return nil;
}


- (UIButton *)candidateButtonForText:(NSString *)text
{
    for (int i = 0; i < [self.candidateString length]; ++ i) {
        NSString *sub = [self.candidateString substringWithRange:NSMakeRange(i, 1)];
        if ([sub isEqualToString:text]) {
            UIButton *button = (UIButton *)[scrollView viewWithTag:CANDIDATE_BASE_TAG + i];
            if ([[button titleForState:UIControlStateNormal] length] == 0) {
                return button;
            }
        }
    }
    return nil;
}

- (void)clickWriteButton:(UIButton *)button
{
    NSString *text = [self realValueForButton:button];
    if (!_guessCorrect && [text length] != 0) {
        UIButton *pButton = [self candidateButtonForText:text];
        if (pButton) {
            [self setButton:button title:nil enabled:NO];
            [self setButton:pButton title:text enabled:YES];
        }
        
    }
}


- (NSString *)getAnswer
{
    //get the word
    NSString *answer = @"";
    NSInteger endIndex = WRITE_BUTTON_TAG_END;
    for (int i = TARGET_BASE_TAG; i <= endIndex; ++ i) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        NSString *text = [self realValueForButton:button];
        if ([text length] == 1 && ![text isEqualToString:@" "]) {
            answer = [NSString stringWithFormat:@"%@%@",answer,text];
        }
    }
    return answer;
}

- (UIButton *)getTheFirstEmptyButton
{
    NSInteger endIndex = WRITE_BUTTON_TAG_END;//(languageType == ChineseType) ? (WRITE_BUTTON_TAG_END - 1) : WRITE_BUTTON_TAG_END;
    for (int i = TARGET_BASE_TAG; i <= endIndex; ++ i) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        if (button.hidden == NO && [[button titleForState:UIControlStateNormal] length] == 0) {
            return button;
        }
    }
    return nil;
}

- (void)clickPickingButton:(UIButton *)button target:(UIButton *)target text:(NSString *)text
{
    [[AudioManager defaultManager] playSoundById:CLICK_WORD];
    if ([text length] != 0) {
        if (target) {
            [self setButton:target title:text enabled:YES];
            [self setButton:button title:nil enabled:NO];
            
            NSString *ans = [self getAnswer];
            if ([ans length] == [self.word.text length]) {
                [self commitAnswer:ans];;
            } 
        }
    }
}

- (void) dragBegan: (UIControl *) c withEvent:ev
{
    scrollView.scrollEnabled = NO;
    UIButton *bt = (UIButton *)c;
    NSString *title = [self realValueForButton:bt];
    moveButton.hidden = NO;
    [self setButton:moveButton title:title enabled:YES];
    [self setButton:bt title:nil enabled:NO];
    moveButton.center = [[[ev allTouches] anyObject] locationInView:self.view];
    
}
- (void) dragMoving: (UIControl *) c withEvent:ev
{
    moveButton.center = [[[ev allTouches] anyObject] locationInView:self.view];
    UIButton *targetButton = [self targetButton:moveButton.center];
    if (targetButton != lastScaleTarget) {
        //scale
        lastScaleTarget.layer.transform = CATransform3DMakeScale(1, 1, 1);
        targetButton.layer.transform = CATransform3DMakeScale(ZOOM_SCALE, ZOOM_SCALE, 1);
        lastScaleTarget = targetButton;
    }
}
- (void) dragEnded: (UIControl *) c withEvent:ev
{
    moveButton.center = [[[ev allTouches] anyObject] locationInView:self.view];
    CGPoint touchPoint = [[[ev allTouches] anyObject] locationInView:scrollView]; 
    NSString *title = [self realValueForButton:moveButton];
    UIButton *targetButton = [self targetButton:moveButton.center];
    UIButton *bt = (UIButton *)c;    
    
    lastScaleTarget.layer.transform = CATransform3DMakeScale(1, 1, 1);
    lastScaleTarget = nil;

    
    if (targetButton != nil) {
        [self clickPickingButton:bt target:targetButton text:title];
    }else{ 
        NSInteger distance = [DrawUtils distanceBetweenPoint:touchPoint point2:c.center];
        if(distance < c.frame.size.width / 2 && 
           (targetButton = [self getTheFirstEmptyButton]) != nil)
        {
            [self clickPickingButton:bt target:targetButton text:title];            
        }else{
            [self setButton:bt title:title enabled:YES];
        }
    }
    [self setButton:moveButton title:nil enabled:NO];
    moveButton.hidden = YES;
    scrollView.scrollEnabled = YES;
}

- (void)addDragActions:(UIButton *)button
{
    [button addTarget:self action:@selector(dragBegan:withEvent: )
     forControlEvents: UIControlEventTouchDown];
    [button addTarget:self action:@selector(dragMoving:withEvent: )
     forControlEvents: UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(dragMoving:withEvent: )
     forControlEvents: UIControlEventTouchDragOutside];
    
    [button addTarget:self action:@selector(dragEnded:withEvent: )
     forControlEvents: UIControlEventTouchUpInside | 
     UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents:UIControlEventTouchCancel];
    
}

- (void)initMoveButton
{
    moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moveButton setBackgroundImage:[UIImage imageNamed:@"wood_button.png"] forState:UIControlStateNormal];
    moveButton.hidden = YES;
    [moveButton.titleLabel setFont:[UIFont systemFontOfSize:MOVE_BUTTON_FONT_SIZE]];
    moveButton.frame = CGRectMake(0, 0, WORD_BUTTON_WIDTH, WORD_BUTTON_HEIGHT);
    moveButton.layer.transform = CATransform3DMakeScale(ZOOM_SCALE, ZOOM_SCALE, 1);
    [self.view addSubview:moveButton];
}

- (void)initCandidateButton:(UIButton *)button
{

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[shareImageManager woodImage]
                      forState:UIControlStateNormal];
    button.enabled = NO;
    button.frame = CGRectMake(0, 0, WORD_BUTTON_WIDTH, WORD_BUTTON_HEIGHT);
    [self addDragActions:button];
    
}
- (void)initWordViews
{
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    
    for (int i = CANDIDATE_BASE_TAG; i <= CANDIDATE_END_TAG; ++ i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [self initCandidateButton:button];
        [scrollView addSubview:button];
    }
    numberPerPage = EN_WORD_COUNT_PER_PAGE;
    pageCount = EN_WORD_PAGE;

    if ([[UserManager defaultManager] getLanguageType] == ChineseType) {
        GuessLevel level = [ConfigManager guessDifficultLevel];
        if(level == NormalLevel){
            numberPerPage = CN_WORD_COUNT_PER_PAGE;
            pageCount = 2;        
        }else if(level == HardLevel)
        {
            numberPerPage = CN_WORD_COUNT_PER_PAGE;
            pageCount = 3;                    
        }
    }
    [self resetWordButtons:numberPerPage page:pageCount];
    [self initMoveButton];
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (currentPage != pageControl.currentPage) {
        pageControl.currentPage = currentPage;
        [self enablePageButton:currentPage];        
    }
}


#pragma mark - Word && Word Views


- (void)updateCandidateViewsWithText:(NSString *)text
{
    self.candidateString = text;
    NSInteger tag = CANDIDATE_BASE_TAG;
    
    for (int i = 0; i < text.length; ++ i) {
        UIButton *button = (UIButton *)[scrollView viewWithTag:tag ++];
        NSString *title = [self.candidateString substringWithRange:NSMakeRange(i, 1)];
        if ([title isEqualToString:@" "]) {
            [self setButton:button title:nil enabled:NO];
        }else{
            [self setButton:button title:title enabled:YES];
        }
    }
    for (; tag <= CANDIDATE_END_TAG; ++ tag) {
        UIButton *button = (UIButton *)[scrollView viewWithTag:tag];
        [self setButton:button title:nil enabled:NO];
        button.hidden = YES;
    }
}


- (void)updateBomb
{
    toolView.number = [[ItemManager defaultManager] tipsItemAmount];
}

- (void)updateCandidateViews:(Word *)word lang:(LanguageType)lang
{
    self.word = word;
    languageType = lang;
    if (lang == EnglishType) {
        NSString *upperString = [WordManager upperText:word.text];
        self.word.text = upperString;        
    }
    NSString *text = nil;
    if (languageType == ChineseType) {
        text = [[WordManager defaultManager] randChinesStringWithWord:
                self.word count:numberPerPage * pageCount];
        [self resetWordButtons:numberPerPage page:pageCount];
    }else{
        text = [[WordManager defaultManager] randEnglishStringWithWord:
                self.word count:numberPerPage * pageCount];        
    }
    [self resetWordButtons:numberPerPage page:pageCount];
    [self updateCandidateViewsWithText:text];
}



- (void)setWordButtonsEnabled:(BOOL)enabled
{
    for (int i = TARGET_BASE_TAG; i <= WRITE_BUTTON_TAG_END; ++ i) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        [button setEnabled:enabled];
    }
    
    for (int i = CANDIDATE_BASE_TAG; i <= CANDIDATE_END_TAG; ++ i) {
        UIButton *button = (UIButton *)[scrollView viewWithTag:i];
        [button setEnabled:enabled];
    }
    [toolView setEnabled:enabled];
}

#pragma makr - Timer Handle

- (void)handleTimer:(NSTimer *)theTimer
{
    --retainCount;
    if (retainCount <= 0) {
        [self resetTimer];
        retainCount = 0;
    }
    [self updateClockButton];
}






#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [drawGameService setShowDelegate:self];
    
    [self initShowView];
    
    //init the toolView for bomb the candidate words
    [self initBomb];
    [self initWordViews];
    [self initTargetViews];
    [self initWithCachData];

    _guessCorrect = NO;
    _shopController = nil;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [self updateBomb];
    [super viewDidAppear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _shopController = nil;
}

- (void)viewDidUnload
{
    [self setClockButton:nil];
    [self setPopupButton:nil];
    [self setTurnNumberButton:nil];
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setLeftPageButton:nil];
    [self setRightPageButton:nil];
    [self setShowView:nil];
    [self setDrawBackground:nil];
    [super viewDidUnload];
    [self setWord:nil];
}


#pragma mark - Draw Game Service Delegate

- (void)didReceiveDrawWord:(NSString*)wordText level:(int)wordLevel language:(int)language
{
    if (wordText) {
        PPDebug(@"<ShowDrawController> ReceiveWord:%@", wordText);
        Word *word = [[[Word alloc] initWithText:wordText level:wordLevel]autorelease];
        [self updateTargetViews:word];
        [self updateCandidateViews:word lang:language];
        toolView.enabled = YES;
    }else{
        PPDebug(@"warn:<ShowDrawController> word is nil");
    }
}

- (void)didReceiveDrawData:(GameMessage *)message
{
    Paint *paint = [[Paint alloc] initWithGameMessage:message];
    DrawAction *action = [DrawAction actionWithType:DRAW_ACTION_TYPE_DRAW paint:paint];
    [showView addDrawAction:action play:YES];
    [paint release];
}

- (void)didReceiveRedrawResponse:(GameMessage *)message
{
    DrawAction *action = [DrawAction actionWithType:DRAW_ACTION_TYPE_CLEAN paint:nil];
    [showView addDrawAction:action play:YES];
    
}
- (void)didBroken
{
    PPDebug(@"<ShowDrawController>:didBroken");
    [self cleanData];
    [HomeController returnRoom:self];
}




#pragma mark - Observer Method/Game Process
- (void)didGameTurnGuessStart:(GameMessage *)message
{
    PPDebug(@"<ShowDrawController>didGameTurnGuessStart");
    [self startTimer];
}


- (void)didUserQuitGame:(GameMessage *)message
{
    NSString *userId = [[message notification] quitUserId];
    [self popUpRunAwayMessage:userId];
    [self adjustPlayerAvatars:userId];
    if ([self userCount] <= 1) {
        [self popupUnhappyMessage:NSLS(@"kAllUserQuit") title:nil];
    }
}
- (void)didGameTurnComplete:(GameMessage *)message
{
    PPDebug(@"<ShowDrawController>didGameTurnComplete");

    NSInteger gainCoin = [[message notification] turnGainCoins];
    [showView setShowPenHidden:YES];
    UIImage *image = [showView createImage];
    
    NSString* drawUserId = [[[drawGameService session] currentTurn] lastPlayUserId];
    NSString* drawUserNickName = [[drawGameService session] getNickNameByUserId:drawUserId];
    [self cleanData];

    ResultController *rc = [[ResultController alloc] initWithImage:image
                                                        drawUserId:drawUserId
                                                  drawUserNickName:drawUserNickName
                                                          wordText:self.word.text 
                                                             score:gainCoin
                                                           correct:_guessCorrect 
                                                         isMyPaint:NO 
                                                    drawActionList:showView.drawActionList];
    if (_shopController) {
        [_shopController.topNavigationController popToViewController:self animated:NO];
        [self.navigationController pushViewController:rc animated:NO];
    }else{
        [self.navigationController pushViewController:rc animated:YES];
    }
    [rc release]; 
    
}



#pragma mark - Common Dialog Delegate
#define SHOP_DIALOG_TAG 20120406


- (void)clickOk:(CommonDialog *)dialog
{
    //run away
    if (dialog.tag == SHOP_DIALOG_TAG) {
        ItemShopController *itemShop = [ItemShopController instance];
        [self.navigationController pushViewController:itemShop animated:YES];
        _shopController = itemShop;
    }else{
        [drawGameService quitGame];
        [HomeController returnRoom:self];
        [self cleanData];
    }
}
- (void)clickBack:(CommonDialog *)dialog
{
    
}

#pragma mark - Actions

- (void)commitAnswer:(NSString *)answer
{
    //alter if the word is correct
    if ([answer isEqualToString:self.word.text]) {
        [[CommonMessageCenter defaultCenter] postMessageWithText:NSLS(@"kGuessCorrect") delayTime:1 isHappy:YES];
        [[AudioManager defaultManager] playSoundById:BINGO];
        _guessCorrect = YES;
        [self setWordButtonsEnabled:NO];
    }else{
        [[CommonMessageCenter defaultCenter] postMessageWithText:NSLS(@"kGuessWrong") delayTime:1 isHappy:NO];
        [[AudioManager defaultManager] playSoundById:WRONG];
    }
    [drawGameService guess:answer guessUserId:drawGameService.session.userId];
}

- (void)scrollToPage:(NSInteger)pageIndex
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGRect frame = CGRectMake(width * pageIndex, 0, width, height);
    [scrollView scrollRectToVisible:frame animated:YES];        
}


- (IBAction)clickLeftPage:(id)sender {
    if (pageControl.currentPage > 0) {
        [self scrollToPage: --pageControl.currentPage];
            [self enablePageButton:pageControl.currentPage];            
    }
}

- (IBAction)clickRightPage:(id)sender {
    if (pageControl.currentPage < pageControl.numberOfPages - 1) {
        [self scrollToPage: ++pageControl.currentPage];
        [self enablePageButton:pageControl.currentPage];
    }
}
- (void)bomb:(id)sender
{
    if ([self.candidateString length] == 0) {
        return;
    }
    if ([[ItemManager defaultManager] tipsItemAmount] <= 0) {
        CommonDialog *dialog = [CommonDialog createDialogWithTitle:NSLS(@"kNoTipsItemTitle") message:NSLS(@"kNoTipsItemMessage") style:CommonDialogStyleDoubleButton delegate:self];
        dialog.tag = SHOP_DIALOG_TAG;
        [dialog showInView:self.view];
    }else{
        [self updateTargetViews:self.word];
        NSString *result  = [WordManager bombCandidateString:self.candidateString word:self.word];
        if (languageType == ChineseType && pageCount > 1 && [result length] != 0) {
            NSLog(@"result = %@",result);
            NSString *temp = [WordManager removeSpaceFromString:result];
            NSLog(@"temp = %@",temp);
            if ([temp length] == CN_WORD_COUNT_PER_PAGE) {
                leftPageButton.hidden = rightPageButton.hidden = pageControl.hidden = YES;
                [scrollView setContentSize:scrollView.bounds.size];
                result = temp;
            }
        }
        [self updateCandidateViewsWithText:result];
        [[AccountService defaultService] consumeItem:ITEM_TYPE_TIPS amount:1];
        [self updateBomb];
        toolView.enabled = NO;
    }
    
}

- (IBAction)clickRunAway:(id)sender {
    CommonDialog *dialog = [CommonDialog createDialogWithTitle:NSLS(@"kQuitGameAlertTitle") message:NSLS(@"kQuitGameAlertMessage") style:CommonDialogStyleDoubleButton delegate:self];
    [self.view addSubview:dialog];
}



- (void)initBomb
{
    toolView = [[ToolView alloc] initWithNumber:0];
    toolView.center = TOOLVIEW_CENTER;
    [self.view addSubview:toolView];
    [toolView addTarget:self action:@selector(bomb:)];
    [toolView setEnabled:NO];
    [self updateBomb];
}

- (void)initTargetViews
{
    NSInteger tag = TARGET_BASE_TAG;
    for (int i = TARGET_BASE_TAG; i <= WRITE_BUTTON_TAG_END; ++ i)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag: tag ++];
        [button addTarget:self action:@selector(clickWriteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view bringSubviewToFront:button];
        button.hidden = YES;
    }    
}
- (void)updateTargetViews:(Word *)word
{

    NSInteger tag = TARGET_BASE_TAG;
    for (int i = 0; i < word.length; ++ i)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag: tag ++];
        [self setButton:button title:nil enabled:NO];
        button.hidden = NO;
    }
    
}

- (void)initShowView
{
    showView = [[ShowDrawView alloc] initWithFrame:DRAW_VEIW_FRAME];       
    [self.view insertSubview:showView aboveSubview:drawBackground];
}




- (void)initWithCachData
{
    if (drawGameService.sessionStatus == SESSION_PLAYING) {
        
        if (drawGameService.word.text) {
            [self didReceiveDrawWord:drawGameService.word.text 
                               level:drawGameService.word.level 
                            language:drawGameService.language];
        }        
        NSArray *actionList = drawGameService.drawActionList;
        for (DrawAction *action in actionList) {
            [showView addDrawAction:action play:YES];
        }
        [self startTimer];
    }
}

- (void)setButton:(UIButton *)button title:(NSString *)title enabled:(BOOL)enabled
{
    [button setTitle:title forState:UIControlStateSelected];
    [button setEnabled:enabled];
    if (languageType == ChineseType && [LocaleUtils isTraditionalChinese]) {
        NSString *realValue = [WordManager changeToTraditionalChinese:title];
        [button setTitle:realValue forState:UIControlStateNormal];
    }else{
        [button setTitle:title forState:UIControlStateNormal];
    }
}
- (NSString *)realValueForButton:(UIButton *)button
{
    return [button titleForState:UIControlStateSelected];
}

- (IBAction)clickGroupChatButton:(id)sender {
    [super showGroupChatView];
}

@end
