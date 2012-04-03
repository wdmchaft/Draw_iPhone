//
//  CommonDialog.m
//  Draw
//
//  Created by  on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonDialog.h"
#import "AnimationManager.h"
#import "ShareImageManager.h"
#import "LocaleUtils.h"
#define RUN_OUT_TIME 0.2
#define RUN_IN_TIME 0.4

@implementation CommonDialog
@synthesize contentView = _contentView;
@synthesize oKButton = _OKButton;
@synthesize backButton = _backButton;
@synthesize messageLabel = _messageLabel;
@synthesize titleLabel = _titleLabel;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_contentView release];
    [_OKButton release];
    [_backButton release];
    [_messageLabel release];
    [_titleLabel release];
    [super dealloc];
}

- (void)initTitles
{

}

- (void)initButtonsWithStyle:(CommonDialogStyle)aStyle
{
    switch (aStyle) {
        case CommonDialogStyleSingleButton: {
            [self.oKButton setFrame:CGRectMake(self.oKButton.frame.origin.x, self.oKButton.frame.origin.y, self.oKButton.frame.size.width*2, self.oKButton.frame.size.height)];
            [self.oKButton setCenter:CGPointMake(self.contentView.center.x, self.oKButton.frame.origin.y)];
            [self.backButton setHidden:YES];
        }
            break;
        case CommonDialogStyleDoubleButton: {
            
        }
            break;
        default:
            break;
    }
}

+ (CommonDialog *)createDialogWithStyle:(CommonDialogStyle)aStyle
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommonDialog" owner:self options:nil];
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <CommonDialog> but cannot find cell object from Nib");
        return nil;
    }
    CommonDialog* view =  (CommonDialog*)[topLevelObjects objectAtIndex:0];
    [view initButtonsWithStyle:aStyle];
    [view initTitles];
    CAAnimation *runIn = [AnimationManager scaleAnimationWithFromScale:0.1 toScale:1 duration:RUN_IN_TIME delegate:view removeCompeleted:NO];
    [view.contentView.layer addAnimation:runIn forKey:@"runIn"];
    
    //init the button
    ShareImageManager *imageManager = [ShareImageManager defaultManager];
    [view.backButton setBackgroundImage:[imageManager greenImage] forState:UIControlStateNormal];
    [view.oKButton setBackgroundImage:[imageManager redImage] forState:UIControlStateNormal];
    [view.backButton setTitle:NSLS(@"kCancel") forState:UIControlStateNormal];
    [view.oKButton setTitle:NSLS(@"kOK") forState:UIControlStateNormal];
    return view;
    
}

+ (CommonDialog *)createDialogWithTitle:(NSString *)title message:(NSString *)message style:(CommonDialogStyle)aStyle deelegate:(id<CommonDialogDelegate>)aDelegate
{
    CommonDialog* view = [CommonDialog createDialogWithStyle:aStyle];
    view.delegate = aDelegate;
    [view setTitle:title];
    [view setMessage:message];
    return view;
    
}

- (void)setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}
- (void)setMessage:(NSString *)message
{
    [self.messageLabel setText:message];
}

- (IBAction)clickOk:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickOk:)]) {
        [_delegate clickOk:self];
    }
    CAAnimation *runOut = [AnimationManager scaleAnimationWithFromScale:1 toScale:0.1 duration:RUN_OUT_TIME delegate:self removeCompeleted:NO];
    [runOut setValue:@"runOut" forKey:@"AnimationKey"];
    [_contentView.layer addAnimation:runOut forKey:@"runOut"];
}

- (IBAction)clickBack:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickBack:)]) {
        [_delegate clickBack:self];
    }
    CAAnimation *runOut = [AnimationManager scaleAnimationWithFromScale:1 toScale:0.1 duration:RUN_OUT_TIME delegate:self removeCompeleted:NO];
    [runOut setValue:@"runOut" forKey:@"AnimationKey"];
    [_contentView.layer addAnimation:runOut forKey:@"runOut"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString* value = [anim valueForKey:@"AnimationKey"];
    if ([value isEqualToString:@"runOut"]) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
