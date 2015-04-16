//
//  UIImage+CropForSize.h
//  HomePolice
//
//  Created by zhulh on 14-12-16.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CropForSize)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
