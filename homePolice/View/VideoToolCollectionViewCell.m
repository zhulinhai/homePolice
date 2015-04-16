//
//  VideoToolCollectionViewCell.m
//  HomePolice
//
//  Created by zhulh on 15-1-11.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "VideoToolCollectionViewCell.h"

@implementation VideoToolCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _selectedBgView = [[UIView alloc] initWithFrame:self.frame];
    _selectedBgView.backgroundColor = [UIColor getSelectToolBarColor];
    self.selectedBackgroundView = _selectedBgView;
}

@end
