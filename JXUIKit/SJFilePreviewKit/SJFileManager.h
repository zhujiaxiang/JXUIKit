//
//  SJFileManager.h
//  SJFilePreviewKit
//
//  Created by zjx on 2017/2/17.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SJFileDownloadProgressCompletionBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void (^SJFileDownloadCompletionBlock)(NSURL *__nullable localFileURL, NSError *__nullable error);
typedef void (^KLCheckCacheCompletionBlock)(NSURL *__nullable localFileURL);


@interface SJFileManager : NSObject

+ (nullable instancetype)sharedManager;

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL progress:(nullable SJFileDownloadProgressCompletionBlock)progressBlock completed:(nonnull SJFileDownloadCompletionBlock)completedBlock;

@end
