//
//  RoomManager.h
//  Draw
//
//  Created by  on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Room;
@interface RoomManager : NSObject
{
    NSMutableArray *_roomList;
}

@property(nonatomic, retain)NSMutableArray *roomList;
+ (RoomManager *)defaultManager;

- (void)cleanData;
- (NSArray *)getLocalRoomList;
- (NSArray *)getMyRoomList;
- (NSArray *)getInvitedRoomList;
- (NSArray *)getJoinedRoomList;
- (Room *)paserRoom:(NSDictionary *)dict;
- (NSArray *)paserRoomList:(NSArray *)data;

@end