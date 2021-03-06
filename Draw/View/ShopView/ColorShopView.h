//
//  ColorShopView.h
//  Draw
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorShopCell.h"
#import "CommonDialog.h"

@class ColorGroup;
@class DrawColor;

@protocol ColorShopViewDelegate <NSObject>

@optional
- (void)didPickedColorView:(ColorView *)colorView;

@end


@interface ColorShopView : UIView<UITableViewDataSource,UITableViewDelegate,ColorShopCellDelegate,CommonDialogDelegate>
{
    NSMutableArray *colorGroups;
    ColorGroup *willBuyGroup;
    id<ColorShopViewDelegate> _delegate;
    BOOL showAnimated;
}
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *coinCountLabel;
@property (retain, nonatomic) IBOutlet UITableView *dataTableView;
@property (retain, nonatomic) NSMutableArray *colorGroups;
@property (assign, nonatomic) id<ColorShopViewDelegate> delegate;
+ (ColorShopView *)colorShopViewWithFrame:(CGRect)frame ;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (IBAction)clickBack:(id)sender;
- (void)updateBalanceLabel;

@end
