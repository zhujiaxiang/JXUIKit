//
//  JXDropdownMenuItem.h
//  JXDropdownMenu
//
//  Created by 朱佳翔 on 16/8/3.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//UI层 数据模型
@interface JXDropdownMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, strong) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action;

- (BOOL) enabled;

- (void) performAction;

@end
