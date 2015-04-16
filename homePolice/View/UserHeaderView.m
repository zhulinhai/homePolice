//
//  UserHeaderView.m
//  zouzoukan
//
//  Created by ios007 on 15/3/30.
//  Copyright (c) 2015年 zh. All rights reserved.
//

#import "UserHeaderView.h"

@implementation UserHeaderView

- (void)awakeFromNib
{
    self.logoImage.layer.cornerRadius = self.logoImage.frame.size.width/2;
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.userInteractionEnabled = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
