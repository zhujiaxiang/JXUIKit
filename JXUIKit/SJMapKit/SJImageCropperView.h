//
//  SJImageCropperView.h
//  SJMapKit
//
//  Created by zjx on 16/7/8.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJImageCropperView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;

- (void)sj_ImageCropperSetUp;
- (void)sj_FinishCropping;
- (void)sj_Reset;

@end
