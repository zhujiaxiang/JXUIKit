//
//  SJFilePreviewViewController.h
//  SJFilePreviewKit
//
//  Created by zjx on 2017/2/17.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface SJFilePreviewViewController : QLPreviewController

- (nullable instancetype)initWithFileURL:(nullable NSURL *)fileURL fileTitle:(nullable NSString *)fileTitle;

@end
