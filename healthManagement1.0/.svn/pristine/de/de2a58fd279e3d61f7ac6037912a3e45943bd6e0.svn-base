//
//  DiaryModelSuperViewController.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "DiaryModelSuperViewController.h"
#import "FamilyListView.h"
#import "BloopressCell.h"

@interface DiaryModelSuperViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *m_cleanBtn;
}

@end

@implementation DiaryModelSuperViewController
@synthesize m_tableView;
@synthesize m_superClass;
@synthesize m_lastIndexPath;
@synthesize m_array;
@synthesize m_openView;
@synthesize m_rowHeight, m_rowOpenHeight;//,indexSelect;
@synthesize m_DiraryTimeType;

#pragma mark -life cycle
- (void)dealloc
{
    self.m_lastIndexPath = nil;
    [m_array release];
    [m_tableView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];

//    self.indexSelect = [self.m_superDic[@" "] intValue];

    [self setNavBar];
    
    m_array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
    [dicAdd setObject:@1 forKey:IsAddSection];
    [dicAdd setObject:self.m_superDic[@"recordDate"] forKey:@"recordDate"];
    [dicAdd setObject:self.m_superDic[@"timeBucket"] forKey:@"timeBucket"];
//    [self apppendColumnToDict:dicAdd];
    [m_array addObject:dicAdd];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain] ;
//    m_tableView.dataSource = self;
    m_tableView.delegate = self;
    m_tableView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];//@"f2f2f2"
    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    [self.view addSubview:m_tableView];
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];//ios7
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    footerView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kDeviceWidth, 400)];
    view.backgroundColor = self.view.backgroundColor;
    [footerView addSubview:view];
    [view release];
    m_tableView.tableFooterView = footerView;
    [footerView release];
    
    if (![self.m_superDic objectForKey:@"id"])
    {
         [dicAdd setObject:@1 forKey:ExpendsFlag];
         self.m_lastIndexPath  = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    
    m_cleanBtn = [Common createKeyboardClean];
    [m_cleanBtn addTarget:self action:@selector(cleanBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_cleanBtn];
}

- (void)cleanBtn:(UIButton*)btn
{
    [self.view endEditing:YES];
}

//- (void)setM_lastIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath) {
//        if (m_lastIndexPath) {
//            m_lastIndexPath
//        }
//    }
//    else {
//        
//    }
//}

//添加一些标示字段
-(void)apppendColumnToDict:(NSMutableDictionary *)dicAdd
{
    [dicAdd setObject:@0 forKey:ExpendsFlag];
//    [dicAdd setObject:self.m_superDic[kIdKeyString] forKey:kIdKeyString];
    [dicAdd setObject:self.m_superDic[@"timeBucket"] forKey:@"timeBucket"];
}

#pragma  mark -网络回调

/**
 *  获得数据
 */
//- (void)getDataSource
//{
//    m_loadingMore = YES;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSDictionary *family = [FamilyListView getSelectFamilyInfoByUserid];
//    [dic setObject:family[@"user_no"] forKey:@"accountId"];
//    [dic setObject:[NSString stringWithFormat:@"%d",self.m_diraryType] forKey:@"recordType"];
//    [dic setObject:self.m_superDic[@"recordDate"] forKey:@"recordDate"];
//    [dic setObject:self.m_superDic[@"timeBucket"] forKey:@"timeBucket"];
//    [[CommonHttpRequest defaultInstance] sendNewPostRequest:kGetRecordDetail values:dic requestKey:kGetRecordDetail delegate:self controller:self actiViewFlag:1 title:nil];
//}

//- (void)didFinishSuccess:(ASIHTTPRequest *)loader
//{
//    NSString *responseString = [loader responseString];
//    NSDictionary *dic = [responseString KXjSONValueObject];
//    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
//    {
//        
//    }
//    else
//    {
//        [Common TipDialog:[dic[@"head"] objectForKey:@"msg"]];
//    }
//}
//
//- (void)didFinishFail:(ASIHTTPRequest *)loader
//{
//    NSLog(@"fail");
//}

//处理返回数据加入相应的控制字段
- (void)handleDataWithDataResult:(NSMutableArray *)dataArray
{
    if (dataArray.count)
    {
        NSString *sId = [NSString stringWithFormat:@"%@", [self.m_superDic objectForKey:@"id"]];
        for (int i = 0; i < dataArray.count; i++)
        {
            NSMutableDictionary *dict = dataArray[i];
            [dict setObject:self.m_superDic[@"timeBucket"] forKey:@"timeBucket"];
            if ([sId isEqualToString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"recordId"]]]) {
                
                self.m_lastIndexPath = [NSIndexPath indexPathForRow:1 inSection:i+1];
                [dict setObject:@1 forKey:ExpendsFlag];
            }
            else {
                [dict setObject:@0 forKey:ExpendsFlag];
            }
        }
        [self.m_array addObjectsFromArray:dataArray];
    }
    else
    {
        //展开第一个
        NSMutableDictionary *dict = [self.m_array firstObject];
        [dict setObject:@1 forKey:ExpendsFlag];
        self.m_lastIndexPath  = [NSIndexPath indexPathForRow:1 inSection:0];
    }
}

