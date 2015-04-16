//
//  NewsListTableViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-10.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "NewsListTableViewController.h"
#import "NewsActTableViewCell.h"
#import "NewsDetailViewController.h"
#import "ODRefreshControl.h"

@interface NewsListTableViewController ()<UIGestureRecognizerDelegate>
{
    NSArray *dataInfo;
}
@end

@implementation NewsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsActTableViewCell" bundle:nil] forCellReuseIdentifier:kNewsActTableViewCellIdentifer];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self loadData];
}

#pragma mark
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    if (!refreshControl.refreshing) {
        [refreshControl beginRefreshing];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
//    NSString *url = [NSString stringWithFormat:@"?action=loadNewsList&page=%@", [NSNumber numberWithInteger:_pageIndex]];
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:APIUrl];
//    MKNetworkOperation *op = [engine operationWithPath:url];
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//        NSError *error = nil;
////        NSArray *array = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingAllowFragments error:&error];
////        if (!error) {
////            NSInteger code = [[array valueForKey:kCode] integerValue];
////            if (code == 1) {
////                NSArray *list = [array valueForKey:kData];
////                _total = [[array valueForKey:kTotal] integerValue];
////                [_dataList removeAllObjects];
////                [_dataList addObjectsFromArray:list];
////                [self.tableView reloadData];
////            }
////        }
//        [refreshControl endRefreshing];
//    }errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
//        //请求失败时执行
//        DLog(@"%@", error);
//    }];
//    [engine enqueueOperation:op];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.navigationController.topViewController isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark load data
- (void)loadData
{
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"NewsInfo" ofType:@"plist"];
    dataInfo = [[NSArray alloc] initWithContentsOfFile:plistFile];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataInfo) {
        return dataInfo.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsActTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsActTableViewCellIdentifer forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewsActTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewsActTableViewCellIdentifer];
    }
    
    NSDictionary *dict = [dataInfo objectAtIndex:indexPath.row];
    [cell.logoImageView setImage:[UIImage imageNamed:[dict valueForKey:kLogo]]];
    cell.lblTitle.text = [dict safeValueForKey:kTitle];
    cell.lblContent.text = [dict safeValueForKey:kDetail];
    [cell.btnBrowseCount setTitle:[[dict safeValueForKey:kBrowseCount] stringValue] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:kShowNewsDetailViewIdentifer sender:[dataInfo objectAtIndex:indexPath.row]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowNewsDetailViewIdentifer]) {
        NewsDetailViewController *controller = segue.destinationViewController;
        controller.dictInfo = sender;
    }
}

@end
