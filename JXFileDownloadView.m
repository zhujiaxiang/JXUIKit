//
//  JXFileDownloadView.m
//  JXUIKit
//
//  Created by 朱佳翔 on 2017/2/27.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import "JXFileDownloadView.h"
#import "UIImage+jxExtension.h"
#import <Masonry/Masonry.h>


@implementation JXFileDownloadView

- (instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.extensionView = ({
            
            UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_file_unknown"]];
            
            [self addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.mas_equalTo(self.mas_top).offset(25.0f);
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
            view.layer.borderWidth = 2;
            view.layer.borderColor = [UIColor redColor].CGColor;
            
            view;
        });
        
        self.fileTitleLabel = ({
            
            UILabel *view = [[UILabel alloc] init];
            
            [self addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX).offset(25.0f);
                make.top.mas_equalTo(self.extensionView.mas_bottom).offset(15.0f);
                make.height.mas_equalTo(20.0f);
            }];
            view.layer.borderWidth = 2;
            view.layer.borderColor = [UIColor redColor].CGColor;
            
            view;
        });
        
        self.downloadButton = ({
            
            UIButton *view = [[UIButton alloc] init];
            
            [self addSubview:view];
            
            view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
            view.titleLabel.textColor = [UIColor whiteColor];
            [view setBackgroundImage:[UIImage jx_imageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
            view.layer.cornerRadius = 3.0f;
            view.layer.masksToBounds = YES;
            [view setTitle:@"download" forState:UIControlStateNormal];
            [view addTarget:self action:@selector(onClickDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX).offset(10.0f);
                make.top.mas_equalTo(self.fileTitleLabel.mas_bottom).offset(15.0f);
                make.height.mas_equalTo(20.0f);
            }];
            view;
            
        });
        
        self.progressLabel = ({
            
            UILabel *view = [[UILabel alloc] init];
            
            [self addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX).offset(25.0f);
                make.top.mas_equalTo(self.downloadButton.mas_bottom).offset(15.0f);
                make.height.mas_equalTo(20.0f);
            }];
            view.layer.borderWidth = 2;
            view.layer.borderColor = [UIColor redColor].CGColor;
            
            view.hidden = YES;
            
            view;
        });
    }
    return self;
}

- (void)onClickDownloadButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(jx_fileDownloadView:didTappedDownloadButton:)]) {
        [_delegate jx_fileDownloadView:self didTappedDownloadButton:sender];
    }
}
@end
