//
//  FamilyListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-7-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FamilyListViewController.h"
#import "ModifyInformationViewController.h"
#import "CommonHttpRequest.h"
#import "ScaleLayout.h"
#import "GetFamilyList.h"
//#import "FamilyListView.h"

@interface FamilyListViewController ()
{
//    NSInteger pageNumbers;
    int m_selIndex;
    UICollectionView *m_collectionView;

}

@end

@implementation FamilyListViewController

- (void)dealloc
{
    [m_collectionView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"家人档案";
        self.log_pageID = 86;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    
    [g_familyList removeAllObjects];
    
    [[GetFamilyList alloc] initWithBlcok:^(NSMutableArray *farray){
        if (!farray.count) {
            NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
            [dic setObject:g_nowUserInfo.userid forKey:@"id"];
            [dic setObject:g_nowUserInfo.filePath forKey:@"filePath"];
            [g_familyList addObject:dic];
        }
        [self createFamilyView];
    } withView:self];
//    [familyList release];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (g_familyList && m_collectionView) {
//        if (g_familyList.lastObject[@"id"]) {
        [self reloadData:3];
//        }
    }
    [super viewWillAppear:animated];
}

- (void)createFamilyView
{
    ScaleLayout *slayout = [[ScaleLayout alloc] init];
    slayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    m_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kDeviceHeight > 500 ? 0 : -10, kDeviceWidth, kDeviceHeight) collectionViewLayout:slayout];
    [m_collectionView registerClass:[FamilyInfoView class] forCellWithReuseIdentifier:@"MY_CELL"];
//    m_collectionView.contentMode = UIViewContentModeTop;
    m_collectionView.backgroundColor = [UIColor clearColor];
    m_collectionView.delegate = self;
    m_collectionView.dataSource = self;
    m_collectionView.pagingEnabled = NO;
    m_collectionView.contentInset = UIEdgeInsetsMake(kDeviceHeight > 500 ? -30 : 0, 40, kDeviceHeight > 500 ? 30 : 0, 40);
    m_collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_collectionView];
    [slayout release];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kDeviceHeight > 500 ? 430 : 380, kDeviceWidth, 20)];
    if (kDeviceHeight>500) {
        pageControl.frame = [Common rectWithOrigin:pageControl.frame x:0 y:(kDeviceHeight-380*kDeviceHeight/504)/2+380*kDeviceHeight/504];
    }
    pageControl.tag = 150;
    pageControl.numberOfPages = g_familyList.count-1;
    pageControl.enabled = NO;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [CommonImage colorWithHexString:@"ff7a40"];
    pageControl.pageIndicatorTintColor = [CommonImage colorWithHexString:@"d3d3d3"];
    [self.view addSubview:pageControl];
    [pageControl release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPageControl *pageControl = (UIPageControl*)[self.view viewWithTag:150];
//	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - (kDeviceWidth-80) / 2) / (kDeviceWidth-80)) + 1;
	pageControl.currentPage = page;
}

- (void)reloadData:(butType)type
{
    if (!g_familyList.lastObject[@"id"]) {
        [g_familyList removeLastObject];
    }
    if (type == DEL) {
        BOOL is=NO;
        if (g_familyList.count < 7) {
            if (g_familyList.lastObject[@"id"]) {
                [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
                is = YES;
                [m_collectionView reloadData];
            }
        }
        if (!is) {
            [m_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:m_selIndex inSection:0]]];
        }
    }
    else {
        if (g_familyList.count < 7) {
            if (g_familyList.lastObject[@"id"]) {
                [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
            }
        }
        [m_collectionView reloadData];
    }
    
    UIPageControl *pageControl = (UIPageControl*)[self.view viewWithTag:150];
    pageControl.numberOfPages = g_familyList.count-1;
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return g_familyList.count-1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    FamilyInfoView *cell = (FamilyInfoView *)[cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.myDelegate = self;
    NSMutableDictionary *dic = [g_familyList objectAtIndex:indexPath.row+1];
    [cell setM_infoDic:dic];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionViewLayout.collectionView.contentMode = UIViewContentModeTop;
    if (kDeviceHeight>600) {
        return CGSizeMake(kDeviceWidth-80, 380*kDeviceHeight/504);
    }
    return CGSizeMake(kDeviceWidth-80, 380);
}

- (void)pusNewView:(butType)type Dic:(NSMutableDictionary*)dic
{
    m_selIndex = (int)[g_familyList indexOfObject:dic];
    
    NSLog(@"%@",dic);
    switch (type) {
        case EDIT:
        {
            ModifyInformationViewController * modify = [[ModifyInformationViewController alloc]init];
            modify.log_pageID = 87;
            modify.title = @"修改信息";
            [modify setM_infoDic:dic];
            [self.navigationController pushViewController:modify animated:YES];
            [modify release];
        }
            break;
        case QUSHI:
        {
//            StatisticsDataViewController *staticDataVC = [[StatisticsDataViewController alloc] initWithNibName:nil bundle:nil WithFlag:NO];
//            staticDataVC.m_selFamily.selIndex = (int)[g_familyList indexOfObject:dic];
//            [staticDataVC.m_selFamily setButEnabled];
//            
//            [staticDataVC showSelFamily:dic];
//            [self.navigationController pushViewController:staticDataVC animated:YES];
//            [staticDataVC release];
        }
            break;
        case DEL:
        {
            UIAlertView* av = [[UIAlertView alloc]
                               initWithTitle:NSLocalizedString(@"提示", nil)
                               message:NSLocalizedString(@"您确定要删除该家人吗？", nil)
                               delegate:self
                               cancelButtonTitle:NSLocalizedString(@"取消", nil)
                               otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            [av show];
            [av release];
        }
            break;
        case ADD:
        {
            ModifyInformationViewController * modify = [[ModifyInformationViewController alloc]init];
            modify.log_pageID = 88;
            modify.title = @"添加家庭成员";
            [modify setM_infoDic:dic];
            [self.navigationController pushViewController:modify animated:YES];
            [modify release];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[g_familyList[m_selIndex] objectForKey:@"id"] forKey:@"id"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:DELETEFAMILYINFO values:dict requestKey:DELETEFAMILYINFO delegate:self controller:self actiViewFlag:1 title:@"删除中..."];
    }
}

#pragma mark - NetWork Function

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSDictionary * dict = dic[@"head"];
    NSLog(@"%@",dic);
    if (![[dict objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dict objectForKey:@"msg"]];
        return;
    }
    if ([loader.username isEqualToString:DELETEFAMILYINFO]) {
//        [FamilyListView deleteSelectFamilyInfoByUserid:g_familyList[m_selIndex]];//清空本地信息
//        [g_familyList removeObjectAtIndex:m_selIndex];
//        [self reloadData:DEL];
//        MBProgressHUD* progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
//        progress_.labelText = @"删除成功";
//        progress_.mode = MBProgressHUDModeText;
//        progress_.userInteractionEnabled = NO;
//        [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
//        [progress_ show:YES];
//        [progress_ showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//        } completionBlock:^{
//            [progress_ release];
//            [progress_ removeFromSuperview];
//        }];
    }
}


@end
