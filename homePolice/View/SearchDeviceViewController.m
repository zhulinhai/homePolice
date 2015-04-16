//
//  SearchDeviceViewController.m
//  HomePolice
//
//  Created by zhulh on 14-11-30.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "AsyncUdpSocket.h"
#import "AddDeviceViewController.h"
#import "SvUDIDTools.h"

@interface SearchDeviceViewController ()
{
    AsyncUdpSocket *asyncSearchSocket;
    NSTimer *searchTimer;
    NSMutableArray *searchDeviceList;
}

@end


@implementation SearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchDeviceList = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self openSearchServerInit];
    [self sendSearchDeviceMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [asyncSearchSocket close];
    [asyncSearchSocket setDelegate:nil];
    if (searchTimer) {
        [searchTimer invalidate];
        searchTimer = nil;
    }
}

#pragma mark user action
- (IBAction)refresh:(id)sender {
    [searchDeviceList removeAllObjects];
    [self.tableView reloadData];
}


//建立基于UDP的Socket连接
-(void)openSearchServerInit{
    //初始化udp
    asyncSearchSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    //绑定端口
    NSError *error = nil;
    [asyncSearchSocket bindToPort:SSDP_SEARCH_PORT error:&error];
    if (error) {
        NSLog(@"bindToPort error:%@", [error debugDescription]);
    }

    [asyncSearchSocket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"enableBroadcast error:%@", [error debugDescription]);
    }
    
    [asyncSearchSocket joinMulticastGroup:VIDEO_BROADCAST_HOST error:&error];
    if (error) {
        NSLog(@"joinMulticastGroup error:%@", [error debugDescription]);
    }
    
    //启动接收线程
    [asyncSearchSocket receiveWithTimeout:-1 tag:0];
    if (searchTimer) {
        [searchTimer invalidate];
        searchTimer = nil;
    }
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendSearchDeviceMessage) userInfo:nil repeats:YES];
}

- (void)sendSearchDeviceMessage
{
    NSMutableString* searchIPC = [[NSMutableString alloc] init];
    [searchIPC appendFormat:@"SEARCH * HDS/1.0%@",KENTER];
    [searchIPC appendFormat:@"CSeq:1%@", KENTER];
    [searchIPC appendFormat:@"Client-ID:%@%@", [SvUDIDTools UDID], KENTER];
    [searchIPC appendFormat:@"Accept-Type:text/HDP%@", KENTER];
    [searchIPC appendFormat:@"Content-Length:0%@", KENTER];
    
    [asyncSearchSocket sendData:[searchIPC dataUsingEncoding:NSUTF8StringEncoding]
                         toHost:VIDEO_BROADCAST_HOST
                           port:SSDP_SEARCH_PORT
                    withTimeout:-1
                            tag:0];
}

- (void)checkAndParaseMsg:(NSString *)msgInfo
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[msgInfo componentsSeparatedByString:@"\r\n"]];
    [array removeObject:@""];
    if (array.count > 0) {
        NSString *head = [array objectAtIndex:0];
        if ([head isEqualToString:SEARCH_ACK_HDS]) {
            NSString *clientId = [self getClientIdWithInfo:array];
            if (![clientId isEqualToString:[SvUDIDTools UDID]]) {
                return;
            }
            
            NSDictionary *dictInfo = [HttpParserManager getDeviceInfo:array];
            NSString *deviceId = [dictInfo valueForKey:PARSER_DEVICE_UID];
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:searchDeviceList];
            for (NSDictionary *dict in mutableArray) {
                NSString *devId = [dict valueForKey:PARSER_DEVICE_UID];
                if ([devId isEqualToString:deviceId]) {
                    [searchDeviceList removeObject:dict];
                    break;
                }
            }
            [searchDeviceList addObject:dictInfo];
            [self.tableView reloadData];
        }
    }
}

- (NSString *)getClientIdWithInfo:(NSArray *)array
{
    NSString *clientId = @"";
    for (NSString *str in array) {
        clientId = [str stringByAffterString:PARSER_CLIENT_ID];
        if (![clientId isEqualToString:@""]) {
            break;
        }
    }
    return clientId;
}

#pragma mark uitableView dataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchDeviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"defaultIdentifer";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
    }
    NSDictionary *dictInfo = [searchDeviceList objectAtIndex:indexPath.row];
    tableCell.textLabel.text = [dictInfo valueForKey:PARSER_DEVICE_NAME];
    tableCell.detailTextLabel.text = [dictInfo valueForKey:PARSER_DEVICE_IP];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictInfo = [searchDeviceList objectAtIndex:indexPath.row];
    AddDeviceViewController *addController = self.delegate;
    addController.userTextField.text = [dictInfo valueForKey:PARSER_DDNS_USER];
    addController.nameTextField.text = [dictInfo valueForKey:PARSER_DEVICE_NAME];
    addController.deviceInfo = dictInfo;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark AsyncUdpSocketDelegate
//接收
-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString * info=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (sock == asyncSearchSocket) {
        [self checkAndParaseMsg:info];
    }
    [sock receiveWithTimeout:-1 tag:0];
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"func:%s error:%@", __func__, [error description]);
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"closed");
}

@end


/*//search ack
 HDS/1.0 200 OK
 CSeq:1
 Client-ID:CC16D5C2-8164-48E8-AAA4-68B585B9411A
 Content-Type:text/HDP
 Content-Length:741
 
 Segment-Num:2
 Segment-Seq:1
 Data-Length:549
 
 Device-ID=ABBC000000e0f8009821BVFCDETYUISX
 Device-Model=V1.0.0.1
 Device-Name=IPCAM
 UID=AZGK2ZVF8DUSYVAL111A
 IP=192.168.1.105
 MASK=255.255.255.0
 MAC=00:E0:F8:00:98:21
 Gateway=192.168.1.1
 Software-Version=V7.4.4.1.1-20140925
 Web-Version=V1.0.0.0
 Http-Port=81
 Rtsp-Port=554
 Dhcp=0
 Ddns=1
 Fdns=211.161.159.3
 Sdns=211.161.159.5
 Device-Type=C6F0SeZ0N0P0L0
 Device-Vendor=EN
 C_Product=C6F0SeZ0N0P0L0
 C_Vendor=EN
 DDNS-Enable=1
 DDNS-Host=user.easyn.hk
 DDNS-Port=808
 DDNS-User=aprit
 DDNS-Passwd=738315
 DDNS-Domain=
 DDNS-Interval=180
 Segment-Seq:2
 Data-Length:107
 
 [dev-media-info]
 cam-count=1
 [cam1]
 id=1
 stream-count=2
 [cam1-stream1]
 id=11
 [cam1-stream2]
 id=12
 
 */

/*//Notify
 NOTIFY * HTTP/1.1
 HOST: 239.255.255.250:1900
 CACHE-CONTROL: max-age=100
 LOCATION: http://192.168.1.1:1900/igd.xml
 NT: upnp:rootdevice
 NTS: ssdp:alive
 SERVER: Wireless N Router WR740N, UPnP/1.0
 USN: uuid:upnp-InternetGatewayDevice-192168115678900001::upnp:rootdevice
 */

