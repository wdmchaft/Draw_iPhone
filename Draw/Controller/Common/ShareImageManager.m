//
//  ShareImageManager.m
//  Draw
//
//  Created by  on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareImageManager.h"
#import "UIImageUtil.h"
#import "LocaleUtils.h"

@implementation ShareImageManager

static ShareImageManager* _defaultManager;
static UIImage* _woodButtonImage;
static UIImage* _orangeButtonImage;
static UIImage* _greenButtonImage;
static UIImage* _redButtonImage;
static UIImage *_buyButtonImage;
static UIImage* _showcaseBackgroundImage;
static UIImage* _whitePaperImage;

+ (ShareImageManager*)defaultManager
{
    if (_defaultManager == nil){
        _defaultManager = [[ShareImageManager alloc] init];
    }
    
    return _defaultManager;
}

- (UIImage*)woodImage
{
    if (_woodButtonImage == nil){        
        _woodButtonImage = [[UIImage strectchableImageName:@"wood_button.png"] retain];
    }
    
    return _woodButtonImage;
}

- (UIImage*)greenImage
{
    if (_greenButtonImage == nil){        
        _greenButtonImage = [[UIImage strectchableImageName:@"green_button.png"] retain];
    }
    
    return _greenButtonImage;    
}

- (UIImage*)redImage
{
    if (_redButtonImage == nil){        
        _redButtonImage = [[UIImage strectchableImageName:@"red_button.png"] retain];
    }
    
    return _redButtonImage;    
}


- (UIImage*)orangeImage
{
    if (_orangeButtonImage == nil){        
        _orangeButtonImage = [[UIImage strectchableImageName:@"orange_button.png"] retain];
    }
    
    return _orangeButtonImage;    
}

- (UIImage *)buyButtonImage
{
    if(_buyButtonImage == nil)
    {
        _buyButtonImage = [[UIImage strectchableImageName:@"buybutton.png"] retain];
    }
    return _buyButtonImage;
}

- (UIImage *)savePercentImage
{
    return [UIImage strectchableImageName:@"mumber.png"];
}

- (UIImage*)showcaseBackgroundImage
{
    if (_showcaseBackgroundImage == nil) {
        _showcaseBackgroundImage = [[UIImage strectchableImageName:SHOWCASE_BACKGROUND]retain];
    }
    return _showcaseBackgroundImage;
}

- (UIImage *)whitePaperImage
{
    if (_whitePaperImage == nil) {
        _whitePaperImage = [[UIImage strectchableImageName:@"white_paper.png"]retain];
//        _whitePaperImage = [[UIImage strectchableImageName:@"white_paper.png" topCapHeight:40]retain];
    }
    return _whitePaperImage;
}

- (UIImage *)inputImage
{
    return [UIImage strectchableImageName:@"inputbg.png"];
}

- (UIImage *)pickEasyWordCellImage
{
    return [UIImage imageNamed:WORD_EASY_CELL_BACKGROUND];
}
- (UIImage *)pickNormakWordCellImage
{
    return [UIImage imageNamed:WORD_NORMAL_CELL_BACKGROUND];    
}
- (UIImage *)pickHardWordCellImage
{
    return [UIImage imageNamed:WORD_HARD_CELL_BACKGROUND];
}

- (UIImage *)avatarSelectImage
{
    return [UIImage strectchableImageName:@"user_pic_bgselected.png"];
}

- (UIImage *)avatarUnSelectImage
{
    return [UIImage strectchableImageName:@"user_picbg.png"];
}

- (UIImage *)coinImage
{
    return [UIImage imageNamed:@"coin.png"];
}
- (UIImage *)toolImage
{
    return [UIImage imageNamed:@"tool.png"];
}

- (UIImage *)toolNumberImage
{
    return [UIImage strectchableImageName:@"number.png"];
}

- (UIImage*)maleDefaultAvatarImage
{
    return [LocaleUtils isChina] ? [UIImage imageNamed:@"man1.png"] : [UIImage imageNamed:@"man2.png"];
}

- (UIImage*)femaleDefaultAvatarImage
{
    return [LocaleUtils isChina] ? [UIImage imageNamed:@"female1.png"] : [UIImage imageNamed:@"female2.png"];
}

#pragma makr - Color Image

