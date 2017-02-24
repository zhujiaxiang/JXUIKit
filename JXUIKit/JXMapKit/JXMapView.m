//
//  JXMapView.m
//  JXMapKit
//
//  Created by 朱佳翔 on 16/7/4.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXMapView.h"

@implementation JXMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.showsUserLocation = YES;

    return self;
}

@end
