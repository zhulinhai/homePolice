//
//  PersonalController.m
//  ShopSmart
//
//  Created by ios001 on 14-5-29.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "UserController.h"

#define kUserInfoListFileName @"UserInfoList.plist"

#define kLogin @"isLogin"
#define kUserId @"userId"
#define kFavorList @"favorList"
#define kStoreIdList @"storeIdList"
#define kSiginIdList @"siginIdList"
#define kFollowIdList @"followIdList"
#define kFavorList @"favorList"
#define kFavorAreaList @"favorAreaList"
#define kBusinessAreaList @"businessAreaList"

#define kUserAddress @"userAddress"
#define kBirthday @"birthday"
#define kEmail @"email"
#define kSex @"sex"
#define kPhoneNum @"phoneNum"
#define kNickName @"nickName"

@implementation UserController

+ (UserController *)sharedInstance
{
    static UserController *instance = nil;
    if (instance == nil) {
        instance = [[UserController alloc] init];
    }
    return instance;
}

#pragma mark init
- (id)init
{
    self = [super init];
    if (self) {
        self.favorList = [NSMutableArray array];
        self.favorAreaList = [NSMutableArray array];
        self.followIDList = [NSMutableArray array];
        self.storeIDList = [NSMutableArray array];
        self.siginIDList = [NSMutableArray array];
        self.loginInfoList = [NSMutableArray array];
        self.favorSelectedList = [NSMutableArray array];
        self.favorAreaSelectedList = [NSMutableArray array];
    }
    return self;
}

@end
