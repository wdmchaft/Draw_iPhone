//
//  GameTurn.m
//  Draw
//
//  Created by  on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameTurn.h"

@implementation GameTurn

@synthesize round = _round;
@synthesize playResultList = _playResultList;
@synthesize userCommentList = _userCommentList;
@synthesize drawActionList = _drawActionList;
@synthesize currentPlayUserId = _currentPlayUserId;
@synthesize nextPlayUserId = _nextPlayUserId;

- (void)dealloc
{
    [_currentPlayUserId release];
    [_nextPlayUserId release];
    [_playResultList release];
    [_userCommentList release];
    [_drawActionList release];
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[round=%d, currentPlayUserId=%@, nextPlayUserId=%@]",
            _round, _currentPlayUserId, _nextPlayUserId];
}

@end