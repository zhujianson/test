//
//  MyChallengerListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-27.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyChallengerListViewController.h"
#import "ChallengeListCell.h"
//#import "ChallengeDetailViewController.h"
#import "AppDelegate.h"
#import "CommonHttpRequest.h"
#import "EGORefreshTableHeaderView.h"
//#import "IconOperationQueue.h"
#import "UIImageView+WebCache.h"


@interface MyChallengerListViewController ()
<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_headView;
    UITableView *challengeListTableView;
    
//    IconOperationQueue *m_OperationQueue;
}
@property (nonatomic,retain) NSDictionary *myScoreDic;//我的昨日信息
@property (nonatomic,retain) NSMutableArray *dataArray;//对手信息

@property (nonatomic,retain) NSIndexPath *selectedIndexPath;//选中的下标
@end

@implementation MyChallengerListViewController

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadChallengeListNotification" object:nil];
    self.dataArray = nil;
    self.myScoreDic = nil;
    self.selectedIndexPath = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
    
//    m_OperationQueue = [[IconOperationQueue alloc] init];
//    [m_OperationQueue setM_arrayList:self.dataArray];
//    m_OperationQueue.delegate = self;
//    m_OperationQueue.imageKey = @"bFilePath";
//    //    m_OperationQueue.arrayScetion = @"entityList";
//    m_OperationQueue.pathSuffix = @"?imageView2/1/w/140/h/140";
    
    challengeListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44-40)];
    challengeListTableView.dataSource = self;
    challengeListTableView.delegate = self;
    challengeListTableView.backgroundColor = [UIColor clearColor];
    challengeListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:challengeListTableView];
    [challengeListTableView release];

    
    [self setExtraCellLineHidden:challengeListTableView];
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [challengeListTableView addSubview:_headView];
    [_headView release];
    
    //无网络 直接返回
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        return;
    }
    [self getDataSource];
    
//    [self registeNotification];
}

/**
 *  隐藏tableviewd多余分割线
 *
 *  @param tableView
 */
-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
    UIView *footView = [Common createTableFooter];
    [view addSubview:footView];
}


- (void)registeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList) name:@"ReloadChallengeListNotification" object:nil];
}

/**
 *  重新加载列表数据
 */
- (void)reloadList
{
    [self getDataSource];
}

/**
 *  获得数据
 */
- (void)getDataSource
{
    m_loadingMore = YES;
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"userId"];
    [requestDic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNo"];
    [requestDic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetStepPKList values:requestDic requestKey:GetStepPKList delegate:self controller:self actiViewFlag:self.dataArray>0?0:1 title:nil];
    m_nowPage++;

    [requestDic release];
}

- (void)removePKRelationWithUid:(NSString *)uid
{
    //
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
    [requestDic setValue:uid forKey:@"pkId"];
    [requestDic setValue:@"3" forKey:@"appVersion"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:RemovePK values:requestDic requestKey:RemovePK delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];

    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *bodyDic = dic[@"body"];
        NSArray *resultArray = bodyDic[@"resultSet"];
        if ([loader.username isEqualToString:GetStepPKList]) {
            if (m_nowPage==2) {
                [self.dataArray removeAllObjects];
            }
            if(resultArray.count < g_everyPageNum){
                [self endOfResultList];
            }
            [self.dataArray addObjectsFromArray:resultArray];
            [challengeListTableView reloadData];
            [self finishRefresh];
            
            
        }else  if ([loader.username isEqualToString:RemovePK]) {
            
            //            [Common ShowMBProgress:self.view MSG:@"" Mode:<#(MBProgressHUDMode)#>]
            
        }
        
    } else {
     
        [Common TipDialog:dic[@"head"][@"msg"]];

    }
}

