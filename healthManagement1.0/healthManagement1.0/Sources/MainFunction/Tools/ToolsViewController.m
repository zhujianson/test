//
//  ToolsViewController.m
//  jiuhaoHealth2.1
//
//  Created by jiuhao-yangshuo on 14-7-25.
//  Copyright (c) 2014年 jiuhao. All rights reserved.
//

#import "ToolsViewController.h"
#import "DiseaseCheckViewController.h"
#import "CalculatorToolsViewController.h"
//#import "HomePageViewController.h"
#import "HealthImageViewController.h"
#import "ReportReadViewController.h"
#import "CheckSugarViewController.h"
#import "SportsTypeViewController.h"
#import "MedicineViewController.h"
#import "SOSViewController.h"
#import "CommonMedicineViewController.h"
#import "DBOperate.h"
#import "CheckSugarViewController.h"
//#import "MyBoxViewController.h"
#import "CheckDiseaseListViewController.h"
#import "NewHealthCheckViewController.h"


@interface ToolsViewController ()
{
    //  TOOLTYPE toolType;
    UITableView* myTable;
    NSArray * dataArray;
}
@end

@implementation ToolsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"工具";
        self.log_pageID = 23;
    }
    return self;
}

- (void)dealloc
{
    [dataArray release];
    [myTable release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array3 = [NSArray arrayWithObjects:@"健康自查",@"体检参考", @"食物库", @"运动库", @"应急措施", @"常用工具", nil];
    NSArray *array2 = [NSArray arrayWithObjects: @"7dd867", @"fdd24f", @"7cbbde", @"46d2b9", @"ff9160", @"ffb55e", nil];
    
    UIButton * backViewBtn = nil;
    UIImage * image;
    CGFloat viewW = (kDeviceWidth-25)/2,viewH1 = (kDeviceHeight-25)/2,viewH2 = (viewH1-5)/2;
    
    for (int i = 0; i<array3.count; i++) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/tools/tool_image%d.png",i]];
        
        backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backViewBtn.tag = 100+i;
        [self.view addSubview:backViewBtn];
        backViewBtn.layer.cornerRadius = 4;
        backViewBtn.clipsToBounds = YES;
        
        NSString * titleBtn = array3[i];
        CGSize titleSize = [titleBtn sizeWithFont:[UIFont systemFontOfSize:14]];
        
        [backViewBtn.imageView setContentMode:UIViewContentModeCenter];
        [backViewBtn setImageEdgeInsets:UIEdgeInsetsMake(-30.0,
                                                         0.0,
                                                         0.0,
                                                         -titleSize.width)];
        [backViewBtn setImage:image forState:UIControlStateNormal];
        
        [backViewBtn.titleLabel setContentMode:UIViewContentModeCenter];
        [backViewBtn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [backViewBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [backViewBtn.titleLabel setTextColor:[CommonImage colorWithHexString:@"ffffff"]];
        [backViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(35.0,
                                                         -image.size.width,
                                                         0.0,
                                                         0.0)];
        [backViewBtn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [backViewBtn setTitle:titleBtn forState:UIControlStateNormal];
        [backViewBtn addTarget:self action:@selector(butEventTool:) forControlEvents:UIControlEventTouchUpInside];
        [backViewBtn setBackgroundColor:[CommonImage colorWithHexString:array2[i]]];
        
        switch (i) {
            case 0:
                backViewBtn.frame = CGRectMake(10, 10, viewW, viewH1);
                break;
            case 1:
                backViewBtn.frame = CGRectMake(viewW+15, 10, viewW, viewH2);
                break;
            case 2:
                backViewBtn.frame = CGRectMake(viewW+15, viewH2+15, viewW, viewH2);
                break;
            case 3:
                backViewBtn.frame = CGRectMake(10, viewH1+15, viewW, viewH2);
                break;
            case 4:
                backViewBtn.frame = CGRectMake(10, viewH1+viewH2+20, viewW, viewH2);
                break;
            case 5:
                backViewBtn.frame = CGRectMake(viewW+15, viewH1+15, viewW, viewH1);
                break;
                
            default:
                break;
        }
    }
}

- (void)butEventTool:(UIButton*)but
{
    switch (but.tag - 100) {
        case 0:
        {
            //健康自查
            NewHealthCheckViewController *healthImageVC = [[NewHealthCheckViewController alloc] init];
            [self.navigationController pushViewController:healthImageVC animated:YES];
            [healthImageVC release];
        }
            break;
        case 1:
        {
            //体检参考
            ReportReadViewController *report = [[ReportReadViewController alloc] init];
            [self.navigationController pushViewController:report animated:YES];
            [report release];
        }
            break;
        case 2:
        {
            //食物库
            CheckSugarViewController *healthImageVC = [[CheckSugarViewController alloc] init];
            [self.navigationController pushViewController:healthImageVC animated:YES];
            [healthImageVC release];
        }
            break;
        case 3:
        {
            //运动库
            SportsTypeViewController *sports =[[SportsTypeViewController alloc]init];
            [self.navigationController pushViewController:sports animated:YES];
            [sports release];
        }
            break;
        case 4:
        {
            //家庭急救
            SOSViewController *sosVC = [[SOSViewController alloc] init];
            sosVC.titleName = NSLocalizedString(@"应急措施", nil);
            self.log_pageID = 29;
            [self.navigationController pushViewController:sosVC animated:YES];
            [sosVC release];
        }
            break;
        case 5:
        {
            //计算器
            CalculatorToolsViewC* calculator = [[CalculatorToolsViewC alloc] init];
            [self.navigationController pushViewController:calculator animated:YES];
            [calculator release];
        }
            break;
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
