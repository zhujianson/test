//
//  ReportReadViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ReportReadViewController.h"
#import "PhysicalDetailsViewController.h"
#import "ChineseToPinyin.h"
#import "ChineseInclude.h"
#import "DBOperate.h"
@interface ReportReadViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,
UITableViewDataSource, UITableViewDelegate,
PhysicalPushDelegate> {
    UISearchDisplayController* _displayController; //搜索table
    NSMutableArray* physicalNameArr; //体检名称
    NSMutableArray* searchResults; //搜索数据
    NSMutableArray* pingyinArr; //体检拼音
    NSMutableDictionary* dataDic; //体检名称和体检简介
    
    UISearchBar* m_searchBar; //搜索框
    NSMutableArray* allArr;
}

@end

@implementation ReportReadViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        allArr = [[NSMutableArray alloc]init];
        physicalNameArr = [[NSMutableArray alloc]init];
        pingyinArr = [[NSMutableArray alloc] init];
        self.log_pageID = 27;
        self.title = @"体检参考";

    }
    return self;
}

- (void)dealloc
{
    [m_searchBar release];
    [_displayController release];
    [physicalNameArr release];
    [searchResults release];
    [pingyinArr release];
    [dataDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];

    DBOperate * sqlite = [[[DBOperate alloc]init]autorelease];

    [allArr addObjectsFromArray:[sqlite getAllReportData]];
    for (int i = 0; i< [allArr count]; i++) {
        [physicalNameArr addObject:allArr[i][@"item"]];
        [pingyinArr
         addObject:[ChineseToPinyin pinyinFromChiniseString:allArr[i][@"item"]]];
        [dataDic setObject:allArr[i] forKey:allArr[i][@"item"]];

    }
///**
// *  汉字转化为拼音
// */

    PhysicalProjectViewController* physical =
        [[PhysicalProjectViewController alloc] init];
    [physical.pingyinArrp addObjectsFromArray:pingyinArr];
    [physical.nameArr addObjectsFromArray:physicalNameArr];
    [physical.dataDic addEntriesFromDictionary:dataDic];

    physical.view.frame = CGRectMake(0, 45, kDeviceWidth, kDeviceHeight + 19);
    physical.myDelegate = self;
    [self.view addSubview:physical.view];
    //    [physical release];

    [self searchBarInit];
    // Do any additional setup after loading the view.
}

/**
 *  创建搜索框
 */
- (void)searchBarInit
{
    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 45.0f)];
    m_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    m_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    m_searchBar.backgroundColor = [UIColor clearColor];
    m_searchBar.translucent = YES;
    m_searchBar.placeholder = @"请输入要查询的体检项目";
    m_searchBar.delegate = self;
    m_searchBar.barStyle = UIBarStyleDefault;
    m_searchBar.layer.borderWidth = 0.5f;
    m_searchBar.layer.borderColor = [CommonImage colorWithHexString:@"f0f0f0"].CGColor;
    //    searchBar.barStyle = uisearchb
    if (IOS_7) {
        m_searchBar.barTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    } else {
        m_searchBar.tintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    }

    [self.view addSubview:m_searchBar];
    for (UIView* view in m_searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
    }
    //相当于tableview
    _displayController =
        [[UISearchDisplayController alloc] initWithSearchBar:m_searchBar
                                          contentsController:self];
    _displayController.active = NO;
    _displayController.searchResultsTableView.frame = CGRectMake(0, 100, kDeviceWidth, kDeviceHeight - 100);
    [Common setExtraCellLineHidden:_displayController.searchResultsTableView];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
}

/**
 *  输入中
 *
 *  @param searchBar  search
 *  @param searchText 输入的内容
 */
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    searchResults = [[NSMutableArray alloc] init];
    if (searchBar.text.length > 0 && ![ChineseInclude isIncludeChineseInString:searchBar.text]) {
        for (int i = 0; i < physicalNameArr.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:physicalNameArr[i]]) {
                NSRange titleResult =
                    [pingyinArr[i] rangeOfString:searchBar.text
                                         options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:physicalNameArr[i]];
                }
            } else {
                NSRange titleResult =
                    [physicalNameArr[i] rangeOfString:searchBar.text
                                              options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:physicalNameArr[i]];
                }
            }
        }
    } else if (searchBar.text.length > 0 &&
               [ChineseInclude isIncludeChineseInString:searchBar.text]) {
        for (NSString* tempStr in physicalNameArr) {
            NSRange titleResult = [tempStr rangeOfString:searchBar.text
                                                 options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [searchResults addObject:tempStr];
            }
        }
    }
    NSLog(@"%@", searchResults);
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [m_searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)_tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [CommonImage colorWithHexString:@"F8F9F9"];
    UILabel* textLable = [Common createLabel:CGRectMake(10, 0, kDeviceWidth-10, 30)
                                   TextColor:nil
                                        Font:[UIFont systemFontOfSize:14]
                               textAlignment:NSTextAlignmentLeft
                                    labTitle:@"搜索结果"];
    textLable.textColor = [UIColor grayColor];
    [cleanView addSubview:textLable];

    return cleanView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView*)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell*)tableView:(UITableView*)_tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* indentifier = @"Cell";
    UITableViewCell* cell = (UITableViewCell*)
        [_tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:indentifier] autorelease];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];

    }

    cell.textLabel.text = searchResults[indexPath.row];
    cell.detailTextLabel.text = [dataDic objectForKey:cell.textLabel.text][@"objective"];
    cell.detailTextLabel.textColor = [UIColor grayColor];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView
        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row
                                                 inSection:indexPath.section]];
    [self pushPhysicalData:cell.textLabel.text];
}

/**
 *  代理跳转页面
 *
 *  @param physical 点击的cell数据
 */
- (void)pushPhysicalData:(NSString*)physical
{
    PhysicalDetailsViewController* detail =
        [[PhysicalDetailsViewController alloc] init];
    detail.phyTitle = physical;
    detail.phydic = dataDic[physical];
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