- (void)activeFirstResponder
{
    if (self.m_lastIndexPath)
    {
        UITableViewCell *cell = [m_tableView cellForRowAtIndexPath:m_lastIndexPath];
        if ([cell isKindOfClass:[DiaryZhanshiCell class]])
        {
            NSArray *array = ((DiaryZhanshiCell *)cell).m_textViewArray;
            if (array.count)
            {
                UITextField *textFiled = [array firstObject];
                if (textFiled)
                {
                    [textFiled becomeFirstResponder];
                }
            }
        }
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_rowOpenHeight;
}

#pragma mark -Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = m_array[section];
    int count = [[dict objectForKey:ExpendsFlag] intValue] + 1;
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.row) {
//        rowHeight = m_rowOpenHeight;
        rowHeight = [self heightForRowAtIndexPath:indexPath];
    }
    else {
        if (indexPath.section) {
            rowHeight = m_rowHeight;
        }
        else {
            rowHeight = m_rowHeight;
        }
    }
    
    return rowHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = m_array[indexPath.section];
    if (indexPath.section == 0 || [dict[ExpendsFlag] boolValue])
    {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = m_array[indexPath.section];
        [tableView beginUpdates];
        [self delCell:dic];
        [m_array removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

        //删除后重新计算索引
        self.m_lastIndexPath = nil;
        for (int i = 0 ;i < self.m_array.count ; i++)
        {
            NSDictionary *dict = self.m_array[i];
            BOOL is = [[dict objectForKey:ExpendsFlag] boolValue];
            if (is)
            {
                self.m_lastIndexPath = [NSIndexPath indexPathForRow:1 inSection:i];
                return;
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row) {
        return;
    }
    
    NSMutableDictionary *dic;
    
    if (m_lastIndexPath && m_lastIndexPath.section == indexPath.section) {
        dic = [m_array objectAtIndex:m_lastIndexPath.section];
        [dic setObject:@NO forKey:ExpendsFlag];
        [tableView deleteRowsAtIndexPaths:@[m_lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        self.m_lastIndexPath = nil;
    }
    else {
        
        if (m_lastIndexPath) {
            dic = [m_array objectAtIndex:m_lastIndexPath.section];
            [dic setObject:@NO forKey:ExpendsFlag];
            [tableView deleteRowsAtIndexPaths:@[m_lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (!m_lastIndexPath.section) {
                DiaryAddCellTableViewCell *cell = (DiaryAddCellTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell openCloseAnimation:NO];
            }
            else {
                BloopressCell *cell = (BloopressCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:m_lastIndexPath.section]];
                [(BloopressCell*)cell playAnimation:NO];
            }
        }
        
        dic = [m_array objectAtIndex:indexPath.section];
        [dic setObject:@YES forKey:ExpendsFlag];
        self.m_lastIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
//        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[m_lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView endUpdates];
    }
    
    NSDictionary *dicTest = [m_array objectAtIndex:indexPath.section];
    BOOL is = [[dicTest objectForKey:ExpendsFlag] boolValue];
    
    if (!indexPath.section) {
        DiaryAddCellTableViewCell *cell = (DiaryAddCellTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell openCloseAnimation:is];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self activeFirstResponder];
        });
    }
    else {
        BloopressCell *cell = (BloopressCell*)[tableView cellForRowAtIndexPath:indexPath];
        [(BloopressCell*)cell playAnimation:is];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

-(void)adjustCellSetSeparatorInsetWithCell:(UITableViewCell *)cell
{
    if (IS_OS_8_OR_LATER)//分割线到头
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
}

#pragma mark -event response
- (void)setNavBar
{
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common.bundle/diary/V4.0/dairy_qushitu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showHistory)];
//    self.navigationItem.rightBarButtonItem = right;
//    [right release];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"历史 " style:UIBarButtonItemStylePlain target:self action:@selector(showHistory)];
    self.navigationItem.rightBarButtonItem = right;
    [right release];

}

- (void)showHistory
{
    UIViewController *lastVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    if ([lastVC isKindOfClass:[DiaryHistoryViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //历史
    DiaryHistoryViewController *mystepCountVC = [[DiaryHistoryViewController alloc] init];
    mystepCountVC.diraryHistoryType = self.m_diraryType;
    [self.navigationController pushViewController:mystepCountVC animated:YES];
    [mystepCountVC release];
}

- (void)delCell:(NSDictionary*)dic
{
    NSMutableDictionary *dicDel = [NSMutableDictionary dictionary];
    [dicDel setObject:dic[@"recordId"] forKey:@"recordId"];
    [dicDel setObject:self.m_superDic[@"accountId"] forKey:@"accountId"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:RECORD_DELETE_URL values:dicDel requestKey:RECORD_DELETE_URL delegate:self controller:self actiViewFlag:1 title:@"删除中..."];
}

- (void)handleDataWithCell:(DiaryZhanshiCell *)cell
{
    WS(weakSelf);
    ((DiaryZhanshiCell *)cell).diaryZhanshiCellBlock = ^(DiaryEventType eventState, NSDictionary*infoDict){
        NSIndexPath *myIndexPath = [weakSelf->m_tableView indexPathForCell:cell];
        [weakSelf handleDataUpdateAndAdjustUiWithDiaryEventType:eventState andWithDict:infoDict withIndexPath:myIndexPath];
    };
}

- (void)handleDataUpdateAndAdjustUiWithDiaryEventType:(DiaryEventType)eventState andWithDict:(NSDictionary *)dict withIndexPath:(NSIndexPath *)indexPath
{
    [self handleDataUpdateAndAdjustUiWithDiaryEventType:eventState andWithDict:dict];
    switch (eventState)
    {
        case DiaryEventAdd:
        {
//            NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
//            [dicAdd setObject:@123 forKey:@"timeBucket"];
//            [dicAdd setObject:@0 forKey:ExpendsFlag];
//            [self.m_array insertObject:dicAdd atIndex:1];
//            [self.m_tableView beginUpdates];
////            [self.m_tableView.delegate tableView:self.m_tableView didSelectRowAtIndexPath:indexPath];
//            [self.m_tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//            [self.m_tableView endUpdates];
//            self.m_lastIndexPath = indexPath;
        }
            break;
        case DiaryEventDelete:
            [self.m_tableView.dataSource tableView:self.m_tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
            break;
        case DiaryEventUpate:
            NSLog(@"更新数据");
//            [self.m_tableView beginUpdates];
//            [self.m_tableView.delegate tableView:self.m_tableView didSelectRowAtIndexPath:indexPath];
//            [self.m_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//            [self.m_tableView endUpdates];
            break;
        default:
            break;
    }
}

#pragma mark -keyboard
//当键盘消失时候下移坐标
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self revertDataView];
    [UIView animateWithDuration:0.3f animations:^{
        m_cleanBtn.frame = [Common rectWithOrigin:m_cleanBtn.frame x:0 y:kDeviceHeight];
    }];
}

//当键盘出现时候上移坐标
- (void	)keyboardWillShow:(NSNotification *)aNotification {
    // 获得键盘大小
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    [self adjustDataView:keyboardSize.height];
    
    CGFloat h = kDeviceHeight-265;
    [UIView animateWithDuration:0.3f animations:^{
        m_cleanBtn.frame = [Common rectWithOrigin:m_cleanBtn.frame x:0 y:h];
    }];
    
}

- (void)adjustDataView:(float)height
{
    [UIView animateWithDuration:0.3 animations:^{
        m_tableView.height = kDeviceHeight - height;
    }];
}

- (void)revertDataView
{
    [UIView animateWithDuration:0.3 animations:^{
        m_tableView.height = kDeviceHeight;
        m_tableView.frameY = 0;
    }];
}
@end
