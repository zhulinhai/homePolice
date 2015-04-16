//
//  ShareTipViewController.h
//  zouzoukan
//
//  Created by ios001 on 14-12-12.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    t_ShareType_Activity = 1,
    t_ShareType_Bussiness,
    t_ShareType_Share,
} t_ShareType;

@protocol ShareTipViewProtocol <NSObject>

- (void)hideShareTipView;

@end

@interface ShareTipViewController : UMengViewController

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *shareInfo;
@property (assign, nonatomic) t_ShareType shareType;

- (void)showTipView;

@end
