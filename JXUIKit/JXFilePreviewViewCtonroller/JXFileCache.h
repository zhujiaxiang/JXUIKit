//
//  JXFileCache.h
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXFileCache : NSObject

+ (nullable instancetype)sharedCache;

- (nullable NSString *)makeDiskCachePath:(nonnull NSString *)fullNamespace;

- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key;

- (nullable NSString *)getFilePathByFullNamespace:(nonnull NSString *)fullNamespace fileName:(nullable NSString *)name;

- (nullable NSString *)getlocalFileURLByPath:(nullable NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr;

@end
