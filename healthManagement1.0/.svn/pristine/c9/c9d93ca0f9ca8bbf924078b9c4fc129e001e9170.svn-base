//
//  FamilyHistoryViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FamilyHistoryViewController.h"
#import "PickerView.h"
//#import "JSON.h"
#import "CommonHttpRequest.h"

@interface FamilyHistoryViewController ()
{
    NSArray * m_contrastArr;
    BOOL m_isRequest;
}
@end

@implementation FamilyHistoryViewController
@synthesize m_infoDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"既往病史";
//        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"添加 " style:UIBarButtonItemStylePlain target:self action:@selector(addNewData)];
//        self.navigationItem.rightBarButtonItem = right;
//        [right release];
        self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(addNewData) setTitle:@"添加"];

    }
    return self;
}

- (void)dealloc
{
    [myTable release];
    [dataArray release];
    [self release];

    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    m_isRequest = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myTable setEditing:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] init];
    NSString *stt = [m_infoDic objectForKey:@"history"];
    if (stt.length && ![stt isEqualToString:@"0"]) {
        NSArray *array = [stt componentsSeparatedByString:@","];
        for (NSString *str in array) {
            [dataArray addObject:str];
        }
    }
    m_contrastArr =[[NSArray arrayWithArray:dataArray] retain];
    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    myTable.delegate = self;
    myTable.dataSource = self;
//    [Common setExtraCellLineHidden:myTable];
    // ios7分割线调整
//    if (IOS_7) {
//        [myTable setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
//    }
//    myTable.backgroundColor = [CommonImage colorWithHexString:@"F6F6F6"];
    myTable.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    myTable.backgroundView = view;
    [view release];
    //分割线颜色
    myTable.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];

    [self.view addSubview:myTable];
    
    if (!dataArray.count) {
        [self addNewData];
    }
    
    myTable.tableFooterView = [self addwithdrawFromAccount];

    // Do any additional setup after loading the view.
}

- (UIView*)addwithdrawFromAccount
{
    UIView* cleanView =
    [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 84)] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    UIButton* withBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withBtn.frame = CGRectMake(17.5, 20, kDeviceWidth-35, 44);
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [withBtn setBackgroundImage:image forState:UIControlStateNormal];
    [withBtn setTitle:NSLocalizedString(@"保存", nil)
             forState:UIControlStateNormal];
    withBtn.layer.cornerRadius = 4;
    withBtn.clipsToBounds = YES;
    withBtn.layer.masksToBounds = YES;
    [withBtn addTarget:self
                action:@selector(saveData)
      forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:withBtn];
    return cleanView;
}

- (void)saveData
{
    [self.navigationController popViewControllerAnimated:YES];
    if (m_isRequest) {
        return;
    }
    NSString *str = [NSString string];
    if (![dataArray.lastObject length]) {
        [dataArray removeLastObject];
    }
    if (dataArray.count) {
        if ([dataArray isEqualToArray:m_contrastArr]) {
            return;
        }
        for (int i = 0; i<dataArray.count; i++) {
            str = [str stringByAppendingFormat:@"%@,",dataArray[i]];
        }
        if([[str substringFromIndex:[str length]-1] isEqualToString:@","])
        {
            str = [str substringToIndex:[str length]-1];
        }
        [m_infoDic setObject:str forKey:@"history"];
        
        if ([m_infoDic[@"is_add"] intValue] == 0) {
            [self loadDataBegin:YES];
        }
    }else{
        [m_infoDic removeObjectForKey:@"history"];
        if ([m_infoDic[@"is_add"] intValue] == 0 && ![m_contrastArr isEqualToArray:dataArray]) {
            [self loadDataBegin:NO];
        }
    }

}

- (void)loadDataBegin:(BOOL)isNo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (m_infoDic[@"history"]) {
        [dic setObject:m_infoDic[@"history"] forKey:@"history"];
    }else{
        [dic setObject:@"" forKey:@"history"];
    }
    
    if ([m_infoDic[@"is_current_user"] intValue] == 0 && m_infoDic[@"is_current_user"]) {
        [dic setObject:m_infoDic[@"id"] forKey:@"id"];
    }else{
        g_nowUserInfo.medical_history = m_infoDic[@"history"];
    }
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATAField_API_URL values:dic requestKey:UPDATAField_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"修改中...", nil)];
}

- (void)transmissionCustomData:(NSString*)arr
{
    [dataArray addObject:arr];
    [myTable reloadData];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 30;
    }
    return 17;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellF = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellF];
//    UIButton *but;
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellF] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];

    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[CommonUser getHistoryDisease]];
    if (dataArray.count) {
        [arr removeLastObject];
    }
    PickerView *myPicker = [[PickerView alloc] init];
    [myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] andWithSelectString:[dataArray objectAtIndex:indexPath.row] setTitle:@"自定义添加" isShow:NO];
    [myPicker setPickerViewBlock:^(NSString *content) {
        if ([content isEqualToString:@"new"]) {
            CustomDiseaseViewController * custom = [[CustomDiseaseViewController alloc]init];
            custom.myDelegate = self;
            custom.type = 1;
            [self.navigationController pushViewController:custom animated:YES];
            [custom release];
            return;
        }
        [dataArray replaceObjectAtIndex:indexPath.row withObject:content];
        [myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)butEventDel:(UIButton*)but
{
    UITableViewCell *cell = (UITableViewCell*)but.superview.superview;
    int row = (int)[myTable indexPathForCell:cell].row;
    [dataArray removeObjectAtIndex:row];
    [myTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


/**
 *  section背景
 *
 *  @param tableView mytable
 *  @param section   section
 *
 *  @return section背景
 */
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    return cleanView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)addNewData
{
    if (![dataArray.lastObject length] && dataArray.count) {
        return;
    }
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[CommonUser getHistoryDisease]];
    if (dataArray.count) {
        [arr removeLastObject];
    }
    [dataArray addObject:@""];
    [myTable setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    [myTable reloadData];

    PickerView *myPicker = [[PickerView alloc] init];
    [myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] andWithSelectString:[arr objectAtIndex:0] setTitle:@"自定义添加" isShow:NO];
    [myPicker setPickerViewBlock:^(NSString *content) {
        if ([content isEqualToString:@"new"]) {
            m_isRequest = YES;
            CustomDiseaseViewController * custom = [[CustomDiseaseViewController alloc]init];
            custom.myDelegate = self;
            custom.type = 1;
            [self.navigationController pushViewController:custom animated:YES];
            [custom release];
            [dataArray removeObjectAtIndex:dataArray.count-1];
            return;
        }
        [dataArray replaceObjectAtIndex:dataArray.count-1 withObject:content];
        
        [myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork Function

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
    if (![[dic[@"head"] objectForKey:@"state"] intValue])
    {
        if([loader.username isEqualToString:UPDATAField_API_URL]){
            
            MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"修改成功";
            progress_.mode = MBProgressHUDModeText;
            progress_.userInteractionEnabled = NO;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
            [progress_ show:YES];
            [progress_ showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [progress_ release];
                [progress_ removeFromSuperview];
            }];
        }
    }
    else {
        [Common TipDialog2:[dic[@"head"] objectForKey:@"msg"]];
    }
}


@end
