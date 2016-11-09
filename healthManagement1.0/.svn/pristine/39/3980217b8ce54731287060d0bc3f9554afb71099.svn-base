//
//  SearchHistoryTableViewController.m
//  MapPoint
//
//  Created by xuguohong on 16/5/31.
//  Copyright © 2016年 xuguohong. All rights reserved.
//

#import "SearchHistoryView.h"

@interface SearchHistoryView () <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *m_butClear;
    
    NSMutableArray *m_array;
}

@end

@implementation SearchHistoryView

- (void)dealloc
{
    self.tableView = nil;
    m_array = nil;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        m_array = [[NSMutableArray alloc] init];
        [self getPointHistory];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
        self.tableView.backgroundColor = [UIColor whiteColor];
        [Common setExtraCellLineHidden:self.tableView];
        [self addSubview:self.tableView];
        
        m_butClear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        NSString *title = m_array.count ? @"清空历史" : @"暂无搜索历史记录";
        [m_butClear setTitle:title forState:UIControlStateNormal];
        [m_butClear setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [m_butClear addTarget:self action:@selector(butEventClear) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = m_butClear;
    }
    
    return self;
}

- (void)butEventTag:(UIButton*)but
{
    if ([self.delegate respondsToSelector:@selector(searchHistorySelectTitle:)]) {
        
        [self.delegate searchHistorySelectTitle:but.currentTitle];
    }
}

- (void)butEventClear
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pointHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [m_array removeAllObjects];
    [self.tableView reloadData];
    [m_butClear setTitle:@"暂无搜索历史记录" forState:UIControlStateNormal];
}

- (BOOL)getPointHistory
{
    [m_array removeAllObjects];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointHistory"];
    if (array) {
        [m_array addObjectsFromArray:array];
    }
    return YES;
}

- (void)addHistory:(NSString*)title
{
    if (!title.length)
        return;
    
    if ([m_array containsObject:title]) {
        
        [m_array removeObject:title];
    }
    
    [m_array insertObject:title atIndex:0];
    
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:m_array forKey:@"pointHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchText resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_array.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    view.backgroundColor = [CommonImage colorWithHexString:@"f5f5f5"];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(15, 0, kDeviceWidth-30, 30);
    labTitle.text = @"历史搜索:";
    labTitle.font = [UIFont systemFontOfSize:13];
    labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
    [view addSubview:labTitle];
    
    UIView *line = [Common createLineLabelWithHeight:30];
    [view addSubview:line];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"000000"];
    }
    
    NSString *title = m_array[indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(searchHistorySelectTitle:)]) {
        
        NSString *title = m_array[indexPath.row];
        [self.delegate searchHistorySelectTitle:title];
    }
}

@end
