//
//  NewsActTableViewCell.m
//  zouzoukan
//
//  Created by ios001 on 14-12-31.
//  Copyright (c) 2014年 zouzoukan. All rights reserved.
//

#import "NewsActTableViewCell.h"

@implementation NewsActTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.logoImageView.layer.cornerRadius = 8.0;
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.borderWidth = 1.0;
    self.logoImageView.layer.borderColor = [UIColor getImageBorderColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
