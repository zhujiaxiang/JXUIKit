//
//  JXPopupMenuPageCell.m
//  JXPopupMenu
//
//  Created by 朱佳翔 on 16/7/26.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXPopupMenuItem.h"
#import "JXPopupMenuItemCell.h"
#import "JXPopupMenuPageCell.h"

// 3rd
#import <Masonry/Masonry.h>
@interface JXPopupMenuPageCell () <UICollectionViewDataSource,
                                   UICollectionViewDelegate,
                                   UICollectionViewDelegateFlowLayout, JXPopupMenuItemCellDelegate>

@property(nonatomic, strong) UICollectionView *pageCollectionView;
@property(nonatomic, assign) NSInteger columns;

@end

@implementation JXPopupMenuPageCell

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
            NSString *identifier = NSStringFromClass([JXPopupMenuItemCell class]);
            [view registerClass:[JXPopupMenuItemCell class] forCellWithReuseIdentifier:identifier];
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
        NSString *identifier = NSStringFromClass([JXPopupMenuItemCell class]);
        [view registerClass:[JXPopupMenuItemCell class] forCellWithReuseIdentifier:identifier];
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
    JXPopupMenuItem *menuItem = (JXPopupMenuItem *)[self.menuPageItems objectAtIndex:indexPath.row];

    NSString *identifier = NSStringFromClass([JXPopupMenuItemCell class]);
    JXPopupMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

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

#pragma mark - JXPopupMenuItemCellDelegate
- (void)popupMenuItemCell:(JXPopupMenuItemCell *)menuCell
          selectedAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(JX_popupMenuPageCell:didSelectCellAtIndex:)]) {
        [self.delegate JX_popupMenuPageCell:self didSelectCellAtIndex:index];
    }
}

@end
