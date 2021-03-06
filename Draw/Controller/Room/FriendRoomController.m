//
//  FriendRoomController.m
//  Draw
//
//  Created by  on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FriendRoomController.h"
#import "ShareImageManager.h"
#import "MyFriendsController.h"
#import "SearchRoomController.h"
#import "UserManager.h"
#import "PPDebug.h"
#import "Room.h"
#import "RoomCell.h"
#import "ConfigManager.h"
#import "StringUtil.h"
#import "GameMessage.pb.h"
#import "RoomController.h"
#import "MyFriendsController.h"
#import "RoomManager.h"
#import "DeviceDetection.h"
#import "WordManager.h"

@interface FriendRoomController ()

- (void)enableMoreRow:(BOOL)enabled;
- (BOOL)isMoreRow:(NSInteger)row;
- (void)updateNoRoomTip;

@end

#define INVITE_LIMIT 20
#define FIND_ROOM_LIMIT 50
#define MORE_CELL_HEIGHT ([DeviceDetection isIPAD] ? 88 : 44)

@implementation FriendRoomController
@synthesize titleLabel;
@synthesize myFriendButton;
@synthesize noRoomTips;
@synthesize createButton;
@synthesize searchButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _userManager = [UserManager defaultManager];
        roomService = [RoomService defaultService];
        _currentStartIndex = 0;
        [self enableMoreRow:YES];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [[WordManager defaultManager] clearWordBaseDictionary];
    
}

#pragma mark - View lifecycle

- (void)updateRoomList
{
    [roomService findMyRoomsWithOffset:_currentStartIndex limit:FIND_ROOM_LIMIT delegate:self];
    [self showActivityWithText:NSLS(@"kLoading")];
}

- (void)initButtons
{
    //bg image
    ShareImageManager *manager = [ShareImageManager defaultManager];
    
    [self.createButton setBackgroundImage:[manager greenImage] forState:UIControlStateNormal];
    [self.searchButton setBackgroundImage:[manager orangeImage] forState:UIControlStateNormal];
    //text
    [self.myFriendButton setTitle:NSLS(@"kFriendControl") forState:UIControlStateNormal];
    [self.createButton setTitle:NSLS(@"kCreateRoom") forState:UIControlStateNormal];
    [self.searchButton setTitle:NSLS(@"kSearchRoom") forState:UIControlStateNormal];
    [self.titleLabel setText:NSLS(@"kFriendPlayTitle")];
    [self.noRoomTips setText:NSLS(@"kNoRoomTips")];
}

- (void)viewDidLoad
{
    [self setSupportRefreshHeader:YES];
    [super viewDidLoad];
    self.dataList = [[[NSMutableArray alloc] init]autorelease];
    [self initButtons];
    
    self.noRoomTips.hidden = YES;
    self.dataTableView.hidden = YES;
    
    [self updateRoomList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.dataTableView reloadData];
    [[DrawGameService defaultService] registerObserver:self];
    [super viewDidDisappear:animated];    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [[DrawGameService defaultService] unregisterObserver:self];
    [super viewDidDisappear:animated];    
}

