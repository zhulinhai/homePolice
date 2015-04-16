//
//  HttpParserManager.m
//  HomePolice
//
//  Created by zhulh on 14-12-4.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "HttpParserManager.h"

@implementation HttpParserManager

+ (NSDictionary *)getDeviceInfo:(NSArray *)info
{
    NSString *deviceId = @"";
    NSString *deviceName = @"";
    NSString *uid = @"";
    NSString *ip = @"";
    NSString *httpPort = @"";
    NSString *rtspPort = @"";
    NSString *fdns = @"";
    NSString *sdns = @"";
    NSString *ddnsHost = @"";
    NSString *ddnsPort = @"";
    NSString *ddnsUser = @"";
    NSString *ddnsPwd = @"";
    NSString *channel1 = @"";
    NSString *channel2 = @"";
    NSString *channel3 = @"";
    for (NSString *str in info) {
        if ([deviceId isEqualToString:@""]) {
            deviceId = [str stringByAffterString:PARSER_DEVICE_ID];
            continue;
        }
        
        if ([deviceName isEqualToString:@""]) {
            deviceName = [str stringByAffterString:PARSER_DEVICE_NAME];
            continue;
        }
        
        if ([uid isEqualToString:@""]) {
            uid = [str stringByAffterString:PARSER_DEVICE_UID];
            continue;
        }
        
        if ([ip isEqualToString:@""]) {
            ip = [str stringByAffterString:PARSER_DEVICE_IP];
            continue;
        }
        
        if ([httpPort isEqualToString:@""]) {
            httpPort = [str stringByAffterString:PARSER_HTTP_PORT];
            continue;
        }
        
        if ([rtspPort isEqualToString:@""]) {
            rtspPort = [str stringByAffterString:PARSER_RTSP_PORT];
            continue;
        }
        
        if ([fdns isEqualToString:@""]) {
            fdns = [str stringByAffterString:PARSER_FDNS];
            continue;
        }
        
        if ([sdns isEqualToString:@""]) {
            sdns = [str stringByAffterString:PARSER_SDNS];
            continue;
        }
        
        if ([ddnsHost isEqualToString:@""]) {
            ddnsHost = [str stringByAffterString:PARSER_DDNS_HOST];
            continue;
        }
        
        if ([ddnsPort isEqualToString:@""]) {
            ddnsPort = [str stringByAffterString:PARSER_DDNS_PORT];
            continue;
        }
        
        if ([ddnsUser isEqualToString:@""]) {
            ddnsUser = [str stringByAffterString:PARSER_DDNS_USER];
            continue;
        }
        
        if ([ddnsPwd isEqualToString:@""]) {
            ddnsPwd = [str stringByAffterString:PARSER_DDNS_PWD];
            continue;
        }
        
        if ([channel1 isEqualToString:@""]) {
            channel1 = [str stringByAffterString:PARSER_CHANNEL_ID];
            continue;
        } else {
            if ([channel2 isEqualToString:@""]) {
                channel2 = [str stringByAffterString:PARSER_CHANNEL_ID];
            } else {
                channel3 = [str stringByAffterString:PARSER_CHANNEL_ID];
            }
            continue;
        }
    }
    
    if ([deviceId isEqualToString:@""] || [uid isEqualToString:@""]) {
        return nil;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          deviceId, PARSER_DEVICE_ID,
                          deviceName, PARSER_DEVICE_NAME,
                          uid,      PARSER_DEVICE_UID,
                          ip,       PARSER_DEVICE_IP,
                          httpPort, PARSER_HTTP_PORT,
                          rtspPort, PARSER_RTSP_PORT,
                          fdns,     PARSER_FDNS,
                          sdns,     PARSER_SDNS,
                          ddnsHost, PARSER_DDNS_HOST,
                          ddnsUser, PARSER_DDNS_USER,
                          ddnsPort, PARSER_DDNS_PORT,
                          ddnsPwd,  PARSER_DDNS_PWD,
                          channel1, PARSER_CAM_CHANNEL0,
                          channel2, PARSER_CAM_CHANNEL1,
                          channel3, PARSER_CAM_CHANNEL2,
                          nil];
    return dict;
}


@end
