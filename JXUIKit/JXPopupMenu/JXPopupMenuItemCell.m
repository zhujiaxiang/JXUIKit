//
//  JXPopupMenuItemCell.m
//  JXPopupMenu
//
//  Created by 朱佳翔 on 16/7/22.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXPopupMenuItemCell.h"

// 3rd
#import <Masonry/Masonry.h>

@implementation JXPopupMenuItemCell

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.menuItemButton = ({
            UIButton *view = [[UIButton alloc] init];
            view.translatesAutoresizingMaskIntoConstraints = NO;

            [view addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(10);
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.height.mas_equalTo(self.bounds.size.height * 0.6);
                make.width.mas_equalTo(self.bounds.size.height * 0.6);
            }];

            view;
        });

        self.menuLabel = ({
            UILabel *view = [[UILabel alloc] init];

            view = [[UILabel alloc] init];
            view.numberOfLines = 2;
            view.textAlignment = NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:12];
            view.textColor = [UIColor blackColor];
            view.translatesAutoresizingMaskIntoConstraints = NO;

            [self.contentView addSubview:view];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.menuItemButton.mas_bottom);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.height.mas_equalTo(self.bounds.size.height * 0.3);
                make.width.mas_equalTo(self.contentView.mas_width);
            }];

            view;
        });

    }

    return self;
}

#pragma mark - Actions
- (void)menuButtonTapped:(UIButton *)sender
{
    UIView *view = [sender superview];                                                   //获取父类view
    UICollectionViewCell *cell = (UICollectionViewCell *)[view superview];               //获取cell
    NSIndexPath *indexpath = [(UICollectionView *)self.superview indexPathForCell:cell]; //获

    NSLog(@"%ld", (long)indexpath.row);

    if ([self.delegate respondsToSelector:@selector(popupMenuItemCell:selectedAtIndex:)]) {
        [self.delegate popupMenuItemCell:self selectedAtIndex:indexpath.row];
    }
}
@end