- (void)viewDidUnload
{
    [self setCreateButton:nil];
    [self setSearchButton:nil];
    [self setMyFriendButton:nil];
    [self setTitleLabel:nil];
    [self setNoRoomTips:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)dealloc {
    [createButton release];
    [searchButton release];
    [myFriendButton release];
    [titleLabel release];
    [noRoomTips release];
    [super dealloc];
}

- (IBAction)clickCreateButton:(id)sender {
    RoomPasswordDialog *rDialog = [RoomPasswordDialog dialogWith:NSLS(@"kCreateRoom") delegate:self];
    NSInteger index = [[UserManager defaultManager] roomCount] + 1;
    NSString *nick = [[UserManager defaultManager]nickName];
    NSString *string = [NSString stringWithFormat:NSLS(@"kRoomNameNumber"),nick,index];
    rDialog.targetTextField.text = string;
    [rDialog showInView:self.view];
}

- (void)didClickOk:(InputDialog *)dialog targetText:(NSString *)targetText
{
    NSString *roomName = targetText;
    NSString *password = ((RoomPasswordDialog *)dialog).passwordField.text;
    [self showActivityWithText:NSLS(@"kRoomCreating")];
    [roomService createRoom:roomName password:password delegate:self];    
}

- (void)passwordIsIllegal:(NSString *)password
{
    [self popupMessage:NSLS(@"kRoomPasswordIllegal") title:nil];
}
- (void)roomNameIsIllegal:(NSString *)password
{
    [self popupMessage:NSLS(@"kRoomNameIllegal") title:nil];
}

- (void)didClickInvite:(NSIndexPath *)indexPath
{
    Room *room = [self.dataList objectAtIndex:indexPath.row];
    if (room) {
        MyFriendsController *mfc = [[MyFriendsController alloc] initWithRoom:room];
        [self.navigationController pushViewController:mfc animated:YES];
        [mfc release];
    }
}

- (IBAction)clickSearchButton:(id)sender {
    SearchRoomController *src = [[SearchRoomController alloc] init];
    [self.navigationController pushViewController:src animated:YES];
    [src release];
}

- (IBAction)clickMyFriendButton:(id)sender {
    MyFriendsController *mfc = [[MyFriendsController alloc] init];
    [self.navigationController pushViewController:mfc animated:YES];
    [mfc release];
}

- (void)didCreateRoom:(Room*)room resultCode:(int)resultCode;
{
    [self hideActivity];
    if (resultCode != 0) {
        [self popupMessage:NSLS(@"kCreateRoomFail") title:nil];
    }else{
        [self popupMessage:NSLS(@"kCreateRoomSucc") title:nil];
        if (room) {
            NSMutableArray *list = (NSMutableArray *)self.dataList;
            [list insertObject:room atIndex:0];
            [dataTableView beginUpdates];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *paths = [NSArray arrayWithObject: path];
            [self.dataTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
            [dataTableView endUpdates];
            [self didClickInvite:path];
        }
        [[UserManager defaultManager] increaseRoomCount];
    }
    [self updateNoRoomTip];
}


- (void)didRemoveRoom:(Room *)room resultCode:(int)resultCode
{
    [self hideActivity];
    if (resultCode == 0) {
        [self popupMessage:NSLS(@"kRemoveRoomSucc") title:nil];
        NSInteger row = [self.dataList indexOfObject:room];
        if (row >= 0 && row < [self.dataList count]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
            [(NSMutableArray *)self.dataList removeObject:room];
            [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else{
        [self popupMessage:NSLS(@"kRemoveRoomFail") title:nil];        
    }
    [self updateNoRoomTip];
}


- (void)didFindRoomByUser:(NSString *)userId roomList:(NSArray*)roomList resultCode:(int)resultCode
{
    [self hideActivity];
    _moreCellLoadding = NO;
    if (resultCode != 0) {
        [self popupMessage:NSLS(@"kFindRoomListFail") title:nil];
    }else{
        if (roomList != nil && [roomList count] != 0) {
            NSMutableArray *array = nil;
            if (_currentStartIndex == 0) {
                array = [NSMutableArray array];                
            }else{
                array = [NSMutableArray arrayWithArray:self.dataList];
            }
            [array addObjectsFromArray:[[RoomManager defaultManager] sortRoomList:roomList]];
            self.dataList = array;
            _currentStartIndex += [roomList count];
            [self enableMoreRow:[roomList count] > FIND_ROOM_LIMIT * 0.9];
            [self.dataTableView reloadData];
        }else{
            [self enableMoreRow:NO];
            if ([self.dataList count] == 0) {
                [self.dataTableView reloadData];
            }else{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataList count] inSection:0];
                [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    [refreshHeaderView setCurrentDate];  	
	[self dataSourceDidFinishLoadingNewData];
    [self updateNoRoomTip];
}


- (void)enableMoreRow:(BOOL)enabled
{
    _hasMoreRow = enabled;
}

- (BOOL)isMoreRow:(NSInteger)row
{
    if (_hasMoreRow == YES) {
        return [self.dataList count] == row;        
    }
    return NO;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isMoreRow:indexPath.row]) {
        return MORE_CELL_HEIGHT;
    }
	return [RoomCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [dataList count];
    if (_hasMoreRow) {
        count ++;
    }
    return count;
}

#define MORE_CELL_ACTIVITY 20120522
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isMoreRow:indexPath.row]) {
        static NSString *CellIdentifier = @"MoreRow";
        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];   
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            cell.textLabel.textColor = [UIColor grayColor];
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];;
            if ([DeviceDetection isIPAD]) {
                activity.center = CGPointMake(cell.contentView.center.x * 3.5, cell.contentView.center.y * 2);
                cell.textLabel.font = [UIFont systemFontOfSize:14 * 2];
            }else{
                activity.center = CGPointMake(cell.contentView.center.x * 1.6, cell.contentView.center.y);
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
            }                     
            activity.tag = MORE_CELL_ACTIVITY;
            activity.hidesWhenStopped = YES;
            [cell.contentView addSubview:activity];            
            [activity release];
        }
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell.contentView viewWithTag:MORE_CELL_ACTIVITY];
        if (_moreCellLoadding) {
            [activity startAnimating];
            [cell.textLabel setText:NSLS(@"kLoadMore")];
        }else
        {
            [cell.textLabel setText:NSLS(@"kMore")];
            [activity stopAnimating];
        }
        return cell;
    }else{
        NSString *CellIdentifier = [RoomCell getCellIdentifier];
        RoomCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [RoomCell createCell:self];
            cell.roomCellType = RoomCellTypeMyRoom;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        Room *room = [self.dataList objectAtIndex:indexPath.row];
        [cell setInfo:room];
        cell.indexPath = indexPath;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Room *room = [self.dataList objectAtIndex:indexPath.row];
    [roomService removeRoom:room delegate:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row > [self.dataList count])
        return;

    if ([self isMoreRow:indexPath.row]) {
        _moreCellLoadding = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataList count] inSection:0];
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self updateRoomList];
    }
    if (indexPath.row >= [self.dataList count])
        return;
    
    Room *room = [self.dataList objectAtIndex:indexPath.row];
    if (room == nil)
        return;
    
    if (_isTryJoinGame)
        return;
    
    
    [self showActivityWithText:NSLS(@"kConnectingServer")];
    [[DrawGameService defaultService] setServerAddress:room.gameServerAddress];
    [[DrawGameService defaultService] setServerPort:room.gameServerPort];    
    [[DrawGameService defaultService] connectServer:self];
    _isTryJoinGame = YES;    
    
    _currentSelectRoom = room;    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    PPDebug(@"<ScollView> contentOffset : (%f,%f)" , scrollView.contentOffset.x,scrollView.contentOffset.y);    
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    if (!_hasMoreRow || _moreCellLoadding) {
        return;
    }
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    if(y > h + MORE_CELL_HEIGHT) {
        [self tableView:dataTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[dataList count] inSection:0]];
    }
}


