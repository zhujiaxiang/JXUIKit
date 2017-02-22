//
//  SJMapViewController.m
//  SJMapKit
//
//  Created by zjx on 16/7/4.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "SJMapViewController.h"

#import "SJImageCropperView.h"
#import "SJMapView.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

// 3rd
#import <Masonry/Masonry.h>

#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface SJMapViewController () <MKMapViewDelegate,
                                   CLLocationManagerDelegate,
                                   UITextFieldDelegate>

@property(nullable, nonatomic, strong) SJMapView *mapView;
@property(nullable, nonatomic, strong) CLLocationManager *locationManager; // 定位管理
@property(nonatomic, assign) int updateInt;                                // updateInt初始化为0，大于1时，didUpdateUserLocation中setRegion不再执行,保证只有一个小圆点
@property(nonatomic, assign) int updateCorInt;
@property(nullable, nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, assign) CLLocationDegrees latitude;  // 火星坐标经度
@property(nonatomic, assign) CLLocationDegrees longitude; // 火星坐标纬度
@property(nonatomic, strong) NSString *address;           // 位置信息
@property(nullable, nonatomic, strong) UIButton *makeAnnotationButton;
@property(nullable, nonatomic, strong) UIImageView *annotationView;
@property(nullable, nonatomic, strong) UILabel *titleLabel;
@property(nullable, nonatomic, strong) UIButton *backButton;
@property(nullable, nonatomic, strong) SJImageCropperView *cropper; // 截图工具
@property(nullable, nonatomic, strong) UIImage *mapImage;           // 地理位置截图
@property(nullable, nonatomic, strong) NSMutableArray *annotationArray;

@end

@implementation SJMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.annotationArray = @[].mutableCopy;

    self.mapView = ({

        SJMapView *view = [[SJMapView alloc] init];
        view.delegate = self;

        [self.view addSubview:view];

        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMapView:)];
        [view addGestureRecognizer:click];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view.superview);
        }];

        view;
    });

    self.locationManager = ({

        CLLocationManager *manager = [[CLLocationManager alloc] init];
        [manager requestAlwaysAuthorization];
        [manager setDelegate:self];
        [manager setDesiredAccuracy:kCLLocationAccuracyBest];
        [manager setDistanceFilter:0.5];

        manager;
    });

    switch (self.mapViewShowType) {
    case kMapViewLocationType:
        self.annotationView = ({

            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(self.mapView.center.x, self.mapView.center.y, 40, 40)];
            view.image = [UIImage imageNamed:@"anjuke_icon_itis_position"];
            view.contentMode = UIViewContentModeScaleAspectFit;

            [self.view addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mapView.center.x - 1);
                make.centerY.mas_equalTo(self.mapView.center.y - 9);
            }];

            view;
        });

        self.titleLabel = ({

            UILabel *view = [[UILabel alloc] init];
            view.font = [UIFont systemFontOfSize:15];
            view.backgroundColor = [UIColor darkGrayColor];
            view.textColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = YES;

            [self.view addSubview:view];

            view;
        });

        break;

    case kMapViewAnnotationType: {
        CLLocationDegrees latitude = 31.275977;
        CLLocationDegrees longtitude = 121.368619;
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
        annotation.title = @"详细位置";

        [self.annotationArray addObject:annotation];
        [self.mapView addAnnotation:[self.annotationArray lastObject]];
        break;
    }
    }

    self.backButton = ({

        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 4;
        view.layer.borderWidth = 0.5;
        [view setImage:[UIImage imageNamed:@"wl_map_icon_position"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"wl_map_icon_position_press"] forState:UIControlEventTouchUpInside];
        view.alpha = 0.5;

        [view addTarget:self action:@selector(onClickBackButton:) forControlEvents:UIControlEventTouchUpInside];

        [self.mapView addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapView.mas_left).offset(8);
            make.bottom.mas_equalTo(self.mapView.mas_bottom).offset(-20);
        }];

        view;
    });

    self.cropper = ({

        SJImageCropperView *view = [[SJImageCropperView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 900, 900)];
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [UIColor redColor].CGColor;

        view;
    });

    self.currentLocation = [[CLLocation alloc] init];
    self.updateInt = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    CLLocation *currLocation = [locations lastObject];

    self.latitude = currLocation.coordinate.latitude;
    self.longitude = currLocation.coordinate.longitude;
    NSLog(@"la---%f, lo---%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude);
    [self sj_SetMapViewWithRegion:currLocation.coordinate];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self.updateInt = 100;
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

#pragma mark - 自定义类
// 获取指定最大宽度和字体大小的string的size
- (CGSize)getSizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGSize size = [string sizeWithAttributes:attributes];
    return size;
}

