//
//  ShoppingManager.m
//  Draw
//
//  Created by  on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShoppingManager.h"
#import "PriceModel.h"
#import "GameNetworkConstants.h"
#import <StoreKit/StoreKit.h>
#import "CoreDataUtil.h"
#import "PPDebug.h"
#import "MobClick.h"

static ShoppingManager *staticShoppingManager = nil;

@implementation ShoppingManager

@synthesize appleProductList = _appleProductList;

- (void)dealloc
{
    [_appleProductList release];
    [super dealloc];
}

+(ShoppingManager *)defaultManager
{
    if (staticShoppingManager == nil) {
        staticShoppingManager = [[ShoppingManager alloc] init];
        staticShoppingManager.appleProductList = [NSMutableDictionary dictionary];
    }
    return staticShoppingManager;
}

- (SKProduct*)productWithId:(NSString*)product
{
    if (product == nil)
        return nil;
    
    return [_appleProductList objectForKey:product];
}

- (NSArray*)findPriceListByType:(int)type
{
    return [[CoreDataManager defaultManager] execute:@"findPriceListByType" 
                                              forKey:@"TYPE" 
                                               value:[NSNumber numberWithInt:type] 
                                              sortBy:@"seq" 
                                           ascending:YES];
}

- (NSArray*)findCoinPriceList
{
    return [self findPriceListByType:SHOPPING_COIN_TYPE];
}

- (NSArray*)findItemPriceList
{
    return [self findPriceListByType:SHOPPING_ITEM_TYPE];
}

- (PriceModel*)findCoinPriceByProductId:(NSString*)productId
{
    NSArray* coinPriceList = [self findCoinPriceList];        
    for (PriceModel* price in coinPriceList){
        if ([[price productId] isEqualToString:productId]){
            return price;
        }
    }    
    
    return nil;
}

- (void)updateCoinSKProduct:(SKProduct*)product
{
    if (product == nil)
        return;
    
    [self.appleProductList setObject:product forKey:product.productIdentifier];    
}

- (NSArray *)getShoppingListByType:(SHOPPING_MODEL_TYPE)type
{
    return [self findPriceListByType:type];
}

//- (NSArray *)getShoppingListByType:(SHOPPING_MODEL_TYPE)type
//{
//    // TODO, read data locally
//    
//    
//    // Test, simulate data here, shall read from local storage
//    NSMutableArray *array = [[[NSMutableArray alloc] init]autorelease];
//
//    ShoppingModel *model1 = [[[ShoppingModel alloc] initWithType:type 
//                                                         count:400 
//                                                         price:0
//                                                    savePercen:0
//                                                     productId:@"com.orange.draw.coins_400"] autorelease];
//    
//    ShoppingModel *model2 = [[[ShoppingModel alloc] initWithType:type 
//                                                           count:1200 
//                                                           price:0
//                                                      savePercen:0
//                                                       productId:@"com.orange.draw.coins_1200"] autorelease];
//
//    [array addObject:model1];
//    [array addObject:model2]; 
//    
//    self.coinPriceList = array;    
//    return array;
//}

- (void)createPriceModel:(int)type
                   price:(double)price
                   count:(int)count
             savePercent:(int)savePercent
               productId:(NSString*)productId
                     seq:(int)seq
{
    CoreDataManager* dataManager = [CoreDataManager defaultManager];
    PriceModel* priceModel = [dataManager insert:@"PriceModel"];
    
    priceModel.type = [NSNumber numberWithInt:type];
    priceModel.count = [NSNumber numberWithInt:count];
    priceModel.savePercent = [NSNumber numberWithInt:savePercent];
    priceModel.productId = productId;
    priceModel.seq = [NSNumber numberWithInt:seq];
    priceModel.price = [NSNumber numberWithDouble:price];
    
    [dataManager save];
    
    PPDebug(@"<createPriceModel> = (%@)", [priceModel description]);
}



- (NSArray *)getShoppingListFromOutputList:(NSArray *)list type:(SHOPPING_MODEL_TYPE)type
{
    if ([list count] == 0)
        return [self findPriceListByType:type];
    
    // clear all existing data
    CoreDataManager* dataManager = [CoreDataManager defaultManager];
    NSArray* listInDatabase = [self findPriceListByType:type];
    for (PriceModel* price in listInDatabase){
        [dataManager del:price];
    }
    
    // insert new ones        
    NSMutableArray *array = [[[NSMutableArray alloc] init]autorelease];
    int seq = 1;
    for (NSDictionary *dictionary in list) {
        NSNumber * amount = [dictionary objectForKey:PARA_SHOPPING_AMOUNT];
        NSNumber * value = [dictionary objectForKey:PARA_SHOPPING_VALUE];
        NSString * productId = [dictionary objectForKey:PARA_APPLE_IAP_PRODUCT_ID];
        NSNumber * savePercent = [dictionary objectForKey:PARA_SAVE_PERCENT];
//        ShoppingModel *model = [[ShoppingModel alloc] initWithType:type count:amount.integerValue price:value.floatValue savePercen:0 productId:productId];
//        [array addObject:model];
        
        [self createPriceModel:type
                         price:value.floatValue
                         count:amount.integerValue
                   savePercent:savePercent.integerValue
                     productId:productId
                           seq:seq];
        seq ++;
//        [model release];
    }
    return array;
}

#define DEFAULT_COLOR_PRICE 100
#define DEFAULT_PEN_PRICE 400
- (NSInteger)getColorPrice
{
    NSString* price = [MobClick getConfigParams:@"COLOR_PRICE"];
    if (price == nil) {
        PPDebug(@"<getColorPrice>: price is nil, return default price = %d",DEFAULT_COLOR_PRICE);
        return DEFAULT_COLOR_PRICE;
    }
    NSInteger retPrice = [price integerValue];
    PPDebug(@"<getColorPrice>: price string = %@,price value = %d",price,retPrice);
    return retPrice;
}

- (NSInteger)getPenPrice
{
    NSString* price = [MobClick getConfigParams:@"PEN_PRICE"];
    if (price == nil) {
        PPDebug(@"<getPenPrice>: price is nil, return default price = %d",DEFAULT_PEN_PRICE);
        return DEFAULT_PEN_PRICE;
    }
    NSInteger retPrice = [price integerValue];
    PPDebug(@"<getPenPrice>: price string = %@,price value = %d",price,retPrice);
    return retPrice;
}
@end
