//
//  SJFileDownloader.h
//  SJFilePreviewViewController
//
//  Created by zjx on 2017/2/23.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SJFileDownloadProgressCompletionBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void (^SJFileDownloadCompletionBlock)(NSURL *__nullable localFileURL, NSError *__nullable error);
typedef void (^KLCheckCacheCompletionBlock)(NSURL *__nullable localFileURL);


@interface SJFileDownloader : NSObject

+ (nullable instancetype)sharedDownloader;

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL progress:(nullable SJFileDownloadProgressCompletionBlock)progressBlock completed:(nonnull SJFileDownloadCompletionBlock)completedBlock;

- (void)cacheFileWithLocation:(nonnull NSURL *)location;

@end
