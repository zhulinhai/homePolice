//
//  NSString+AutoSize.m
//  ShopSmart
//
//  Created by ios001 on 14-6-10.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "NSString+AutoSize.h"

@implementation NSString (AutoSize)

- (CGSize)autoSizeWithFrameWith:(NSInteger)width fontSize:(CGFloat)fontSize
{
    CGSize size = CGSizeMake(width, 0);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize retSize = [self boundingRectWithSize:size
                                            options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
    return retSize;
}

- (CGSize)autoSizeWithFrameHeight:(NSInteger)height fontSize:(CGFloat)fontSize
{
    CGSize size = CGSizeMake(0, height);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

@end
