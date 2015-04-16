//
//  NSDictionary+SafeValue.h
//  ShopSmart
//
//  Created by ios001 on 14-5-21.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeValue)

- (id)safeValueForKey:(NSString *)key;

@end
