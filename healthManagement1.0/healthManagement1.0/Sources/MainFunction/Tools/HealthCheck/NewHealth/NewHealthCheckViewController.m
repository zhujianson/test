//
//  NewHealthCheckViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-1.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "NewHealthCheckViewController.h"
#import "CheckDiseaseListViewController.h"
#import "AppDelegate.h"
#import "KXSlideView.h"
#import "MedicineViewController.h"

@interface NewHealthCheckViewController ()
<SlideViewDelegate>

@end

@implementation NewHealthCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"健康自查";
        self.log_pageID = 24;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *myDelegate = [Common getAppDelegate];
    myDelegate.navigationVC = self.navigationController;
    
    // Do any additional setup after loading the view.
    
    //scrollView
//    SlideView *slideView = [[SlideView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, SCREEN_HEIGHT-44) titleHeight:30];

    KXSlideView *kxSlideView = [[KXSlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleScrollViewFrame:
                                CGRectMake(0, 0, kDeviceWidth, 40)];
    
    CheckDiseaseListViewController *allTeamVC = [[CheckDiseaseListViewController alloc] init];
    allTeamVC.view.frame = CGRectMake(0, 10, kDeviceWidth, SCREEN_HEIGHT-44);
 
    
    MedicineViewController *myTeamVC = [[MedicineViewController alloc] init];
    myTeamVC.view.frame = CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44);
    myTeamVC.isSearchingBlock = ^(BOOL yes){
        kxSlideView.notResponseToselect = yes;
    };
    NSArray *viewArray = @[allTeamVC,myTeamVC];
    
    NSArray *titleArray = @[@"症状",@"疾病"];
    
//    slideView.theTitleType = SegmentTypeWithTwoItem;
//    slideView.delegate = self;
//    [self.view addSubview:slideView];
//    [slideView release];
    
//    [slideView  setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];


    kxSlideView.theSlideType = SegmentType;
    kxSlideView.delegate = self;
    [kxSlideView forbiddenScorllContentView];
    [kxSlideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];
    [self.view addSubview:kxSlideView];
    [kxSlideView release];
    [allTeamVC release];
    [myTeamVC release];

    
}

- (void)selPageScrollView:(int)page{

    

}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
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
