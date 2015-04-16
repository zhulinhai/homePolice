//
//  NSString+Checking.m
//  FhzzClient
//
//  Created by Chris on 13-6-21.
//  Copyright (c) 2013年 Fhzz. All rights reserved.
//

#import "NSString+Checking.h"

@implementation NSString (Checking)

- (BOOL)isLetterOrNum
{
    static NSCharacterSet *letterAndNumSet = nil;
    if (letterAndNumSet == nil) {
        letterAndNumSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:self];
    return [letterAndNumSet isSupersetOfSet:set];
}

- (BOOL)isBeginWithLetter
{
    static NSCharacterSet *letterSet = nil;
    if (letterSet == nil) {
        letterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    }
    if ([self length] == 0) {
        return NO;
    }
    return [letterSet characterIsMember:[self characterAtIndex:0]];
}

@end
