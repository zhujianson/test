//
//  TheAgentViewController.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/21.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "TheAgentViewController.h"
#import "ScanningViewController.h"
#import "TheAgentTableViewCell.h"
#import "BindAgentViewController.h"

@interface TheAgentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TheAgentViewController
{
    UITableView *m_tabeleView;
    NSMutableArray *m_dataArray;

}

- (BOOL)closeNowView
{
    [super closeNowView];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyAgent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理人绑定";
    self.log_pageID = 16;
    m_dataArray = [[NSMutableArray alloc]init];
    
//    self.navigationItem.rightBarButtonItem = [Common createNavBarButton:self setEvent:@selector(setupCamera)withNormalImge:@"common.bundle/personnal/device/scanCode" andHighlightImge:nil];
    m_tabeleView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,kDeviceHeight) style:UITableViewStylePlain];
    m_tabeleView.delegate = self;
    m_tabeleView.dataSource = self;
    m_tabeleView.showsVerticalScrollIndicator = NO;
    m_tabeleView.backgroundColor = [UIColor clearColor];
    m_tabeleView.rowHeight = 90;
    [self.view addSubview:m_tabeleView];
    // Do any additional setup after loading the view.
}

- (void)getMyAgent
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_MY_AGENT values:dic requestKey:GET_MY_AGENT delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"", nil)];
}

-(void)setupCamera
{
    //是否有摄像头
    if (![self isCameraAvailable]) {
        [Common TipDialog2:@"该设备不支持此功能！"];
        return;
    }
    ScanningViewController * rt = [[ScanningViewController alloc] init];
//    rt.m_userId = userIdStr;
    rt.isFirst = YES;
    rt.sao_type = typeSaoAgent;
    rt.title = @"扫码添加";
    [self.navigationController pushViewController:rt animated:YES];
}

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark tableviewcellDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    TheAgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[TheAgentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    
    NSDictionary * dic = [m_dataArray objectAtIndex:indexPath.row];
    [cell setAgentInfo:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(25, 25, kDeviceWidth-50, 45);
    [btn setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"更换代理人", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.cornerRadius = btn.height/2;
    btn.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    return view;
}

- (void)change
{
    BindAgentViewController *bind = [[BindAgentViewController alloc] init];
    [self.navigationController pushViewController:bind animated:YES];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSDictionary * dict = dic[@"head"];
    NSLog(@"%@",dic);
    if ([[dict objectForKey:@"state"] intValue] != 0) {
        [Common TipDialog:[dict objectForKey:@"msg"]];
        return;
    }
    if ([loader.username isEqualToString:GET_MY_AGENT])
    {
        [m_dataArray removeAllObjects];
        
//        for (NSDictionary * d in dic[@"body"][@"entity"]) {
            [m_dataArray addObject:dic[@"body"][@"entity"]];
//        }
        [m_tabeleView reloadData];
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
