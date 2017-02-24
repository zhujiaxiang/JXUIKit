//
//  JXPopupMenu.h
//  JXPopupMenu
//
//  Created by 朱佳翔 on 16/7/19.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXPopupMenuItem.h"
#import <UIKit/UIKit.h>

// 3rd
#import <MMPopupView/MMPopupCategory.h>
#import <MMPopupView/MMPopupDefine.h>
#import <MMPopupView/MMPopupView.h>

@class JXPopupMenu;

@protocol JXPopupMenuDelegate <NSObject>

- (void)JX_popupMenu:(nullable JXPopupMenu *)menu didSelectMenuItemAtIndex:(NSUInteger)index;
- (void)JX_popupMenu:(nullable JXPopupMenu *)menu didClickCancelButton:(nullable UIButton *)cancelButton;

@end

@interface JXPopupMenu : MMPopupView

@property(nullable, nonatomic, assign) id<JXPopupMenuDelegate> delegate;
@property(nullable, nonatomic, strong) UILabel *titleLabel;
//- (instancetype)initWithItemList:(NSArray<JXPopupMenuItem *> *)itemList;
- (_Nullable instancetype)initWithNumberOfLines:(NSInteger)numberOfLines numberOfColumns:(NSInteger)numberOfColumns itemList:(NSArray< JXPopupMenuItem *> * _Nullable )itemList;


- (NSInteger)calculatePageWithLines:(NSInteger)line columns:(NSInteger)columns count:(NSInteger)count;



@end
