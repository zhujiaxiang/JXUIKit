//
//  SJFileCache.h
//  SJFilePreviewViewController
//
//  Created by zjx on 2017/2/23.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJFileCache : NSObject

+ (nullable instancetype)sharedCache;

- (nullable NSString *)makeDiskCachePath:(nonnull NSString *)fullNamespace;

- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key;

- (nullable NSString *)getFilePathByDiskCachePath:(nonnull NSString *)path fileName:(nullable NSString *)name;

- (nullable NSString *)getlocalFileURLByPath:(nullable NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr;

@end
