//
//  JXFilePreviewViewController.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFilePreviewViewController.h"

@interface JXFilePreviewViewController () <QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (nonnull, nonatomic, copy) NSURL *webFileURL;
@property (nonnull, nonatomic, copy) NSURL *localFileURL;
@property (nonnull, nonatomic, copy) NSString *fileTitle;

@end

@implementation JXFilePreviewViewController

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
