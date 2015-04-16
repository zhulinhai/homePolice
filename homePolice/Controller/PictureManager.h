//
//  PictureManager.h
//  HomePolice
//
//  Created by zhulh on 14-12-7.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFilePath @"filePath"
#define kPreImagePath @"preImagePath"
#define kAddDate @"addDate"
#define kFileType @"fileType"
#define kFileSize @"fileSize"

typedef enum : NSUInteger {
    t_ImageType_ShotImage = 1,
    t_ImageType_RecordVideo,
} t_ImageType;

@interface PictureManager : NSObject

+ (PictureManager *)shareInstance;

#pragma mark image manage
- (void)addSnapImageWithPath:(NSString *)filePath;
- (void)deleteSnapImageByPath:(NSString *)filePath;
//- (void)addRecordWithPath:(NSString *)path thumbImage:(UIImage *)thumbImage;
- (NSArray *)getPictureListByType:(t_ImageType)imageType;

@end
