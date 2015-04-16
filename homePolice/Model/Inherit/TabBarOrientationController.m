//
//  TabBarOrientationController.m
//  HomePolice
//
//  Created by ios001 on 15/2/11.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "TabBarOrientationController.h"

@interface TabBarOrientationController ()

@end

@implementation TabBarOrientationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark 自动旋转
- (BOOL)shouldAutorotate
{
    if ([self.selectedViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [self.selectedViewController shouldAutorotate];
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self.selectedViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([self.selectedViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}


@end
