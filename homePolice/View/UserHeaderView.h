//
//  UserHeaderView.h
//  zouzoukan
//
//  Created by ios007 on 15/3/30.
//  Copyright (c) 2015年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblIntegral;

@end
