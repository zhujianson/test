//
//  MedicineListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MedicineListViewController.h"

@protocol PhysicalPushDelegate;

@interface MedicineListViewController ()
{
   
}
@end

@implementation MedicineListViewController

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
    // Do any additional setup after loading the view.

//

    for (int section = 'A'; section <= 'Z'; section++) {
        [zimuArr addObject:[NSString stringWithFormat:@"%c", section]];
    }
    [self many];
    [self takeArray];
    
    dataTable = [[UITableView alloc]
                              initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 44-40)
                              style:UITableViewStylePlain];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    [self.view addSubview:dataTable];
//    dataTable.sectionIndexBackgroundColor = [UIColor clearColor];
    dataTable.backgroundColor = [UIColor clearColor];
    [dataTable release];
    [Common setExtraCellLineHidden:dataTable];
}

/**
 *  刷新数据列表
 */
- (void)reloadListData
{
    for (int section = 'A'; section <= 'Z'; section++) {
        [zimuArr addObject:[NSString stringWithFormat:@"%c", section]];
    }
    [self many];
    [self takeArray];
  

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
            //不属于字母的--放到#中 #对象为数组 数里面有一字典 ==字典key为# value为内容
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
    if (array.count && array[0][@"#"]) {
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
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    tableView.sectionIndexColor = [CommonImage colorWithHexString:@"56b2ff"];
    //    NSMutableArray* array = [NSMutableArray array];
    //    [array addObject:@"@"];
    //    for (int section = 'A'; section <= 'Z'; section++) {
    //        [array addObject:[NSString stringWithFormat:@"%c", section]];
    //    }
    //    [array addObject:@"#"];
    //    return array;
    NSMutableArray *arr;
    
    arr = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    
    for (int i=0 ; i<[_finalArray count]; i++) {
        [arr addObject:[[[_finalArray objectAtIndex:i]allKeys]objectAtIndex:0]];
    }
//    [arr addObject:@" "];
    return arr;
    
}

// 自定义索引与数组的对应关系
- (NSInteger)tableView:(UITableView*)tableView
sectionForSectionIndexTitle:(NSString*)title
               atIndex:(NSInteger)index
{
    if(index == 0)
        return 0;
    
    return index-1;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    //    return 26;
    return ([_finalArray count]);
    
}

//每个seciont中cell的数量
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{

    return [
            [[[_finalArray objectAtIndex:section] allObjects] objectAtIndex:0] count];
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
    }
    NSDictionary* group = [_finalArray objectAtIndex:indexPath.section];
    NSArray* groupArray = [[group allValues] objectAtIndex:0];
//    NSLog(@"%d",indexPath.section);
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.text =
    [[[groupArray objectAtIndex:indexPath.row] allObjects] objectAtIndex:0];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView
                             cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row
                                                                      inSection:indexPath.section]];
//    NSLog(@"%@", cell.textLabel.text);
    if (_myDelegate &&
        [_myDelegate respondsToSelector:@selector(pushPhysicalData:)]) {
        [_myDelegate pushPhysicalData:cell.textLabel.text];
    }
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
    return [[[_finalArray objectAtIndex:section]allKeys]objectAtIndex:0];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *headView = [UILabel new];
//    headView.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
//    headView.text = [[[_finalArray objectAtIndex:section]allKeys]objectAtIndex:0];
//    return [headView autorelease];
//
//}


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
