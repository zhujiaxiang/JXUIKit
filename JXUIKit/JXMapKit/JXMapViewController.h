//
//  JXMapViewController.h
//  JXMapKit
//
//  Created by 朱佳翔 on 16/7/4.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MapViewShowType) {
    kMapViewLocationType = 0,
    kMapViewAnnotationType = 1,
};

@class JXMapViewController;

@protocol JXMapViewControllerDelegate <NSObject>

@optional

/**
 *  结束定位
 *
 *  @param mapViewController 视图控制器实例
 *  @param locationInfo      位置信息
 *  @param mapSnapshot       地图截图
 */
- (void)JX_mapViewController:(JXMapViewController *)mapViewController didFinishLocatingWithInfo:(NSDictionary *)locationInfo mapSnapshot:(UIImage *)mapSnapshot;

- (void)JX_mapViewController:(JXMapViewController *)mapViewController currentLocationInfo:(NSDictionary *)locationInfo;

- (void)JX_mapViewController:(JXMapViewController *)mapViewController touchLocationInfo:(NSDictionary *)locationInfo;
@end

@interface JXMapViewController : UIViewController

@property(nonatomic, assign) id<JXMapViewControllerDelegate> mapDelegate;
@property(nonatomic, assign) MapViewShowType mapViewShowType;

- (void)cropperMap;
- (void)makeAnnotationAt:(CLLocation *)location;
- (void)deleteLastAnnotation;

@end
