//
//  SJPopupMenuPageCell.m
//  SJPopupMenu
//
//  Created by zjx on 16/7/26.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "SJPopupMenuItem.h"
#import "SJPopupMenuItemCell.h"
#import "SJPopupMenuPageCell.h"

// 3rd
#import <Masonry/Masonry.h>
@interface SJPopupMenuPageCell () <UICollectionViewDataSource,
                                   UICollectionViewDelegate,
                                   UICollectionViewDelegateFlowLayout, SJPopupMenuItemCellDelegate>

@property(nonatomic, strong) UICollectionView *pageCollectionView;
@property(nonatomic, assign) NSInteger columns;

@end

@implementation SJPopupMenuPageCell

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.pageCollectionView = ({

            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

            flowLayout.itemSize = CGSizeMake(50.0, 50.0);

            UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            view.backgroundColor = [UIColor clearColor];
            view.delegate = self;
            view.dataSource = self;
            view.scrollEnabled = NO;
            NSString *identifier = NSStringFromClass([SJPopupMenuItemCell class]);
            [view registerClass:[SJPopupMenuItemCell class] forCellWithReuseIdentifier:identifier];
            view.translatesAutoresizingMaskIntoConstraints = NO;

            [self.contentView addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.left.mas_equalTo(self.mas_left);
                make.height.mas_equalTo(self.bounds.size.height);
                make.width.mas_equalTo(self.bounds.size.width);

            }];
            view;
        });
    }

    return self;
}

- (void)setFlowLayout:(UICollectionViewFlowLayout *)flowLayout
{
    [self.pageCollectionView removeFromSuperview];
    self.pageCollectionView = ({

        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        view.dataSource = self;
        view.scrollEnabled = NO;
        NSString *identifier = NSStringFromClass([SJPopupMenuItemCell class]);
        [view registerClass:[SJPopupMenuItemCell class] forCellWithReuseIdentifier:identifier];
        view.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.height.mas_equalTo(self.bounds.size.height);
            make.width.mas_equalTo(self.bounds.size.width);

        }];
        view;
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuPageItems.count;
}

#pragma mark - UICollectionViewDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)
                                                 collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJPopupMenuItem *menuItem = (SJPopupMenuItem *)[self.menuPageItems objectAtIndex:indexPath.row];

    NSString *identifier = NSStringFromClass([SJPopupMenuItemCell class]);
    SJPopupMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    [cell.menuItemButton setImage:menuItem.icon forState:UIControlStateNormal];
    cell.menuLabel.text = menuItem.title;
    cell.delegate = self;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / self.numberOfColumns;
    return CGSizeMake(width, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", (long)indexPath.row);
}

#pragma mark - SJPopupMenuItemCellDelegate
- (void)popupMenuItemCell:(SJPopupMenuItemCell *)menuCell
          selectedAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(sj_popupMenuPageCell:didSelectCellAtIndex:)]) {
        [self.delegate sj_popupMenuPageCell:self didSelectCellAtIndex:index];
    }
}

@end
