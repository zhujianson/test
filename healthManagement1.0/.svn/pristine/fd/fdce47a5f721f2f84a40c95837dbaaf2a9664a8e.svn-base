//
//  MyChallengerViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-26.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyChallengerViewController.h"
#import "SelectedView.h"
#import "myDayRankListViewController.h"
#import "MyChallengerListViewController.h"
#import "AppDelegate.h"
#import "AddFriendViewController.h"
//#import "SlideView.h"

#import "KXSlideView.h"

@interface MyChallengerViewController ()
<UIScrollViewDelegate, SlideViewDelegate>
{
    UIScrollView *myScrollView;
    SelectedView *selectedView;
    NSArray *m_sArray;
}
@property (nonatomic,retain) NSMutableArray *viewControllersArray;

@end

@implementation MyChallengerViewController

- (void)dealloc
{
    for (id ii in m_sArray) {
        [ii release];
    }
    
    [super dealloc];
}

- (BOOL)closeNowView
{
    //移除嵌套类中的
    
    for(CommonViewController *list in m_sArray){
        
        [list closeNowView];
    }
    
    return [super closeNowView];
}


- (void)butEventAddFriend
{
    //加朋友
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFriendVC animated:YES];
    [addFriendVC release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排行榜";
    
//    UIBarButtonItem *right = [Common CreateNavBarButton:self setEvent:@selector(butEventAddFriend) setImage:@"common.bundle/nav/top_sport_dekaron.png" setTitle:nil];
//    self.navigationItem.rightBarButtonItem = right;

    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"挑战好友 " style:UIBarButtonItemStylePlain target:self action:@selector(butEventAddFriend)];
    self.navigationItem.rightBarButtonItem = sendItem;
    [sendItem release];
    //
    [self inite];
}

- (void)inite
{
//    SlideView *slideView = [[SlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleHeight:40 withTitleButHeight:30 withY:0];
//    slideView.theTitleType = SegmentTypeWithTwoItem;
//    slideView.LineSeparate = YES;
//    slideView.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
//    slideView.tag = 996;
//    [self.view addSubview:slideView];
//    [slideView release];
    
    NSArray *titleArray = @[@"日排名",@"总排名",@"挑战"];
    
    myDayRankListViewController *myDayRankListVC = [[myDayRankListViewController alloc] init];
    myDayRankListVC.isDayRankFlag = YES;
    myDayRankListVC.log_pageID = 113;
    
    myDayRankListViewController *myAllRankListVC = [[myDayRankListViewController alloc] init];
    myAllRankListVC.isDayRankFlag = NO;
    self.log_pageID = 114;
    
    MyChallengerListViewController *myChallengerListVC = [[MyChallengerListViewController alloc] init];
    myChallengerListVC.log_pageID = 115;
    
    m_sArray = @[myDayRankListVC, myAllRankListVC, myChallengerListVC];

//    [slideView  setTitleArray:titleArray SourcesArray:m_sArray SetDefault:0];
    
    
    KXSlideView *kxSlideView = [[KXSlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleScrollViewFrame:
                                CGRectMake(0, 0, kDeviceWidth, 40)];
    kxSlideView.theSlideType = SegmentStyle;
    kxSlideView.tag = 996;
    [kxSlideView setTitleArray:titleArray SourcesArray:m_sArray SetDefault:0];
    [self.view addSubview:kxSlideView];
    [kxSlideView release];

    
}

- (void)moveToLastPage
{
    KXSlideView *slideView = (KXSlideView *)[self.view viewWithTag:996];
    [slideView  jumpToPage:2];

}

- (void)selPageScrollView:(int)page
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
      int page = scrollView.contentOffset.x/kDeviceWidth;
    
      [selectedView justShowSelectedViewAtIndex:page];
    
}

- (void)addSomeOne
{
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFriendVC animated:YES];
    [addFriendVC release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(hiddenNavigationBarLine) withObject:nil afterDelay:0];

}

//- (void)hiddenNavigationBarLine
//{
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
//        
//        NSArray *list = self.navigationController.navigationBar.subviews;
//        
//        for (id obj in list) {
//            
//            if ([obj isKindOfClass:[UIImageView class]]) {
//                
//                UIImageView *imageView=(UIImageView *)obj;
//                
//                NSArray *list2=imageView.subviews;
//                
//                for (id obj2 in list2) {
//                    
//                    if ([obj2 isKindOfClass:[UIImageView class]]) {
//                        
//                        UIImageView *imageView2=(UIImageView *)obj2;
//                        
//                        imageView2.hidden=YES;
//                    }
//                }
//            }
//        }
//    }
//}
//
- (void)createViewControllers
{
    myDayRankListViewController *myDayRankListVC = [[myDayRankListViewController alloc] init];
    myDayRankListVC.isDayRankFlag = YES;
    myDayRankListVC.log_pageID = 113;
    
    myDayRankListViewController *myAllRankListVC = [[myDayRankListViewController alloc] init];
    myAllRankListVC.isDayRankFlag = NO;
    self.log_pageID = 114;
    
    MyChallengerListViewController *myChallengerListVC = [[MyChallengerListViewController alloc] init];
    myChallengerListVC.log_pageID = 115;
    [self.viewControllersArray addObject:myDayRankListVC];
    [self.viewControllersArray addObject:myAllRankListVC];
    [self.viewControllersArray addObject:myChallengerListVC];
    [myDayRankListVC release];
    [myAllRankListVC release];
    [myChallengerListVC release];
    
    for(int i = 0; i < self.viewControllersArray.count;i++){
        UIViewController *viewController = self.viewControllersArray[i];
        UIView *view = viewController.view;
        CGRect viewRect = view.frame;
        viewRect.origin.y = 0;
        viewRect.size.height = myScrollView.height;
        viewRect.origin.x = i*kDeviceWidth;
        view.frame = viewRect;
        [myScrollView addSubview:view];
    }
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
