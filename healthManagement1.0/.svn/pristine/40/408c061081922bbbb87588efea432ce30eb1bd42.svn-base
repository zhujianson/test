//
//  SelectionListView.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SelectionListView.h"
#import "SelectionListTableViewCell.h"
#import "Common.h"

#define SIZE_HEIGHT 260

@implementation SelectionListView
{
    SelectionListViewBlock _inBlock;
    UIView* m_view;
    UITableView * table;
    NSMutableArray * chooseArr;
    UIView * blackView;
    NSMutableArray * returnArr;
     UIView *m_viewB;
}

- (void)dealloc
{
    [m_viewB release];
    [chooseArr release];
    [returnArr release];
    [m_view release];
    [table release];
    [blackView release];
    [super dealloc];
}

- (id)initWithdData:(NSArray*)dataArr andTitle:(NSString *)title andWithSelectArray:(NSArray *)selectArray
{
    self = [super init];
    if (self) {
        // Initialization code
        chooseArr = [[NSMutableArray alloc]init];
        returnArr = [[NSMutableArray alloc]init];
        [chooseArr addObjectsFromArray:dataArr];
        if (selectArray.count)
        {
            [returnArr addObjectsFromArray:selectArray];
            
            if ([[chooseArr lastObject] isEqualToString:[selectArray lastObject]])//无不显示
            {
                [returnArr removeAllObjects];
            }
        }
        
        m_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        m_view.backgroundColor = [UIColor clearColor];
        
        UIControl *controlBtn = [[UIControl alloc]initWithFrame:m_view.frame];
        [controlBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [m_view addSubview:controlBtn];
        
        m_viewB = [[UIView alloc] init];
        m_viewB.layer.cornerRadius = 4;
        m_viewB.clipsToBounds = YES;
        [m_view addSubview:m_viewB];
        
        //头
        UIView *dueAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-20, 35)];
        dueAccessoryView.tag = 541;
        dueAccessoryView.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
        [m_viewB addSubview:dueAccessoryView];
        [dueAccessoryView release];
        
        UILabel *labTitle = [Common createLabel];
        labTitle.frame = CGRectMake(7, 0, 200, dueAccessoryView.height);
        labTitle.backgroundColor = [UIColor clearColor];
        labTitle.textColor = [UIColor whiteColor];
        labTitle.font = [UIFont systemFontOfSize:17];
        labTitle.text = title;
        [dueAccessoryView addSubview:labTitle];
        [labTitle release];
        
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-75, 0, 60, dueAccessoryView.height)];
        [but setTitle:@"完成" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font = [UIFont systemFontOfSize:17];
        [dueAccessoryView addSubview:but];
        [but release];
        
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, dueAccessoryView.bottom, dueAccessoryView.width, 162) style:UITableViewStylePlain];
        table.backgroundColor = [UIColor whiteColor];
        table.delegate = self;
        table.userInteractionEnabled = YES;
        table.dataSource = self;
        [m_viewB addSubview:table];
        
        m_viewB.frame = CGRectMake(10, kDeviceHeight+64, kDeviceWidth-20, table.bottom);
        //初始化_dueAccessoryView
        [APP_DELEGATE addSubview:m_view];

        [Common setExtraCellLineHidden:table];
        [self showView];
    }
    return self;
}

- (void)choose
{
    NSLog(@"wanc");
    if (!returnArr.count)
    {
        [returnArr addObject:[chooseArr lastObject]];//无选择为最后一个 默认为无
    }
    _inBlock(returnArr);
    [self hideView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [chooseArr count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* indentifier = @"Cell";
    SelectionListTableViewCell* cell = (SelectionListTableViewCell*) [tableView dequeueReusableCellWithIdentifier:indentifier];
    UIButton* btn;
    if (cell == nil) {
        cell = [[[SelectionListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:indentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
    }
    if (indexPath.row < [chooseArr count]) {
        BOOL check = [returnArr containsObject:chooseArr[indexPath.row]];
        [cell setLableText:chooseArr[indexPath.row] check:check];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    BOOL checkBoxState = ((SelectionListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked;
    checkBoxState = !checkBoxState;
    ((SelectionListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked = checkBoxState;
    NSString  *weekName = [chooseArr objectAtIndex:indexPath.row];
    if (checkBoxState) {
        //最后一个选了无 清空别的
        if (indexPath.row == chooseArr.count-1)
        {
            [returnArr removeAllObjects];
            [returnArr addObject:weekName];
            [tableView reloadData];
            return;
        }
        if ([returnArr containsObject: [chooseArr lastObject]])
        {
            [returnArr removeObject:[chooseArr lastObject]];
            [returnArr addObject:weekName];
            [tableView reloadData];
            return;
        }
         [returnArr addObject:weekName];
        
        
    }else{
        [returnArr removeObject:weekName];
    }

    NSLog(@"%@",weekName);
}


- (void)hiddl
{
    [self hideView];
    
    [UIView animateWithDuration:0.3 animations:^{
        UIView *view = [m_view viewWithTag:789];
        UIView * top = [m_view viewWithTag:88];
        UIButton * custom = (UIButton*)[m_view viewWithTag:89];
        m_view.backgroundColor = [UIColor clearColor];
        view.transform = CGAffineTransformMakeTranslation(0, 0);
        top.frame = [Common rectWithOrigin:top.frame x:0 y:kDeviceHeight+64];
        //        custom.frame = CGRectMake(10, kDeviceHeight+64, 100, 44);
        custom.frame = [Common rectWithOrigin:custom.frame x:0 y:kDeviceHeight+64];
    } completion:^(BOOL f) {
        
        [m_view removeFromSuperview];
        [self release];
    }];
}

- (void)setSelectionListViewBlock:(SelectionListViewBlock)arr
{
    _inBlock = [arr copy];
}

- (void)hideView
{
    [UIView animateWithDuration:0.35 animations:^{
        //        m_viewB.frame = [Common rectWithOrigin:_inputDueDatePicker.frame x:0 y:kDeviceHeight+64];
        m_viewB.transform = CGAffineTransformMakeTranslation(0, 0);
        //        _dueAccessoryView.frame = [Common rectWithOrigin:_dueAccessoryView.frame x:0 y:kDeviceHeight+64];
        m_view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [m_view removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)showView
{
    [UIView animateWithDuration:0.35 animations:^{
        m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        //        m_viewB.frame = [Common rectWithOrigin:_inputDueDatePicker.frame x:0 y:kDeviceHeight-SIZE_HEIGHT+108];
        m_viewB.transform = CGAffineTransformMakeTranslation(0, -m_viewB.height-10);
        //    _dueAccessoryView.frame = [Common rectWithOrigin:_dueAccessoryView.frame x:0 y:kDeviceHeight-SIZE_HEIGHT+108-40];
    }];
}

@end
