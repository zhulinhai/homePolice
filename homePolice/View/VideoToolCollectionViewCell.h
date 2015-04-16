//
//  VideoToolCollectionViewCell.h
//  HomePolice
//
//  Created by zhulh on 15-1-11.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoToolCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (strong, nonatomic) UIView *selectedBgView;

@end
