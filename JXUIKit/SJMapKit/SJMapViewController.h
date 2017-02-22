//
//  SJMapViewController.h
//  SJMapKit
//
//  Created by zjx on 16/7/4.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MapViewShowType) {
    kMapViewLocationType = 0,
    kMapViewAnnotationType = 1,
};

@class SJMapViewController;

@protocol SJMapViewControllerDelegate <NSObject>

@optional

/**
 *  结束定位
 *
 *  @param mapViewController 视图控制器实例
 *  @param locationInfo      位置信息
 *  @param mapSnapshot       地图截图
 */
- (void)sj_mapViewController:(SJMapViewController *)mapViewController didFinishLocatingWithInfo:(NSDictionary *)locationInfo mapSnapshot:(UIImage *)mapSnapshot;

- (void)sj_mapViewController:(SJMapViewController *)mapViewController currentLocationInfo:(NSDictionary *)locationInfo;

- (void)sj_mapViewController:(SJMapViewController *)mapViewController touchLocationInfo:(NSDictionary *)locationInfo;
@end

@interface SJMapViewController : UIViewController

@property(nonatomic, assign) id<SJMapViewControllerDelegate> mapDelegate;
@property(nonatomic, assign) MapViewShowType mapViewShowType;

- (void)cropperMap;
- (void)makeAnnotationAt:(CLLocation *)location;
- (void)deleteLastAnnotation;

@end
