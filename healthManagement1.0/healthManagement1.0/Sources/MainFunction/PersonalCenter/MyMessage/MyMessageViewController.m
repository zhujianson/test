//
//  MyMessageViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-18.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"
#import "CommonViewController.h"
//#import "CommunityDetailViewController.h"
#import "DiaryModelView.h"
//#import "RichTextView.h"
#import "UIImageView+WebCache.h"

@interface MyMessageViewController ()//<IconOperationQueueDelegate>
{
    UITableView* m_tableView;
    NSMutableArray * dataArray;
//    IconOperationQueue *m_OperationQueue;
    NSString *requestTime;
    MLEmojiLabel *m_emojiLabel;//处理富文本的对象
}
@end

@implementation MyMessageViewController

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc]init];
        self.title = @"我的跟帖";
    }
    return self;
}

- (void)dealloc
{
//    [m_OperationQueue release];
    [m_tableView release];
    [dataArray release];
    if (m_emojiLabel)
    {
        [m_emojiLabel release];
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    g_nowUserInfo.myThreadNotRead = 0;
//    m_OperationQueue = [[IconOperationQueue alloc] init];
//    [m_OperationQueue setM_arrayList:dataArray];
//    m_OperationQueue.delegate = self;
//    m_OperationQueue.imageKey = @"iconUrl";
//    m_OperationQueue.pathSuffix = @"?imageView2/1/w/160/h/160";
    
    self.view.backgroundColor = [UIColor whiteColor];
    m_nowPage = 1;
    requestTime = [DiaryModelView getTimeWithKey:@"kLastTime"];//总是取上一次时间
    
    [self beginLooding];
    // Do any additional setup after loading the view.
}

- (void)creatTableView
{
    if (m_tableView) {
        UILabel* lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
        if ([dataArray count] < g_everyPageNum*(m_nowPage-1)) {
            lab.text = NSLocalizedString(@"已到底部", nil);
            lab.textColor = [CommonImage colorWithHexString:@"cccccc"];
            lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
            UIActivityIndicatorView* activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
            [activi removeFromSuperview];
        } else {
            lab.text = NSLocalizedString(@"加载更多...", nil);
        }
        [m_tableView reloadData];
        return;
    }
    
    m_tableView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                   style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
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
    UILabel* lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    
    if ([dataArray count] < g_everyPageNum*(m_nowPage-1)) {
        lab.text = NSLocalizedString(@"已到底部", nil);
        lab.textColor = [CommonImage colorWithHexString:@"cccccc"];
        lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
        UIActivityIndicatorView* activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
        [activi removeFromSuperview];
    } else {
        lab.text = NSLocalizedString(@"加载更多...", nil);
    }
}

#pragma mark -Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat heigt = [Common heightForString:dataArray[indexPath.row][@"content"] Width:(kDeviceWidth-80) Font:[UIFont systemFontOfSize:15]].height;
    
    CGFloat heigt = [MyMessageTableViewCell getCellHeightWithDict:dataArray[indexPath.row] withHandler:self];
    return heigt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    MyMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[MyMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];

    }
    if (indexPath.row < [dataArray count]) {
        [cell setMessageData:dataArray[indexPath.row]];
        NSMutableDictionary *dataDic = dataArray[indexPath.row];
//        NSString *imagePath = dataDic[@"iconUrl"];
        NSString *imagePath = [dataDic[@"iconUrl"] stringByAppendingString:@"?imageView2/1/w/160/h/160"];
        UIImage *define = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
        [cell.m_headerView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:define];
//        if ([imagePath length]) {
//            UIImage *image = [m_OperationQueue getImageForUrl:imagePath];
//            if (image) {
//                cell.m_headerView.image = image;
//            }else {
//                if (tableView.dragging == NO && tableView.decelerating == NO)//table停止不再滑动的时候下载图片（先用默认的图片来代替Cell的image）
//                {
//                    [m_OperationQueue startIconDownload:imagePath forIndexPath:indexPath setNo:0];
//                }
//                cell.m_headerView.image =[UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
//            }
//        }
//        else {
//            cell.m_headerView.image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
//        }
        
    }
    return cell;
}

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
    
    MyMessageTableViewCell *cell = (MyMessageTableViewCell*)[m_tableView cellForRowAtIndexPath:indexPath];
    cell.m_headerView.image = image;
    
    //刷新当前显示页面
     NSArray *visiblePaths = [m_tableView indexPathsForVisibleRows];
     [m_tableView reloadRowsAtIndexPaths:visiblePaths withRowAnimation:UITableViewRowAnimationNone];
}

//- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
//{
//      NSMutableDictionary *dicItem = dataArray[indexPath.row];
//    //标记以读
//    if (![dicItem[@"isRead"] boolValue]) {
//        g_nowUserInfo.myMessageNoReadNum = MAX(--g_nowUserInfo.myMessageNoReadNum, 0);
//        [dicItem setObject:@"1" forKey:@"isRead"];
//         MyMessageTableViewCell *cell = (MyMessageTableViewCell*)[m_tableView cellForRowAtIndexPath:indexPath];
//        [cell hiddenRedImage];
//    }
//
//    NSMutableDictionary *dict = [@{@"postId":dicItem[@"postId"]} mutableCopy];
//    CommunityDetailViewController * communityDetailVC = [[CommunityDetailViewController alloc] init];
//    communityDetailVC.isfromSearchListFlag = NO;
//    communityDetailVC.m_superDic = dict;
//     WS(weakSelf);
//    __block UITableView *weakTabel = m_tableView;
//    __block NSIndexPath *weakIndexPath = [indexPath retain];
//    
//    communityDetailVC.myCommunityDetailViewControllerBlock = ^(NSString *str){
//        if ([kDeletePost isEqualToString:str])
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf->dataArray removeObjectAtIndex:weakIndexPath.row];
//                [weakTabel deleteRowsAtIndexPaths:[NSArray arrayWithObject:weakIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            });
//        }
//    };
//    
//    [self.navigationController pushViewController:communityDetailVC animated:YES];
//    [communityDetailVC release];
//    [dict release];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//assistantId/start/pageSize
        [dic setObject:dataArray[indexPath.row][@"id"] forKey:@"id"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_MYMESSAGEDELETE_BY_ID values:dic requestKey:GET_MYMESSAGEDELETE_BY_ID delegate:self controller:self actiViewFlag:1 title:nil];
        
        [dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark -UIScrollView deletegate
//UIScrollView滚动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    // 下拉到最底部时显示更多数据
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 45)) {
        if ([dataArray count] < g_everyPageNum*(m_nowPage-1)) {
        } else {
            m_nowPage ++;
            [self beginLooding];
        }
    }
//    NSArray *visiblePaths = [m_tableView indexPathsForVisibleRows];
//    //row 为1 是section 里面为row 为1的情况
//    [m_OperationQueue loadImagesForOnscreenRows:visiblePaths isRow:YES];
}
//UIScrollView松开手指
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate)//手指松开且不滚动
//    {
//        NSArray *visiblePaths = [m_tableView indexPathsForVisibleRows];
//        [m_OperationQueue loadImagesForOnscreenRows:visiblePaths isRow:YES];
//    }
//}

#pragma  mark -网络回调
- (void)beginLooding
{
    m_loadingMore = YES;
    NSString *commentsId = @"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [dataArray lastObject];
    if (dict.count)
    {
        commentsId = dict[@"commentId"];
    }
    [dic setObject:commentsId forKey:@"commentId"];
    [dic setObject:[NSString stringWithFormat:@"%d",g_everyPageNum] forKey:@"pageSize"];
    [dic setObject:requestTime forKey:@"cutTime"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:kGetMyCommentReply values:dic requestKey:kGetMyCommentReply delegate:self controller:self actiViewFlag:1 title:nil];
    m_nowPage++;
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
   if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:kGetMyCommentReply]) {
            //我的消息
            if (m_nowPage==2) {
                [dataArray removeAllObjects];
                [DiaryModelView saveTimeWithKey:@"kLastTime" withTimeStr:dic[@"head"][@"timestamp"]];
            }
            NSMutableArray *resultList = dic[@"body"][@"data"];
            [dataArray addObjectsFromArray:resultList];
            [self creatTableView];

            NSLog(@"%@",dic);
        }else if ([loader.username isEqualToString:GET_MYMESSAGEDELETE_BY_ID]) {
            //删除消息
            if ([[dic objectForKey:@"state"] intValue] )
            {
                [Common TipDialog:[dic objectForKey:@"msg"]];
            }
            else
            {
                MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
                progress_.labelText = @"删除成功";
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
        }else if ([loader.username isEqualToString:GET_UPDATEMYMESSAGE_BY_ID]) {
            //标记以读
            if ([[dic objectForKey:@"state"] intValue] )
            {
                [Common TipDialog:[dic objectForKey:@"msg"]];
            }
            else
            {
                NSLog(@"以读");
            }
        }
    }
    else {
        [Common TipDialog2:dic[@"head"][@"msg"]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -set-getUi
//处理数据
//-(float)getContentHeightWithDict:(NSMutableDictionary *)dataDict withKeyConentString:(NSString *)conentString withContentWidth:(float)width
//{
//    float hightContent = 0;
//    hightContent = [dataDict[kTextHeight] floatValue];
//    if (hightContent > 0)
//    {
//        return hightContent;
//    }
//
//    m_emojiLabel = [RichTextView setEmgText:conentString withOldEmojiLabel:m_emojiLabel withContentWeight:width withTitleFront:M_FRONT_SIXTEEN];
//    hightContent = ceilf(m_emojiLabel.size.height);
//    [dataDict setObject:[NSString stringWithFormat:@"%f",hightContent] forKey:kTextHeight];
//    return hightContent;
//}

@end
