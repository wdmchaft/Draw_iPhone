//
//  UserService.h
//  Draw
//
//  Created by  on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"

@class PPViewController;

@protocol UserServiceDelegate <NSObject>

@optional
- (void)didUserRegistered:(int)resultCode;
- (void)didUserUpdated:(int)resultCode;
- (void)didSendFeedback:(int)resultCode;
- (void)didUserLogined:(int)resultCode;
@end

@interface UserService : CommonService

+ (UserService*)defaultService;

- (void)registerUser:(NSString*)email 
            password:(NSString*)password 
      viewController:(PPViewController<UserServiceDelegate>*)viewController;

- (void)registerUserWithSNSUserInfo:(NSDictionary*)userInfo 
                     viewController:(PPViewController<UserServiceDelegate>*)viewController;

- (void)updateUserAvatar:(UIImage*)avatarImage 
                nickName:(NSString*)nickName 
                  gender:(NSString*)gender
          viewController:(PPViewController<UserServiceDelegate>*)viewController;

- (void)updateUserAvatar:(UIImage*)avatarImage 
                nickName:(NSString*)nickName 
                  gender:(NSString*)gender
                password:(NSString*)password
          viewController:(PPViewController<UserServiceDelegate>*)viewController;

- (void)feedback:(NSString*)feedback 
             WithContact:(NSString*)contact  
  viewController:(PPViewController<UserServiceDelegate>*)viewController;

- (void)reportBugs:(NSString*)bugDescription 
       withContact:(NSString*)contact  
    viewController:(PPViewController<UserServiceDelegate>*)viewController;

- (void)loginUserByEmail:(NSString*)email 
                password:(NSString*)password 
          viewController:(PPViewController<UserServiceDelegate>*)viewController;
- (void)loginByDeviceWithViewController:(PPViewController*)viewController;
- (void)commitWords:(NSString*)words 
     viewController:(PPViewController<UserServiceDelegate>*)viewController;
//- (void)checkDevice;


@end