//放大地图到自身的经纬度位置
- (void)sj_SetMapViewWithRegion:(CLLocationCoordinate2D)myLocation
{
    if (self.updateInt >= 10) {
        return;
    }
    self.updateInt += 1;

    //    //手机获取坐标转化为火星坐标
    double latitude = 0.0;
    double longitude = 0.0;
    transform_earth_to_mars(self.latitude, self.longitude, &latitude, &longitude);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude + self.latitude longitude:longitude + self.longitude];

    [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.0002, 0.0002)) animated:NO];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    switch (self.mapViewShowType) {
    case kMapViewLocationType: {
        CLLocationCoordinate2D centerCoordinate = mapView.region.center;

        double latitude = 0.0;
        double longitude = 0.0;
        transform_earth_to_mars(centerCoordinate.latitude, centerCoordinate.longitude, &latitude, &longitude);

        //地图上获取的火星坐标转化为地球坐标
        CLLocation *location = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude - latitude longitude:centerCoordinate.longitude - longitude];

        //地图上获取的火星坐标转化为百度坐标
        double baiduLatitude = 0.0;
        double baiduLongitude = 0.0;
        transform_mars_to_baidu(centerCoordinate.latitude, centerCoordinate.longitude, &baiduLatitude, &baiduLongitude);

        WEAKSELF

        self.currentLocation = location;

        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           if(placemarks.count >0){
                           for (CLPlacemark *place in placemarks) {
                               CLPlacemark *plmark = [placemarks objectAtIndex:0];
                               NSLog(@"name,%@", place.name);
                               self.address = place.name;
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   CGSize titleLabelSize = [self getSizeOfString:plmark.name maxWidth:290 withFontSize:15];
                                   float titleWidth = (titleLabelSize.width <= 80) ? 80 : titleLabelSize.width;
                                   weakSelf.titleLabel.frame = CGRectMake(weakSelf.annotationView.frame.origin.x - titleWidth / 2, weakSelf.annotationView.frame.origin.y - 50, titleWidth + 3, 40);
                                   self.titleLabel.text = plmark.name;
                                   self.titleLabel.textAlignment = UITextAlignmentCenter;

                               });
                           }
                           }
                       }];

        if ([self.mapDelegate respondsToSelector:@selector(sj_mapViewController:currentLocationInfo:)]) {
            NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];
            [locationDictionary setValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"earth_latitude"];
            [locationDictionary setValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"earth_longitude"];
            [locationDictionary setValue:[NSString stringWithFormat:@"%f", centerCoordinate.latitude] forKey:@"mars_latitude"];
            [locationDictionary setValue:[NSString stringWithFormat:@"%f", centerCoordinate.longitude] forKey:@"mars_longitude"];
            [locationDictionary setValue:[NSString stringWithFormat:@"%f", baiduLatitude] forKey:@"baidu_latitude"];
            [locationDictionary setValue:[NSString stringWithFormat:@"%f", baiduLongitude] forKey:@"baidu_longitude"];
            [locationDictionary setValue:self.address forKey:@"address"];

            [self.mapDelegate sj_mapViewController:self currentLocationInfo:locationDictionary];
        }
        break;
    }
    default:
        break;
    }
}

#pragma mark - Actions
- (void)onClickMapView:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.mapDelegate respondsToSelector:@selector(sj_mapViewController:touchLocationInfo:)]) {

        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView]; //这里touchPoint是点击的某点在地图控件中的位置
        CLLocationCoordinate2D touchMapCoordinate =
            [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

        double latitude = 0.0;
        double longitude = 0.0;
        transform_earth_to_mars(touchMapCoordinate.latitude, touchMapCoordinate.longitude, &latitude, &longitude);

        //地图上获取的火星坐标转化为地球坐标
        CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude - latitude longitude:touchMapCoordinate.longitude - longitude];

        NSLog(@"touching %f,%f", location.coordinate.latitude, location.coordinate.longitude);

        NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];

        [locationDictionary setValue:[NSString stringWithFormat:@"%f", touchMapCoordinate.latitude] forKey:@"mars_latitude"];
        [locationDictionary setValue:[NSString stringWithFormat:@"%f", touchMapCoordinate.longitude] forKey:@"mars_longitude"];

        //显示的是火星坐标对应的地球坐标所展示的地址
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           for (CLPlacemark *place in placemarks) {
                               NSLog(@"name,%@", place.name);
                               [locationDictionary setValue:place.name forKey:@"address"];
                           }

                       }];

        [self.mapDelegate sj_mapViewController:self touchLocationInfo:locationDictionary];
    }
}

