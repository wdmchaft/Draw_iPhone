//
//  DrawView.m
//  Draw
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"
#import "Paint.h"
#import "DrawColor.h"
#import "DrawUtils.h"
#import <QuartzCore/QuartzCore.h>


#define DEFAULT_PLAY_SPEED (1/40.0)
#define DEFAULT_SIMPLING_DISTANCE (5.0)
#define DEFAULT_LINE_WIDTH (4.0 * 1.414)

@implementation DrawView
@synthesize drawEnabled = _drawEnable;
@synthesize paintList = _paintList;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize status = _status;
@synthesize playSpeed= _playSpeed;
@synthesize delegate = _delegate;
@synthesize simplingDistance = _simplingDistance;
#pragma mark Action Funtion

- (void)printListCount:(NSTimer *)theTimer
{
    if (self.paintList) {
        if (theTimer) {
            NSLog(@"from timer paintList count is %d", [self.paintList count]);                    
        }else{
            NSLog(@"NOT from timer paintList count is %d", [self.paintList count]);                    
        }

    }else
    {
        NSLog(@"paintList is null");
    }
    
}

- (void)clear
{
    [self.paintList removeAllObjects];
//    [self setDrawEnabled:YES];
    _status = Unplaying;
    [self setNeedsDisplay];
}

- (void)playFromPaintIndex:(NSInteger)index
{
    _status = Playing;
    _paintPosition = CGPointMake(index, -1);
    [self setDrawEnabled:NO];

    _playTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(nextFrame:) userInfo:nil repeats:NO];
}

- (void)play
{
    [self playFromPaintIndex:0];
}

- (void)addPaint:(Paint *)paint play:(BOOL)play
{
    if (play) {
        [self.paintList addObject:paint];
        if (self.status == Playing) {
            return;
        }
        [self playFromPaintIndex:[self.paintList count] - 1];
    }else{
        [self.paintList addObject:paint];
        [self setNeedsDisplay];
    }
}

- (NSInteger)lastPaintPointCount
{
    Paint *paint = [self.paintList lastObject];
    if (paint) {
        return [paint pointCount];
    }
    return 0;
}

#pragma mark function called by player

- (CGPoint)pointForPaintPosition:(CGPoint)position
{
    NSInteger x = position.x;
    NSInteger y = position.y;
    if (x < 0 || x >= [self.paintList count]) {
        return ILLEGAL_POINT;
    }
    Paint *paint = [self.paintList objectAtIndex:x];
    if (y < 0 || y >= [paint pointCount]) {
        return ILLEGAL_POINT;
    }
    return [paint pointAtIndex:y];
}

