//
//  VideoListCollectionVC.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/4.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "VideoListCollectionVC.h"
#import "RightCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "VideoMoreViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "VideoDetailViewController.h"

@interface VideoListCollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation VideoListCollectionVC
{
    UICollectionView *_rightCollectionView;
    NSMutableArray * m_allData;
    EGORefreshTableHeaderView *_headView;
    
}
static NSString * const reuseIdentifier = @"RightCollectionViewCell";

- (void)dealloc
{
    m_allData = nil;
    _rightCollectionView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    m_allData = [[NSMutableArray alloc]init];

    [self CreatRightCollectionView];

    [self getAllData];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)getAllData
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:@"0" forKey:@"classification"];
    [dic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_CORSELIST values:dic requestKey:GET_API_CORSELIST delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"", nil)];
    m_nowPage++;
}

-(void)CreatRightCollectionView
{
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    flowayout.minimumInteritemSpacing = 0.f;
    flowayout.minimumLineSpacing = 0.5f;
    flowayout.itemSize = CGSizeMake((kDeviceWidth-40)/2, 55+190/2*kDeviceWidth/375);
    flowayout.headerReferenceSize = CGSizeMake(kDeviceWidth, 45);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, kDeviceWidth, 400)];
    headerView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-45-64) collectionViewLayout:flowayout];
    [_rightCollectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader"];
    [_rightCollectionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwFooter"];
    _rightCollectionView.alwaysBounceVertical = YES;
//    _rightCollectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [_rightCollectionView addSubview:headerView];

    [_rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_rightCollectionView setBackgroundColor:[CommonImage colorWithHexString:@"ffffff"]];
//    _rightCollectionView.co
    
//    _rightCollectionView.dele
    _rightCollectionView.delegate = self;
    _rightCollectionView.dataSource = self;
    
    [self.view addSubview:_rightCollectionView];
    
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [_rightCollectionView addSubview:_headView];
}

#pragma mark------CollectionView的代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return m_allData.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [m_allData[section][@"list"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
//    cell.layer.borderWidth = 0.5;
    cell.backgroundColor = [UIColor whiteColor];

    NSDictionary *dic = m_allData[indexPath.section][@"list"][indexPath.row];
    cell.titleLabel.text = dic[@"courseTitle"];
    cell.readingLab.text = [NSString stringWithFormat:@"%@",dic[@"browseNum"]];

    [CommonImage setImageFromServer:[NSString stringWithFormat:@"%@",dic[@"iconUrl"]] View:cell.imageview Type:2];
    cell.viedoType.image = [Common setImageTypeWithStr:[NSString stringWithFormat:@"%@",dic[@"isFree"]]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        FooterCollectionReusableView *footerView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwFooter" forIndexPath:indexPath];
        if (m_allData.count<g_everyPageNum) {
            [self endOfResultList];
        }
        return footerView;
    }
    
    HeaderCollectionReusableView *headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
    headView.butMore.tag = indexPath.section+100;
    
    headView.backgroundColor = [UIColor whiteColor];
    headView.label.text = m_allData[indexPath.section][@"name"];
    
    WSS(weak);
    headView.m_block = ^(int blockTag){
        VideoMoreViewController * video = [[VideoMoreViewController alloc]init];
//        [video.m_allData addObjectsFromArray:m_allData[indexPath.section][@"list"]];
        video.m_dic = m_allData[indexPath.section];
        video.title =m_allData[indexPath.section][@"name"];
        UIViewController * contro = weak.view.superview.viewController;
        [contro.navigationController pushViewController:video animated:YES];
        video.log_pageID = 9+[video.m_dic[@"id"] intValue];
    };
    
    return headView;
}
//返回头headerView的大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    CGSize size={kDeviceWidth,45};
////    if (!section) {
////        size = CGSizeMake(kDeviceWidth, 10);
////    }
//    return size;
//}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {kDeviceWidth, 0};
    if (m_allData.count-1 == section) {
        size = CGSizeMake(kDeviceWidth, 10);
    }
    return size;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(kDeviceWidth/2, 55+190/2*kDeviceWidth/375);
//}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    
    VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
    detail.m_superDic = m_allData[indexPath.section][@"list"][indexPath.row];
    [((UIViewController*)self.m_superClass).navigationController pushViewController:detail animated:YES];
    
    NSLog(@"%ld",(long)indexPath.row);
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    if ([loader.username isEqualToString:GET_API_CORSELIST])
    {
        
    }
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = dic[@"head"];
    if (![head[@"state"] intValue]) {
        NSDictionary *body = dic[@"body"];
        if (!body.count)
        {
            return;
        }
        if ([loader.username isEqualToString:GET_API_CORSELIST])
        {
            [self finishRefresh];

            if (m_nowPage==2) {
                [m_allData removeAllObjects];
            }


            for (NSDictionary * d in body[@"list"]) {
                [m_allData addObject:d];
            }
//            [UIView animateWithDuration:0.25 animations:^{
                [_rightCollectionView reloadData];
//            }];
            
            if([body[@"list"] count] < [REQUEST_PAGE_NUM intValue])
            {
                [self endOfResultList];
            }
            else{
                hasMoreFlag = YES;
            }

        }
    }
    else
    {
        [Common TipDialog2:head[@"msg"]];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_rightCollectionView];
    m_loadingMore = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    hasMoreFlag = YES;
    m_loadingMore = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    //    [newsListTableView reloadData];
    [self getAllData];
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
        [self getAllData];
    }
    
}

- (void)endOfResultList
{
    hasMoreFlag = NO;
    UILabel *lab = (UILabel*)[_rightCollectionView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[_rightCollectionView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
