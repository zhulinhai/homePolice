//
//  DeviceTableViewCell.m
//  homePolice
//
//  Created by ios007 on 15/2/27.
//  Copyright (c) 2015年 yunzhifeng. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.btnState.layer.cornerRadius = 3.0;
    self.btnState.layer.masksToBounds = YES;
    self.btnState.layer.borderColor = [UIColor getImageBorderColor].CGColor;
    self.btnState.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