- (void)onClickBackButton:(UIButton *)sender
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    self.updateInt = 9;
    [self sj_SetMapViewWithRegion:location.coordinate];
}

#pragma mark - 公用类

- (void)makeAnnotationAt:(CLLocation *)location
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    annotation.title = @"详细位置";
    annotation.subtitle = self.address;

    [self.annotationArray addObject:annotation];
    [self.mapView addAnnotation:[self.annotationArray lastObject]];
}

- (void)deleteLastAnnotation
{
    if (self.annotationArray != nil) {
        [self.mapView removeAnnotation:[self.annotationArray lastObject]];
        [self.annotationArray removeLastObject];
    }
}

- (void)cropperMap
{
    if ([self.mapDelegate respondsToSelector:@selector(sj_mapViewController:didFinishLocatingWithInfo:mapSnapshot:)]) {
        self.mapView.showsUserLocation = NO;
        self.backButton.hidden = YES;

        UIGraphicsBeginImageContextWithOptions(self.mapView.frame.size, YES, 0);

        // 设置截屏大小
        [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.cropper.image = viewImage;
        [self.cropper sj_FinishCropping];
        self.cropper.hidden = YES;

        UIImageWriteToSavedPhotosAlbum(self.cropper.croppedImage, self, nil, nil);

        self.mapImage = self.cropper.croppedImage;

        self.mapView.showsUserLocation = YES;
        self.backButton.hidden = NO;

        NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];
        [locationDictionary setValue:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude] forKey:@"earth_latitude"];
        [locationDictionary setValue:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude] forKey:@"earth_longitude"];

        [self.mapDelegate sj_mapViewController:self didFinishLocatingWithInfo:locationDictionary mapSnapshot:self.mapImage];
    }
}

#pragma mark - 坐标转换算法
/*
 * a = 6378245.0, 1/f = 298.3
 * b = a * (1 - f)
 * ee = (a^2 - b^2) / a^2;
 */
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

// 是否属于中国大陆境内
bool transform_sino_out_china(double latitude, double longitude)
{
    if (longitude < 72.004 || longitude > 137.8347)
        return true;
    if (latitude < 0.8293 || latitude > 55.8271)
        return true;
    return false;
}

// 地球坐标纬度转火星坐标纬度
double transform_earth_to_mars_latitude(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

// 地球坐标经度转火星坐标经度
double transform_earth_to_mars_longitude(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

// 地球坐标转火星坐标
void transform_earth_to_mars(double latitude, double longitude, double *targetLatitude, double *targetLongitude)
{
    if (transform_sino_out_china(latitude, longitude)) {
        *targetLatitude = latitude;
        *targetLongitude = longitude;
        return;
    }
    double earthLatitude = transform_earth_to_mars_latitude(longitude - 105.0, latitude - 35.0);
    double earthLongitude = transform_earth_to_mars_longitude(longitude - 105.0, latitude - 35.0);
    double radLat = latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    earthLatitude = (earthLatitude * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    earthLongitude = (earthLongitude * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *targetLatitude = earthLatitude;
    *targetLongitude = earthLongitude;
}

// 火星坐标转百度坐标
const double x_pi = M_PI * 3000.0 / 180.0;

void transform_mars_to_baidu(double google_latitude, double google_longitude, double *baidu_latitude, double *baidu_longitude)
{
    double x = google_longitude, y = google_latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    *baidu_longitude = z * cos(theta) + 0.0065;
    *baidu_latitude = z * sin(theta) + 0.006;
}

// 百度坐标转火星坐标
void transform_baidu_to_mars(double baidu_latitude, double baidu_longitude, double *google_latitude, double *google_longitude)
{
    double x = baidu_longitude - 0.0065, y = baidu_latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    *google_longitude = z * cos(theta);
    *google_latitude = z * sin(theta);
}

@end
