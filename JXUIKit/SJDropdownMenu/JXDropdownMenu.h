//
//  JXDropdownMenu.h
//  JXDropdownMenu
//
//  Created by 朱佳翔 on 16/8/3.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXDropdownMenu : UIView

-(UIColor*)tintColor;

- (UIFont *) titleFont;

-(void)showMenuFromRect:(CGRect)rect menuItems:(NSArray*)menuTems;

@end
