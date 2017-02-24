//
//  JXFileDownloader.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFileDownloader.h"
#import "JXFileCache.h"

static NSString *const sFileCacheDirName = @"FileCache";

@interface JXFileDownloader () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, copy) JXFileDownloadProgressCompletionBlock progressBlock;
@property (nonatomic, copy) JXFileDownloadCompletionBlock completedBlock;

@property (strong, nonatomic) NSMutableData *imageData;

@property (strong, atomic) NSThread *thread;

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
//    // Session
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:fileURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSURL *localFileURL = nil;
//        NSData *fileData = [NSData dataWithContentsOfURL:location];
//        
//        if (fileData) {
//            
//            
//            
//            
//            
//            
//            
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *cacheDirectory = [paths objectAtIndex:0];
//            NSFileManager *fm = [NSFileManager defaultManager];
//            NSString *dirPath = [NSString stringWithFormat:@"%@/%@/%@", cacheDirectory, [NSBundle mainBundle].bundleIdentifier, sFileCacheDirName];
//            NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", dirPath, [fileURL.absoluteString JX_md5], [fileURL pathExtension]];
//            
//            BOOL createDirectorySuccess = [fm createDirectoryAtPath:dirPath
//                                        withIntermediateDirectories:YES
//                                                         attributes:nil
//                                                              error:nil];
//            if (createDirectorySuccess) {
//                BOOL createFileSuccess = [fm createFileAtPath:filePath
//                                                     contents:fileData
//                                                   attributes:nil];
//                if (createFileSuccess) {
//                    localFileURL = [NSURL fileURLWithPath:filePath];
//                }
//            }
//        }
//        !completedBlock ?: completedBlock(localFileURL, error);
//        
//    }];
//    
//    [downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    /*
     bytesWritten               本次写入的字节数
     totalBytesWritten          已经写入的字节数
     totalBytesExpectedToWrite  下载文件总字节数
     */
    
    if(self.progressBlock){
        self.progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
    }
    
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@" %@ ,progress = %f",[NSThread currentThread],progress);
}
@end
