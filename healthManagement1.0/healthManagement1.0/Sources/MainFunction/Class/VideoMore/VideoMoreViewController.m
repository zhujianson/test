//
//  VideoDetailViewController.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "VideoMoreViewController.h"
#import "RightCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "EGORefreshTableHeaderView.h"
#import "VideoDetailViewController.h"

@interface VideoMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshTableHeaderDelegate>

@end


@implementation VideoMoreViewController
{
    UICollectionView *_rightCollectionView;
    NSMutableArray * m_allData;
    EGORefreshTableHeaderView *_headView;

}
@synthesize m_allData;

static NSString * const reuseIdentifier = @"Cell";

- (id)init
{
    self = [super init];
    if (self) {
        m_allData = [[NSMutableArray alloc]init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreatRightCollectionView];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self getAllData];
}

- (void)getAllData
{
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%@",_m_dic[@"classification"]] forKey:@"classification"];
    [dic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_CORSELIST values:dic requestKey:GET_API_CORSELIST delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"", nil)];
    m_nowPage++;

}

-(void)CreatRightCollectionView
{
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    flowayout.minimumInteritemSpacing = 0.f;
    flowayout.minimumLineSpacing = 0.5f;
    flowayout.itemSize = CGSizeMake((kDeviceWidth-40)/2, 55+190/2*kDeviceWidth/375);
    flowayout.headerReferenceSize = CGSizeMake(kDeviceWidth, 60);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, kDeviceWidth, 400)];
    headerView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64) collectionViewLayout:flowayout];
    [_rightCollectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader"];
    [_rightCollectionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwFooter"];
    _rightCollectionView.alwaysBounceVertical = YES;

    [_rightCollectionView addSubview:headerView];
    
    [_rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
    
    [_rightCollectionView setBackgroundColor:[CommonImage colorWithHexString:@"ffffff"]];
    
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
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return m_allData.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
    //    cell.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    //    cell.layer.borderWidth = 0.5;
//    cell.backgroundColor = [UIColor whiteColor];
    //根据左边点击的indepath更新右边内容;
//    if (indexPath.row%2) {
//        cell.imageview.frame = [Common rectWithOrigin:cell.imageview.frame x:5 y:0];
//    }else{
//        cell.imageview.frame = [Common rectWithOrigin:cell.imageview.frame x:15 y:0];
//    }
//    cell.titleLabel.frame = [Common rectWithOrigin:cell.titleLabel.frame x:cell.imageview.left y:0];
//    cell.sparkImage.frame = [Common rectWithOrigin:cell.sparkImage.frame x:cell.imageview.left y:0];
//    cell.readingLab.frame = [Common rectWithOrigin:cell.readingLab.frame x:cell.imageview.left+15 y:0];
    
    cell.titleLabel.text = m_allData[indexPath.row][@"courseTitle"];
    cell.readingLab.text = [NSString stringWithFormat:@"%@",m_allData[indexPath.row][@"browseNum"]];
    
    [CommonImage setImageFromServer:[NSString stringWithFormat:@"%@",m_allData[indexPath.row][@"iconUrl"]] View:cell.imageview Type:2];
    cell.viedoType.image = [Common setImageTypeWithStr:[NSString stringWithFormat:@"%@",m_allData[indexPath.row][@"isFree"]]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
    
    UICollectionReusableView *headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];;
    headView.backgroundColor = [UIColor whiteColor];

    UIView * view = (UIView*)[headView viewWithTag:100];
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(15, 10, kDeviceWidth-30, 40)];
        view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
        view.tag = 100;
        [headView addSubview:view];

        UIView * v2 = [[UIView alloc]init];
        [view addSubview:v2];
        
        UIImage * image = [UIImage imageNamed:@"common.bundle/classroom/gossip"];
        UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, 40)];
        imageV.contentMode  = UIViewContentModeScaleAspectFit;
//        imageV.image = image;
        [v2 addSubview:imageV];
        [CommonImage setImageFromServer:[NSString stringWithFormat:@"%@",_m_dic[@"icon_url"]] View:imageV Type:2];

        NSString * text = _m_dic[@"explain"];
        CGSize size = [Common sizeForString:text andFont:15];
        UILabel * lab = [Common createLabel:CGRectMake(imageV.right+10, 0, size.width, 40) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:text];
        [v2 addSubview:lab];
        v2.frame  = CGRectMake((view.width - lab.right)/2, 0, lab.right, 40);
    }
    //    UIViewController * contro = self.view.superview.viewController;
    
    return headView;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(kDeviceWidth/2, 55+190/2*kDeviceWidth/375);
//}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {kDeviceWidth, 0};
//    if (m_allData.count-1 == section) {
        size = CGSizeMake(kDeviceWidth, 10);
//    }
    return size;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%ld",(long)indexPath.row);
    VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
    detail.m_superDic = m_allData[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    
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
      
            for (NSDictionary * d in body[@"list"][0][@"list"]) {
                [m_allData addObject:d];
            }
            [UIView animateWithDuration:0.25 animations:^{
                [_rightCollectionView reloadData];
            }];
            
            if([body[@"list"][0][@"list"] count] < [REQUEST_PAGE_NUM intValue])
            {
                [self endOfResultList];
            }else{
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