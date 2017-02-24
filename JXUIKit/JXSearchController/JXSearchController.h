//
//  JXSearchController.h
//  JXSearchController
//
//  Created by 朱佳翔 on 16/5/10.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXSearchController;

@protocol JXSearchControllerDelegate <NSObject, UISearchControllerDelegate>

@optional

//- (void)JX_searchController:(JXSearchController *)searchController

@end

@interface JXSearchController : UISearchController

@property(nonatomic, assign) BOOL allowVoiceSearch;

@property(nullable, nonatomic, weak) id<JXSearchControllerDelegate> delegate;

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
