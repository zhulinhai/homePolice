//
//  UserController.h
//  ShopSmart
//
//  Created by ios001 on 14-5-29.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserController : NSObject

+ (UserController *)sharedInstance;

@property (strong, nonatomic) NSArray *loginInfoList;
@property (strong, nonatomic) NSArray *accBusinessList;
@property (strong, nonatomic) NSMutableArray *storeIDList;
@property (strong, nonatomic) NSMutableArray *followIDList;
@property (strong, nonatomic) NSMutableArray *siginIDList;
@property (strong, nonatomic) NSArray *businessAreaList;
@property (strong, nonatomic) NSMutableArray *favorList;
@property (strong, nonatomic) NSMutableArray *favorSelectedList;
@property (strong, nonatomic) NSMutableArray *favorAreaList;
@property (strong, nonatomic) NSMutableArray *favorAreaSelectedList;

@property (copy, nonatomic) UIImage *headImage;
@property (copy, nonatomic) NSString *userAddress;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *phoneNum;
@property (copy, nonatomic) NSString *nickName;

@property (copy, nonatomic) NSString *clockDate;
@property (copy, nonatomic) NSString *clockDay;
@property (assign, nonatomic) NSInteger clockIntegral;
@property (assign, nonatomic) BOOL isLogin;
@property (copy, nonatomic) NSString *userId;


@end