//停止加载TableView
- (void)endOfResultList
{
    hasMoreFlag = NO;
    UILabel *lab = (UILabel*)[challengeListTableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[challengeListTableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
    //    activi.hidden = YES;
    
}
#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:challengeListTableView];
    m_loadingMore = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    hasMoreFlag = YES;
    m_loadingMore = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    [self setExtraCellLineHidden:challengeListTableView];
    //    [newsListTableView reloadData];
    [self getDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_loadingMore;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

//scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView egoRefreshScrollViewDidScroll:scrollView];
}

//UIScrollView滚动停止
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSArray *visiblePaths = [challengeListTableView indexPathsForVisibleRows];
//    [m_OperationQueue loadImagesForOnscreenRows:visiblePaths isRow:YES];
//}

- (void)showImageForDownload:(NSDictionary *)imageDicInfo
{
    if (m_isClose) {
        return;
    }
    
    NSMutableDictionary *dicCansu = [[NSMutableDictionary alloc] initWithDictionary:imageDicInfo];
    [self performSelectorOnMainThread:@selector(setSellerTableCellImage:) withObject:dicCansu waitUntilDone:YES];
}

- (void)setSellerTableCellImage:(NSDictionary*)canshu
{
    UIImage *image = [canshu objectForKey:@"image"];
    NSIndexPath *indexPath = [canshu objectForKey:@"indexPath"];
    [canshu release];
    
    ChallengeListCell *cell = (ChallengeListCell*)[challengeListTableView cellForRowAtIndexPath:indexPath];
    //	[cell setIconImage:[UIImage imageWithData:image]];
    [cell setIconImage:image];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
    NSLog(@"------------:%f",scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height);
    //上提
    if(hasMoreFlag == YES && m_loadingMore == NO &&  scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height <= -40){
        m_loadingMore = YES;
        [self getDataSource];
    }
//    if (!decelerate)//手指松开且不滚动
//    {
//        NSArray *visiblePaths = [challengeListTableView indexPathsForVisibleRows];
//        [m_OperationQueue loadImagesForOnscreenRows:visiblePaths isRow:YES];
//    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"challengeCell";
    ChallengeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[ChallengeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    
    if(indexPath.row >= self.dataArray.count){
        return cell;
    }
    
    NSDictionary *otherScoreDic = self.dataArray[indexPath.row];
    
    [cell setDataDic:otherScoreDic];
    
    NSString *imagePath = [Common isNULLString3:otherScoreDic[@"accountB"][@"userPhoto"]];
    
    imagePath = [imagePath stringByAppendingString:@"?imageView2/1/w/140/h/140"];
    UIImage *define = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
    [cell.otherPhotoImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:define];
//    if ([imagePath length]) {
//        
//        UIImage *image = [m_OperationQueue getImageForUrl:imagePath];
//        
//        if (image) {
//            [cell setIconImage:image];
//        }else {
//            if (tableView.dragging == NO && tableView.decelerating == NO)//table停止不再滑动的时候下载图片（先用默认的图片来代替Cell的image）
//            {
//                [m_OperationQueue startIconDownload:imagePath forIndexPath:indexPath setNo:0];
//            }
//            [cell setIconImage:[UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"]];
//            
//        }
//    }
//    else {
//        [cell setIconImage:[UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"]];
//    }
    
    
    return cell;
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
    if(indexPath.row >= self.dataArray.count){
        return NO;
    }
    
     NSDictionary *pkDic = self.dataArray[indexPath.row];
    if([pkDic[@"status"] intValue] == 2){
        
        return  YES;
    }else{
    
        return NO;
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        [dataArray removeObjectAtIndex:indexPath.row];//---删除数据呀
        // Delete the row from the data source.
        
        self.selectedIndexPath = indexPath;
        //提示是否更换
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"提示", nil)
                           message:NSLocalizedString(@"亲，解除挑战后将扣除积分筹码，您确认现在解除么？",
                                                     nil)
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消", nil)
                           otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
        [av show];
        [av release];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){

        NSDictionary *pkDic = self.dataArray[self.selectedIndexPath.row];
        [self removePKRelationWithUid:pkDic[@"challengeId"]];
        [self.dataArray removeObjectAtIndex:self.selectedIndexPath.row];
        [challengeListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.selectedIndexPath = nil;
        
    }else{
        //不切换 读本地数据
        
        [challengeListTableView reloadData];

    }
    
}




- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解除挑战";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AppDelegate *appDelegate = [Common getAppDelegate];
//    ChallengeDetailViewController *challengeVC = [[ChallengeDetailViewController alloc] init];
//    NSDictionary *otherScoreDic = self.dataArray[indexPath.row];
//    challengeVC.pkId = otherScoreDic[@"pkid"];
//    challengeVC.myName = self.myScoreDic[@"userName"];
//    challengeVC.otherName = otherScoreDic[@"userName"];
//    challengeVC.indexPath = indexPath;
//    challengeVC.removePkRelationBlock = ^(NSIndexPath *index){
//        
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        // Delete the row from the data source.
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    };
//    [appDelegate.navigationVC pushViewController:challengeVC animated:YES];
//    [challengeVC release];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
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
