//
//  JXFileDownloader.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFileDownloader.h"
#import "JXFileCache.h"

static NSString *const kDefaultNamespace = @"com.zjx.JXFileCache";

@interface JXFileDownloader () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property(nonatomic, copy) JXFileDownloadProgressCompletionBlock progressBlock;
@property(nonatomic, copy) JXFileDownloadCompletionBlock completedBlock;

@property(nonatomic, strong) NSMutableData *fileData;
@property(nonatomic, assign) NSInteger expectedSize;
@property(nonatomic, strong) NSURL *fileURL;

@end

@implementation JXFileDownloader

+ (instancetype)sharedDownloader
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL progress:(nullable JXFileDownloadProgressCompletionBlock)progressBlock completed:(nonnull JXFileDownloadCompletionBlock)completedBlock
{
    // Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    
    self.fileURL = fileURL;
    
    self.progressBlock = progressBlock;
    self.completedBlock = completedBlock;
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:fileURL];
    
    [downloadTask resume];
}
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%lf", 1.0 * totalBytesWritten / totalBytesExpectedToWrite);
    self.progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    NSURL *localFileURL = nil;
    NSData *fileData = [NSData dataWithContentsOfURL:location];
    
    if (fileData) {
        localFileURL = [[JXFileCache sharedCache] getLocalFileURLByFullNamespace:kDefaultNamespace URL:self.fileURL contents:fileData attributes:nil];
        !self.completedBlock ?: self.completedBlock(localFileURL, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    !self.completedBlock ?: self.completedBlock(nil, error);
}
@end
