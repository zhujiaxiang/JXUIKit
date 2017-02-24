//
//  JXPopupMenu.m
//  JXPopupMenu
//
//  Created by 朱佳翔 on 16/7/19.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXPopupMenu.h"
#import "JXPopupMenuItem.h"
#import "JXPopupMenuItemCell.h"
#import "JXPopupMenuPageCell.h"

#import <Masonry/Masonry.h>
@interface JXPopupMenu () <UICollectionViewDataSource, UICollectionViewDelegate,
                           UICollectionViewDelegateFlowLayout,
                           JXPageCellDelegate>

@property(nullable, nonatomic, strong) UICollectionView *menuCollectionView;

@property(nullable, nonatomic, strong) UIButton *completeButton;
@property(nullable, nonatomic, strong) NSArray *menuItems;
@property(nullable, nonatomic, strong) UIPageControl *pageControl;
@property(nullable, nonatomic, strong) UIView *dividingLineAbove;
@property(nullable, nonatomic, strong) UIView *dividingLineDown;
@property(nonatomic, assign) NSInteger numberOfLines;
@property(nonatomic, assign) NSInteger numberOfColumns;
@property(nonatomic, assign) NSInteger counts;

@end

@implementation JXPopupMenu

- (instancetype)initWithNumberOfLines:(NSInteger)numberOfLines numberOfColumns:(NSInteger)numberOfColumns itemList:(NSArray<JXPopupMenuItem *> *)itemList
{
    self = [super init];

    if (self) {
        self.type = MMPopupTypeSheet;
        self.backgroundColor = [UIColor whiteColor];

        self.menuItems = itemList;
        if (numberOfColumns < 3) {
            _numberOfColumns = 3;
        }
        else if (numberOfColumns > 5) {
            _numberOfColumns = 5;
        }
        else {
            _numberOfColumns = numberOfColumns;
        }

        if (numberOfLines > 5) {
            _numberOfLines = 5;
        }
        else if (numberOfLines < 1) {
            _numberOfLines = 1;
        }
        else {
            _numberOfLines = numberOfLines;
        }

        NSInteger numberOfPages = [self calculatePageWithLines:self.numberOfLines columns:self.numberOfColumns count:itemList.count];

        self.counts = itemList.count;

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(100 + 90 * self.numberOfLines + 20);
        }];

        self.titleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = @"分享到";
            view.textColor = [UIColor blackColor];
            view.textAlignment = NSTextAlignmentCenter;

            [self addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50));
            }];

            view;

        });

        self.completeButton = ({

            UIButton *view = [[UIButton alloc] init];
            [view setTitle:@"完成" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
            [view addTarget:self action:@selector(completeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(
                    CGSizeMake([UIScreen mainScreen].bounds.size.width, 50));
                make.bottom.equalTo(self);
                make.left.equalTo(self);
            }];

            view;

        });

        self.menuCollectionView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.sectionInset = UIEdgeInsetsMake(0,
                                                       0,
                                                       0,
                                                       0);
            flowLayout.minimumLineSpacing = 0;
            UICollectionView *view =
                [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view.backgroundColor = [UIColor clearColor];
            view.bounces = NO;
            view.pagingEnabled = YES;
            view.showsHorizontalScrollIndicator = NO;
            view.dataSource = self;
            view.delegate = self;

            NSString *identifier = NSStringFromClass([JXPopupMenuPageCell class]);
            [view registerClass:[JXPopupMenuPageCell class] forCellWithReuseIdentifier:identifier];

            [self addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.mas_equalTo(self.mas_top).offset(50);
                make.size.mas_equalTo(
                    CGSizeMake([UIScreen mainScreen].bounds.size.width, 90 * numberOfLines));
            }];

            view;

        });
        self.pageControl = ({

            UIPageControl *view = [[UIPageControl alloc] init];
            _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
            view.numberOfPages = numberOfPages;
            if (view.numberOfPages == 1) {
                view.hidden = YES;
            }

            view.pageIndicatorTintColor = [UIColor grayColor];
            view.currentPageIndicatorTintColor = [UIColor blackColor];

            [self addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.menuCollectionView.mas_bottom);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.size.mas_equalTo(
                    CGSizeMake(100, 20));

            }];
            view;

        });
        self.dividingLineAbove = ({
            UIView *view = [[UIView alloc] init];

            view.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];

            [self addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom);
                make.left.mas_equalTo(self.titleLabel.mas_left);
                make.size.mas_equalTo(
                    CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));

            }];

            view;
        });
        self.dividingLineDown = ({
            UIView *view = [[UIView alloc] init];

            view.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];

            [self addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.completeButton.mas_top);
                make.left.mas_equalTo(self.completeButton.mas_left);
                make.size.mas_equalTo(
                    CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));

            }];

            view;
        });
    }

    return self;
}

- (NSInteger)calculatePageWithLines:(NSInteger)line columns:(NSInteger)columns count:(NSInteger)count
{
    NSInteger numberOfPages;
    if (line == 0 || columns == 0 || count == 0) {
        NSLog(@"Bad input");
        return 0;
    }
    else {
        if ((count % (line * columns)) != 0) {
            numberOfPages = count / (line * columns) + 1;
        }
        else {
            numberOfPages = count / (line * columns);
        }

        NSLog(@"%ld 页", numberOfPages);
        return numberOfPages;
    }
    return 0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if ((self.menuItems.count % (self.numberOfLines * self.numberOfColumns)) == 0)
        return (self.menuItems.count / (self.numberOfLines * self.numberOfColumns));
    else {
        return (self.menuItems.count / (self.numberOfLines * self.numberOfColumns)) + 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0,
                                               0,
                                               0,
                                               0);
    flowLayout.itemSize = CGSizeMake(80.0, 80.0);

    NSString *identifier = NSStringFromClass([JXPopupMenuPageCell class]);

    JXPopupMenuPageCell *cell = [collectionView
        dequeueReusableCellWithReuseIdentifier:identifier
                                  forIndexPath:indexPath];

    NSInteger loc = indexPath.row * self.numberOfColumns * self.numberOfLines;
    NSInteger len = (loc + self.numberOfColumns * self.numberOfLines) > self.menuItems.count ? self.menuItems.count - loc : self.numberOfColumns * self.numberOfLines;

    cell.menuPageItems = [self.menuItems subarrayWithRange:NSMakeRange(loc, len)];
    cell.flowLayout = flowLayout;
    cell.numberOfColumns = self.numberOfColumns;
    cell.delegate = self;

    return cell;
}

#pragma mark - JXPageCellDelegate
- (void)JX_popupMenuPageCell:(JXPopupMenuPageCell *)Pagecell didSelectCellAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(JX_popupMenu:didSelectMenuItemAtIndex:)]) {
        [self.delegate JX_popupMenu:self didSelectMenuItemAtIndex:self.pageControl.currentPage * self.numberOfColumns * self.numberOfLines + index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.menuCollectionView.frame.size.width;

    self.pageControl.currentPage = (self.menuCollectionView.contentOffset.x + pageWidth / 2) / pageWidth;
}

#pragma mark - UICollectionViewDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)
                                                 collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    return CGSizeMake(keyWindow.frame.size.width, self.menuCollectionView.frame.size.height);
}

#pragma mark - Actions
- (void)completeButtonTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(JX_popupMenu:didClickCancelButton:)]) {
        [self.delegate JX_popupMenu:self didClickCancelButton:sender];
    }
}
@end
