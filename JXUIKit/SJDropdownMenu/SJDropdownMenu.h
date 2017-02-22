//
//  SJDropdownMenu.h
//  SJDropdownMenu
//
//  Created by zjx on 16/8/3.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SJDropdownMenu : UIView

-(UIColor*)tintColor;

- (UIFont *) titleFont;

-(void)showMenuFromRect:(CGRect)rect menuItems:(NSArray*)menuTems;

@end