- (BOOL)increasePaintPosition
{
    NSInteger x = _paintPosition.x;
    NSInteger y = _paintPosition.y;
    if (x < [self.paintList count]) {
        Paint *paint = [self.paintList objectAtIndex:x];
        if (y < [paint pointCount]) {
            _paintPosition.y ++;
            NSInteger count = [paint pointCount];
            if (_paintPosition.y == count) {
                _paintPosition.y = 0;
                _paintPosition.x ++;
            }
            if (_paintPosition.x == [_paintList count]) {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

- (void)nextFrame:(NSTimer *)theTimer;
{
    CGPoint lastPoint = [self pointForPaintPosition:_paintPosition];
    BOOL flag = [self increasePaintPosition];
    if (!flag) {
        [theTimer invalidate];
        theTimer = nil;
        _status = Unplaying;
        return;
    }
    CGPoint currentPoint = [self pointForPaintPosition:_paintPosition];
    if (![DrawUtils isIllegalPoint:lastPoint] && ![DrawUtils isIllegalPoint:currentPoint]) {
        CGRect rect = [DrawUtils constructWithPoint1:lastPoint point2:currentPoint];
        [self setNeedsDisplayInRect:rect];
    }
    [self setNeedsDisplay];
}

- (void)setDrawEnabled:(BOOL)drawEnabled
{
    pan.enabled = drawEnabled;
    tap.enabled = drawEnabled;
}

#pragma mark Gesture Handler
- (void)addPoint:(CGPoint)point toPaint:(Paint *)paint
{
//    [self printListCount:nil];

    if (paint) {
        point.x = MAX(point.x, 0);
        point.y = MAX(point.y, 0);
        point.x = MIN(point.x, self.bounds.size.width);
        point.y = MIN(point.y, self.bounds.size.height);

        CGPoint lastPoint = ILLEGAL_POINT;
        if ([self.paintList count] != 0) {
            
            Paint *paint = [self.paintList lastObject];
            NSInteger index = paint.pointCount - 1;
            if (index >= 0) {
                lastPoint = [paint pointAtIndex:index];
                if ([DrawUtils distanceBetweenPoint:lastPoint point2:point] <= _simplingDistance) {
                    return;
                }
            }
            
        }

        [paint addPoint:point];   
        if (![DrawUtils isIllegalPoint:lastPoint]) {
            CGRect rect = [DrawUtils constructWithPoint1:lastPoint point2:point edgeWidth:_lineWidth];        
            [self setNeedsDisplayInRect:rect];
        }else{
            [self setNeedsDisplay];
        }
        
    }

}

- (void) performPan:(UIPanGestureRecognizer *)panGestuereReconizer
{
    CGPoint point = [panGestuereReconizer locationInView:self];
    if (panGestuereReconizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didStartedTouch)]) {
            [self.delegate didStartedTouch];
        }
        currentPaint = [[Paint alloc] initWithWidth:self.lineWidth color:self.lineColor];
        [self.paintList addObject:currentPaint];
        [currentPaint release];
        [self addPoint:point toPaint:currentPaint];

    }else if(panGestuereReconizer.state == UIGestureRecognizerStateChanged)
    {
        [self addPoint:point toPaint:currentPaint];

    }else if(panGestuereReconizer.state == UIGestureRecognizerStateEnded)
    {
        [self addPoint:point toPaint:currentPaint];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDrawedPaint:)]) {
            [self.delegate didDrawedPaint:currentPaint];
        }

    }
}

- (void) performTap:(UITapGestureRecognizer *)tapGestuereReconizer
{
    
    if(tapGestuereReconizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didStartedTouch)]) {
            [self.delegate didStartedTouch];
        }
        CGPoint point = [tapGestuereReconizer locationInView:self];
        currentPaint = [[Paint alloc] initWithWidth:self.lineWidth color:self.lineColor];
        [self.paintList addObject:currentPaint];
        [currentPaint release];
        [self addPoint:point toPaint:currentPaint];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDrawedPaint:)]) {
            [self.delegate didDrawedPaint:currentPaint];
        }
    }
}

#pragma mark Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (gestureRecognizer.view == self);
}



#pragma mark Constructor & Destructor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _status = Unplaying;
        self.lineColor = [DrawColor blackColor];
        self.lineWidth = DEFAULT_LINE_WIDTH;
        self.simplingDistance = DEFAULT_SIMPLING_DISTANCE;
        self.playSpeed = DEFAULT_PLAY_SPEED;
        _paintList = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        
        //add gesture recognizer;
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPan:)];
        [self addGestureRecognizer:pan];
        [pan release];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performTap:)];
        [self addGestureRecognizer:tap];
        [tap release];
        
        [self setDrawEnabled:YES];
        
    }
    
//    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(printListCount:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)dealloc
{
    [_paintList release];
    [_lineColor release];
    [super dealloc];
}



#pragma mark drawRect

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextSetLineCap(context, kCGLineCapRound);

    int k = 0;
    for (Paint *paint in self.paintList) {
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
            if (self.status == Playing && k == _paintPosition.x && i == _paintPosition.y) {
                CGContextStrokePath(context);            
                _playTimer = [NSTimer scheduledTimerWithTimeInterval:_playSpeed target:self selector:@selector(nextFrame:) userInfo:nil repeats:NO];
                return;
            }
        }
        
        CGContextStrokePath(context);            
        ++ k;

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
