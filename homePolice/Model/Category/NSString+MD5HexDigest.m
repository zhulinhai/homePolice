//
//  NSString+MD5HexDigest.m
//  FhzzClient
//
//  Created by Fhzz on 13-4-11.
//  Copyright (c) 2013年 Fhzz. All rights reserved.
//

#import "NSString+MD5HexDigest.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MD5HexDigest)

- (NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

@end
