//
//  CommonMedDetailViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-8.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "CommonMedDetailViewController.h"
#import "SOSTableViewCell.h"
#import "AppDelegate.h"

@interface CommonMedDetailViewController ()
<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CommonMedDetailViewController

- (void)dealloc
{
    self.dataArray = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"头痛";
        self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
//        NSDictionary *methodDic = @{@"title": @"常识判断",@"content":@"临床以咳嗽伴(或不伴)有支气管分泌物增多为特征。多伴随有感冒症状同时出现。急性支气管炎是婴幼儿时期的常见病，往往继发于上呼吸道感染之后，也常为肺炎的早期表现。病原体为各种病毒或细菌，常在病毒感染基础上继发细菌感染，一般要使用抗生素，如能及时治疗，多能控制病情，预后良好。但如果不予注意，治疗不及时，可发展为支气管肺炎。"};
//        NSDictionary *decideDic = @{@"title": @"临床表现",@"content":@"1.乾咳或有少量粘液痰。婴幼儿不会吐痰，多经咽部吞下。\n\
//                                    2.体温可高可低，但多为低热，可持续数天或2一3周。\n\
//                                    3.婴幼儿可有呕吐、腹泻，年长儿可诉头痛、乏力、食欲不振。\n\
//                                    4.呼吸稍增快，可闻干性罗音及大、中湿罗音，罗音部位和时间不恒定，常在体位改变或咳嗽后减少或消失。\n\
//"};
//        NSDictionary *principleDic = @{@"title": @"用药原则",@"content":@"祛痰止咳类+抗生素"};
//        [self.dataArray addObject:methodDic];
//        [self.dataArray addObject:decideDic];
//        [self.dataArray addObject:principleDic];
        
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    allTableView.backgroundView = view;
    [view release];
    allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *oneDic = self.dataArray[indexPath.section];
    NSString *contentString = oneDic[@"content"];
    CGFloat contentHeight = [Common heightForString:contentString Width:kDeviceWidth-30-2*11 Font:[UIFont systemFontOfSize:15.0f]].height;
    
    
    return contentHeight+60+15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailCell = @"sosDetailCell";
    
    SOSTableViewCell *sosCell = [tableView dequeueReusableCellWithIdentifier:detailCell];
    if(!sosCell){
        
        sosCell = [[[SOSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCell] autorelease];
        sosCell.selectionStyle = UITableViewCellSelectionStyleNone;
        sosCell.backgroundColor = [UIColor clearColor];
        sosCell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    
    [sosCell setDetaiDic:self.dataArray[indexPath.section]];
    
    return sosCell;
}

@end
