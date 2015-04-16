//
//  RoundBackgroundView.m
//  ShopSmart
//
//  Created by ios001 on 14-6-27.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "RoundBackgroundView.h"

@implementation RoundBackgroundView

- (void)awakeFromNib
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor getImageBorderColor].CGColor;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

}


@end
