//
//  RecordListTableViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-22.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "RecordListTableViewController.h"
#import "PlayBackViewController.h"
#import <MediaPlayer/MediaPlayer.h>      //导入视频播放库

#define kHref   @"href"
#define kName   @"name"
#define kSize   @"size"

static NSString *cellIdentifer = @"defaultCellIdentifer";

@interface RecordListTableViewController ()
{
    NSMutableArray *dataList;
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation RecordListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifer];
    dataList = [NSMutableArray array];
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicatorView];
    [indicatorView setCenter:self.view.center];

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [indicatorView startAnimating];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *curDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/sd/%@/record000/", _hostName, curDate];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[DeviceListManager getServerHost]
                                                     customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithURLString:urlString];
    [op setUsername:[self.dictInfo valueForKey:PARSER_DEVICE_ACOUNT] password:[self.dictInfo valueForKey:PARSER_DEVICE_PWD] basicAuth:YES];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [indicatorView stopAnimating];
        [dataList removeAllObjects];
        
        NSString *content = [[completedOperation responseString] stringByAffterString:@"&nbsp;&nbsp;"];
        NSArray *array = [content componentsSeparatedByString:@"\n"];
        for (NSString *info in array) {
            if ([info rangeOfString:@"<tr><td>"].location != NSNotFound) {
                NSString *preHref = [info stringByAffterString:@"href=\""];
                preHref = [preHref stringByBeforeString:@"</a>"];
                NSString *href = [preHref stringByBeforeString:@"\">"];
                NSString *name = [preHref stringByAffterString:@"\">"];
                NSString *size = [info stringByAffterString:@"&nbsp;&nbsp;"];
                size = [size stringByBeforeString:@"</td></tr>"];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:href, kHref, name, kName, size, kSize, nil];
                [dataList addObject:dict];
            }
        }
        [self.tableView reloadData];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%s%@", __func__, [error description]);
    }];
    [engine enqueueOperation:op];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifer];
    }
    
    NSDictionary *dict = [dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict valueForKey:kName];
    cell.detailTextLabel.text = [dict valueForKey:kSize];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [dataList objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"http://%@:%@@%@%@", [_dictInfo valueForKey:PARSER_DEVICE_ACOUNT], [_dictInfo valueForKey:PARSER_DEVICE_PWD], _hostName, [dict valueForKey:kHref]];
    [self performSegueWithIdentifier:kShowPlayBackViewIdentifer sender:path];

}


-(void)movieStateChangeCallback:(NSNotification*)notify  {
    
    //点击播放器中的播放/ 暂停按钮响应的通知
    
}

-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                 object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowPlayBackViewIdentifer]) {
        UINavigationController *navController = segue.destinationViewController;
        PlayBackViewController *controller = (PlayBackViewController *)navController.topViewController;
        controller.path = sender;
    }
}

@end
