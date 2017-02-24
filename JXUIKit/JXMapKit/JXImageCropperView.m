//
//  JXImageCropperView.m
//  JXMapKit
//
//  Created by 朱佳翔 on 16/7/8.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXImageCropperView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

@interface JXImageCropperView ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, assign)CGSize originalImageViewSize;

@end

@implementation JXImageCropperView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self JX_ImageCropperSetUp];
    }

    return self;
}

- (void)setImage:(UIImage *)image
{
    //使图片不被扭曲
    _image = image;
    float _imageScale = self.frame.size.width / image.size.width;
    self.imageView.frame = CGRectMake(0, 0, image.size.width*_imageScale, image.size.height*_imageScale);
    self.originalImageViewSize = CGSizeMake(image.size.width*_imageScale, image.size.height*_imageScale);
    self.imageView.image = image;
    self.imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

// Methods
- (void)JX_ImageCropperSetUp
{
    [self addSubview:self.imageView];
}


- (void)JX_FinishCropping
{
    //计算缩小
    float _imageScale = self.image.size.width/self.originalImageViewSize.width;
    CGSize cropSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGPoint cropperViewOrigin = CGPointMake((0.0 - self.imageView.frame.origin.x),
                                            (0.0 - self.imageView.frame.origin.y));

    if((NSInteger)cropSize.width % 2 == 1)
    {
        cropSize.width = ceil(cropSize.width);
    }
    if((NSInteger)cropSize.height % 2 == 1)
    {
        cropSize.height = ceil(cropSize.height);
    }
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(cropperViewOrigin.x * _imageScale * 2) ,(NSInteger)( cropperViewOrigin.y *_imageScale * 2), (NSInteger)(cropSize.width * _imageScale * 2),(NSInteger)(cropSize.height * _imageScale * 2));
    CGImageRef tmp = CGImageCreateWithImageInRect([self.image CGImage], CropRectinImage);
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:self.image.scale orientation:self.image.imageOrientation];
    CGImageRelease(tmp);
}

- (void)JX_Reset
{
    self.imageView.transform = CGAffineTransformIdentity;
}

#pragma mark - Property
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    }
    
    return  _imageView;
}

@end

