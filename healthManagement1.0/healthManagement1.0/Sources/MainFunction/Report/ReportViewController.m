//
//  ReportViewController.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/1.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCollectionViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"


#define IMAGE_HEIGHT 340/2*kDeviceWidth/375
@interface ReportViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshTableHeaderDelegate>

@end

@implementation ReportViewController
{
    UIView * m_noInfoView;//没有信息会显示的view
    UIImageView * bigImage;
    UICollectionView * m_collection;
    NSMutableArray * m_allData;
    EGORefreshTableHeaderView *_headView;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.log_pageID = 24;
        self.m_isHideNavBar = 64;
        m_allData = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:bigImage];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreatRightCollectionView:0];
    
    [self createNoInfoView:IMAGE_HEIGHT];
    [self getAllData];
    // Do any additional setup after loading the view.
}

- (void)getAllData
{
    
//
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:MEDICAL_LIST values:dic requestKey:MEDICAL_LIST delegate:self controller:self actiViewFlag:1 title:@""];
}

-(void)CreatRightCollectionView:(CGFloat)y
{
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    flowayout.minimumInteritemSpacing = 0.f;
    flowayout.minimumLineSpacing = 0.5f;
    flowayout.itemSize = CGSizeMake((kDeviceWidth-15*3)/2, 200);
    flowayout.headerReferenceSize = CGSizeMake(kDeviceWidth, IMAGE_HEIGHT);
    
    m_collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.width, self.view.height-y-49) collectionViewLayout:flowayout];
    [m_collection registerClass:[ReportCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
    [m_collection setBackgroundColor:[UIColor clearColor]];
    [m_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader"];
    m_collection.alwaysBounceVertical = YES;
    
    //    _rightCollectionView.dele
    m_collection.delegate = self;
    m_collection.dataSource = self;
    
    m_collection.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:m_collection];
    
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [m_collection addSubview:_headView];

}


- (void)createNoInfoView:(CGFloat)y
{
    m_noInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, y, kDeviceWidth, m_collection.height-y-8)];
    m_noInfoView.backgroundColor = [UIColor whiteColor];
    [m_collection addSubview:m_noInfoView];
    UIImage * image = [UIImage imageNamed:@"common.bundle/home/noInfo"];
    
    UIImageView * noImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 82, kDeviceWidth, image.size.height)];
    noImage.image = image;
    noImage.contentMode = UIViewContentModeCenter;
    [m_noInfoView addSubview:noImage];
    
    UILabel * lab = [Common createLabel:CGRectMake(0, noImage.bottom+10, kDeviceWidth, 30) TextColor:@"9ea6bb" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:@"您暂时还没有任何检测信息"];
    [m_noInfoView addSubview:lab];
    
    m_noInfoView.hidden = YES;
    
}

#pragma mark------CollectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return m_allData.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
    if (!m_allData.count) {
        return cell;
    }
    cell.titleLabel.text = m_allData[indexPath.row][@"name"];
    cell.timeLab.text = [[CommonDate getServerTime:[[NSString stringWithFormat:@"%@",m_allData[indexPath.row][@"measureTime"]] longLongValue] type:4] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    [CommonImage setImageFromServer:[NSString stringWithFormat:@"%@",m_allData[indexPath.row][@"smallpic"]] View:cell.sparkImage Type:4];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",m_allData[indexPath.row]);
    WebViewController * web = [[WebViewController alloc]init];
    web.m_url = m_allData[indexPath.row][@"url"];
    web.title =m_allData[indexPath.row][@"name"];
    [self.navigationController pushViewController:web animated:YES];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];;
    headView.backgroundColor = [UIColor clearColor];
    if (!bigImage) {
        bigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, IMAGE_HEIGHT)];
        bigImage.backgroundColor = [UIColor blackColor];
        bigImage.contentMode = UIViewContentModeScaleAspectFit;
        [headView addSubview:bigImage];
    }
    
    //    UIViewController * contro = self.view.superview.viewController;
    
    return headView;
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
        if ([loader.username isEqualToString:MEDICAL_LIST])
        {

            [self finishRefresh];

            [m_allData removeAllObjects];
            
            
            for (NSDictionary * d in body[@"data"]) {
                [m_allData addObject:d];
            }
            if (!m_allData.count) {
                m_noInfoView.hidden = NO;
            }else{
                m_noInfoView.hidden = YES;
            }
            [UIView animateWithDuration:0.25 animations:^{
                [m_collection reloadData];
            }];
//            [CommonImage setImageFromServer:[NSString stringWithFormat:@"%@",body[@"titpic"]] View:bigImage Type:2];
            [bigImage sd_setImageWithURL:[NSURL URLWithString:body[@"titpic"]] placeholderImage:nil];
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
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:m_collection];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
