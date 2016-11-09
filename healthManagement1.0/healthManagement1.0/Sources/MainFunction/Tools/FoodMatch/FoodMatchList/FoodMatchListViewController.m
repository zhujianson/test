//
//  FoodMatchListViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FoodMatchListViewController.h"
#import "ListCellTableViewCell.h"
#import "DBOperate.h"
#import "FoodIntroduceViewController.h"

@interface FoodMatchListViewController () <ListCellDelegate>

@end

@implementation FoodMatchListViewController
@synthesize m_dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_butWidht = 80;
    m_maxTag = 1000;
    
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    searchbar.delegate = self;
    searchbar.placeholder = @"请输入";
    if(IOS_7){
        searchbar.barTintColor = [CommonImage colorWithHexString:@"e3e3d9"];
    }else{
        searchbar.tintColor = [CommonImage colorWithHexString:@"e3e3d9"];
    }
//	//为UISearchBar添加背景图片
//	UIView *segment = [m_searchbar.subviews objectAtIndex:0];
//	UIImageView *bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"img.bundle/common/cell_bj.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
//	bgImage.frame = CGRectMake(0, 0, 320, 44);
//	[segment addSubview:bgImage];
//	[bgImage release];
    
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 50)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.rowHeight = 50;
    m_tableView.separatorColor = [CommonImage colorWithHexString:@""];
    m_tableView.tableHeaderView = searchbar;
    [searchbar release];
    [self.view addSubview:m_tableView];
    
    m_searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchbar contentsController:self];
    m_searchDisplay.delegate = self;
    m_searchDisplay.searchResultsDelegate = self;
    m_searchDisplay.searchResultsDataSource = self;
    m_searchDisplay.searchResultsTableView.backgroundColor = [CommonImage colorWithHexString:@"#f6f7ed"];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, m_tableView.bottom, kDeviceWidth, 50)];
    [self.view addSubview:footView];
    UILabel *labTit = [Common createLabel:CGRectMake(0, 0, 80, 50) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentCenter labTitle:@"已选择"];
    [footView addSubview:labTit];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 2, 50)];
    imageV.image = [UIImage imageNamed:@""];
    [footView addSubview:imageV];
    [imageV release];
    m_footerView = [[UIScrollView alloc] initWithFrame:CGRectMake(82, 0, kDeviceWidth-82, 50)];
    m_footerView.backgroundColor = [UIColor clearColor];
    [footView addSubview:m_footerView];
    [footView release];
    
    [NSThread detachNewThreadSelector:@selector(getDBData:) toTarget:self withObject:m_dicInfo];
}

