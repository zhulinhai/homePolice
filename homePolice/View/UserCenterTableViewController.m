//
//  UserCenterTableViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-9.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "UserCenterTableViewController.h"
#import "UITableView+ZGParallelView.h"
#import "UserHeaderView.h"

@interface UserCenterTableViewController ()<UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblCache;
@property (strong, nonatomic) UserHeaderView *headerView;

@end

@implementation UserCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil] objectAtIndex:0];
    [_headerView.btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.tableView addParallelViewWithUIView:self.headerView withDisplayRadio:0.75 cutOffAtMax:YES];
    [self loadInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user action
- (void)login:(id)sender {
    [self performSegueWithIdentifier:kShowLoginViewIdentifer sender:nil];
}


- (void)loadInfo
{
    NSString *cacheSize = [NSString stringWithFormat:@"%.fM", [[SDImageCache sharedImageCache] getSize]/(1024*1024.0)];
    self.lblCache.text = cacheSize;
}

#pragma mark - Table view data source and delegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否清除本地缓存" message:@"清除缓存后将重新获取图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
                break;
            case 3:
                [self performSegueWithIdentifier:kShowAboutUsViewIdentifer sender:nil];
                break;
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        [self loadInfo];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
