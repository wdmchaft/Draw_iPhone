//
//  ConfigManager.m
//  Draw
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConfigManager.h"
#import "LocaleUtils.h"
#import "PPApplication.h"

#define KEY_GUESS_DIFF_LEVEL    @"KEY_GUESS_DIFF_LEVEL"
#define KEY_CHAT_VOICE_ENABLE   @"KEY_CHAT_VOICE_ENABLE"

@implementation ConfigManager

+ (int)getBalanceDeviation
{
    return [MobClickUtils getIntValueByKey:@"BALANCE_DEVIATION" defaultValue:4000];
}

+ (NSString*)getTrafficAPIServerURL
{
    if ([LocaleUtils isChina]){
        return [MobClickUtils getStringValueByKey:@"TRAFFIC_API_SERVER_CN" defaultValue:@"http://58.215.189.146:8100/api/i?"];    
    }
    else{
        return [MobClickUtils getStringValueByKey:@"TRAFFIC_API_SERVER_EN" defaultValue:@"http://58.215.189.146:8100/api/i?"];    
    }
}

+ (NSString*)getAPIServerURL
{
    return [MobClickUtils getStringValueByKey:@"API_SERVER_URL" defaultValue:@"http://58.215.189.146:8001/api/i?"];    
    
//    NSString* url = [MobClick getConfigParams:@"API_SERVER_URL"];
//    return (url == nil) ? @"http://58.215.189.146:8001/api/i?" : url;
}


+ (NSString*)getMusicDownloadHomeURL
{
    if ([LocaleUtils isChina]){
        return [MobClickUtils getStringValueByKey:@"MUSIC_HOME_CN" defaultValue:@"http://m.easou.com/col.e?id=112"];
    }
    else{
        return [MobClickUtils getStringValueByKey:@"MUSIC_HOME_EN" defaultValue:@"http://mp3skull.com/"];
    }
}

+ (int)getGuessRewardNormal
{
    return [MobClickUtils getIntValueByKey:@"REWARD_GUESS_1" defaultValue:3];
}

+ (NSString*)getChannelId
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFChannelId"];
}

+ (NSString*)defaultEnglishServer
{
    return [MobClickUtils getStringValueByKey:@"ENGLISH_SERVER_ADDRESS" defaultValue:@"106.187.89.232"];
}

+ (NSString*)defaultChineseServer
{
    return [MobClickUtils getStringValueByKey:@"CHINESE_SERVER_ADDRESS" defaultValue:@"58.215.190.75"];
}

+ (int)defaultEnglishPort
{
    return [MobClickUtils getIntValueByKey:@"ENGLISH_SERVER_PORT" defaultValue:9000];
}

+ (int)defaultChinesePort
{
    return [MobClickUtils getIntValueByKey:@"CHINESE_SERVER_PORT" defaultValue:9000];
}

+ (GuessLevel)guessDifficultLevel
{
    NSInteger level = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_GUESS_DIFF_LEVEL] intValue];
    if (level == 0) {
        return NormalLevel;
    }
    return level;
}

+ (void)setGuessDifficultLevel:(GuessLevel)level
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:level] forKey:KEY_GUESS_DIFF_LEVEL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)enableReview
{
    return ([MobClickUtils getIntValueByKey:@"ENABLE_REVIEW" defaultValue:0] == 1);
}

+ (BOOL)isInReview
{
    return ([MobClickUtils getIntValueByKey:@"IN_REVIEW" defaultValue:0] == 1);    
}

+ (BOOL)isInReviewVersion
{
    NSString* currentVersion = [PPApplication getAppVersion];
    NSString* inReviewVersion = [MobClickUtils getStringValueByKey:@"IN_REVIEW_VERSION" defaultValue:@""];
    if ([inReviewVersion length] > 0){
        return [currentVersion isEqualToString:inReviewVersion];
    }
    else{
        return NO;
    }    
}

+ (ChatVoiceEnable)getChatVoiceEnable
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [userDefault objectForKey:KEY_CHAT_VOICE_ENABLE];
    if (number == nil) {
        return EnableWifi;
    }
    return [number intValue];
}

+ (void)setChatVoiceEnable:(ChatVoiceEnable)enable
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:enable] forKey:KEY_CHAT_VOICE_ENABLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
