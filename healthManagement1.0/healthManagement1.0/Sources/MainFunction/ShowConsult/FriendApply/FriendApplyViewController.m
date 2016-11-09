//
//  FriendApplyViewController.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FriendApplyViewController.h"
#import "FriendApplyCell.h"
//#import "IconOperationQueue.h"
#import "EGORefreshTableHeaderView.h"
#import "DocDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MsgDBOperate.h"

@interface FriendApplyViewController ()<UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView* m_tableView;
    NSMutableArray *m_dataArray;
//    IconOperationQueue *m_OperationQueue;
    
    NSMutableDictionary *m_lastDic;
//    EGORefreshTableHeaderView *m_headView;
    BOOL m_isloading;
}
@end

@implementation FriendApplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_dataArray = [[NSMutableArray alloc]init];
        self.title = @"新的朋友";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_nowPage = 1;
    [self creatTableView];
}

- (void)dealloc
{
    self.applyViewBlock = nil;
    [m_tableView release];
    [m_dataArray release];
    [super dealloc];
}

- (void)creatTableView
{
    m_tableView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                   style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.rowHeight = 60.0;
    m_tableView.backgroundColor = [UIColor clearColor];
    [Common setExtraCellLineHidden:m_tableView];
    [self.view addSubview:m_tableView];
    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    
    if (IOS_7) {
        [m_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    //创建加载更多
    UIView* footerView = [Common createTableFooter];
    m_tableView.tableFooterView = footerView;
    
    [self getDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)getDataSource
{
    m_loadingMore = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSNumber numberWithInt:_applyType] forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%d",m_nowPage] forKey:@"pageNo"];
    [dic setObject:[NSString stringWithFormat:@"%d",g_everyPageNum] forKey:@"pageSize"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:getFriendApplyList values:dic requestKey:getFriendApplyList delegate:self controller:self actiViewFlag:1 title:nil];
    [dic release];
    m_nowPage++;
}

#pragma mark --tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return [m_dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    FriendApplyCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[FriendApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    
    if (IS_OS_8_OR_LATER)//分割线到头
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    NSMutableDictionary *dataDic = m_dataArray[indexPath.row];
    NSString *imagePath = [dataDic[@"userPhoto"] stringByAppendingString:@"?imageView2/1/w/160/h/160"];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
    [cell.m_headerView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];
    
    [cell setInfoDic:dataDic with:^{
        m_lastDic = dataDic;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:dataDic[@"accountId"] forKey:@"id"];
        [dic setObject:@"" forKey:@"commentName"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:APPROVE_FRIEND_URL values:dic requestKey:APPROVE_FRIEND_URL delegate:self controller:self actiViewFlag:1 title:nil];
    }];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goToApproveView:m_dataArray[indexPath.row] IndexPath:indexPath];
}

- (void)goToApproveView:(NSDictionary *)dic IndexPath:(NSIndexPath*)indexPath
{
     NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if(_applyType == 1){
        //会员
        [dataDic setObject:[NSString stringWithFormat:@"性别：%@",[CommonUser getSex:[NSString stringWithFormat:@"%@",dic[@"sex"]]]] forKey:@"secText"];
        [dataDic setObject:[NSString stringWithFormat:@"年龄：%@",[CommonDate getAgeWithBirthday:dic[@"birthday"]]] forKey:@"thirdText"];
    }else{
        //医师
        [dataDic setObject:[NSString stringWithFormat:@"职称：%@",[self getStringValue:dic[@"title"]]] forKey:@"secText"];
        [dataDic setObject:[NSString stringWithFormat:@"医院：%@",[self getStringValue:dic[@"mechanismName"]]] forKey:@"thirdText"];
    }
    
//    ApplyInfoViewController *applyViewVC = [[ApplyInfoViewController alloc] initWithNibName:@"ApplyInfoViewController" bundle:nil];
//    applyViewVC.isApplyViewFlag = NO;
//    applyViewVC.applySuccessBlock = ^{
//        [m_dataArray removeObjectAtIndex:indexPath.row];
//
//        [m_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    };
//    applyViewVC.dataDic = dataDic;
//    [self.navigationController pushViewController:applyViewVC animated:YES];
//    [applyViewVC release];
}

