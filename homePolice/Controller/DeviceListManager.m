//
//  DeviceListManager.m
//  HomePolice
//
//  Created by zhulh on 14-12-4.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "DeviceListManager.h"
#import "DeviceListTableViewController.h"

#define kDeviceList @"deviceList"

@implementation DeviceListManager

@synthesize deviceList;

+ (DeviceListManager *)shareInstance
{
    static DeviceListManager *instance = nil;
    if (instance == nil) {
        instance = [[DeviceListManager alloc] init];
    }
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        deviceList = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceList];
        if (array) {
            for (NSDictionary *dict in array) {
                NSMutableDictionary *dictInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
                [dictInfo setValue:[NSNumber numberWithInteger:t_Device_Status_Offline] forKey:PARSER_IS_ONLINE];
                [deviceList addObject:dictInfo];
            }
        }
    }
    
    return self;
}

- (void)loadStripDeviceList
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"api.reco4life.com/v/api.1.1"
                                                     customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:@"get_token"
                                                params:[NSDictionary dictionaryWithObjectsAndKeys:@"波波阳",@"user_name",@"6373d8000aaacfc10ac5a0b93514ba12",@"api_key", nil]
                                            httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        NSString *token = [dict valueForKey:@"token"];
        NSLog(@"token:%@", token);
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"api.reco4life.com/v/api.1.1"
                                                         customHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil]];
        MKNetworkOperation *op = [engine operationWithPath:@"item_list"
                                                    params:[NSDictionary dictionaryWithObjectsAndKeys:@"波波阳",@"user_name", nil]
                                                httpMethod:@"GET"];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSArray *array = [completedOperation responseJSON];
            NSInteger result = [[array valueForKey:@"result"] integerValue];
            if (result == 1) {
                NSArray *list = [array valueForKey:@"list"];
                for (NSDictionary *dict in list) {
                    NSString *uid = [dict valueForKey:@"sn"];
                    NSMutableDictionary *stripDic = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [stripDic setValue:uid forKey:PARSER_DEVICE_UID];
                    [stripDic setValue:@"热水器" forKey:PARSER_DEVICE_NAME];
                    [stripDic setValue:[NSNumber numberWithInt:t_DeviceType_STRIP] forKey:PARSER_DEVICE_TYPE];
                    [stripDic setValue:token forKey:PARSER_DEVICE_TOKEN];
                    [self updateDeviceWithInfo:stripDic];
                }
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            DLog(@"%@", error);
        }];
        [engine enqueueOperation:op];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"%@", error);
    }];
    [engine enqueueOperation:op];

}

+ (NSString *)getServerHost
{
    static char *host = nil;
    if (host == nil) {
        struct hostent *hostinfo;
        hostinfo = gethostbyname(SERVER_HOST.UTF8String);
        if (hostinfo == nil) {
            host = "211.161.159.3";
        } else {
            char **addr = hostinfo->h_addr_list;
            while (*addr) {
                host = inet_ntoa(*(struct in_addr *)*addr);
                break;
            }
        }
    }
    return [NSString stringWithUTF8String:host];
}

- (void)addDeviceWithInfo:(NSDictionary *)deviceInfo
{
    if (deviceInfo == nil) {
        return;
    }
    
    NSString *deviceUid = [deviceInfo valueForKey:PARSER_DEVICE_UID];
    [self removeDeviceWithId:deviceUid];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:deviceInfo];
    [dict setValue:[NSNumber numberWithInteger:t_Device_Status_NewAdd] forKey:PARSER_IS_ONLINE];
    [deviceList addObject:dict];
    [[NSUserDefaults standardUserDefaults] setValue:deviceList forKey:kDeviceList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.delegate respondsToSelector:@selector(refresh)]) {
        [self.delegate refresh];
    }
}

- (void)updateDeviceWithInfo:(NSDictionary *)deviceInfo
{
    NSString *deviceUid = [deviceInfo valueForKey:PARSER_DEVICE_UID];
    BOOL needUpdate = NO;
    NSDictionary *oldInfo = nil;
    NSInteger index = 0;
    for (NSDictionary *dict in deviceList) {
        NSString *devId = [dict valueForKey:PARSER_DEVICE_UID];
        if ([deviceUid isEqualToString:devId]) {
            needUpdate = YES;
            oldInfo = dict;
            index = [deviceList indexOfObject:dict];
            break;
        }
    }

    if (needUpdate) {
        [deviceList removeObject:oldInfo];
    }
    [deviceList insertObject:deviceInfo atIndex:index];
    [[NSUserDefaults standardUserDefaults] setValue:deviceList forKey:kDeviceList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.delegate respondsToSelector:@selector(refresh)]) {
        [self.delegate refresh];
    }
}

- (BOOL)removeDeviceWithId:(NSString *)deviceId
{
    if ([deviceId isEqualToString:@""]) {
        return NO;
    }
    
    BOOL needRemove = NO;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:deviceList];
    for (NSDictionary *dict in deviceList) {
        NSString *devId = [dict valueForKey:PARSER_DEVICE_UID];
        if ([deviceId isEqualToString:devId]) {
            [mutableArray removeObject:dict];
            needRemove = YES;
            break;
        }
    }
    
    if (needRemove) {
        [[SDImageCache sharedImageCache] removeImageForKey:deviceId];
        [deviceList removeAllObjects];
        [deviceList addObjectsFromArray:mutableArray];

        [[NSUserDefaults standardUserDefaults] setValue:deviceList forKey:kDeviceList];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return needRemove;
}

- (NSDictionary *)getDeviceInfoWithId:(NSString *)uid
{
    NSDictionary *dictInfo = nil;
    for (NSDictionary *dict in deviceList) {
        NSString *devId = [dict valueForKey:PARSER_DEVICE_UID];
        if ([uid isEqualToString:devId]) {
            dictInfo = dict;
        }
    }
    
    return dictInfo;
}

@end
