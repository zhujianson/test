//
//  HomeIndexItemViewController.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/1/18.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HomeIndexItemViewController.h"
#import "HomeIndexCollectionViewCell.h"
#import "DraggableCollectionViewFlowLayout.h"
#import "LSCollectionViewHelper.h"
#import "UICollectionView+Draggable.h"
#import "HomeModel.h"
#import "NoticeDetailViewController.h"
#import "ShowConsultViewController.h"
#import "DoctorListViewController.h"
//#import "SteperHomeViewController.h"
//#import "HealthNewsListViewController.h"
#import "ASIFormDataRequest.h"


@interface HomeIndexItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource_Draggable,UINavigationControllerDelegate>
{
    UICollectionView *m_collectionView;
    NSMutableArray *m_dataArray;
    KXBasicBlock m_block;
    
    UILabel *lastTipLabel;
}
@end

@implementation HomeIndexItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.log_pageID = 33;

//        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存  " style:UIBarButtonItemStylePlain target:self action:@selector(butEventHeader)];
//        self.navigationItem.rightBarButtonItem = leftBtn;
    }
    return self;
}

-(void)dealloc
{
    if (m_block)
    {
         m_block = nil;
    }   
}

-(BOOL)closeNowView
{
    
    return [super closeNowView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"太平送福";
    // Do any additional setup after loading the view.
    m_dataArray = [[NSMutableArray alloc] init];
    [self getAllHomeMeunse];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self updateDataToServer];
//    [super viewWillDisappear:animated];
//}

-(void)updateDataToServer
{
    NSLog(@"------%@",self.navigationController.viewControllers);
    if (![self.navigationController.viewControllers containsObject:self])
    {
        [self updateAllHomeMeunse];
    }
}

- (void)butEventHeader
{
    [self updateAllHomeMeunse];
}

-(void)setKXBlock:(KXBasicBlock)block
{
    if (m_block != block)
    {
        m_block = nil;
        m_block = [block copy];
    }
}

//获取未读消息
- (void)getAllHomeMeunse
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_ALLHOMEMENUS_URL values:dic requestKey:GET_API_ALLHOMEMENUS_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)updateAllHomeMeunse
{
    if (!m_dataArray.count)
    {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *oneArray = m_dataArray[0];
    if (m_block)
    {
        m_block(oneArray);
    }
    NSArray *twoArray = m_dataArray[1];
    NSMutableArray *confsArray = [NSMutableArray array];
    for (int i= 0;i<oneArray.count-1; i++)
    {
        NSDictionary * dict = oneArray[i];
        NSDictionary *dictNew = @{@"configureId":dict[@"configureId"],@"isHome":@"1"};
        [confsArray addObject:dictNew];
    }
    for (NSDictionary * dict in twoArray)
    {
        NSDictionary *dictNew = @{@"configureId":dict[@"configureId"],@"isHome":@"0"};
        [confsArray addObject:dictNew];
    }
    [dic setObject:confsArray forKey:@"confs"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_UPDATEHOMEMENUS_URL values:dic requestKey:GET_API_UPDATEHOMEMENUS_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
    
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    ASIFormDataRequest *asi = [array objectAtIndex:array.count-1];
    NSLog(@"%@", asi);
    asi.winCloseIsNoCancle = YES;
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
        if ([loader.username isEqualToString:GET_API_ALLHOMEMENUS_URL])
        {
            NSArray *array = body[@"data"];
            if (array.count)
            {
                 [m_dataArray removeAllObjects];
                 [m_dataArray addObjectsFromArray:array];
                 [self createSubViews];
            }
           
    
//            NSInteger countFirst = 5;
//            NSMutableArray *subArray = [NSMutableArray array];
//            for (NSUInteger j = 0; j < countFirst; j++)
//            {
//                [subArray addObject:array[j]];
//            }
//            [subArray addObject:@""];
//            [m_dataArray addObject:subArray];
            
//            NSMutableArray *subArrayTwo = [NSMutableArray array];
//            for (NSUInteger j = countFirst; j < array.count; j++)
//            {
//                [subArrayTwo addObject:array[j]];
//            }
//            [m_dataArray addObject:subArrayTwo];
//            [self createSubViews];
        }
        if ([loader.username isEqualToString:GET_API_UPDATEHOMEMENUS_URL])
        {
            
        }
    }
    else
    {
        [Common TipDialog2:head[@"msg"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSubViews
{
    float  CELL_ROW = 3.0;
    float  CELL_MARGIN = 0.5;
    float  CELL_LINE_MARGIN = 0.5;
    
    CGFloat cellW = (kDeviceWidth- CELL_MARGIN * (CELL_ROW - 1)) / CELL_ROW;
    DraggableCollectionViewFlowLayout *layout = [[DraggableCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);// 定义cell的size
    layout.minimumInteritemSpacing = CELL_MARGIN;// 定义左右cell的最小间距
    layout.minimumLineSpacing = CELL_LINE_MARGIN;// 定义上下cell的最小间距
    
    m_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) collectionViewLayout:layout];
    m_collectionView.backgroundColor = [UIColor clearColor];
    [m_collectionView registerClass:[HomeIndexCollectionViewCell class] forCellWithReuseIdentifier:itemCell];
    [m_collectionView registerClass:[HomeIndexCollectionAddViewCell class] forCellWithReuseIdentifier:itemLastCell];
    [m_collectionView registerClass:[HomeIndexCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:itemHeadView];
    m_collectionView.alwaysBounceVertical = YES;

//    [m_collectionView registerClass:[HomeIndexCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:itemFooterViewView];
//    m_collectionView.draggable = YES;
    m_collectionView.delegate = self;
    m_collectionView.dataSource = self;
    [self.view addSubview:m_collectionView];
    
}

#pragma mark <UICollectionViewDataSource>
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return m_dataArray.count;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

//    return [m_dataArray[section] count];
    return m_dataArray.count;
}

- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.item >= 5)
    {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Prevent item from being moved to index 0
    if (toIndexPath.section == 0 && toIndexPath.item >= 5 )
    {
        return NO;
    }
    return YES;
}

- (void)collectionView:(LSCollectionViewHelper *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    NSMutableArray *data1 = [m_dataArray objectAtIndex:fromIndexPath.section];
//    NSMutableArray *data2 = [m_dataArray objectAtIndex:toIndexPath.section];
//    
//    NSString *indexData1 = [data1 objectAtIndex:fromIndexPath.item];
//    NSString *indexData2 = [data2 objectAtIndex:toIndexPath.item];
//    UICollectionView *collectionNew = collectionView;
//    if (fromIndexPath.section == toIndexPath.section)
//    {
////        [data1 exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
//        NSString *index = [data1 objectAtIndex:fromIndexPath.item];
//        
//        [data1 removeObjectAtIndex:fromIndexPath.item];
//        [data2 insertObject:index atIndex:toIndexPath.item];
//
//    }
//    else
//    {
//        [data1 replaceObjectAtIndex:fromIndexPath.item withObject:indexData2];
//        [data2 replaceObjectAtIndex:toIndexPath.item withObject:indexData1];
//        [collectionNew reloadData];
//    }   
}

-(void)collectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    if (indexPath.section != toIndexPath.section)
//    {
//        NSMutableArray *data2 = [m_dataArray objectAtIndex:toIndexPath.section];
//        NSIndexPath *newToIndex = [NSIndexPath indexPathForItem:toIndexPath.item + 1 inSection:toIndexPath.section];
//        NSDictionary *dict = data2[newToIndex.item ];
//        
//        [data2 removeObjectAtIndex:newToIndex.item];
//        NSMutableArray *data1 = [m_dataArray objectAtIndex:indexPath.section];
//        [data1 insertObject:dict atIndex:indexPath.item];
//        
//        [collectionView performBatchUpdates:^{
//            [collectionView deleteItemsAtIndexPaths:@[newToIndex]];
//            [collectionView insertItemsAtIndexPaths:@[indexPath]];
//
//        } completion:nil];
////        [collectionView reloadData];
//    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *type = itemCell;
    UICollectionViewCell *cell;
//    if (indexPath.section == 0 && indexPath.row == 5)
//    {
//        type = itemLastCell;
//        cell = (HomeIndexCollectionAddViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:type forIndexPath:indexPath];
//    }
//    else
//    {
        cell = (HomeIndexCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:type forIndexPath:indexPath];
//        NSDictionary *dict = [m_dataArray[indexPath.section] objectAtIndex:indexPath.row];
        NSDictionary *dict = m_dataArray[indexPath.row] ;
        [((HomeIndexCollectionViewCell*)cell) setM_infoDict:dict];
//    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableDictionary *dict = [m_dataArray[indexPath.section] objectAtIndex:indexPath.row];
     NSMutableDictionary *dict = m_dataArray[indexPath.row] ;
    NSLog(@"------%@",dict);
    if (![dict isKindOfClass:[NSDictionary class]] )
    {
        return;
    }
    int iconType = [dict[@"iconType"] intValue];
    NSString *iconTarget = dict[@"iconTarget"];
    //iconType为1原生应用
    if (iconType == 2)
    {
        if ([dict.allKeys containsObject:@"iconName"])
        {
            [dict setObject:dict[@"iconName"] forKey:kWebTitle];
        }
        [self gotoWebViewWithDict:dict];
        HomeIndexCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [cell hidenImage];
    }
    else
    {
        NSString *viewC =[HomeModel fetchViewControllerStrWith:iconTarget];
        UIViewController *viewController = [[NSClassFromString(viewC) alloc]init];
        if (viewController)
        {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


-(void)gotoNextViewcontrollerWithDict:(NSDictionary *)dict andWithViewController:(UIViewController *)view
{

}

+(UIViewController *)fetchViewControllerWithDict:(NSDictionary *)dict
{
    NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
    NSString *requestURL = dict[@"iconUrl"];
    
    if (!requestURL.length)
    {
        return nil;
    }
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    [dicc setObject:requestURL forKey:@"url"];
    noticeDetailVC.m_url = dict[@"iconUrl"];
    NSString *isShare = [HomeModel getShareFromDict:dict withKey:@"isShare"];
    [dicc setObject:isShare forKey:@"isShare"];
    [noticeDetailVC setM_dicInfo:dicc];
    noticeDetailVC.shareURL = dict[@"linkUrl"];
    if ([dict.allKeys containsObject:kWebTitle])
    {
        noticeDetailVC.titleName = dict[kWebTitle];
        noticeDetailVC.subTitle = dict[kWebTitle];
        noticeDetailVC.title = dict[kWebTitle];
    }
    return noticeDetailVC;
}

-(void)gotoWebViewWithDict:(NSMutableDictionary *)dict
{
    NoticeDetailViewController *noticeDetailVC = [[self class] fetchViewControllerWithDict:dict];
    if (!noticeDetailVC)
    {
        return;
    }
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
    [HomeModel setNoRedImageWithDict:dict];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        HomeIndexCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:itemHeadView forIndexPath:indexPath];
        reusableView = headView;
        [headView showText:!indexPath.section];
    }
    else
    {
//        HomeIndexCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:itemFooterViewView forIndexPath:indexPath];
//        reusableView = footerView;
    }
    return reusableView;
}
//在布局对象的代理协议方法中设置header的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    float hight = section?7:40;
//    return CGSizeMake(kDeviceWidth, hight);
//}

//在布局对象的代理协议方法中设置footer的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    float hight = 0.5;
//    return CGSizeMake(kDeviceWidth, hight);
//}
@end
