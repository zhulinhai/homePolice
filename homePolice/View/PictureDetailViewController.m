//
//  PictureDetailViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-11.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "PictureDetailViewController.h"

@interface PictureDetailViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.filePath]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark uiscollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark user action
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [self.scrollView setBackgroundColor:(self.navigationController.navigationBarHidden?[UIColor blackColor]:[UIColor getTableBGColor])];
}

- (IBAction)download:(id)sender {
UIImageWriteToSavedPhotosAlbum([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.filePath], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"图片保存被阻止了" message:@"请到系统\"设置>隐私>照片\"中开启\"走走看\"访问权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    } else {
        [ProgressHUD showSuccess:@"图片已保存至相册"];
    }

}


@end
