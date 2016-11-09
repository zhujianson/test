//
//  HealthImageViewController.h
//  jiuhaoHealth2.0
//
//  Created by wangmin on 14-4-9.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@protocol SearchDelegate;
@interface HealthImageViewController : CommonViewController
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, UITextFieldDelegate>

@property (nonatomic,assign) id<SearchDelegate> healthImageVCDelegate;//代理

- (void)hiddenCheckBtn;

@end
/**
 *  返回搜索状态
 */
@protocol SearchDelegate <NSObject>

- (void)searchStatues:(BOOL)isSearching;

@end