//
//  ProtocolDefine.h
//  HomePolice
//
//  Created by ios001 on 14-12-2.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#ifndef HomePolice_ProtocolDefine_h
#define HomePolice_ProtocolDefine_h

#define kUp     @"up"
#define kDown   @"down"
#define kRight  @"right"
#define kLeft   @"left"

typedef enum : NSUInteger {
    t_Device_Status_Online = 1,
    t_Device_Status_Offline,
    t_Device_Status_Unknow,
    t_Device_Status_NewAdd
} t_Device_Status;

#define DOCUMENTS_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define VIDEO_BROADCAST_HOST @"239.255.255.250"
#define VIDEO_BROADCAST_PORT 1900
#define SOAP_DISCOVERY_PORT  3702
#define VIDEO_BROADCAST_URL @"239.255.255.250:1900"
#define SERVER_HOST @"user.easyn.hk"

#define KENTER @"\r\n"
#define KBLACK @" "
#define MAX_BUF 10240

#define SSDP_SEARCH_PORT 8002

#define SEARCH_SEND_HDS @"SEARCH * HDS/1.0"
#define SEARCH_ACK_HDS @"HDS/1.0 200 OK"
#define HTTP_MSEARCH_MESSAGE @"M-SEARCH * HTTP/1.1"
#define HTTP_NOTIFY_MESSAGE @"NOTIFY * HTTP/1.1"

#define PARSER_CLIENT_ID @"Client-ID:"
#define PARSER_DEVICE_ID @"Device-ID="
#define PARSER_DEVICE_NAME @"Device-Name="
#define PARSER_DEVICE_ACOUNT  @"Device-Acount"
#define PARSER_DEVICE_PWD @"Device-PWD"
#define PARSER_DEVICE_UID @"UID="
#define PARSER_DEVICE_IP @"IP="
#define PARSER_DEVICE_TOKEN @"token"
#define PARSER_HTTP_PORT @"Http-Port="
#define PARSER_RTSP_PORT @"Rtsp-Port="
#define PARSER_FDNS @"Fdns="
#define PARSER_SDNS @"Sdns="
#define PARSER_DDNS_HOST @"DDNS-Host="
#define PARSER_DDNS_PORT @"DDNS-Port="
#define PARSER_DDNS_USER @"DDNS-User="
#define PARSER_DDNS_PWD  @"DDNS-Passwd="
#define PARSER_CAM_STREAM @"cam1"
#define PARSER_CAM_STREAM1 @"cam1-stream1"
#define PARSER_CAM_STREAM2 @"cam1-stream2"
#define PARSER_CHANNEL_ID @"id="
#define PARSER_CAM_CHANNEL0 @"channel"
#define PARSER_CAM_CHANNEL1 @"channel1"
#define PARSER_CAM_CHANNEL2 @"channel2"
#define PARSER_IS_ONLINE @"is_online"
#define PARSER_IS_POWERON @"is_poweron"

#define PARSER_HARD_VERSION @"hardVersion="
#define PARSER_SOFT_VERSION @"softVersion="
#define PARSER_WEB_VERSION  @"webVersion="
#define PARSER_NAME         @"name="
#define PARSER_SD_STATUS    @"sdstatus="
#define PARSER_SD_FREESPACE @"sdfreespace="
#define PARSER_SD_TOTALSPACE    @"sdtotalspace="
#define PARSER_STREAM_NUM   @"stream_num="
#define PARSER_DEVICE_TYPE   @"device_type"

#endif
