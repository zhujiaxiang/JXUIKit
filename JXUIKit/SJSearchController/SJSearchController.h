//
//  SJSearchController.h
//  SJSearchController
//
//  Created by zjx on 16/5/10.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJSearchController;

@protocol SJSearchControllerDelegate <NSObject, UISearchControllerDelegate>

@optional

//- (void)sj_searchController:(SJSearchController *)searchController

@end

@interface SJSearchController : UISearchController

@property(nonatomic, assign) BOOL allowVoiceSearch;

@property(nullable, nonatomic, weak) id<SJSearchControllerDelegate> delegate;

/*
    搜索数组，返回新的数组。
    DatasourceArray      要搜索的数据源
    searchText           要搜索的内容
    返回 NSArray型结果集合
*/
- (NSMutableArray *)searchWithDatasourceArray:(NSMutableArray<NSDictionary *> *)DatasourceArray
                                   SearchText:(NSString *)searchText;

- (BOOL)containChineseCharacter:(NSString *)string;
- (void)convertIntoPinYinWithInitial;
- (void)convertIntoPinYin:(NSMutableString *)chineseString;

@end
