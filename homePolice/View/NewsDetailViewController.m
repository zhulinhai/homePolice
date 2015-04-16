//
//  NewsDetailViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-10.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsHeadTableViewCell.h"
#import "NewsImageTableViewCell.h"
#import "NewsTitleTableViewCell.h"

#define kNewsHeadTableViewCellIdentifer   @"NewsHeadTableViewCellIdentifer"
#define kNewsTitleTableViewCellIdentifer  @"NewsTitleTableViewCellIdentifer"
#define kNewsImageTableViewCellIdentifer  @"NewsImageTableViewCellIdentifer"

@interface NewsDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsImageTableViewCell" bundle:nil] forCellReuseIdentifier:kNewsImageTableViewCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsHeadTableViewCell" bundle:nil] forCellReuseIdentifier:kNewsHeadTableViewCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTitleTableViewCell" bundle:nil] forCellReuseIdentifier:kNewsTitleTableViewCellIdentifer];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uitableView dataSource and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (indexPath.row == 0) {
        height = 60;
    } else if (indexPath.row == 1) {
        height = 160;
    } else if (indexPath.row == 2) {
        NSString *content = [_dictInfo valueForKey:kContent];
        CGSize retSize = [content autoSizeWithFrameWith:290 fontSize:14.0];
        height = retSize.height + 30;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell = nil;
    if (indexPath.row == 0) {
        NewsHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsHeadTableViewCellIdentifer];
        if (cell == nil) {
            cell = [[NewsHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewsHeadTableViewCellIdentifer];
        }
        cell.lblTitle.text = [_dictInfo valueForKey:kTitle];
        [cell.btnTimeAndAuthor setTitle:[NSString stringWithFormat:@"%@  作者:%@", [_dictInfo valueForKey:kAddTime], [_dictInfo valueForKey:kAuthor]] forState:UIControlStateNormal];
        
        tableCell = cell;
    } else if (indexPath.row == 1) {
        NewsImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsImageTableViewCellIdentifer];
        if (cell == nil) {
            cell = [[NewsImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewsImageTableViewCellIdentifer];
        }
        
        [cell.actImage setImage:[UIImage imageNamed:[_dictInfo valueForKey:kImage]]];
        tableCell = cell;
    } else if (indexPath.row == 2) {
        NewsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsTitleTableViewCellIdentifer];
        if (cell == nil) {
            cell = [[NewsTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewsTitleTableViewCellIdentifer];
        }
        
        cell.lblName.text = [_dictInfo valueForKey:kContent];
        tableCell = cell;
    }
    
    return tableCell;
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
