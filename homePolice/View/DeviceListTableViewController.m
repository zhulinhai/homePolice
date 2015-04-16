//
//  DeviceListTableViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-8.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "DeviceListTableViewController.h"
#import "VideoViewController.h"
#import "AddDeviceViewController.h"
#import "DeviceListManager.h"
#import "DeviceTableViewCell.h"
#import "StripViewController.h"

static NSString * const deviceCellIdentifer = @"DeviceTableViewCellIdentifer";

@interface DeviceListTableViewController ()<UIGestureRecognizerDelegate>
{
    NSArray *dataInfo;
}

@end

@implementation DeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:deviceCellIdentifer];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [DeviceListManager shareInstance].delegate = self;
    [self refresh];
    [self loadStatus];
    [[DeviceListManager shareInstance] loadStripDeviceList];
    
    NSArray *items = self.tabBarController.tabBar.items;
    NSArray *names = [NSArray arrayWithObjects:@"home", @"news", @"user", nil];
    for (int i = 0; i < items.count; i++) {
        UITabBarItem *homeItem = items[i];
        NSString *name = [names objectAtIndex:i];
        homeItem.image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select", name]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"0x54575a"] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor getThemeColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    }
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

- (void)refresh
{
    dataInfo = [DeviceListManager shareInstance].deviceList;
    if (dataInfo && dataInfo.count > 0) {
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deviceBg"]];
//        [bgView setContentMode:UIViewContentModeCenter];
//        [bgView setBackgroundColor:[UIColor whiteColor]];
//        self.tableView.backgroundView = bgView;
    } else {
        UIImageView *noDeviceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodeviceTip"]];
        [noDeviceView setContentMode:UIViewContentModeCenter];
        [noDeviceView setBackgroundColor:[UIColor whiteColor]];
        self.tableView.backgroundView = noDeviceView;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataInfo == nil) {
        return 0;
    }
    return dataInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceCellIdentifer];
    NSDictionary *dictInfo = [dataInfo objectAtIndex:indexPath.row];
    NSString *deviceName = [dictInfo valueForKey:PARSER_DEVICE_NAME];
    NSInteger deviceStatus = [[dictInfo valueForKey:PARSER_IS_ONLINE] integerValue];
    NSInteger deviceType = [[dictInfo valueForKey:PARSER_DEVICE_TYPE] integerValue];
    NSString *image = nil;
    switch (deviceType) {
        case t_DeviceType_IPC:
            cell.detailTextLabel.text = @"视频设备";
            image = @"ipc";
            break;
        case t_DeviceType_STRIP:
            cell.detailTextLabel.text = @"智能开关";
            image = @"strip";
            break;
        case t_DeviceType_LIGHT:
            cell.detailTextLabel.text = @"灯";
            image = @"light";
            break;
        default:
            break;
    }
    
    [cell.imageView setImage:[UIImage imageNamed:image]];
    [cell.btnState setImage:[UIImage imageNamed:(deviceStatus == t_Device_Status_Online?@"online":@"offline")] forState:UIControlStateNormal];
    [cell.btnState setTitle:(deviceStatus == t_Device_Status_Online?@"在线":@"离线") forState:UIControlStateNormal];
    cell.textLabel.text = deviceName;

    return cell;
}

- (void)loadStatus
{
    for (NSDictionary *dict in dataInfo) {
        NSInteger deviceType = [[dict valueForKey:PARSER_DEVICE_TYPE] integerValue];
        if (deviceType == t_DeviceType_IPC) {
            [self loadDeviceStatus:dict];
        }
    }
}

- (void)loadDeviceStatus:(NSDictionary *)dictInfo
{
    NSString *dnsName = [dictInfo valueForKey:PARSER_DDNS_USER];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dictInfo];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[DeviceListManager getServerHost]
                                                     customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithURLString:[NSString stringWithFormat:@"http://%@.easyn.hk", dnsName]];
    [op setUsername:[dictInfo valueForKey:PARSER_DEVICE_ACOUNT] password:[dictInfo valueForKey:PARSER_DEVICE_PWD] basicAuth:YES];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSURL *url = [completedOperation.readonlyResponse URL];
        if ([FieldValidate validateIP:url.host]) {
            [info setValue:url.host forKey:PARSER_DEVICE_IP];
            [info setValue:url.port forKey:PARSER_HTTP_PORT];
            [info setValue:[NSNumber numberWithInteger:t_Device_Status_Online] forKey:PARSER_IS_ONLINE];
        } else {
            [info setValue:[NSNumber numberWithInteger:t_Device_Status_Offline] forKey:PARSER_IS_ONLINE];
        }
        [[DeviceListManager shareInstance] updateDeviceWithInfo:info];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [info setValue:[NSNumber numberWithInteger:t_Device_Status_Offline] forKey:PARSER_IS_ONLINE];
        [[DeviceListManager shareInstance] updateDeviceWithInfo:info];
    }];
    [engine enqueueOperation:op];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictInfo = [dataInfo objectAtIndex:indexPath.row];
    NSInteger deviceStatus = [[dictInfo valueForKey:PARSER_IS_ONLINE] integerValue];
    NSInteger deviceType = [[dictInfo valueForKey:PARSER_DEVICE_TYPE] integerValue];
    switch (deviceType) {
        case t_DeviceType_IPC:
            if (deviceStatus == t_Device_Status_Online) {
                [self performSegueWithIdentifier:kShowVideoViewControllerIdentifer sender:dictInfo];
            } else if (deviceStatus == t_Device_Status_Offline){
                [self loadDeviceStatus:dictInfo];
            }
            break;
        case t_DeviceType_STRIP:
            if (deviceStatus == t_Device_Status_Online) {
                [self performSegueWithIdentifier:kShowStripViewControllerIdentifer sender:[dictInfo valueForKey:PARSER_DEVICE_UID]];
            } else if (deviceStatus == t_Device_Status_Offline){
                [[DeviceListManager shareInstance] loadStripDeviceList];
            }
            break;
        case t_DeviceType_LIGHT:
            break;
        default:
            break;
    }

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[DeviceListManager shareInstance] removeDeviceWithId:[[dataInfo objectAtIndex:indexPath.row] objectForKey:PARSER_DEVICE_UID]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowVideoViewControllerIdentifer]) {
        VideoViewController *controller = segue.destinationViewController;
        controller.dictInfo = sender;
    } else if ([segue.identifier isEqualToString:kShowStripViewControllerIdentifer]) {
        StripViewController *controller = segue.destinationViewController;
        controller.uid = sender;
    }
}


@end
