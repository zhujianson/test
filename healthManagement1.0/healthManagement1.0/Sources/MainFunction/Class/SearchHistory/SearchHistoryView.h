//
//  SearchHistoryTableViewController.h
//  MapPoint
//
//  Created by xuguohong on 16/5/31.
//  Copyright © 2016年 xuguohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHistoryViewDelegate <NSObject>

- (void)searchHistorySelectTitle:(NSString*)title;

@end

@interface SearchHistoryView : UIView

@property (nonatomic, weak) id<SearchHistoryViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchText;

- (void)addHistory:(NSString*)title;

@end
