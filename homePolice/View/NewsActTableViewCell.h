//
//  NewsActTableViewCell.h
//  zouzoukan
//
//  Created by ios001 on 14-12-31.
//  Copyright (c) 2014年 zouzoukan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsActTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowseCount;

@end
