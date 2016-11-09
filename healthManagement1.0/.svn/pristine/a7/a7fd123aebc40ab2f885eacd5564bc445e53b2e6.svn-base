//
//  HealthNewsListViewController.m
//  healthManagement1.0
//
//  Created by wangmin on 15/10/16.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "HealthNewsListViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "HomeTableViewCell.h"
#import "CommonHttpRequest.h"
#import "TopicDetailsViewController.h"
#import "UIImageView+WebCache.h"

@interface HealthNewsListViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    
     EGORefreshTableHeaderView *_headView;

}
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uuu;

@property (nonatomic,retain) NSMutableArray *dataList;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *lastPostId;//最后一条数据id

@end

@implementation HealthNewsListViewController
@synthesize tableView;

/**
 *  隐藏tableviewd多余分割线
 *
 *  @param tableView
 */
-(void)setExtraCellLineHidden:(UITableView *)myTableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [myTableView setTableFooterView:view];
    UIView *footView = [Common createTableFooter];
    [view addSubview:footView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康资讯";
    [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    tableView.separatorColor = [CommonImage colorWithHexString:@"dcdcdc"];
    [self setExtraCellLineHidden:self.tableView];
//    tableView.separatorColor = [UIColor clearColor];
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [tableView addSubview:_headView];
    [self getDataSource];
    if (IOS_7) {
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }

}

- (void)getDataSource
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];

    NSString *postId = @"";
    if(self.dataList.count){
        postId = [[self.dataList lastObject] objectForKey:@"postId"];
    }
    if(m_nowPage == 1){
        
        postId = @"";
    }
    
    NSString *requestName =  GetHealthGroupPostList;
    [requestDic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNumber"];
    [requestDic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    [requestDic setValue:postId forKey:@"postId"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:requestName values:requestDic requestKey:requestName delegate:self controller:self actiViewFlag:0 title:nil];
    m_nowPage++;
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *bodyDic = dic[@"body"];
       if ([loader.username isEqualToString:GetHealthGroupPostList]) {
            
            NSMutableArray *resultArray = [NSMutableArray arrayWithArray:bodyDic[@"list"]];
            
            if(resultArray.count < g_everyPageNum){
                [self endOfResultList];
            }
            
            if (m_nowPage==2) {
                
                [self.dataList removeAllObjects];
                
            }
            
            [self.dataList addObjectsFromArray:resultArray];
            [tableView reloadData];
        }
        
        [self finishRefresh];
        
    } else {
        
        [Common TipDialog:dic[@"head"][@"msg"]];
    }
}

//停止加载TableView
- (void)endOfResultList
{
    hasMoreFlag = NO;
    UILabel *lab = (UILabel*)[tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
    //    activi.hidden = YES;
    
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell1= @"cell3";
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:cell1];
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    [cell setInformationWithDic:self.dataList[indexPath.row]];
    
    return cell;

//    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:@"HealthListCell"];
//    
//    UIImageView *picImageView = (UIImageView *)[cell.contentView viewWithTag:110];
//    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:111];
//    UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:112];
//    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:113];
//    UIImageView *redImageView = (UIImageView *)[cell.contentView viewWithTag:150];
//    
//    NSDictionary *dataDic = self.dataList[indexPath.row];
//    
//    NSString *imagePath = [dataDic[@"img"] stringByAppendingString:@"?imageView2/1/w/160/h/160"];
//    UIImage *define = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
//    [picImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:define];
//    picImageView.clipsToBounds = YES;
//    
//    redImageView.image = [UIImage imageNamed:@"common.bundle/home/see_img.png"];
//    titleLabel.text = dataDic[@"postName"];
//    titleLabel.textColor = [CommonImage colorWithHexString:@"333333"];
//   
//    NSString *subTitle = [NSString stringWithFormat:@"%@\n",dataDic[@"shareTitle"]];
//    if(subTitle.length > 25){
//        subTitle = [subTitle substringToIndex:24];
//    }
//    detailLabel.text = subTitle;
//    detailLabel.contentMode = UIViewContentModeTopLeft;
//    detailLabel.textColor = [CommonImage colorWithHexString:@"666666"];
////    float width = [Common sizeForString:@"5" andFont:12].width;
////    dateLabel.width = width;
//    dateLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"redNumber"]];
//    dateLabel.textColor = [CommonImage colorWithHexString:@"999999"];
//    
////    if(indexPath.row %2 == 0){
////        
////        cell.contentView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
////    }else{
////        
////         cell.contentView.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];
////    }
//    
//    return cell;

}

- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
        [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        NSDictionary *dataDic = self.dataList[indexPath.row];

        TopicDetailsViewController * top = [[TopicDetailsViewController alloc] init];
        top.m_isHideNavBar = [dataDic[@"transparent"] intValue];
        top.m_dic = dataDic;
//        top.title = dataDic[@"postName"];
        top.shareTitle = [NSString stringWithFormat:@"【康迅360】- 您值得信赖的健康管理专家 %@",dataDic[@"postName"]];
        top.shareContentString = [NSString stringWithFormat:@"【康迅360】- 您值得信赖的健康管理专家%@",dataDic[@"shareTitle"]];
        [self.navigationController  pushViewController:top animated:YES];
}


#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
    m_loadingMore = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    hasMoreFlag = YES;
    m_loadingMore = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    [self setExtraCellLineHidden:tableView];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
    //上提
    if(hasMoreFlag == YES && m_loadingMore == NO &&  scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height <= -40){
        m_loadingMore = YES;
        [self getDataSource];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
