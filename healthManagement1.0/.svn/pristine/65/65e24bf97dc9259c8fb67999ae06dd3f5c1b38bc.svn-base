//
//  MedicineDetailViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MedicineDetailViewController.h"
#import "MedicineDetailCell.h"
#import "MedicineDetailCell.h"
#import "AppDelegate.h"

@interface MedicineDetailViewController ()
<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MedicineDetailViewController

- (void)dealloc
{
    self.dataArray = nil;
    self.titleName = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.log_pageID = 32;

        // Custom initialization
//        self.title = @"头痛";
//        self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
//        NSDictionary *methodDic = @{@"title": @"急救方法",@"content":@"用于对所包含的view进行布局"};
//        NSDictionary *decideDic = @{@"title": @"判断",@"content":@"用于对所包含的view进行布局看看空间里六点四十卡卡是达到阿凡达是法师打发的"};
//        [self.dataArray addObject:methodDic];
//        [self.dataArray addObject:decideDic];
        
//        UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(goToShare) withNormalImge:@"common.bundle/nav/top_share_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_share_icon_pre.png"];
//        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    UITableView *allTableView = [[UITableView alloc]
                                 initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
    allTableView.delegate = self;
    allTableView.dataSource = self;
    allTableView.backgroundColor = [UIColor clearColor];
    allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    allTableView.backgroundView = view;
    [view release];
    
    [self.view addSubview:allTableView];
    [allTableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataArray.count-1) {
        return 10;
    }
    else {
        return .1f;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
//    view.backgroundColor = [UIColor clearColor];
//    return [view autorelease];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *oneDic = self.dataArray[indexPath.section];
    NSString *contentString = oneDic[@"content"];
    CGFloat contentHeight = [Common heightForString:contentString Width:kDeviceWidth-40-33-10 Font:[UIFont systemFontOfSize:15.0f]].height;
    
    return contentHeight +60+15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailCell = @"medicineDetailCell";
    
    MedicineDetailCell *medCell = [tableView dequeueReusableCellWithIdentifier:detailCell];
    if(!medCell){
        
        medCell = [[[MedicineDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCell] autorelease];
        medCell.selectionStyle = UITableViewCellSelectionStyleNone;
        medCell.backgroundColor = [UIColor clearColor];
        UIView *tempView = [[[UIView alloc] init] autorelease];
        medCell.backgroundView = tempView;
        medCell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    
    [medCell setDetaiDic:self.dataArray[indexPath.section]];
    
    return medCell;
}

@end