- (void)getDBData:(NSDictionary*)dic
{
//    m_array = [[DBOperate shareInstance] getFoodItemForGroupid:[dic objectForKey:@"groupid"] setPage:m_nowPage];
    m_array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1;
    for (int i = 0; i < 50; i++) {
        dic1 = [NSMutableDictionary dictionaryWithDictionary:@{@"icon":@"", @"name":[NSString stringWithFormat:@"name%d",i], @"calorie":@"200卡/100克", @"isOK":i%2?@YES:@NO, @"isSel":@NO}];
        [m_array addObject:dic1];
    }
    
    //
    m_selArray = [[NSMutableArray alloc] init];
    NSMutableArray *selArray = [m_dicInfo objectForKey:@"selArray"];
    if (selArray) {
        NSMutableDictionary *dic1, *dic2;
        
        for (int i = 0; i < [selArray count]; i++) {
            
            dic1 = [selArray objectAtIndex:i];
            
            for (int j = 0; j < [m_array count]; j++) {
                
                dic2 = [m_array objectAtIndex:j];
                if ([dic1[@"name"] isEqualToString:dic2[@"name"]]) {
                    [dic2 setObject:[NSNumber numberWithBool:YES] forKey:@"isSel"];
                    continue;
                }
            }
            
            [self createFooterViewButItem:dic1];
            m_maxTag++;
        }
    }
    
    [m_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!m_selArray) {
        return;
    }
    BOOL is = NO;
    NSArray *array = self.navigationController.viewControllers;
    for (id cl in array) {
        if ([cl isKindOfClass:[FoodMatchListViewController class]]) {
            is = YES;
            break;
        }
    }
    if (!is) {
        [m_dicInfo setObject:[m_selArray retain] forKey:@"selArray"];
        NSString *str = [NSString string];
        for (NSDictionary *dic in m_selArray) {
            str = [str stringByAppendingFormat:@"%@ ", [dic objectForKey:@"name"]];
        }
        [m_dicInfo setObject:str forKey:@"con"];
        float height = [Common heightForString:str Width:230 Font:[UIFont systemFontOfSize:14]].height+5;
        [m_dicInfo setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
    }
    [super viewWillDisappear:animated];

}

#pragma mark - UISearchBarDelegate
/**
 *  搜索
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *spaceString = [searchBar.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(spaceString.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                        message:@"请输入正确的搜索条件！"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"关闭",nil)
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
}

/**
 *  开始输入
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    isSearching = YES;
    if(IOS_7 ){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    m_SearchNum = 1;//重置页数
    
    for (UIView *subView in searchBar.subviews)
    {
        for (UIView *ndLeSubView in subView.subviews)
        {
            if ([ndLeSubView isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)ndLeSubView;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    NSLog(@"searchText:%@",searchText);
//    if(searchText.length == 0){
//        m_nowPage = 0;
//        [self.searchArray removeAllObjects];
//        [searchC.searchResultsTableView reloadData];
//        searchC.searchResultsTableView.tableFooterView.hidden = YES;
//    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    isSearching = NO;
    if (!searchBar.text.length) {
        [self searchBarCancelButtonClicked:searchBar];
        searchBar.layer.borderColor = [CommonImage colorWithHexString:@"e3e3d9"].CGColor;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
//    isSearching = NO;
//    if(IOS_7){
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
//    [self.searchArray removeAllObjects];
//    [searchC.searchResultsTableView reloadData];
//    searchC.searchResultsTableView.tableFooterView.hidden = YES;
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"text:%@,range:%@",text,NSStringFromRange(range));
    return YES;
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"unload");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"--%@",tableView.subviews);
    for (UIView* v in controller.searchResultsTableView.subviews) {
        if ([v isKindOfClass: [UILabel class]])
        {
            UILabel *lbl = (UILabel *)v;
            [lbl setText:@""];
            break;
        }
    }
}

#pragma tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	if (aTableView == m_tableView) {
        m_nowArray = m_array;
    } else {
        
        //isSel
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", m_searchBar.text];
//        m_searchArray = [m_array filteredArrayUsingPredicate:predicate];
//        m_nowArray = []
    }
    return [m_nowArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[ListCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
        cell.delegate = self;
        
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    
    NSDictionary *userDic = [m_nowArray objectAtIndex:indexPath.row];
    [cell setM_dicInfo:userDic];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dic = [m_nowArray objectAtIndex:indexPath.row];
    NSUInteger index = [m_selArray indexOfObject:dic];
    if (index == NSNotFound) {
        [dic setObject:[NSNumber numberWithInt:m_maxTag] forKey:@"tag"];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSel"];
        [self createFooterViewButItem:dic];
        m_maxTag++;
    }
    else {
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSel"];
        [self removeViewForTag:dic];
    }
}

- (void)butShowEvent:(NSDictionary *)dic
{
    FoodIntroduceViewController *food = [[FoodIntroduceViewController alloc] init];
    [food setM_dicInfo:dic];
    [self.navigationController pushViewController:food animated:YES];
    [food release];
}

- (UIView*)createFooterViewButItem:(NSMutableDictionary*)dic
{
    [m_selArray addObject:dic];
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)]autorelease];
    [m_footerView addSubview:view];
    view.backgroundColor = [UIColor redColor];
//    view.tag = [[dic objectForKey:@"tag"] intValue];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 60, 25)];
    labTitle.backgroundColor = [UIColor clearColor];
    labTitle.font = [UIFont systemFontOfSize:15];
    labTitle.text = [dic objectForKey:@"name"];
    labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
    [view addSubview:labTitle];
    [labTitle release];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(60, 10, 20, 20);
    but.tag = [[dic objectForKey:@"tag"] intValue];
//    [but setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor greenColor];
    [but addTarget:self action:@selector(butEventFooter:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
    
    int widht = m_selArray.count * m_butWidht;
    CGRect rect = view.frame;
    rect.origin.x = widht- m_butWidht;
    view.frame = rect;
    [m_footerView setContentSize:CGSizeMake(widht, 50)];
    if (widht > m_footerView.width) {
        [UIView animateWithDuration:0.2 animations:^{
            int x = widht%(int)m_footerView.width;
            m_footerView.contentOffset = CGPointMake(x, 0);
        }];
    }
    
    return view;
}

- (void)butEventFooter:(UIButton*)but
{
    int tag = (int)but.tag, tag1;
    for (NSDictionary *dic in m_selArray) {
        tag1 = [[dic objectForKey:@"tag"] intValue];
        if (tag1 == tag) {
            [self removeViewForTag:dic];
            break;
        }
    }
}

- (void)removeViewForTag:(NSDictionary*)dic
{
    int tag = [[dic objectForKey:@"tag"] intValue];
    UIView *view = [[m_footerView viewWithTag:tag] superview];
    [UIView animateWithDuration:0.3 animations:^{
        
        view.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
        CGRect rect;
        NSDictionary *dic1;
        NSUInteger index = [m_selArray indexOfObject:dic];
        for (; index < m_selArray.count; index++) {
            dic1 = [m_selArray objectAtIndex:index];
            UIView *nextView = [m_footerView viewWithTag:[[dic1 objectForKey:@"tag"] intValue]].superview;
            rect = nextView.frame;
            rect.origin.x -= m_butWidht;
            nextView.frame = rect;
        }
        [m_selArray removeObject:dic];
        
        CGSize size = m_footerView.contentSize;
        size.width -= m_butWidht;
        m_footerView.contentSize = size;

    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_searchDisplay release];
    [m_tableView release];
    [m_array release];
    [m_selArray release];
    [m_footerView release];
    
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
