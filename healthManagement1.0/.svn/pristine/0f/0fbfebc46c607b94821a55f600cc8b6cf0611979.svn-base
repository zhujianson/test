//
//  PhysicalProjectViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "PhysicalProjectViewController.h"

@interface PhysicalProjectViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* zimuArr; // abcd字母大全
    //    NSMutableArray* noZimuArr; //数据中不存在该字母
}

@end

@implementation PhysicalProjectViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _nameArr = [[NSMutableArray alloc] initWithCapacity:0];
        _pingyinArrp = [[NSMutableArray alloc] initWithCapacity:0];
        zimuArr = [[NSMutableArray alloc] initWithCapacity:0];
//        noZimuArr = [[NSMutableArray alloc] initWithCapacity:0];
        _dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [_nameArr release];
    [_pingyinArrp release];
    [zimuArr release];
//    [noZimuArr release];
    [_dataDic release];
    [_nameIndexesArray release];
    [_nameIndexesDictionary release];
    [_finalArray release];
    [_allDataDictionary release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    NSLog(@"%@", _pingyinArrp);
//    for (int section = 'A'; section <= 'Z'; section++) {
//        [zimuArr addObject:[NSString stringWithFormat:@"%c", section]];
//    }

//    [self many];
//    [self takeArray];

    UITableView* dataTable = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 44)
                style:UITableViewStylePlain];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];

    [self.view addSubview:dataTable];
    [Common setExtraCellLineHidden:dataTable];

    // Do any additional setup after loading the view.
}

- (void)takeArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    _nameIndexesDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [_pingyinArrp count]; i++) {
        NSString* firstLetter1 =
        [[_pingyinArrp objectAtIndex:i] substringToIndex:1]; //取出BEIJING的B
        NSString* firstLetter = [firstLetter1 uppercaseString];
        //        NSLog(@"%@",_pingyinArrp);
        if (![zimuArr containsObject:firstLetter]) {
            if ((array = [_nameIndexesDictionary objectForKey:@"#"])) {
                NSDictionary* add = [NSDictionary
                                     dictionaryWithObjectsAndKeys:[_nameArr objectAtIndex:i],
                                     @"#", nil];
                [array addObject:add];
                
            }else{
                NSDictionary* add = [NSDictionary
                                     dictionaryWithObjectsAndKeys:[_nameArr objectAtIndex:i],
                                     @"#", nil];
                NSMutableArray* getArray = [NSMutableArray array];
                [_nameIndexesDictionary setValue:getArray forKey:@"#"];
                [getArray addObject:add];
            }
            
        }else
        {
            if ((array = [_nameIndexesDictionary objectForKey:firstLetter])) {
                //有该索引  取出该索引对应的数组,添加一个字典 key为该索引 value为内容
                NSDictionary* add = [NSDictionary
                                     dictionaryWithObjectsAndKeys:[_nameArr objectAtIndex:i],
                                     [_pingyinArrp objectAtIndex:i], nil];
                [array addObject:add];
                
            } else {
                NSDictionary* add2 = [NSDictionary
                                      dictionaryWithObjectsAndKeys:[_nameArr objectAtIndex:i],
                                      [_pingyinArrp objectAtIndex:i], nil];
                NSMutableArray* getArray = [NSMutableArray array];
                [_nameIndexesDictionary setValue:getArray forKey:firstLetter];
                [getArray addObject:add2];
            }
        }
    }
    
    _nameIndexesArray = [[NSMutableArray alloc] initWithCapacity:2];
    //_nameIndexsDictionary key为索引 value为数组--内容为字典--key为该索引 vaule为实际内容
    for (NSString* key in _nameIndexesDictionary) {
        NSDictionary* dic = [NSDictionary
                             dictionaryWithObjectsAndKeys:[_nameIndexesDictionary objectForKey:key],
                             key, nil];
        [_nameIndexesArray addObject:dic];
    }
    _finalArray =
    [[NSMutableArray alloc] initWithArray:[self sortArray:_nameIndexesArray]];
    [array release];
}

