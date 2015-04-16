//
//  NSDictionary+SafeValue.m
//  ShopSmart
//
//  Created by ios001 on 14-5-21.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "NSDictionary+SafeValue.h"

@implementation NSDictionary (SafeValue)

- (id)safeValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isEqual:[NSNull null]]) {
        return @"";
    }
    return value;
}

@end
