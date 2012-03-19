//
//  RoomController.h
//  Draw
//
//  Created by  on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "DrawGameService.h"

@interface RoomController : PPViewController<DrawGameServiceDelegate>

- (IBAction)clickStart:(id)sender;
- (IBAction)clickChangeRoom:(id)sender;

@end