- (NSArray*)sortArray:(NSMutableArray*)array
{
    int count = (int)[array count];
    //    NSLog(@"%d", count);
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - 1 - i; j++) {
            if ([[[[_nameIndexesArray objectAtIndex:j] allKeys] objectAtIndex:0]
                 compare:[[[_nameIndexesArray objectAtIndex:j + 1] allKeys]
                          objectAtIndex:0]] == NSOrderedDescending) {
                     NSDictionary* dic = [array[j] retain];
                     [array removeObject:dic];
                     [array insertObject:dic atIndex:j + 1];
                 }
        }
    }
    //把数组第一排的＃号数组移到最后一排
    if ([array count]<1) {
        return nil;
    }

    if (array[0][@"#"]) {
        [array addObject:array[0]];
        [array removeObjectAtIndex:0];
    }
    return array;
}

//组合名称和拼音
- (void)many
{
    _allDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
    for (int i = 0; i < [_pingyinArrp count]; i++) {
        [_allDataDictionary setValue:[_nameArr objectAtIndex:i]
                              forKey:[_pingyinArrp objectAtIndex:i]];
        //
    }
}

//
//- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
//{
//    tableView.sectionIndexColor = [CommonImage colorWithHexString:@"86C843"];
////    NSMutableArray* array = [NSMutableArray array];
////    [array addObject:@"@"];
////    for (int section = 'A'; section <= 'Z'; section++) {
////        [array addObject:[NSString stringWithFormat:@"%c", section]];
////    }
////    [array addObject:@"#"];
////    return array;
//    NSMutableArray *arr;
//
//    arr = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
//
//    for (int i=0 ; i<[_finalArray count]; i++) {
//        [[[_finalArray objectAtIndex:i]allKeys]objectAtIndex:0];
//        [arr addObject:[[[_finalArray objectAtIndex:i]allKeys]objectAtIndex:0]];
//        NSLog(@"%@",[[[_finalArray objectAtIndex:i]allKeys]objectAtIndex:0]);
//    }
////    [arr addObject:@"#"];
//    return arr;
//
//}

// 自定义索引与数组的对应关系
//- (NSInteger)tableView:(UITableView*)tableView
//    sectionForSectionIndexTitle:(NSString*)title
//                        atIndex:(NSInteger)index
//{
//    return index - 1;
//}

- (CGFloat)tableView:(UITableView*)tableView
    heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 49;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
//    return ([_finalArray count]);

}

//每个seciont中cell的数量
- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section
{
//    if ([noZimuArr containsObject:[_finalArray[section] allKeys]]) {
//        return 0;
//    }
//    for (int i = 0 ; i<[_finalArray count]; i++) {
//        if (section == (i+1)) {
//            return   [[[[_finalArray objectAtIndex:i] allObjects] objectAtIndex:0] count];
//        }
//    }
    return [_nameArr count];
//    return [
//        [[[_finalArray objectAtIndex:section] allObjects] objectAtIndex:0] count];
}

//自定义每个cell的内容，indexPath里面保函了section，row的信息。
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        
    }
    cell.textLabel.text = _nameArr[indexPath.row];
//    NSDictionary* group = [_finalArray objectAtIndex:indexPath.section];
//    NSArray* groupArray = [[group allValues] objectAtIndex:0];
//    NSLog(@"%d",indexPath.section);
//
//    cell.textLabel.text =
//        [[[groupArray objectAtIndex:indexPath.row] allObjects] objectAtIndex:0];
//    
    cell.detailTextLabel.text = [_dataDic objectForKey:cell.textLabel.text][@"objective"];
    cell.detailTextLabel.textColor = [UIColor grayColor];

    return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView
        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row
                                                 inSection:indexPath.section]];
    NSLog(@"%@", cell.textLabel.text);
    if (_myDelegate &&
        [_myDelegate respondsToSelector:@selector(pushPhysicalData:)]) {
        [_myDelegate pushPhysicalData:cell.textLabel.text];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Table view data source
- (NSString*)tableView:(UITableView*)tableView
    titleForHeaderInSection:(NSInteger)section
{
//    return _finalArray[section];
//    for (int i = 0 ; i<[_finalArray count]; i++) {
//        if (section == (i)) {
//            NSLog(@"%@",[[[_finalArray objectAtIndex:i]allKeys]objectAtIndex:0]);
//            
//            return [[[_finalArray objectAtIndex:i]allKeys]objectAtIndex:0];
//        }
//    }
    return nil;
    return [[[_finalArray objectAtIndex:section]allKeys]objectAtIndex:0];;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
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
