//
//  RedPacketDetailViewController.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "RedPacketDetailViewController.h"
#import "RedPacketCell.h"

@interface RedPacketDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    RedPacketCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[RedPacketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];        
    }
    if (indexPath.row < [self.m_dataArray count])
    {
          [cell setUpDict:self.m_dataArray[indexPath.row] withModelType:self.m_redPacketUseType];
    }
    return cell;
}

-(void)getDataSource
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%d",m_nowPage] forKey:@"pageNumber"];
    [dic setObject:[NSString stringWithFormat:@"%d",g_everyPageNum] forKey:@"pageSize"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)self.m_redPacketUseType] forKey:@"type"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:k_GetRedPacketList values:dic requestKey:k_GetRedPacketList delegate:self controller:self actiViewFlag:0 title:nil];
     m_nowPage++;
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    self.isShow = YES;
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:k_GetRedPacketList])
        {
            self.isShow = YES;
            NSMutableArray *resultList = dic[@"body"][@"list"];
            if (m_nowPage==2) {
                [self.m_dataArray removeAllObjects];
            }
            [self.m_dataArray addObjectsFromArray:resultList];
            if(resultList.count < g_everyPageNum)
            {
                [self endOfResultList];
            }
            else {
                m_loadingMore = NO;
            }
            [self.m_tableView reloadData];
        }
        else
        {
            [Common TipDialog2:dic[@"head"][@"msg"]];
        }
    }
}

@end
