//
//  DrawDataService.h
//  Draw
//
//  Created by haodong qiu on 12年5月16日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "CommonService.h"
#import "PPViewController.h"

@protocol  DrawDataServiceDelegate<NSObject>

@optional
- (void)didFindRecentDraw:(NSArray *)remoteDrawDataList result:(int)resultCode;

@end


@interface DrawDataService : CommonService

+ (DrawDataService *)defaultService;

- (void)findRecentDraw:(PPViewController<DrawDataServiceDelegate>*)viewController;

@end
