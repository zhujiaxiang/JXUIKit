## SJFilePreviewViewController

### 介绍
使用 QLPreviewController 进行预览

Quicklook 支持的文件：
iWork文档
微软Office97以上版本的文档
RTF文档
PDF文件
图片文件
文本文件和CSV文件

下载方式采用NSURLSession

缓存方式为磁盘缓存

### 工程结构
```
SJFilePreviewViewController
├ SJFilePreviewViewController(lib)
├ SJFileLoadingView.h
├ SJFileLoadingView.m
├ SJFilePreviewViewController.h
├ SJFilePreviewViewController.m
├ SJFileDownloader.h
├ SJFileDownloader.m
├ SJFileCache.h
├ SJFileCache.m
├ SJFilePreviewViewControllerDemo(app)
```

### 详细设计

```
@interface SJFileDownloader : NSObject

+ (nullable instancetype)sharedDownloader;

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL progress:(nullable SJFileDownloadProgressCompletionBlock)progressBlock completed:(nonnull SJFileDownloadCompletionBlock)completedBlock;

@end

@interface SJFilePreviewViewController : QLPreviewController

- (nullable instancetype)initWithFileURL:(nullable NSURL *)fileURL fileTitle:(nullable NSString *)fileTitle;

@end

@interface SJFilePreviewViewController () <QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (nonnull, nonatomic, copy) NSURL *webFileURL;
@property (nonnull, nonatomic, copy) NSURL *localFileURL;
@property (nonnull, nonatomic, copy) NSString *fileTitle;
@property (nonnull, nonatomic, strong) SJFileLoadingView *loadingView ;

@end

@interface SJFileCache : NSObject

+ (nullable instancetype)sharedCache;

- (nullable NSString *)makeDiskCachePath:(nonnull NSString*)fullNamespace;

- (nullable NSString *)getCachedFilePathByKey:(nullable NSString *)key;

- (nullable NSString *)getlocalFileURLByPath:(nullable NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr;

@end
```
