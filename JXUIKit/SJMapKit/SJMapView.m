//
//  SJMapView.m
//  SJMapKit
//
//  Created by zjx on 16/7/4.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "SJMapView.h"

@implementation SJMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.showsUserLocation = YES;

    return self;
}

@end
