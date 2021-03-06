//
//  StableView.h
//  Draw
//
//  Created by  on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJManagedImageV;

@interface ToolView : UIButton
{
    NSInteger _number;
    UIButton *numberButton;
}
- (id)initWithNumber:(NSInteger)number;
- (void)setNumber:(NSInteger)number;
- (NSInteger)number;
- (void)addTarget:(id)target action:(SEL)action;
- (void)decreaseNumber;
- (void)setEnabled:(BOOL)enabled;

@end

typedef enum {
    Drawer = 1,
    Guesser = 2,
}AvatarType;


@protocol AvatarViewDelegate <NSObject>

@optional
- (void)didClickOnAvatar:(NSString*)userId;

@end


@interface AvatarView : UIView
{
    NSInteger _score;
    UIButton *markButton;
    AvatarType type;
    HJManagedImageV *imageView;
    NSString *_userId;
    UIImageView *bgView;
}

- (void)setUrlString:(NSString *)urlString;
- (id)initWithUrlString:(NSString *)urlString type:(AvatarType)aType gender:(BOOL)gender;
- (id)initWithUrlString:(NSString *)urlString frame:(CGRect)frame gender:(BOOL)gender;

- (void)setImage:(UIImage *)image;
- (void)setAvatarFrame:(CGRect)frame;
- (void)setAvatarUrl:(NSString *)url gender:(BOOL)gender;
- (void)setAvatarSelected:(BOOL)selected;
@property(nonatomic, assign) NSInteger score;
@property(nonatomic, retain) NSString *userId;
@property(nonatomic, assign) id<AvatarViewDelegate> delegate;
@property(nonatomic, assign) BOOL hasPen;

@end

