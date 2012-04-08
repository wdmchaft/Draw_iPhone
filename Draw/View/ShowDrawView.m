//
//  DrawView.m
//  Draw
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowDrawView.h"
#import "Paint.h"
#import "DrawColor.h"
#import "DrawUtils.h"
#import "DrawAction.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageExt.h"
#import "UIImageUtil.h"


#define DEFAULT_PLAY_SPEED (1/40.0)
#define DEFAULT_SIMPLING_DISTANCE (5.0)
#define DEFAULT_LINE_WIDTH (4.0 * 1.414)

@implementation ShowDrawView
@synthesize playSpeed= _playSpeed;
@synthesize delegate = _delegate;
@synthesize drawActionList = _drawActionList;
@synthesize status = _status;
@synthesize gifFrameArray = _gifFrameArray;
@synthesize shouldCreateGif =  _shouldCreateGif;
#pragma mark Action Funtion


- (DrawAction *)playingAction
{
    if (playingActionIndex >= 0 && playingActionIndex < [self.drawActionList count]) {
        return [self.drawActionList objectAtIndex:playingActionIndex];
    }
    return nil;
}

- (void)cleanAllActions
{
    [self.drawActionList removeAllObjects];
    [self setStatus:Stop];
    playingActionIndex = 0;
    playingPointIndex = 0;
    startPlayIndex = 0;
    [self setNeedsDisplay];    
}


- (void)playFromDrawActionIndex:(NSInteger)index
{
    playingActionIndex = index;
    playingPointIndex = 0;
    self.status = Playing;
    [self setNeedsDisplay];
}

- (void)play
{
    [self playFromDrawActionIndex:0];
    
    int frameCount = [_drawActionList count];
    if (frameCount > 200) {
        for (int index = 0; index < 200; index ++) {
            int j = frameCount*index/200;
            NSNumber* sholudPlayIndex = [NSNumber numberWithInt:j];
            [_indexShouldSave addObject:sholudPlayIndex];
        }
    } else {
        for (int index = 0; index < frameCount; index ++) {
            NSNumber* sholudPlayIndex = [NSNumber numberWithInt:index];
            [_indexShouldSave addObject:sholudPlayIndex];
        }
    }
}


- (void)addDrawAction:(DrawAction *)action play:(BOOL)play
{
    if (play) {
        [self.drawActionList addObject:action];
        if (self.status == Playing) {
            return;
        }else{
            [self playFromDrawActionIndex:[self.drawActionList count] -1];
        }
    }else{
        [self.drawActionList addObject:action];
        [self setNeedsDisplay];
    }
}


#pragma mark function called by player

- (void)cleanFrame:(NSTimer *)theTimer
{
    self.status = Stop;
    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayDrawView)]) {
        [self.delegate didPlayDrawView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayDrawView:)]) {
        [self.delegate didPlayDrawView:self.gifFrameArray];
    }
}

- (void)nextFrame:(NSTimer *)theTimer;
{   
    
    DrawAction *currentAction = [self playingAction];
    playingPointIndex ++;
    if (playingPointIndex < [currentAction pointCount]) {
        //can play this action
    }else{
        //play next action
        playingPointIndex = 0;
        playingActionIndex ++;
        if (_shouldCreateGif && playingActionIndex%2 == 0) {
            UIImage* frame = [[self createImage] imageByScalingAndCroppingForSize:CGSizeMake(self.frame.size.width/2, self.frame.size.height/2)];
            [self.gifFrameArray addObject:frame];
            NSLog(@"creating frame %d size= %d", self.gifFrameArray.count, [(NSData*)UIImageJPEGRepresentation(frame, 1.0) length]);
        }
        if ([self.drawActionList count] > playingActionIndex) {
        }else{
            //illegal
            _status = Stop;
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayDrawView)]) {
                [self.delegate didPlayDrawView];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayDrawView:)]) {
                [self.delegate didPlayDrawView:self.gifFrameArray];
            }
            return;
        }
    }
    [self setNeedsDisplay];
    
    
    
}



#pragma mark Constructor & Destructor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = Stop;
        self.playSpeed = DEFAULT_PLAY_SPEED;
        _drawActionList = [[NSMutableArray alloc] init];
        _gifFrameArray = [[NSMutableArray alloc] init];
        _indexShouldSave = [[NSMutableSet alloc] init];
          self.backgroundColor = [UIColor whiteColor];      
    }
    return self;
}

- (void)dealloc
{
    [_drawActionList release];
    [_gifFrameArray release];
    [_indexShouldSave release];
    [super dealloc];
}

- (NSInteger)lastCleanActionIndex
{
    int i = 0, ans = -1;
    for (DrawAction *action in self.drawActionList) {
        if (action.type == DRAW_ACTION_TYPE_CLEAN) {
            ans = i;
        }
        ++ i;
    }
    return  ans;
}


#pragma mark drawRect

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextSetLineCap(context, kCGLineCapRound);

    for (int j = startPlayIndex; j < self.drawActionList.count; ++ j) {
        
        DrawAction *drawAction = [self.drawActionList objectAtIndex:j];
        if (drawAction.type == DRAW_ACTION_TYPE_DRAW) { //if is draw action 
            Paint *paint = drawAction.paint;
            CGContextSetStrokeColorWithColor(context, paint.color.CGColor);
            CGContextSetLineWidth(context, paint.width);
            for (int i = 0; i < [paint pointCount]; ++ i) {
                CGPoint point = [paint pointAtIndex:i];
                if ([paint pointCount] == 1) {
                    //if tap gesture, draw a circle
                    CGContextSetFillColorWithColor(context, paint.color.CGColor);
                    CGFloat r = paint.width / 2;
                    CGFloat x = point.x - r;
                    CGFloat y = point.y - r;
                    CGFloat width = paint.width;
                    CGRect rect = CGRectMake(x, y, width, width);
                    CGContextFillEllipseInRect(context, rect);
                }else{
                    //if is pan gesture, draw a line.
                    if (i == 0) {
                        CGContextMoveToPoint(context, point.x, point.y);   
                    }else{
                        CGContextAddLineToPoint(context, point.x, point.y);
                        CGContextSetLineJoin(context, kCGLineJoinRound);
                    }
                }
                //if is playing then play the next frame
                if (self.status == Playing && j == playingActionIndex && i == playingPointIndex) {
                    CGContextStrokePath(context);            
                    _playTimer = [NSTimer scheduledTimerWithTimeInterval:_playSpeed target:self selector:@selector(nextFrame:) userInfo:nil repeats:NO];
                    return;
                }
            }
        }else{ // if is clean action 
            //if is playing then play the next frame
            //is the last action
            startPlayIndex = j + 1;
            if (playingActionIndex == [self.drawActionList count] - 1) {
                _playTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(cleanFrame:) userInfo:nil repeats:NO];
            }else{
                if (self.status == Playing && j == playingActionIndex) {
                    CGContextStrokePath(context);            
                    _playTimer = [NSTimer scheduledTimerWithTimeInterval:_playSpeed target:self selector:@selector(nextFrame:) userInfo:nil repeats:NO];
                    return;
                }
            }
        }
        CGContextStrokePath(context); 
    }
}


- (UIImage*)createImage
{
    CGRect rect = self.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
