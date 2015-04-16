//
//  DeviceCollectionViewCell.m
//  homePolice
//
//  Created by ios007 on 15/2/28.
//  Copyright (c) 2015年 yunzhifeng. All rights reserved.
//

#import "DeviceCollectionViewCell.h"

@implementation DeviceCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor getImageBorderColor].CGColor;
    self.layer.borderWidth = 1.0;
    [self.deviceImage setContentMode:UIViewContentModeScaleAspectFit];
    [UIView animateWithDuration:kAnimationInterval animations:^{
        [self.deviceImage setContentMode:UIViewContentModeCenter];
    }];
}

@end
