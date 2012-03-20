//
//  DrawViewController.m
//  Draw
//
//  Created by gamy on 12-3-4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"
#import "DrawGameService.h"
#import "DrawColor.h"
#import "GameMessage.pb.h"
#import "Word.h"
#import "PickColorView.h"
#import "PickLineWidthView.h"
#import "GameSessionUser.h"
#import "GameSession.h"
#import "LocaleUtils.h"
#import "AnimationManager.h"

@implementation DrawViewController
@synthesize playButton;
@synthesize redButton;
@synthesize greenButton;
@synthesize blueButton;
@synthesize widthButton;
@synthesize eraserButton;
@synthesize moreButton;
@synthesize blackButton;
@synthesize guessMsgLabel;
@synthesize word = _word;
@synthesize pickColorView = _pickColorView;
@synthesize pickLineWidthView = _pickLineWidthView;

#define DRAW_TIME 59

- (void)dealloc
{
    [playButton release];
    [redButton release];
    [greenButton release];
    [blueButton release];
    [blackButton release];
    [_word release];
    [widthButton release];
    [eraserButton release];
    [moreButton release];
    [_pickLineWidthView release];
    [_pickColorView release];
    [guessMsgLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (id)initWithWord:(Word *)word
{
    self = [super init];
    if (self) {
        self.word = word; 
    }
    return self;
    
}

- (void)addPickLineWidthView
{
    self.pickLineWidthView = [[[PickLineWidthView alloc] initWithFrame:CGRectMake(100, 100, 120, 100)]autorelease];
    [self.pickLineWidthView setCenter:CGPointMake(self.widthButton.center.x, self.widthButton.center. y + 80)];
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    for (int i = 5; i < 21; i += 5) {
        NSNumber *number = [NSNumber numberWithInt:i];
        [widthArray addObject:number];
    }
    [self.pickLineWidthView setLineWidths:widthArray];
    [widthArray release];
    [self.view addSubview:self.pickLineWidthView];
    self.pickLineWidthView.delegate = self;
}


- (void)addPickColorView
{
    self.pickColorView = [[[PickColorView alloc] initWithFrame:CGRectMake(100, 100, 120, 90)]autorelease];
    [self.pickColorView setCenter:CGPointMake(self.moreButton.center.x, self.moreButton.center. y + 75)];
    NSMutableArray *colorList = [[NSMutableArray alloc] init];

    [colorList addObject:[DrawColor cyanColor]];    
    [colorList addObject:[DrawColor orangeColor]];    
    [colorList addObject:[DrawColor brownColor]];    
    [colorList addObject:[DrawColor magentaColor]];
    [colorList addObject:[DrawColor blackColor]];    
    [colorList addObject:[DrawColor magentaColor]];    
    [colorList addObject:[DrawColor orangeColor]];
    [colorList addObject:[DrawColor purpleColor]];
    [colorList addObject:[DrawColor whiteColor]];
    [colorList addObject:[DrawColor blueColor]];
    [colorList addObject:[DrawColor greenColor]];
    [colorList addObject:[DrawColor redColor]];
    
    
    [self.pickColorView setColorList:colorList];
    [colorList release];
    [self.view addSubview:self.pickColorView];
    self.pickColorView.delegate = self;
}

- (void)hidePickViews
{
    [self.pickLineWidthView setHidden:YES];
    [self.pickColorView setHidden:YES];
}

#define PLAYER_BUTTON_TAG_START 1
#define PLAYER_BUTTON_TAG_END 6

- (void)makePlayerButtons
{
    for (int i = PLAYER_BUTTON_TAG_START; i <= PLAYER_BUTTON_TAG_END; ++ i) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.hidden = YES;
    }
    int i = 1;
    GameSession *session = [[DrawGameService defaultService] session];
    for (GameSessionUser *user in session.userList) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.hidden = NO;
        [button setTitle:user.userId forState:UIControlStateNormal];
        ++ i;
    }
}

- (void)setClockTitle:(NSTimer *)theTimer
{
    NSString *title = [NSString stringWithFormat:NSLS(@"画画中(%@) %d"),self.word.text, --retainCount];
    [self setTitle:title];
    if (retainCount == 0) {
        [theTimer invalidate];
        theTimer = nil;
        [drawView setDrawEnabled:NO];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    retainCount = DRAW_TIME;
    NSString *title = [NSString stringWithFormat:NSLS(@"画画中(%@) %d"),self.word.text, retainCount];
    [self setTitle:title];
    drawTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setClockTitle:) userInfo:nil repeats:YES];
    drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 40, 320, 330)];
    [self.view addSubview:drawView];
    drawView.delegate = self;
    [drawView release];
    
    _drawGameService = [DrawGameService defaultService];
    _drawGameService.drawDelegate = self;
    
    [self addPickColorView];
    [self addPickLineWidthView];
    [self hidePickViews];
    [self.guessMsgLabel setHidden:YES];
}


