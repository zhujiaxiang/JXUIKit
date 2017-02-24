//
//  JXPopupMenuItemCell.h
//  JXPopupMenu
//
//  Created by 朱佳翔 on 16/7/22.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JXPopupMenuItem.h"


@class  JXPopupMenuItemCell;


@protocol JXPopupMenuItemCellDelegate <NSObject>

- (void)popupMenuItemCell:(JXPopupMenuItemCell *)menuCell
          selectedAtIndex:(NSInteger)index;

@end

@interface JXPopupMenuItemCell : UICollectionViewCell

@property(nonatomic, strong) UIButton *menuItemButton;
@property(nonatomic, strong) UILabel *menuLabel;

@property (nonatomic, assign) id<JXPopupMenuItemCellDelegate> delegate;
@property (nonatomic, strong) NSArray *menuItems;

@end
