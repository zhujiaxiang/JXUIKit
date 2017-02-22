//
//  SJFilePreviewViewController.m
//  SJFilePreviewKit
//
//  Created by zjx on 2017/2/17.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import "SJFilePreviewViewController.h"

@interface SJFilePreviewViewController () <QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (nonnull, nonatomic, copy) NSURL *webFileURL;
@property (nonnull, nonatomic, copy) NSURL *localFileURL;
@property (nonnull, nonatomic, copy) NSString *fileTitle;

@end

@implementation SJFilePreviewViewController

#pragma mark - Init

- (instancetype)initWithFileURL:(NSURL *)fileURL fileTitle:(NSString *)fileTitle
{
    if (self = [super init]) {
        _webFileURL = fileURL;
        _fileTitle = fileTitle;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma  mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
