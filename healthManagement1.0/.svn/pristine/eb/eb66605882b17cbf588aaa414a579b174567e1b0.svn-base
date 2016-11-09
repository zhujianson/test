//
//  PickerGroupViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#define CELL_ROW 4
#define CELL_MARGIN 5
#define CELL_LINE_MARGIN 5


#import "PickerGroupViewController.h"
#import "PickerCollectionView.h"
#import "PickerDatas.h"
#import "PickerGroupViewController.h"
#import "PickerGroup.h"
#import "PickerGroupTableViewCell.h"
#import "PickerAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PickerGroupViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , assign) PickerAssetsViewController *collectionVc;

@property (nonatomic , assign) UITableView *tableView;
@property (nonatomic , retain) NSArray *groups;

@end

@implementation PickerGroupViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [self.view addSubview:tableView];
        [tableView release];
         self.tableView = tableView;
         [Common setExtraCellLineHidden:self.tableView];
    }
    return _tableView;
}

-(void)dealloc
{
    self.groups = nil;
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置按钮
    [self setupButtons];
    // 获取图片
    [self getImgs];
    self.title = @"选择相册";
    
}

- (void) setupButtons{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[barItem,fiexItem];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"groupCell";
    PickerGroupTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[[PickerGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
    }
    cell.group = self.groups[indexPath.row];
    return cell;
    
}

#pragma mark 跳转到控制器里面的内容
- (void) jump2StatusVc{
    // 如果是相册
    PickerGroup *gp = nil;
    for (PickerGroup *group in self.groups) {
        if ([group.groupName isEqualToString:@"Camera Roll"]) {
            gp = group;
            break;
        }
    }
    PickerAssetsViewController *assetsVc = [[PickerAssetsViewController alloc] init];
    assetsVc.assetsGroup = gp;
    assetsVc.maxCount = self.maxCount;
    [self.navigationController pushViewController:assetsVc animated:NO];
    [assetsVc release];
}

#pragma mark -<UITableViewDelegate>
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PickerGroup *group = self.groups[indexPath.row];
    PickerAssetsViewController *assetsVc = [[PickerAssetsViewController alloc] init];
    assetsVc.sendTitle = self.sendTitle;
    assetsVc.assetsGroup = group;
    assetsVc.maxCount = self.maxCount;
    [self.navigationController pushViewController:assetsVc animated:YES];
    [assetsVc release];
}

#pragma mark -<Images Datas>

-(void)getImgs{
    PickerDatas *datas = [PickerDatas defaultPicker];
    // 获取所有的图片URLs
    [datas getAllGroupWithPhotos:^(NSArray *groups) {
        self.groups = groups;
        if (self.status) {
            [self jump2StatusVc];
        }
        
        [self.tableView reloadData];
        
    }];
}


#pragma mark -<Navigation Actions>
- (void) back{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
