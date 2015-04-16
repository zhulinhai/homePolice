//
//  NSString+AutoSize.h
//  ShopSmart
//
//  Created by ios001 on 14-6-10.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AutoSize)

- (CGSize)autoSizeWithFrameWith:(NSInteger)width fontSize:(CGFloat)fontSize;

- (CGSize)autoSizeWithFrameHeight:(NSInteger)height fontSize:(CGFloat)fontSize;

@end