- (NSString *)getStringValue:(NSString *)aString
{
    if(aString.length){
        return aString;
    }else{
        
        return @"";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//assistantId/start/pageSize
        [dic setObject:m_dataArray[indexPath.row][@"accountId"] forKey:@"id"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:REJICT_FRIEND_URL values:dic requestKey:REJICT_FRIEND_URL delegate:self controller:self actiViewFlag:0 title:nil];
        
        [m_dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark 加载图片
- (void)showImageForDownload:(NSDictionary *)imageDicInfo
{
    NSMutableDictionary *dicCansu = [[NSMutableDictionary alloc] initWithDictionary:imageDicInfo];
    [self performSelectorOnMainThread:@selector(setSellerTableCellImage:) withObject:dicCansu waitUntilDone:YES];
}

- (void)setSellerTableCellImage:(NSDictionary*)canshu
{
    UIImage *image = [canshu objectForKey:@"image"];
    NSIndexPath *indexPath = [canshu objectForKey:@"indexPath"];
    [canshu release];
    
    FriendApplyCell *cell = (FriendApplyCell*)[m_tableView cellForRowAtIndexPath:indexPath];
    cell.m_headerView.image = image;
}

//UIScrollView滚动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //上拉加载  拖动过程中
    if(m_loadingMore == NO)
    {
        // 下拉到最底部时显示更多数据
        if( !m_loadingMore && scrollView.contentOffset.y >= ( scrollView.contentSize.height - scrollView.frame.size.height - 45) )
        {
            [self getDataSource];
        }
    }
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dic objectForKey:@"body"];
        if ([loader.username isEqualToString:getFriendApplyList]) {
            NSMutableArray *resultArray = body[@"postList"];
            if (m_nowPage==2) {
                [m_dataArray removeAllObjects];
            }
            [m_dataArray addObjectsFromArray:resultArray];
            
            if(resultArray.count < [REQUEST_PAGE_NUM intValue])
            {
                [self endOfResultList];
            }
            else {
                m_loadingMore = NO;
            }
            [m_tableView reloadData];
//            [self finishRefresh];
            NSLog(@"%@",dic);
        }
        else if ([loader.username isEqualToString:APPROVE_FRIEND_URL]) {
            //请求成功消息

            [m_lastDic setObject:@1 forKey:@"flag"];
            int row = (int)[m_dataArray indexOfObject:m_lastDic];
            [m_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            NSMutableDictionary *dicItem = body[@"friend"];
            if (self.applyViewBlock) {
                self.applyViewBlock(dicItem);
            }
            
            MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"添加成功";
            progress_.mode = MBProgressHUDModeText;
            progress_.userInteractionEnabled = NO;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
            [progress_ show:YES];
            [progress_ showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [progress_ release];
                [progress_ removeFromSuperview];
            }];
        }
        else if ([loader.username isEqualToString:REJICT_FRIEND_URL]) {
            //拒绝好友
//            NSString *sql = [NSString stringWithFormat:@"UPDATE friendList SET readCount = '%@' WHERE id = '-1'", newName, m_dicInfo[@"id"]];
//            [[MsgDBOperate shareInstance] updateFriendInfoRow:sql];
        }
    }
    else {
        [Common TipDialog:[head objectForKey:@"msg"]];
        if ([loader.username isEqualToString:GET_FRIENDAPPLY_LIST]){
            m_loadingMore = NO;
        }
    }
}

//更新ui和对应的数据
- (void)changeSelectCellState
{
    m_nowPage = 1;
    [self getDataSource];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    [self endOfResultList];
    [self finishRefresh];
    if ([loader.username isEqualToString:NEWS_List]){
        m_loadingMore = NO;
    }
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    m_isloading = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (m_isloading) {
        return;
    }
    m_isloading = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    [self getDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_isloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (void)endOfResultList
{
    UILabel *lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
}

@end
