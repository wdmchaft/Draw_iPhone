//
//  ItemManager.h
//  Draw
//
//  Created by  on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserItem.h"

@interface ItemManager : NSObject
{
    
}

+ (ItemManager *)defaultManager;

- (UserItem*)findUserItemByType:(int)type;
- (BOOL)isUserOwnItem:(int)itemType;
- (BOOL)addNewItem:(int)itemType amount:(int)amount;
- (BOOL)increaseItem:(int)itemType amount:(int)amount;
- (BOOL)decreaseItem:(int)itemType amount:(int)amount;

@end

