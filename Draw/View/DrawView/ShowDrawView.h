//
//  DrawView.h
//  Draw
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawUtils.h"
#import "Paint.h"

typedef enum{
    Stop = 0x1,
    Playing = 0x1 << 1 
}DrawViewStatus;

@class ShowDrawView;
@protocol ShowDrawViewDelegate <NSObject>

@optional
- (void)didPlayDrawView:(ShowDrawView *)showDrawView;
- (void)didPlayDrawView:(ShowDrawView *)showDrawView AtActionIndex:(NSInteger)actionIndex pointIndex:(NSInteger)pointIndex;


@end

@class DrawColor;
@class DrawAction;
@class PenView;

@interface ShowDrawView : UIView
{
    NSMutableArray *_drawActionList;
    NSTimer *_playTimer;
    NSInteger playingActionIndex;
    NSInteger playingPointIndex;
    NSInteger startPlayIndex;
    BOOL _showPenHidden;
    PenView *pen;
}

@property (nonatomic, retain) NSMutableArray *drawActionList;
@property(nonatomic, assign) CGFloat playSpeed; //default is 1/40.0;
@property(nonatomic, assign) id<ShowDrawViewDelegate>delegate;
@property(nonatomic, assign) NSInteger status;

- (void)playFromDrawActionIndex:(NSInteger)index;
- (void)play;
- (UIImage *)createImage;
- (UIImage *)createImageWithScale:(CGFloat)scale;
- (void)addDrawAction:(DrawAction *)action play:(BOOL)play;
- (void)cleanAllActions;
- (BOOL)isViewBlank;
- (void)setShowPenHidden:(BOOL)showPenHidden;
- (BOOL)isShowPenHidden;
@end
