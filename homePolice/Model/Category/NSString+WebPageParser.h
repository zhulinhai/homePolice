//
//  NSString+WebPageParser.h
//  makeplist
//
//  Created by Chris on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WebPageParser)

- (NSString *)stringByAffterString:(NSString *)str;
- (NSString *)stringByBeforeString:(NSString *)str;
- (NSString *)stringByAffterLastString:(NSString *)str;
- (NSString *)stringByBeforeLastString:(NSString *)str;

@end
