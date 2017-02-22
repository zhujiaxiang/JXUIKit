//
//  SJPopupMenuItemCell.h
//  SJPopupMenu
//
//  Created by zjx on 16/7/22.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SJPopupMenuItem.h"


@class  SJPopupMenuItemCell;


@protocol SJPopupMenuItemCellDelegate <NSObject>

- (void)popupMenuItemCell:(SJPopupMenuItemCell *)menuCell
          selectedAtIndex:(NSInteger)index;

@end

@interface SJPopupMenuItemCell : UICollectionViewCell

@property(nonatomic, strong) UIButton *menuItemButton;
@property(nonatomic, strong) UILabel *menuLabel;

@property (nonatomic, assign) id<SJPopupMenuItemCellDelegate> delegate;
@property (nonatomic, strong) NSArray *menuItems;

@end
