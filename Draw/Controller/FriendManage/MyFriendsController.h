//
//  MyFriendsController.h
//  Draw
//
//  Created by haodong qiu on 12年5月8日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PPTableViewController.h"
#import "FriendService.h"
#import "FriendCell.h"
#import "RoomService.h"

@class Room;
@interface MyFriendsController : PPTableViewController <FriendServiceDelegate,FollowDelegate,RoomServiceDelegate, UIActionSheetDelegate>
{
    Room *_room;
    BOOL _isInviteFriend;
    NSMutableSet *_selectedSet;
    NSArray *_myFollowList;
    NSArray *_myFanList;

}
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *editButton;
@property (retain, nonatomic) IBOutlet UIButton *myFollowButton;
@property (retain, nonatomic) IBOutlet UIButton *myFanButton;
@property (retain, nonatomic) IBOutlet UIButton *searchUserButton;
@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UIButton *inviteButton;

@property (retain, nonatomic) NSArray *myFollowList;
@property (retain, nonatomic) NSArray *myFanList;
@property (retain, nonatomic) Room *room;

- (id)initWithRoom:(Room *)room;
- (IBAction)clickBack:(id)sender;
- (IBAction)clickMyFollow:(id)sender;
- (IBAction)clickMyFan:(id)sender;
- (IBAction)clickEdit:(id)sender;
- (IBAction)clickSearchUser:(id)sender;

@end
