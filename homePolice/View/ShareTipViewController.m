//
//  ShareTipViewController.m
//  zouzoukan
//
//  Created by ios001 on 14-12-12.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "ShareTipViewController.h"

typedef enum : NSUInteger {
    T_SHARE_TYPE_WECHAT = 101,
    T_SHARE_TYPE_WEFRIEND,
    T_SHARE_TYPE_QQ,
    T_SHARE_TYPE_SINA,
    T_SHARE_TYPE_MESSAGE,
} SHARE_TYPE;

@interface ShareTipViewController ()
{
    NSArray *itemList;
    NSString *url;
}

@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;
@property (weak, nonatomic) IBOutlet UIView *viewFive;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UIButton *btnWefriend;
@property (weak, nonatomic) IBOutlet UIButton *btnQQ;
@property (weak, nonatomic) IBOutlet UIButton *btnSina;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;

@end

@implementation ShareTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    itemList = [NSArray arrayWithObjects:self.viewOne, self.viewTwo, self.viewThree, self.viewFour, self.viewFive, self.btnCancel, nil];
    for (int i = 0; i < itemList.count; i++) {
        UIView *view = [itemList objectAtIndex:i];
        [view setCenter:CGPointMake(view.center.x, self.view.frame.size.height + 95)];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];

//    url = [NSString stringWithFormat:@"http://%@/share.html", HOST];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTipView];
}

- (void)showTipView
{
    for (int i = 0; i < itemList.count; i++) {
        UIView *view = [itemList objectAtIndex:i];
        CGPoint center = self.view.center;
        switch (i) {
            case 0:
                center.x = self.view.center.x - 95;
                break;
            case 2:
                center.x = self.view.center.x + 95;
                break;
            case 3:
                center.x = self.view.center.x - 95;
                center.y = self.view.center.y + 105;
                break;
            case 4:
                center.y = self.view.center.y + 105;
                break;
            case 5:
                center.y = self.view.center.y + 200;
                break;
            default:
                break;
        }
        
        [UIView animateWithDuration:kAnimationInterval delay:0.1 * i options:UIViewAnimationOptionCurveEaseIn animations:^{
            [view setCenter:center];
        }completion:nil];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:kShowSinaShareViewControllerIdentifer]) {
//        NSDictionary *dict = sender;
//        SinaShareViewController *controller = segue.destinationViewController;
//        controller.shareTitle = [dict safeValueForKey:@"title"];
//        controller.shareContent = [dict safeValueForKey:@"content"];
//        controller.shareImage = [dict valueForKey:@"image"];
//    }
}

#pragma mark user action
- (IBAction)cancel:(id)sender {
    for (int i = 0; i < itemList.count; i++) {
        UIView *view = [itemList objectAtIndex:i];
        [UIView animateWithDuration:kAnimationInterval delay:0.1 * i options:UIViewAnimationOptionCurveEaseIn animations:^{
            [view setCenter:CGPointMake(view.center.x, self.view.frame.size.height + 95)];
        }completion:^(BOOL isCompleted){
            if (i == itemList.count - 1) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }];
    }
}

- (IBAction)share:(UIButton *)sender {
    
    
}

@end
