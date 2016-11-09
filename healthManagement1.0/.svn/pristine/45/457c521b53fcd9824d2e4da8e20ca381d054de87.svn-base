//
//  ClearBufferViewController.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-8.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "ClearBufferViewController.h"
#import "SSCheckBoxView.h"

@interface ClearBufferViewController ()

@end

@implementation ClearBufferViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"清理缓存";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    
    m_array = [[NSMutableArray alloc] init];
    NSArray *array = [NSArray arrayWithObjects:@"我的留言", @"进行中的方案", @"已完成的方案", @"健康速递", @"健康广播", @"预警信息", @"健康报告信息", nil];
    for (int i = 0; i < [array count]; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[array objectAtIndex:i] forKey:@"title"];
        [dic setObject:@NO forKey:@"isSel"];
        [m_array addObject:dic];
    }
	
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 100)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
	m_tableView.rowHeight = 50;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.separatorColor = [UIColor clearColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	UIView *view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	view.backgroundColor = [CommonImage colorWithHexString:@"#f0efed"];
    [self.view addSubview:m_tableView];
	
	UIButton *butOK = [UIButton buttonWithType:UIButtonTypeCustom];
	butOK.frame = CGRectMake(25, m_tableView.height+25, 270, 50);
//    butOK.backgroundColor = [CommonImage colorWithHexString:@"#d05151"];
    UIImage *image = [[UIImage imageNamed:@"common.bundle/common/red_normal.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [butOK setBackgroundImage:image forState:UIControlStateNormal];
    butOK.layer.cornerRadius = 4;
	[butOK setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
	[butOK setTitle:@"清除" forState:UIControlStateNormal];
	butOK.titleLabel.font = [UIFont systemFontOfSize:20];
	[butOK addTarget:self action:@selector(butEventClear) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:butOK];
}

- (void)butEventClear
{
    NSMutableDictionary *dicCan = [NSMutableDictionary dictionary];
    
    NSString *strSql = [NSString stringWithFormat:@"DELETE FROM msgboxlist WHERE userid = %@ and (", g_nowUserInfo.userid];
    for (int i = 0; i < [m_array count]; i++) {
        
        NSDictionary *dic = [m_array objectAtIndex:i];
        BOOL isSel = [[dic objectForKey:@"isSel"] boolValue];
        if (!i && isSel) {
            [dicCan setObject:@"1" forKey:@"str1"];
            continue;
        }
        
        if (isSel) {
            strSql = [strSql stringByAppendingFormat:@" msgType = %d or", i];
        }
    }
    NSString *strLast = [strSql substringFromIndex:strSql.length - 2];
    if ([strLast isEqualToString:@"or"]) {
        strSql = [strSql substringToIndex:strSql.length - 2];
        strSql = [strSql stringByAppendingString:@")"];
    } else {
        strSql = nil;
    }
    
    if ([dicCan objectForKey:@"str1"] || strSql) {
        
        MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
        progress_.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:progress_];
        [progress_ show:YES];
        
        [dicCan setObject:progress_ forKey:@"view"];
        [progress_ release];
        if (strSql)
        {
             [dicCan setObject:strSql forKey:@"str2"];
        }
        [NSThread detachNewThreadSelector:@selector(removeObject:) toTarget:self withObject:dicCan];
    }
}

- (void)removeObject:(NSDictionary*)dic
{
//    UIView *view = [dic objectForKey:@"view"];
//	[view removeFromSuperview];
//    
//    NSString *str1 = [dic objectForKey:@"str1"];
//    NSString *str2 = [dic objectForKey:@"str2"];
//    BOOL isOK;
//    if (str1) {
//        isOK = [[DBOperate shareInstance] deleteAllConsultData];
//        isOK = [[DBOperate shareInstance] deleteAllChatRecordData];
//    }
//    if (str2) {
//        isOK = [[DBOperate shareInstance] deleteAllMsgBoxListData:str2];
//    }
//    
//    dispatch_async( dispatch_get_main_queue(), ^(void){
//        NSMutableArray *array = [NSMutableArray array];
//        int row = 0;
//        for (int i = 0; i < [m_array count]; i++) {
//            
//            NSDictionary *dic = [m_array objectAtIndex:i];
//            BOOL isSel = [[dic objectForKey:@"isSel"] boolValue];
//            if (isSel) {
//                [m_array removeObject:dic];
//                [array addObject:[NSIndexPath indexPathForRow:row inSection:0]];
//                i--;
//            }
//            row++;
//        }
//        [m_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
//        
//        MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//        progress_.labelText = @"清空缓存成功";
//        progress_.mode = MBProgressHUDModeText;
//        [self.view addSubview:progress_];
//        [progress_ show:YES];
//        [progress_ showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//        } completionBlock:^{
//            [progress_ release];
//            [progress_ removeFromSuperview];
//        }];
//    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *checkBox;
    
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"666666"];
        
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        
        checkBox = [[UIImageView alloc] initWithFrame:CGRectMake(277, 0, 22, 50)];
        checkBox.contentMode = UIViewContentModeCenter;
        checkBox.image = [UIImage imageNamed:@"common.bundle/common/check1_off.png"];
        checkBox.tag = 100;
        [cell.contentView addSubview:checkBox];
        [checkBox release];
        
        UIView *viewXian = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kDeviceWidth, 0.5)];
        viewXian.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [cell.contentView addSubview:viewXian];
        [viewXian release];
    } else {
		checkBox = (UIImageView*)[cell viewWithTag:100];
	}
	
    NSDictionary *dic = [m_array objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    BOOL isSel = [[dic objectForKey:@"isSel"] boolValue];

    [self setImageForView:checkBox IsSel:isSel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *checkBox = (UIImageView*)[cell viewWithTag:100];

    NSMutableDictionary *dic = [m_array objectAtIndex:indexPath.row];
    BOOL isSel = ![[dic objectForKey:@"isSel"] boolValue];
    [dic setObject:[NSNumber numberWithBool:isSel] forKey:@"isSel"];
    
    [self setImageForView:checkBox IsSel:isSel];
    
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setImageForView:(UIImageView*)checkBox IsSel:(BOOL)isSel
{
    NSString *imagepaht = @"common.bundle/common/check1_off.png";
    if (isSel) {
        imagepaht = @"common.bundle/common/check1_on.png";
    }
    [checkBox setImage:[UIImage imageNamed:imagepaht]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_array release];
    [m_tableView release];
    
    [super dealloc];
}

@end