#pragma mark - Draw Game Service Delegate

- (void)didBroken
{
    _isTryJoinGame = NO;
    PPDebug(@"<didBroken> Friend Room");
    [self hideActivity];
    [self popupUnhappyMessage:NSLS(@"kNetworkBroken") title:@""];
    
    if (self.navigationController.topViewController != self){
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (void)didConnected
{
    [self hideActivity];
    [self showActivityWithText:NSLS(@"kJoiningGame")];
        
    NSString* userId = [_userManager userId];    
    if (userId == nil){
        _isTryJoinGame = NO;
        PPDebug(@"<didConnected> Friend Room, but user Id nil???");
        [[DrawGameService defaultService] disconnectServer];
        return;
    }
    
    if (_isTryJoinGame){
        [[DrawGameService defaultService] registerObserver:self];
        [[DrawGameService defaultService] joinFriendRoom:[_userManager userId] 
                                                  roomId:[_currentSelectRoom roomId]
                                                roomName:[_currentSelectRoom roomName]
                                                nickName:[_userManager nickName]
                                                  avatar:[_userManager avatarURL]
                                                  gender:[_userManager isUserMale]
                                                location:[_userManager location]         
                                          guessDiffLevel:[ConfigManager guessDifficultLevel]
                                             snsUserData:[_userManager snsUserData]];
    }
    
    _isTryJoinGame = NO;    
}

- (void)didJoinGame:(GameMessage *)message
{
    _currentSelectRoom.myStatus = UserJoined;
    
    [[DrawGameService defaultService] unregisterObserver:self];
    
    [self hideActivity];
    if ([message resultCode] == 0){
        [self popupHappyMessage:NSLS(@"kJoinGameSucc") title:@""];
    }
    else{
        NSString* text = [NSString stringWithFormat:NSLS(@"kJoinGameFailure")];
        [self popupUnhappyMessage:text title:@""];
        [[DrawGameService defaultService] disconnectServer];
        return;
    }
    
    [RoomController enterRoom:self isFriendRoom:YES];
}

- (void)reloadTableViewDataSource
{
    _currentStartIndex = 0;
    [self enableMoreRow:YES];
    [self updateRoomList];

}

- (void)updateNoRoomTip
{
    if ([dataList count] == 0) {
        self.dataTableView.hidden = YES;
        self.noRoomTips.hidden = NO;
    }else{
        self.dataTableView.hidden = NO;
        self.noRoomTips.hidden = YES;
    }
}


@end
