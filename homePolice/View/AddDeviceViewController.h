//
//  AddDeviceViewController.h
//  HomePolice
//
//  Created by zhulh on 14-11-16.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceViewController : UMengTableViewController

@property (strong, nonatomic) NSDictionary *deviceInfo;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
