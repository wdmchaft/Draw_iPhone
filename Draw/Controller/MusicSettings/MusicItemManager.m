//
//  MusicItemManager.m
//  Draw
//
//  Created by gckj on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MusicItemManager.h"
#import "LocaleUtils.h"
#import "AudioManager.h"

#define KEY_MUSICLIST @"musicList"
#define KEY_CURRENT_MUSIC @"currentMusic"
#define DELIMITER @"$$"


@implementation MusicItemManager
@synthesize itemList;
@synthesize currentMusicItem;
@synthesize defaultMusicItem;
@synthesize noneMusicItem;

static MusicItemManager *_defaultManager;

+ (MusicItemManager*)defaultManager
{
    if (_defaultManager == nil){
        _defaultManager = [[MusicItemManager alloc] init];
    }
    
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.itemList = [[[NSMutableArray alloc] init] autorelease];
        [self loadMusicItems];
        [self loadCurrentMusic];
    }
    return self;
}

- (void)dealloc
{
    [itemList release];
    [currentMusicItem release];
    [defaultMusicItem release];
    [noneMusicItem release];
    
    [super dealloc];
}

- (MusicItem*) parseMusicItemFromString:(NSString*)str
{
    NSMutableString *string = [[[NSMutableString alloc] initWithString:str] autorelease];
    NSArray *array = [string componentsSeparatedByString:DELIMITER];
    
    NSString *fileName = [array objectAtIndex:0];
    NSString *url = [array objectAtIndex:1];
    NSString *localPath = [array objectAtIndex:2];
    NSString *downloadProgress = [array objectAtIndex:3];
    MusicItem *item = [[[MusicItem alloc] initWithUrl:url fileName:fileName filePath:localPath tempPath:@""] autorelease];
    item.downloadProgress = [NSNumber numberWithLongLong:[downloadProgress longLongValue]];
    return item;
}

- (void)loadMusicItems
{
    //no music item
    noneMusicItem = [[MusicItem alloc] initWithUrl:nil fileName:NSLS(@"kNoMusic") filePath:nil tempPath:nil];
    [itemList addObject:noneMusicItem];
    
    //default music item
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"cannon" ofType:@"mp3"];
    defaultMusicItem = [[MusicItem alloc] initWithUrl:nil fileName:NSLS(@"kDefaultMusic") filePath:soundFilePath tempPath:nil];
    [itemList addObject:defaultMusicItem];

    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *data = [userDefault arrayForKey:KEY_MUSICLIST];
    if (data != nil) {
        for (NSString* str in data) {
            MusicItem *item = [self parseMusicItemFromString:str];
            if ([self.itemList indexOfObject:item] != -1) {
                [self.itemList addObject:item];
            }
        }
    }   
}

- (void)saveMusicItems
{        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (MusicItem *item in self.itemList) {
        //do not save default and no into UserDefaults
        if (item == defaultMusicItem || item == noneMusicItem) {
            continue;
        }
        
        NSMutableString *itemString = [[NSMutableString alloc]init];
        [itemString appendFormat:@"%@%@%@%@%@%@%@", 
                        item.fileName, DELIMITER, 
                        item.url, DELIMITER, 
                        item.localPath, DELIMITER, 
                        [item.downloadProgress stringValue]];
        
        [list addObject:itemString];
        [itemString release];

    }
    
    [userDefaults setObject: list forKey:KEY_MUSICLIST];
    [list release];
    
}

- (void)loadCurrentMusic
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString *data = [userDefault objectForKey:KEY_CURRENT_MUSIC];
    if (data != nil) {
        MusicItem *item = [self parseMusicItemFromString:data];
        self.currentMusicItem = item;
        }
    
    if (self.currentMusicItem == nil) {
        self.currentMusicItem = defaultMusicItem;
    }
}

- (void)saveCurrentMusic
{        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    NSMutableString *itemString = [[NSMutableString alloc]init];
    [itemString appendFormat:@"%@%@%@%@%@%@%@", 
         currentMusicItem.fileName, DELIMITER, 
         currentMusicItem.url, DELIMITER, 
         currentMusicItem.localPath, DELIMITER, 
         [currentMusicItem.downloadProgress stringValue]];
        
    [userDefaults setObject: itemString forKey:KEY_CURRENT_MUSIC];
    [itemString release];

}

- (BOOL)isCurrentMusic:(MusicItem*)item
{
    return [item.fileName isEqualToString:currentMusicItem.fileName];
}

- (BOOL)isNoneOrDefaultMusic:(MusicItem*)item
{
    return item == noneMusicItem || item == defaultMusicItem;
}

- (void)saveItem:(MusicItem*)item
{
    [itemList addObject:item];
}

- (void)deleteItem:(MusicItem*)item
{
    if (itemList != nil && [itemList indexOfObject:item] != -1) {
        [itemList removeObject:item];
        [self removeFile:item];
    }
}

- (void)removeFile:(MusicItem*)item
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:item.localPath error:nil];
}

- (NSArray*) findAllItems
{   
    return itemList;
}

- (void)setFileInfo:(MusicItem*)item newFileName:(NSString*)fileName fileSize:(long)fileSize
{
    [itemList removeObject:item];
    item.fileName = fileName;
    item.fileSize = [NSNumber numberWithLong:fileSize];
    [itemList addObject:item];
}

//select current background Music to play
- (void)selectCurrentMusicItem:(MusicItem*)item
{
    if (self.currentMusicItem != item) {
        self.currentMusicItem = item;
        [self saveCurrentMusic];

    }
    
    AudioManager *audioManager = [AudioManager defaultManager];

    //if select 'No', stop the audio
    if (currentMusicItem == noneMusicItem) {
        [audioManager backgroundMusicStop];
    }
    else {
        NSURL *url = [NSURL fileURLWithPath:self.currentMusicItem.localPath];
        //stop old music
        [audioManager backgroundMusicStop];
        //start new music
        [audioManager setBackGroundMusicWithURL:url];
        [audioManager backgroundMusicStart];
    }
    
}

@end
