//
//  PictureCollectionViewCell.m
//  HomePolice
//
//  Created by zhulh on 15-1-10.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.borderColor = [UIColor getImageBorderColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    self.layer.borderWidth = 1;
    
}

@end
