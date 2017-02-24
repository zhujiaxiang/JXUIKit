//
//  JXPopupMenuPageCell.h
//  JXPopupMenu
//
//  Created by 朱佳翔 on 16/7/26.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPopupMenuPageCell;

@protocol JXPageCellDelegate <NSObject>

- (void)JX_popupMenuPageCell:(JXPopupMenuPageCell *)Pagecell didSelectCellAtIndex:(NSInteger)index;

@end
@interface JXPopupMenuPageCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *menuPageItems;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) id<JXPageCellDelegate> delegate;

@end
