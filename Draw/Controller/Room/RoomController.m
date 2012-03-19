//
//  RoomController.m
//  Draw
//
//  Created by  on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoomController.h"
#import "DrawGameService.h"
#import "SelectWordController.h"
#import "ShowDrawController.h"
#import "GameSession.h"

@interface RoomController ()

- (void)updateGameUsers;

@end

@implementation RoomController
@synthesize startGameButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (void)viewDidAppear:(BOOL)animated
{
    [self showActivityWithText:NSLS(@"kJoining")];

    [self.startGameButton setHidden:![[DrawGameService defaultService] isMyTurn]];

    // Do any additional setup after loading the view from its nib.
    [[DrawGameService defaultService] setRoomDelegate:self];
    [[DrawGameService defaultService] joinGame];
    
    [[DrawGameService defaultService] registerObserver:self];

    [self updateGameUsers];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self hideActivity];
    [super viewDidDisappear:animated];
    [[DrawGameService defaultService] unregisterObserver:self];    
}

- (void)viewDidUnload
{
    [[DrawGameService defaultService] unregisterObserver:self];
    [self setStartGameButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateGameUsers
{
    
    [self.startGameButton setHidden:![[DrawGameService defaultService] isMyTurn]];
    
    GameSession* session = [[DrawGameService defaultService] session];
    NSArray* userList = [session userList];
    int startTag = 21;
    int endTag = 26;
    for (GameSessionUser* user in userList){
//        UIButton* button = (UIButton*)[self.view viewWithTag:startTag++];
//        [button setTitle:[user userId] forState:UIControlStateNormal];
//        button.titleLabel.numberOfLines = 2;

        UILabel* label = (UILabel*)[self.view viewWithTag:startTag++];
        [label setText:[user userId]];
        
        if ([session isHostUser:[user userId]]){
            NSString* title = [NSString stringWithFormat:@"%@ (Host)", [user userId]];
//            [button setTitle:title forState:UIControlStateNormal];
            [label setText:title];
        }
        
        if ([session isMe:[user userId]]){
            NSString* title = [NSString stringWithFormat:@"%@ (Me)", [user userId]];
            [label setText:title];
//            [button setTitle:title forState:UIControlStateNormal];
        }

        if ([session isCurrentPlayUser:[user userId]]){
            [label setTextColor:[UIColor redColor]];
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
    
    // clean all data
    for (int i=startTag; i<=endTag; i++){
//        UIButton* button = (UIButton*)[self.view viewWithTag:i];
//        [button setTitle:@"" forState:UIControlStateNormal];
        UILabel* label = (UILabel*)[self.view viewWithTag:startTag++];
        [label setText:@""];
    }
    
}

#pragma Draw Game Service Delegate

- (void)didJoinGame:(GameMessage *)message
{
    [self hideActivity];
    [UIUtils alert:@"Join Game OK!"];

    // update 
    [self updateGameUsers];
}

- (void)didStartGame:(GameMessage *)message
{
    [self hideActivity];
    [self updateGameUsers];

    SelectWordController *sw = [[SelectWordController alloc] init];
    [self.navigationController pushViewController:sw animated:YES];
    [sw release];    

}

- (void)didGameStart:(GameMessage *)message
{
    [self updateGameUsers];
    ShowDrawController *sd = [[ShowDrawController alloc] init];
    [self.navigationController pushViewController:sd animated:YES];
    [sd release];
//    SelectWordController *sw = [[SelectWordController alloc] init];
//    [self.navigationController pushViewController:sw animated:YES];
//    [sw release];    
}

- (void)didNewUserJoinGame:(GameMessage *)message
{
    [self updateGameUsers];    
}

- (void)didUserQuitGame:(GameMessage *)message
{
    [self updateGameUsers];    
}

- (IBAction)clickStart:(id)sender
{
    [self showActivityWithText:NSLS(@"kStartingGame")];
    [[DrawGameService defaultService] startGame];
    // Goto Select Word UI
}

- (IBAction)clickChangeRoom:(id)sender
{
    [self showActivityWithText:NSLS(@"kChangeRoom")];
    [[DrawGameService defaultService] changeRoom];
    
}

- (void)dealloc {
    [startGameButton release];
    [super dealloc];
}
@end
