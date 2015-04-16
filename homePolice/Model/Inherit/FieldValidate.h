//
//  FieldValidate.h
//  shopsmart
//
//  Created by user on 13-9-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldValidate : NSObject

+ (BOOL)validateEmail:(NSString *)value;
+ (BOOL)validateUserName:(NSString *)value;
+ (BOOL)validatePhone:(NSString *)value;
+ (BOOL)validatePostNoForIt:(NSString *)value;
+ (BOOL)validatePostNoForCn:(NSString *)value;
+ (BOOL)validatePwd:(NSString *)value;
+ (BOOL)validateRePwd:(NSString *)value1 reValue:(NSString *)value2;
+ (BOOL)validateBrithday:(NSString *)value;
+ (BOOL)validateCode:(NSString *)value;
+ (BOOL)validateIP:(NSString *)value;

+ (BOOL)checkPhoneNum:(UITextField *)sender;
+ (BOOL)checkPassWord:(UITextField *)sender;
+ (BOOL)checkCode:(UITextField *)sender;
+ (BOOL)checkEmail:(UITextField *)sender;

@end
