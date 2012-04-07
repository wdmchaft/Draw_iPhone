//
//  InputDialog.h
//  Draw
//
//  Created by  on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputDialog;
@protocol InputDialogDelegate <NSObject>

@optional
- (void)clickOk:(InputDialog *)dialog targetText:(NSString *)targetText;
- (void)clickCancel:(InputDialog *)dialog;

@end

@interface InputDialog : UIView<UITextFieldDelegate>
{
    
}

- (void)setDialogTitle:(NSString *)title;
- (void)setTargetText:(NSString *)text;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UIImageView *bgView;
@property (retain, nonatomic) IBOutlet UIButton *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *targetTextField;
@property (assign, nonatomic) id<InputDialogDelegate> delegate;

- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickOkButton:(id)sender;

+ (InputDialog *)inputDialogWith:(NSString *)title delegate:(id<InputDialogDelegate>)delegate;
- (void)showInView:(UIView *)view;

@end
