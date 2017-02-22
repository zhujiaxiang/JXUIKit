//
//  SJPopupMenuPageCell.h
//  SJPopupMenu
//
//  Created by zjx on 16/7/26.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJPopupMenuPageCell;

@protocol SJPageCellDelegate <NSObject>

- (void)sj_popupMenuPageCell:(SJPopupMenuPageCell *)Pagecell didSelectCellAtIndex:(NSInteger)index;

@end
@interface SJPopupMenuPageCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *menuPageItems;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) id<SJPageCellDelegate> delegate;

@end
