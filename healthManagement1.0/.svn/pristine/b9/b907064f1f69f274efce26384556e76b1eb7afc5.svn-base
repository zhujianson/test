//
//  HealthAlertListTableViewController.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "HealthAlertListTableViewController.h"
#import "AlertTableViewCell.h"
#import "CommonHttpRequest.h"
#import "Global.h"
#import "Common.h"
#import "DBOperate.h"
#import "HealthAlertViewController.h"
#import "AlertManager.h"
#import "Global_Url.h"

@interface HealthAlertListTableViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HealthAlertListTableViewController
{
     UITapGestureRecognizer * _tapGestureRecognizer;
     NSIndexPath * _editingIndexPath;
     UILongPressGestureRecognizer *_longPress;
     UIButton * _deleteButton;
     BOOL isRequeting;
}

@synthesize myDelegate;
@synthesize m_url,moreAlertGet;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        isRequeting = NO;
        _editingIndexPath = nil;
        [g_winDic setObject:@"1" forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDataByNotfication:) name:@"changeAlertData" object:nil];
          m_array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [CommonImage colorWithHexString:ANSWERBACKBACKCOLOR];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self loadDataBegin];
    
     _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
     _longPress.minimumPressDuration = 0.5;
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(kDeviceWidth, 0, kDeleteButtonWidth, kDeleteButtonHeight);
    _deleteButton.backgroundColor = [CommonImage colorWithHexString:@"ff564f"];
    _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_deleteButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_deleteButton];
    
}

//接受通知做出变化\更新闹钟
- (void)changeDataByNotfication:(NSNotification *)not
{
    [m_array removeAllObjects];
    m_nowPage = 0;
    [self loadDataBegin];
}


