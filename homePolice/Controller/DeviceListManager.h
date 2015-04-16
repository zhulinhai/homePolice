//
//  DeviceListManager.h
//  HomePolice
//
//  Created by zhulh on 14-12-4.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    t_DeviceType_IPC = 1,
    t_DeviceType_STRIP,
    t_DeviceType_LIGHT,
} t_DeviceType;

@interface DeviceListManager : NSObject

@property (strong, nonatomic) NSMutableArray *deviceList;
@property (strong, nonatomic) NSMutableDictionary *thumbImageList;
@property (assign, nonatomic) id delegate;

+ (DeviceListManager *)shareInstance;
+ (NSString *)getServerHost;

- (void)loadStripDeviceList;
- (void)addDeviceWithInfo:(NSDictionary *)deviceInfo;
- (void)updateDeviceWithInfo:(NSDictionary *)deviceInfo;
- (BOOL)removeDeviceWithId:(NSString *)uid;
- (NSDictionary *)getDeviceInfoWithId:(NSString *)uid;


@end
