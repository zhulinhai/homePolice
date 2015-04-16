//
//  NSString+WebPageParser.m
//  makeplist
//
//  Created by Chris on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+WebPageParser.h"

@implementation NSString (WebPageParser)

- (NSString *)stringByAffterString:(NSString *)str
{
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:range.location + range.length];
}

- (NSString *)stringByBeforeString:(NSString *)str
{
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:range.location];
}

- (NSString *)stringByAffterLastString:(NSString *)str
{
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:range.location + range.length];
}

- (NSString *)stringByBeforeLastString:(NSString *)str
{
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:range.location];
}

@end
