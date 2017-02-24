//
//  JXImageCropperView.h
//  JXMapKit
//
//  Created by 朱佳翔 on 16/7/8.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXImageCropperView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;

- (void)JX_ImageCropperSetUp;
- (void)JX_FinishCropping;
- (void)JX_Reset;

@end