//- (UIImage *)redColorImage
//{
//    return [UIImage imageNamed:@"red_color.png"];
//}
//- (UIImage *)blueColorImage
//{
//    return [UIImage imageNamed:@"blue_color.png"];    
//}
//- (UIImage *)yellowColorImage
//{
//    return [UIImage imageNamed:@"yellow_color.png"];    
//}
//- (UIImage *)blackColorImage
//{
//    return [UIImage imageNamed:@"black_color.png"];    
//}
//
//- (UIImage *)orangeColorImage
//{
//    return [UIImage imageNamed:@"orange_color.png"];    
//}
//- (UIImage *)greenColorImage
//{
//    return [UIImage imageNamed:@"green_color.png"];    
//}
//- (UIImage *)pinkColorImage
//{
//    return [UIImage imageNamed:@"pink_color.png"];    
//}
//- (UIImage *)brownColorImage
//{
//    return [UIImage imageNamed:@"brown_color.png"];    
//}
//- (UIImage *)skyColorImage
//{
//    return [UIImage imageNamed:@"sky_color.png"];    
//}
//- (UIImage *)whiteColorImage
//{
//    return [UIImage imageNamed:@"white_color.png"];    
//}


- (UIImage *)addColorImage
{
    return [UIImage imageNamed:@"add_color.png"];        
}

- (UIImage *)popupImage
{
    return [UIImage strectchableImageName:@"guess_popup.png" leftCapWidth:20];
}

- (UIImage *)popupChatImageLeft
{
    return [UIImage strectchableImageName:@"message_popup.png" leftCapWidth:10];
}

- (UIImage *)popupChatImageRight
{
    return [UIImage strectchableImageName:@"message_popup.png" leftCapWidth:20];
}

- (UIImage *)selectedPointImage
{
    return [UIImage imageNamed:@"point_selected.png"];    
}
- (UIImage *)unSelectedPointImage
{
    return [UIImage imageNamed:@"point_unselect.png"];    
}

- (UIImage *)toolPopupImage
{
    return [UIImage imageNamed:@"tool_popup.png"];    
}

- (UIImage *)eraserPopupImage
{
    return [UIImage imageNamed:@"eraser_popup.png"];    
}

- (UIImage *)penPopupImage
{
    UIImage *image = [UIImage imageNamed:@"pen_popup_bg.png"];
    CGFloat left = image.size.width * 0.8;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:0];
}

- (UIImage *)drawingMarkSmallImage
{
    return [UIImage imageNamed:@"print_tip.png"];        
}
- (UIImage *)drawingMarkLargeImage
{
    return [UIImage imageNamed:@"print_tipbig.png"];            
}
- (UIImage *)scoreBackgroundImage
{
    return [UIImage imageNamed:@"score.png"];            
}

- (UIImage *)penMaskImage
{
    return [UIImage imageNamed:@"pen_mask.png"];
}
- (UIImage *)colorMaskImage
{
    return [UIImage imageNamed:@"color_mask.png"];    
}

- (UIImage *)myFoucsImage
{
    return [UIImage strectchableImageName:@"myfoucs.png"];
}

- (UIImage *)myFoucsSelectedImage
{
     return [UIImage strectchableImageName:@"myfoucs_selected.png"];
}

- (UIImage *)foucsMeImage
{
    return [UIImage strectchableImageName:@"foucsme.png"];
}

- (UIImage *)foucsMeSelectedImage
{
    return [UIImage strectchableImageName:@"foucsme_selected.png"];
}

- (UIImage *)normalButtonImage
{
    return [UIImage strectchableImageName:@"normal_button.png"];
}

- (UIImage *)sinaWeiboImage
{
    return [UIImage imageNamed:@"sina.png"]; 
}

- (UIImage *)qqWeiboImage
{
    return [UIImage imageNamed:@"qq.png"]; 
}

- (UIImage *)facebookImage
{
    return [UIImage imageNamed:@"facebook.png"];
}

- (UIImage *)messageImage
{
    return [UIImage strectchableImageName:@"messagebg.png"];
}

//- (UIImage *)snowImage
//{
//    return [UIImage imageNamed:@"snow.png"];
//}

- (UIImage *)pencilImage
{
    return [UIImage imageNamed:@"pen1.png"];    
}
- (UIImage *)waterPenImage
{
    return [UIImage imageNamed:@"pen2.png"];        
}
- (UIImage *)penImage
{
    return [UIImage imageNamed:@"pen3.png"];
}
- (UIImage *)iceImage
{
    return [UIImage imageNamed:@"pen4.png"];    
}
- (UIImage *)quillImage
{
    return [UIImage imageNamed:@"pen5.png"];    
}
- (UIImage *)eraserImage
{
    return [UIImage imageNamed:@"eraser.png"];    
}


@end
