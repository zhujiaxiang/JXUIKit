//
//  SJPopupMenu.h
//  SJPopupMenu
//
//  Created by zjx on 16/7/19.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "SJPopupMenuItem.h"
#import <UIKit/UIKit.h>

// 3rd
#import <MMPopupView/MMPopupCategory.h>
#import <MMPopupView/MMPopupDefine.h>
#import <MMPopupView/MMPopupView.h>

@class SJPopupMenu;

@protocol SJPopupMenuDelegate <NSObject>

- (void)sj_popupMenu:(nullable SJPopupMenu *)menu didSelectMenuItemAtIndex:(NSUInteger)index;
- (void)sj_popupMenu:(nullable SJPopupMenu *)menu didClickCancelButton:(nullable UIButton *)cancelButton;

@end

@interface SJPopupMenu : MMPopupView

@property(nullable, nonatomic, assign) id<SJPopupMenuDelegate> delegate;
@property(nullable, nonatomic, strong) UILabel *titleLabel;
//- (instancetype)initWithItemList:(NSArray<SJPopupMenuItem *> *)itemList;
- (_Nullable instancetype)initWithNumberOfLines:(NSInteger)numberOfLines numberOfColumns:(NSInteger)numberOfColumns itemList:(NSArray< SJPopupMenuItem *> * _Nullable )itemList;


- (NSInteger)calculatePageWithLines:(NSInteger)line columns:(NSInteger)columns count:(NSInteger)count;



@end
