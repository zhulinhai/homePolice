//
//  UserProtocolViewController.h
//  ShopSmart
//
//  Created by ios001 on 14-6-27.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProtocolViewController : UMengViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