#pragma mark tableview

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    // 设置tableView进行编辑
    [self.tableView setEditing:editing animated:animated];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是添加操作还是删除操作触发的此方法
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteDataIndex:indexPath.row];
        // 1.修改数据源
        [m_array removeObjectAtIndex:indexPath.row];
        // 2.执行删除动画
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        if (m_array.count)
        {
//            NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:firstIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)deleteItem:(id)sender
{
    UIButton * deleteButton = (UIButton *)sender;
    NSIndexPath * indexPath = deleteButton.indexPath;

    [self.tableView.dataSource tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    _editingIndexPath = nil;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = _deleteButton.frame;
        _deleteButton.frame = (CGRect){frame.origin, frame.size.width, 0};
    } completion:^(BOOL finished) {
        CGRect frame = _deleteButton.frame;
        _deleteButton.frame = (CGRect){kDeviceWidth, frame.origin.y, frame.size.width, kDeleteButtonHeight};
    }];
     [self.tableView removeGestureRecognizer:_tapGestureRecognizer];
}
//长按手势
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan &&  !_editingIndexPath)
    {
        UIView * view = gestureRecognizer.view;
        //    CGPoint location = [gestureRecognizer locationInView:self.view];
        if(![view isKindOfClass:[UITableView class]])
        {
            return;
        }
        CGPoint point = [gestureRecognizer locationInView:view];
       
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell)
        {
        _editingIndexPath = indexPath;
        [self setEditing:YES atIndexPath:indexPath cell:cell];
        }
    }
}
//取消删除
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_editingIndexPath)
    {
        [self tapped:nil];
    }
}
- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(_editingIndexPath)
    {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    }
}
- (void)setEditing:(BOOL)editing atIndexPath:indexPath cell:(UITableViewCell *)cell {
    
    if(editing)
    {
        if(_editingIndexPath)
        {
            UITableViewCell * editingCell = [self.tableView cellForRowAtIndexPath:_editingIndexPath];
            [self setEditing:NO atIndexPath:_editingIndexPath cell:editingCell];
        }
        [self.tableView addGestureRecognizer:_tapGestureRecognizer];
    }
    else
    {
        [self.tableView removeGestureRecognizer:_tapGestureRecognizer];
    }
    
    CGRect frame = cell.frame;
    CGFloat cellXOffset;
    CGFloat deleteButtonXOffsetOld;
    CGFloat deleteButtonXOffset;
    
    if(editing)
    {
        cellXOffset = -kDeleteButtonWidth;
        deleteButtonXOffset = kDeviceWidth - kDeleteButtonWidth;
        deleteButtonXOffsetOld = kDeviceWidth;
        _editingIndexPath = indexPath;
    } else {
        cellXOffset = 0;
        deleteButtonXOffset = kDeviceWidth;
        deleteButtonXOffsetOld = kDeviceWidth - kDeleteButtonWidth;
        _editingIndexPath = nil;
    }
    
    CGFloat cellHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
    _deleteButton.frame = (CGRect) {deleteButtonXOffsetOld, frame.origin.y+6, _deleteButton.frame.size.width, cellHeight-6};
    _deleteButton.indexPath = indexPath;
    
    [UIView animateWithDuration:0.2f animations:^{
        cell.frame = CGRectMake(cellXOffset, frame.origin.y, frame.size.width, frame.size.height);
        _deleteButton.frame = (CGRect) {deleteButtonXOffset, frame.origin.y+6, _deleteButton.frame.size.width, cellHeight-6};
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setM_url:(NSString *)url
{
    m_url = [url retain];
    [self loadDataBegin];
}

- (void)loadDataBegin
{
    NSArray *dic_dataOrigel  = [AlertManager getAllAlertList];
    [m_array addObjectsFromArray:dic_dataOrigel];
    [self.tableView reloadData];
}

- (void)udateAlertState:(NSDictionary*)dic
{
    NSMutableDictionary *updateDict = [[NSMutableDictionary alloc] init];
    [updateDict setValue:dic[@"id"] forKey:@"id"];
    [updateDict setValue:[self changeAlertStateWithDictionary:dic ] forKey:@"use_yn"];
    [updateDict setObject:@"_isUpdate" forKey:@"_isUpdate"];
    [[DBOperate shareInstance] upadteMyAlertFromDBByAlertId:updateDict];
    [updateDict release];
    if ([[dic objectForKey:@"isOpen"] boolValue])
    {
         [AlertManager startClock:dic];
    }
    else
         [AlertManager shutdownClock:dic[@"id"]];
}

//更改闹钟的状态
-(NSString *)changeAlertStateWithDictionary:(NSDictionary *)dict
{
    BOOL state = [[dict objectForKey:@"isOpen"] boolValue];
    NSString *returnState = nil;
    if (state)
    {
          returnState = @"Y";
    }
    else
    {
        returnState = @"N";
    }
   return   returnState;
}
//UIScrollView滚动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_loadingMore == NO)
    {
        // 下拉到最底部时显示更多数据
        if( !_loadingMore && scrollView.contentOffset.y >= ( scrollView.contentSize.height - scrollView.frame.size.height - 45) )
        {
//            [self loadDataBegin];
        }
    }
}

#pragma mark - Table view data source
- (NSIndexPath *)cellIndexPathForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    UIView * view = gestureRecognizer.view;
    if(![view isKindOfClass:[UITableView class]])
    {
        return nil;
    }
    
    CGPoint point = [gestureRecognizer locationInView:view];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    return indexPath;
}


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
    static NSString *identifier = @"cell";
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[AlertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if(indexPath.row < m_array.count)
    {
        NSMutableDictionary *dic = [m_array objectAtIndex:(int)indexPath.row];
        [cell setDicInfo:dic];
        [cell setAlertTableViewCellBlock:^(NSMutableDictionary *content) {
            [self udateAlertState:content];
            [self changeAlertStateWithIndexRow:(int)indexPath.row];
        }];
        
        NSString *sendtimeTitle = [[dic objectForKey:@"sendtime"] stringByReplacingOccurrencesOfString:@"," withString:@"   |   "];
        sendtimeTitle = [NSString stringWithFormat:@"%@  |",sendtimeTitle];
        CGSize  size = [ sendtimeTitle sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kDeviceWidth-50, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        if (size.height > 17)
        {
            cell.m_labCyclist.frame = CGRectMake(17, 110, IOS_7?270:220,34);
            cell.view.frame = CGRectMake(cell.view.frame.origin.x, 10, cell.view.frame.size.width, 150+17);
        }
        else
        {
            cell.m_labCyclist.frame = CGRectMake(17,110, IOS_7?270:220, 17);
            cell.view.frame = CGRectMake(10, 10, kDeviceWidth-20, 150);
        }
    }
    return cell;
}

#pragma mark delete
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self deleteDataIndex:(int)indexPath.row];
//    [m_array removeObjectAtIndex:indexPath.row];
//    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str =[[[m_array objectAtIndex:indexPath.row] objectForKey:@"sendtime"] stringByReplacingOccurrencesOfString:@"," withString:@"   |   "];
     str = [NSString stringWithFormat:@"%@  |",str];
    CGSize  size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kDeviceWidth-50, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height > 17)
    {
         return 162+17;
    }
    return 162;
}

