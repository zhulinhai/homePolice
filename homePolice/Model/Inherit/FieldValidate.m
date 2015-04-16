//
//  FieldValidate.m
//  shopsmart
//
//  Created by user on 13-9-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "FieldValidate.h"

@implementation FieldValidate

//验证邮箱
+ (BOOL)validateEmail:(NSString *)value
{
    NSString *strRegex = @"^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

//验证用户名
+ (BOOL)validateUserName:(NSString *)value
{
    NSString *strRegex = @"^[\\u4E00-\\u9FA5|_|\\-|a-z|A-Z||0-9]{1,24}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

//验证电话
+ (BOOL)validatePhone:(NSString *)value
{
    NSString *strRegex = @"[0-9]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

//验证邮编 意大利
+ (BOOL)validatePostNoForIt:(NSString *)value
{
    NSString *strRegex = @"^[1-9][0-9]{4}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

//验证邮编 中文
+ (BOOL)validatePostNoForCn:(NSString *)value
{
    NSString *strRegex = @"^[1-9][0-9]{5}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

//验证密码
+ (BOOL)validatePwd:(NSString *)value
{
    if(value.length < 6 || value.length > 20)
        return NO;
    return YES;
}

//验证2个密码是否相同
+ (BOOL)validateRePwd:(NSString *)value1 reValue:(NSString *)value2
{
    if([value1 compare:value2] == NSOrderedSame)
    {
        return YES;
    }
    return NO;
}

//日期格式验证yyyy/mm/dd
+ (BOOL)validateBrithday:(NSString *)value
{
    NSString *strRegex = @"(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})/(((0[13578]|1[02])/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

+ (BOOL)validateCode:(NSString *)value
{
    if (value.length != 6) {
        return NO;
    }
    return YES;
}

+ (BOOL)validateIP:(NSString *)value
{
    NSString *strRegex = @"[0-9]{1,3}+\\.+[0-9]{1,3}+\\.+[0-9]{1,3}+\\.+[0-9]{1,3}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

+(NSString *)randomPassword{
    //自动生成8位随机密码
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSLog(@"now:%.8f",random);
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    NSLog(@"randompassword:%@",randompassword);
    
    return randompassword;
}

#pragma mark user action
+ (BOOL)checkPhoneNum:(UITextField *)sender
{
    if (![FieldValidate validatePhone:sender.text] || sender.text.length != 11) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"输入的手机号非法,请输入11位手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        
        
        [sender becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkPassWord:(UITextField *)sender
{
    if (![FieldValidate validatePwd:sender.text]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入6-20位长度的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        [sender becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkCode:(UITextField *)sender
{
    if (![FieldValidate validateCode:sender.text]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"请查看手机输入6位的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        [sender becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkEmail:(UITextField *)sender
{
    if (![FieldValidate validateEmail:sender.text]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"输入的邮箱地址非法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        [sender becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
