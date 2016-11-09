//
//  FoodIntroduceViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FoodIntroduceViewController.h"
#import "DBOperate.h"

@interface FoodIntroduceViewController ()

@end

@implementation FoodIntroduceViewController
@synthesize m_dicInfo;
@synthesize introBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        UIBarButtonItem *right = [Common CreateNavBarButton:self setEvent:@selector(butEventRightNav) setTitle:@"添加"];
//        self.navigationItem.rightBarButtonItem = right;
        self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(butEventRightNav) setTitle:@"添加"];

    }
    return self;
}

- (void)butEventRightNav
{
    introBlock(m_dicInfo);
}

//- (void)setM_dicInfo:(NSDictionary *)dic
//{
//    m_dicInfo = dic;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [m_dicInfo objectForKey:@"title"];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:m_scrollView];
    
    m_progress_ = [Common ShowMBProgress:self.view MSG:@"加载中..." Mode:MBProgressHUDModeIndeterminate];
    m_progress_.alpha = 0.8;
    
    [NSThread detachNewThreadSelector:@selector(getDBData) toTarget:self withObject:nil];
}

- (void)getDBData
{
    NSDictionary *dic = [[[DBOperate shareInstance] getDataForSQL:@"" getParam:[NSArray array]] objectAtIndex:0];
    [self performSelectorOnMainThread:@selector(createInfo:) withObject:dic waitUntilDone:YES];
}

- (void)stopActiView
{
    m_progress_.mode = MBProgressHUDModeCustomView;
    [m_progress_ showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }completionBlock:^{
        
        if (m_progress_)
        {
            [Common HideMBProgress:m_progress_];
        }
        m_progress_ = nil;
    }];
}

- (void)createInfo:(NSDictionary*)dic
{
    [self stopActiView];
    
    UIView *bastInfo = [self createBastInfo:dic];
    [self.view addSubview:bastInfo];
    [bastInfo release];
    
    UIView *detail = [self createDetailInfo:dic[@"array"]];
    CGRect rect = detail.frame;
    rect.origin.y = bastInfo.bottom;
    detail.frame = rect;
    [self.view addSubview:detail];
    [detail release];
}

//创建食品的基本信息
- (UIView*)createBastInfo:(NSDictionary*)dic
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 0)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4;
    view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    view.layer.borderWidth = 0.5;
    view.clipsToBounds = YES;
    
    UILabel *labTitle = [Common createLabel:CGRectMake(10, 15, 80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"评价"];
    [view addSubview:labTitle];
    
    //
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
//    [Common setHeadPicImage:[dic objectForKey:@"pic"] View:imageView];
//    [CommonImage setPicImageQiniu:[dic objectForKey:@"pic"] View:imageView Type:2 Delegate:nil];
    [CommonImage setImageFromServer:[dic objectForKey:@"pic"] View:imageView Type:2];

    [view addSubview:imageView];
    [imageView release];
    
    //
    CGRect rect = CGRectMake(10, 15, 250, 20);
    UILabel *labCon = [Common createLabel:rect TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:[dic objectForKey:@"con"]];
    labCon.numberOfLines = 0;
    float height = [Common heightForString:labCon.text Width:250 Font:labCon.font].height + 5;
    rect.size.height = height;
    labCon.frame = rect;
    [view addSubview:labCon];
    
    rect = view.frame;
    rect.size.height = labCon.bottom + 10;
    view.frame = rect;
    
    return view;
}

//营养信息表
- (UIView*)createDetailInfo:(NSArray*)array
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 0)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4;
    view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    view.layer.borderWidth = 0.5;
    view.clipsToBounds = YES;
    
    UILabel *labTitle = [Common createLabel:CGRectMake(10, 15, 80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"营养信息表"];
    [view addSubview:labTitle];
    
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, labTitle.bottom, view.width, 0.5)];
    xian.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
    [view addSubview:xian];
    [xian release];
    
    UIView *item;
    NSDictionary *dic;
    BOOL is = YES;
    CGRect rect;
    for (int i = 0; i < [array count]; i++) {
        
        dic = [array objectAtIndex:i];
        if (i == [array count]-1) {
            is = NO;
        }
        item = [self createItem:dic IsShowLine:is];
        rect = item.frame;
        rect.origin.x += xian.bottom + i*45;
        item.frame = rect;
        [view addSubview:item];
        [item release];
    }
    
    return view;
}

- (UIView*)createItem:(NSDictionary*)dic IsShowLine:(BOOL)is
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 45)];
    
    UILabel *labName = [Common createLabel:CGRectMake(10, 15, 80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:[dic objectForKey:@"dic"]];
    [view addSubview:labName];
    
    UILabel *labValue = [Common createLabel:CGRectMake(10, 15, 80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight labTitle:[dic objectForKey:@"dic"]];
    [view addSubview:labValue];
    
    if (is) {
        UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(15, 44.5, 250, 0.5)];
        xian.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        [view addSubview:xian];
        [xian release];
    }
    
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_scrollView release];
    
    [super dealloc];
}

@end
