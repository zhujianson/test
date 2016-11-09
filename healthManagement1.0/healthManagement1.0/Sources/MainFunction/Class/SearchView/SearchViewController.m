//
//  SearchViewController.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/4.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryView.h"
#import "VideoDetailViewController.h"
#import "MobClick.h"

@interface SearchViewController () <UISearchBarDelegate, SearchHistoryViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *m_array;
    
    UISearchBar *m_searchBar;
    
    SearchHistoryView *m_historyView;
    UITableView *m_tableView;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    m_array = [[NSMutableArray alloc] init];
    
    [self createSearchBar];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.separatorColor = [CommonImage colorWithHexString:@"ebebeb"];
    m_tableView.tableFooterView = [Common createTableFooter];
    [self.view addSubview:m_tableView];
    
    [self endOfResultList];
    
    [self getHistoryHistoryTableView];
    
//    [self.navigationController.navigationBar]setBarTintColor
    [self.navigationController.navigationBar setBarTintColor:[CommonImage colorWithHexString:@"ebebeb"]];
}

- (void)createSearchBar
{
    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    m_searchBar.delegate = self;
    m_searchBar.layer.masksToBounds = YES;
    m_searchBar.clipsToBounds = YES;
    m_searchBar.placeholder = @"搜索你感兴趣的视频";
    m_searchBar.returnKeyType = UIReturnKeySearch;
    
    [m_searchBar setImage:[UIImage imageNamed:@"common.bundle/community/ic_search.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    self.navigationItem.titleView = m_searchBar;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@" 取消 " style:UIBarButtonItemStylePlain target:self action:@selector(butcancle)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)butcancle
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UITextField * searchField;
    for (UIView *subview in [m_searchBar.subviews[0] subviews]){
        if ([subview isKindOfClass:[UITextField class]]){
            searchField = (UITextField *)subview;
            searchField.layer.cornerRadius = searchField.height/2.f;
//            searchField.layer.borderWidth = 1;
            searchField.clipsToBounds = YES;
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[CommonImage colorWithHexString:@"ebebeb"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[CommonImage colorWithHexString:@"ffffff"]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

//透明
- (void)transparentSearchBar:(UISearchBar *)searchBarView
{
    for (UIView *view in searchBarView.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

//停止加载TableView
- (void)endOfResultList
{
    UILabel *lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    activi.hidden = YES;
}

- (void)startOfResultList
{
    UILabel *lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"加载中...";
    lab.frame = CGRectMake(122, 0, 100, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    activi.hidden = NO;
}

//创建
- (void)getHistoryHistoryTableView
{
    if (!m_historyView) {
        m_historyView = [[SearchHistoryView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        m_historyView.delegate = self;
    }
    [self.view addSubview:m_historyView];
}

- (void)searchHistorySelectTitle:(NSString *)title
{
    m_searchBar.text = title;
    [self searchServerForTitle:title];
}

- (void)searchServerForTitle:(NSString*)title
{
    if ([self.view containsSubView:m_historyView]) {
        [m_historyView removeFromSuperview];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:title forKey:@"keyword"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:get_course_serch_list values:dic requestKey:get_course_serch_list delegate:self controller:self actiViewFlag:0 title:nil];
    
    [self startOfResultList];
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    [m_array removeAllObjects];
    [m_tableView reloadData];
    [self endOfResultList];
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    
    NSDictionary * dic = dict[@"head"];
    if (![[dic objectForKey:@"state"] intValue]) {
        NSDictionary *body = dict[@"body"];
        if ([loader.username isEqualToString:get_course_serch_list]) {
            [m_array removeAllObjects];
            
            NSDictionary *map = body[@"map"];
            NSMutableDictionary *dicItem;
            for (NSString *key in [map allKeys]) {
                dicItem = [NSMutableDictionary dictionary];
                [dicItem setObject:[NSString stringWithFormat:@"%@", key] forKey:@"id"];
                [dicItem setObject:map[key] forKey:@"title"];
                [m_array addObject:dicItem];
            }
            [m_tableView reloadData];
            
//            [m_searchBar resignFirstResponder];
        }
    }
    else {
        [Common TipDialog:dic[@"msg"]];
    }
    [self endOfResultList];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [m_searchBar resignFirstResponder];
    [m_historyView addHistory:m_searchBar.text];
}

#pragma mark - UISearBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //    [self.searchHistoryArray removeAllObjects];
    //    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"quanzilishisousuo"];
    //    if (array) {
    //        [self.searchHistoryArray addObjectsFromArray:array];
    //    }
    //    [self finishRefresh];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"123132");
    if(searchText.length){

//        if ([self.view containsSubView:m_historyView]) {
//            [m_historyView removeFromSuperview];
//        }
        
        [self searchServerForTitle:searchText];

    } else {

        [self getHistoryHistoryTableView];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchServerForTitle:m_searchBar.text];
    [m_historyView addHistory:m_searchBar.text];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *cells = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cells];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cells];
        cell.imageView.image = [UIImage imageNamed:@"common.bundle/class/search_gray.png"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    }
//    cell.textLabel.text = m_array[indexPath.row][@"title"];
    
    cell.textLabel.attributedText = [Common replaceWithNSString:m_array[indexPath.row][@"title"] andUseKeyWord:m_searchBar.text TextColor:@"4bda86"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"search_class" label:m_searchBar.text];
    
    VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
    detail.m_superDic = m_array[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