- (void)viewDidUnload
{
    [self setPlayButton:nil];
    [self setRedButton:nil];
    [self setGreenButton:nil];
    [self setBlueButton:nil];
    [self setBlackButton:nil];
    [self setWord:nil];
    [self setWidthButton:nil];
    [self setEraserButton:nil];
    [self setMoreButton:nil];
    [self setPickColorView:nil];
    [self setPickLineWidthView:nil];
    [self setGuessMsgLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//- (void)alert:(NSString *)message
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLS(@"confirm") otherButtonTitles:nil];
//    [alertView show];
//    [alertView release];
//}



- (IBAction)pickColor:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == redButton) {
        [drawView setLineColor:[DrawColor redColor]];
    }else if (button == greenButton) {
        [drawView setLineColor:[DrawColor greenColor]];
    }else if (button == blueButton) {
        [drawView setLineColor:[DrawColor blueColor]];
    }else if (button == blackButton) {
        [drawView setLineColor:[DrawColor blackColor]];
    }
}

- (IBAction)clickPlay:(id)sender {
    [drawView play];
}

- (IBAction)clickRedraw:(id)sender {
    //send clean request.
    [_drawGameService cleanDraw];
    [drawView clear];
    [drawView setDrawEnabled:YES];
}

- (IBAction)clickMoreColorButton:(id)sender {

    [self.pickColorView setHidden:![self.pickColorView isHidden]];
    [self.pickLineWidthView setHidden:YES];
}

- (IBAction)clickPickWidthButton:(id)sender {
    [self.pickLineWidthView setHidden:![self.pickLineWidthView isHidden]];
    [self.pickColorView setHidden:YES];
}

- (IBAction)clickEraserButton:(id)sender {
    [drawView setLineColor:[DrawColor whiteColor]];
}



- (void)didDrawedPaint:(Paint *)paint
{
    NSInteger count = [paint pointCount];
    [self.playButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];

    NSInteger intColor  = [DrawUtils compressDrawColor:paint.color];    
    
    NSMutableArray *pointList = [[[NSMutableArray alloc] init] autorelease];
    for (NSValue *pointValue in paint.pointList) {
        CGPoint point = [pointValue CGPointValue];
        NSNumber *pointNumber = [NSNumber numberWithInt:[DrawUtils compressPoint:point]];
        [pointList addObject:pointNumber];
    }
    
    [[DrawGameService defaultService]sendDrawDataRequestWithPointList:pointList color:intColor width:paint.width];
}

- (void)didStartedTouch
{
    [self hidePickViews];
}

- (void)popUpGuessMessage:(NSString *)message
{
    [self.guessMsgLabel setText:message];
    [self.guessMsgLabel setHidden:NO];
    [self.view bringSubviewToFront:self.guessMsgLabel];
    [AnimationManager popUpView:self.guessMsgLabel fromPosition:CGPointMake(160, 335) toPosition:CGPointMake(160, 235) interval:2 delegate:self];
}

- (void)didReceiveGuessWord:(NSString*)wordText guessUserId:(NSString*)guessUserId guessCorrect:(BOOL)guessCorrect
{
    if (![_drawGameService.userId isEqualToString:guessUserId]) {
        //alert the ans;
        if (!guessCorrect) {
            [self popUpGuessMessage:[NSString stringWithFormat:NSLS(@"%@ : \"%@\""), 
                                     guessUserId, wordText]];            
        }else{
            [self popUpGuessMessage:[NSString stringWithFormat:NSLS(@"%@ guesss correct!"), 
                                     guessUserId]];
        }

    }
}
#pragma mark pick view delegate
- (void)didPickedLineWidth:(NSInteger)width
{
    [self hidePickViews];
    [drawView setLineWidth:width];
}

- (void)didPickedColor:(DrawColor *)color
{
    [self hidePickViews];
    [drawView setLineColor:color];
}

#pragma mark CAAnimation delegate
//animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.guessMsgLabel setHidden:YES];
}

@end
