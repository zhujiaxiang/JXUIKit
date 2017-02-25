//
//  JXFileCache.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFileCache.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const sFileCacheDirName = @"FileCache";

@implementation JXFileCache

+ (instancetype)sharedCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nullable NSString *)makeDiskCachePath:(nonnull NSString *)fullNamespace
{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key
{
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                                                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                                                    r[11], r[12], r[13], r[14], r[15], [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension]];

    return filename;
}

- (nullable NSURL *)getLocalFileURLByFullNamespace:(nullable NSString *)fullNamespace URL:(nonnull NSURL *)url contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr
{
    NSURL *localFileURL = nil;
    //构建缓存目录
    NSString *cacheDirectory = [self makeDiskCachePath:fullNamespace];
    //构建指定文件缓存目录
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@/%@", cacheDirectory, [NSBundle mainBundle].bundleIdentifier, sFileCacheDirName];
    //构建缓存文件的路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, [self cachedFileNameForKey:url.absoluteString]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    BOOL createFileSuccess = [fm createFileAtPath:filePath
                                         contents:data
                                       attributes:nil];
    if (createFileSuccess) {
        localFileURL = [NSURL fileURLWithPath:filePath];
    }
    
    return localFileURL;
}

@end
