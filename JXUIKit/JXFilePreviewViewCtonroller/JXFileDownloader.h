//
//  JXFileDownloader.h
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JXFileDownloadProgressCompletionBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void (^JXFileDownloadCompletionBlock)(NSURL *__nullable localFileURL, NSError *__nullable error);
typedef void (^KLCheckCacheCompletionBlock)(NSURL *__nullable localFileURL);


@interface JXFileDownloader : NSObject

+ (nullable instancetype)sharedDownloader;

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL progress:(nullable JXFileDownloadProgressCompletionBlock)progressBlock completed:(nonnull JXFileDownloadCompletionBlock)completedBlock;

- (void)cacheFileWithLocation:(nonnull NSURL *)location;

@end
