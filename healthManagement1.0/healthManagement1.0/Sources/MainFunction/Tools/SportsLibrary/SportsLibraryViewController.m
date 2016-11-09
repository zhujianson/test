//
//  SportsLibraryViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SportsLibraryViewController.h"
#import "SportsDetailsViewController.h"
#import "SportsLibraryTableViewCell.h"
#import "DBOperate.h"
@interface SportsLibraryViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* sportArray;
    int _indexNum;
    UITableView* sportDataTable;
}

@end

@implementation SportsLibraryViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.log_pageID = 18;

        sportArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [sportArray release];
    [sportDataTable release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DBOperate* sqlite = [[[DBOperate alloc] init] autorelease];
    [sportArray addObjectsFromArray:[sqlite getSportsAllData:_code type:2]];
    self.title = _sportsTitle;
    //运动类型数据列表
    sportDataTable =
        [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                                     style:UITableViewStylePlain];
    sportDataTable.delegate = self;
    sportDataTable.dataSource = self;
    sportDataTable.tag = 99;
    // ios7分割线调整
    //    if (IOS_7) {
    //        [sportDataTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    }
    sportDataTable.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];

    [self.view addSubview:sportDataTable];
    [Common setExtraCellLineHidden:sportDataTable];
    // Do any additional setup after loading the view.
}

/**
 *  默认选择第一行的cell
 *
 *  @param tab 选择的table
 */
- (void)defaultOptionFirst:(UITableView*)tab
{
    NSInteger selectedIndex = 0;
    NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [tab selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [sportArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //    if (tableView.tag == 88) {
    //运动类型列表
    static NSString* indentifier = @"Cell";
    UITableViewCell* cell = (UITableViewCell*)
        [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:indentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        cell.detailTextLabel.textColor = [CommonImage colorWithHexString:@"666666"];
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    if (indexPath.row < [sportArray count]) {
        cell.textLabel.text = sportArray[indexPath.row][@"ITEM"];
            if ([Common unicodeLengthOfString:sportArray[indexPath.row][@"ITEM"]]>18) {
                cell.textLabel.text = [[sportArray[indexPath.row][@"ITEM"] substringToIndex:9] stringByAppendingString:@"..."];
            }
        cell.detailTextLabel.text = sportArray[indexPath.row][@"ITEM_TITLE"];
        if ([Common unicodeLengthOfString:sportArray[indexPath.row][@"ITEM_TITLE"]] > 12) {
            cell.detailTextLabel.text = [sportArray[indexPath.row][@"ITEM_TITLE"] substringToIndex:6];
        }
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"%ld", (long)indexPath.row);
    SportsDetailsViewController* details =
        [[SportsDetailsViewController alloc] init];
    details.sportDic = sportArray[indexPath.row];

    [self.navigationController pushViewController:details animated:YES];
    [details release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