-(void)deleteDataIndex:(int)indexRow
{
    NSDictionary *dictInfo = [m_array objectAtIndex:indexRow];
    [[DBOperate shareInstance] deleteMyAlertByAlertId:dictInfo[@"id"]];
    [AlertManager shutdownClock:dictInfo[@"id"]];
}

//更改数据源
-(void)changeAlertStateWithIndexRow:(int)row
{
   NSDictionary *dict = [m_array objectAtIndex:row];
   NSMutableDictionary *changeDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
   [changeDict setObject:[self changeAlertStateWithDictionary:dict] forKey:@"use_yn"];
   [m_array replaceObjectAtIndex:row withObject:changeDict];
    [changeDict release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    已读
    NSDictionary *dic = [m_array objectAtIndex:indexPath.row];
    NSString *alertTag = dic[@"alertTag"];
    if ([alertTag hasPrefix:kMealAlert])//是早餐前 后记录提醒
    {
        [Common TipDialog2:@"记录血糖下次测量不能在此进行修改!"];
        return;
    }
    [myDelegate showView:dic Type:self];
}

-(void)text
{
    NSString *jsonString = [[NSBundle mainBundle]pathForResource:@"alert" ofType:@"txt"];
    NSString *htmlString = [NSString stringWithContentsOfFile:jsonString encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *dic_data = [dictionary objectForKey:@"rs"];
    [m_array addObjectsFromArray:dic_data];
    [self.tableView reloadData];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dictionary = [responseString KXjSONValueObject];
   if ([loader.username isEqualToString:m_url])
    {
        if ([[dictionary objectForKey:@"state"] intValue])
        {
            
        }
        else
        {
//            [Common TipDialog:[dictionary objectForKey:@"msg"]];
            
            NSArray *dic_data = [dictionary objectForKey:@"rs"];
            self.tableView.tableFooterView.hidden = NO;
//            [m_array removeAllObjects];
            [m_array addObjectsFromArray:dic_data];
            
            UILabel *lab = (UILabel*)[self.tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
            if ([dic_data count] <= g_everyPageNum) {
                
                lab.text = NSLocalizedString(@"已到底部", nil);
                lab.textColor = [CommonImage colorWithHexString:@"666666"];
                lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
                UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[self.tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
                [activi removeFromSuperview];
            }else {
                _loadingMore = NO;
                
                lab.text = NSLocalizedString(@"加载更多...", nil);
            }
            
            [self.tableView reloadData];

        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeAlertData" object:nil];
    [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    [m_array release];
    [m_url release];
    [super dealloc];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO; // Recognizers of this class are the first priority
}

@end
