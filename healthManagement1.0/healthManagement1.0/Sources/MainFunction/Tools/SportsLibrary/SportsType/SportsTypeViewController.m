//
//  SportsTypeViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-21.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SportsTypeViewController.h"
#import "SportsTypeTableViewCell.h"
#import "SportsLibraryViewController.h"
#import "DBOperate.h"
@interface SportsTypeViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView* m_tableView;
    NSMutableArray* sportsArr;
}

@end

@implementation SportsTypeViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sportsArr = [[NSMutableArray alloc] init];
        self.title = @"运动库";
        self.log_pageID = 17;

    }
    return self;
}

- (void)dealloc
{
    [m_tableView release];
    [sportsArr release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DBOperate* sqlite = [[[DBOperate alloc] init] autorelease];
    [sportsArr addObjectsFromArray:[sqlite getSportsAllData:nil type:1]];
    
    m_tableView = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                style:UITableViewStyleGrouped];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.separatorColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = view;
    [view release];
    m_tableView.rowHeight = 210;
    [self.view addSubview:m_tableView];

    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [sportsArr count];
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    SportsTypeTableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[SportsTypeTableViewCell alloc]
              initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:identifier] autorelease];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setDataForCell:sportsArr[indexPath.section] row:(int)indexPath.section];

    return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    SportsLibraryViewController* improve = [[SportsLibraryViewController alloc] init];
    improve.code = sportsArr[indexPath.section][@"CODE"];
    improve.sportsTitle = sportsArr[indexPath.section][@"CATALOG"];
    [self.navigationController pushViewController:improve animated:YES];
    [improve release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView*)tableView shouldHighlightRowAtIndexPath:(NSIndexPath*)indexPath
{
    SportsTypeTableViewCell *cell = (SportsTypeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.backView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    } completion:^(BOOL fl) {
        
    }];
    return YES;
}

- (void)tableView:(UITableView*)tableView didUnhighlightRowAtIndexPath:(NSIndexPath*)indexPath
{
    SportsTypeTableViewCell *cell = (SportsTypeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
