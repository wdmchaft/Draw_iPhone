//
//  PriceService.h
//  Draw
//
//  Created by  on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "ShoppingModel.h"
#import "PPTableViewController.h"
#import <StoreKit/StoreKit.h>

@protocol PriceServiceDelegate <NSObject>

@optional
- (void)didBeginFetchShoppingList;
- (void)didFinishFetchShoppingList:(NSArray *)shoppingList resultCode:(int)resultCode;

@end
@interface PriceService : CommonService<SKProductsRequestDelegate>
{
    
}

+ (PriceService *)defaultService;

- (void)fetchShoppingListByType:(SHOPPING_MODEL_TYPE)type
      viewController:(PPViewController<PriceServiceDelegate> *)viewController;

- (void)fetchCoinProductList:(PPViewController<PriceServiceDelegate> *)viewController;

@end
