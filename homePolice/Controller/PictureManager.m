//
//  PictureManager.m
//  HomePolice
//
//  Created by zhulh on 14-12-7.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "PictureManager.h"
#import "UIImage+CropForSize.h"

#define kShotImageList @"shotImageList.plist"
#define kJpegQuality 1
#define kWidth 145
#define kHight 145

@implementation PictureManager
{
    NSMutableArray *shotImageList;
}

+ (PictureManager *)shareInstance
{
    static PictureManager *instance;
    if (instance == nil) {
        instance = [[PictureManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        shotImageList = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:kShotImageList];
        if (array) {
            [shotImageList addObjectsFromArray:array];
        }
    }
    return self;
}

#pragma mark manage shot image
- (void)addSnapImageWithPath:(NSString *)filePath
{
    NSMutableDictionary *resource = [NSMutableDictionary dictionary];
    [resource setObject:[NSNumber numberWithInt:t_ImageType_ShotImage] forKey:kFileType];
    [resource setObject:filePath forKey:kFilePath];
    [shotImageList addObject:resource];
    [[NSUserDefaults standardUserDefaults] setValue:shotImageList forKey:kShotImageList];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteSnapImageByPath:(NSString *)filePath
{
    NSDictionary *fileDict = nil;
    for (NSDictionary *dict in shotImageList) {
        NSString *path = [dict valueForKey:kFilePath];
        if ([filePath isEqualToString:path]) {
            fileDict = dict;
            break;
        }
    }
    
    if (fileDict) {
        [shotImageList removeObject:fileDict];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [[NSUserDefaults standardUserDefaults] setValue:shotImageList forKey:kShotImageList];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//
//- (void)addRecordWithPath:(NSString *)path thumbImage:(UIImage *)thumbImage
//{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
//    NSString *preFileName = [[NSString stringWithFormat:@"%@_pre", [formatter stringFromDate:date]] stringByAppendingPathExtension:@"jpg"];
//    NSString *preFilePath = [DOCUMENTS_PATH stringByAppendingFormat:@"/%@", preFileName];
//    NSData *preImageData = UIImageJPEGRepresentation([thumbImage imageByScalingAndCroppingForSize:CGSizeMake(kWidth, kHight)], kJpegQuality);
//    [preImageData writeToFile:preFilePath atomically:YES];
//    
//    NSMutableDictionary *resource = [NSMutableDictionary dictionary];
//    [resource setObject:[NSNumber numberWithDouble:[date timeIntervalSince1970]] forKey:kAddDate];
//    [resource setObject:[NSNumber numberWithInt:t_ImageType_RecordVideo] forKey:kFileType];
//    [resource setObject:preFilePath forKey:kPreImagePath];
//    [resource setObject:path forKey:kFilePath];
//    [shotImageList addObject:resource];
//    [[NSUserDefaults standardUserDefaults] setValue:shotImageList forKey:kShotImageList];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}

- (NSArray *)getPictureListByType:(t_ImageType)imageType
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in shotImageList) {
        t_ImageType type = [[dict valueForKey:kFileType] intValue];
        if (type == imageType) {
            [mutableArray addObject:dict];
        }
    }
    return mutableArray;
}

@end
