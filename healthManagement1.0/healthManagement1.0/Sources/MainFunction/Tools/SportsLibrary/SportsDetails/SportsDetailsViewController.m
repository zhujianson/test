//
//  SportsDetailsViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SportsDetailsViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface SportsDetailsViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView* myTable;
    NSArray* dataArr;//练习方法数据//注意事项数据
}

@end

@implementation SportsDetailsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.log_pageID = 19;
    }
    return self;
}

- (void)dealloc
{
    [myTable release];
    [dataArr release];
    self.sportDic = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _sportDic[@"ITEM"];
    NSArray* titleArr;
    
    //运动内容，注意事项，适合范围，运动强度，运动时间，运动频率，运动功效
    if ([_sportDic[@"duration"] length]) {
        //运动时间和运动频率可能为空
        dataArr = [[NSArray alloc]
                   initWithObjects:_sportDic[@"motion"], _sportDic[@"attention"],
                   _sportDic[@"applicable"], _sportDic[@"strength"],
                   _sportDic[@"duration"], _sportDic[@"frequency"],
                   _sportDic[@"effect"],
                   nil];
        NSLog(@"%@",dataArr);
        titleArr = @[@"练习方法",@"注意事项",@"适合范围",@"运动强度",@"运动时间",@"运动频率",@"运动功效"];
    }
    else{
        //运动时间和运动频率可能为空
        dataArr = [[NSArray alloc]
                   initWithObjects:_sportDic[@"motion"], _sportDic[@"attention"],
                   _sportDic[@"applicable"], _sportDic[@"strength"],
                   _sportDic[@"effect"],
                   nil];
        NSLog(@"%@",dataArr);
        titleArr = @[@"练习方法",@"注意事项",@"适合范围",@"运动强度",@"运动功效"];
    }
    
    UIScrollView* scroll =
        [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    scroll.backgroundColor = [UIColor clearColor];
    CGFloat sizeFloat = 10;
    CGFloat firstF = 0.0;
    for (int i = 0; i < [dataArr count]; i++) {
        firstF = [Common heightForString:dataArr[i]
                                   Width:kDeviceWidth-40
                                    Font:[UIFont systemFontOfSize:15]].height + 20;
        if (!i) {
            if ([_sportDic[@"img2"] length]>2) {
                firstF+=155;
                if ([_sportDic[@"img3"] length]>2) {
                    firstF+=155;
                }
            }
        }
        UIView* backView = [self creatBackView:firstF + 45
                                        number:i
                                        pointY:sizeFloat
                                          text:dataArr[i]
                                         title:titleArr];
        NSLog(@"%@", titleArr[i]);
        [scroll addSubview:backView];
        sizeFloat = backView.bottom + 10;
    }

    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(0, sizeFloat);
    [scroll release];
    // Do any additional setup after loading the view.
}

- (UIView*)creatBackView:(CGFloat)heigt
                  number:(int)num
                  pointY:(CGFloat)y
                    text:(NSString*)text
                   title:(NSArray*)titleArr
{
    if (num == 0) {
        heigt = 165 + heigt;
    }
    UIView* backView = [
        [[UIView alloc] initWithFrame:CGRectMake(10, y, kDeviceWidth-20, heigt)] autorelease];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    backView.layer.borderWidth = 0.5;
    backView.layer.borderColor = [[CommonImage colorWithHexString:@"DADADA"] CGColor];

    UILabel* textLab = [Common createLabel:CGRectMake(10, 0, kDeviceWidth-120, 45)
                                 TextColor:@"333333"
                                      Font:[UIFont systemFontOfSize:18]
                             textAlignment:NSTextAlignmentLeft
                                  labTitle:titleArr[num]];
    [backView addSubview:textLab];
    UILabel* dataLab = [Common createLabel:CGRectMake(10, 45, kDeviceWidth-40, heigt - 45)
                                 TextColor:@"666666"
                                      Font:[UIFont systemFontOfSize:15]
                             textAlignment:NSTextAlignmentLeft
                                  labTitle:dataArr[num]];
    dataLab.numberOfLines = 0;
    [backView addSubview:dataLab];
    if (num == 0) {
        UILabel* textLab1 =
            [Common createLabel:CGRectMake(kDeviceWidth-92, 0, 60, 45)
                      TextColor:@"999999"
                           Font:[UIFont systemFontOfSize:15]
                  textAlignment:NSTextAlignmentRight
                       labTitle:[NSString stringWithFormat:@"%@千卡",
                                                           _sportDic[@"calorie"]]];
        [backView addSubview:textLab1];
        
        float x = [textLab1.text sizeWithFont:textLab1.font].width;
        
        UIImageView* freeimage =
            [[UIImageView alloc] initWithFrame:CGRectMake(textLab1.right-x-18, 11, 15, 22)];
        freeimage.image = [UIImage imageNamed:@"common.bundle/common/fire.png"];
        [backView addSubview:freeimage];
        [freeimage release];

        UIImageView* image =
            [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, kDeviceWidth-40, 155)];
//        [CommonImage setPicImageQiniu:_sportDic[@"img1"] View:image Type:2 Delegate:nil];
//        image.contentMode = UIViewContentModeScaleAspectFit;
//        [CommonImage setImageFromServer:_sportDic[@"img1"] View:image Type:2];
        UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
        [image sd_setImageWithURL:[NSURL URLWithString:_sportDic[@"img1"]] placeholderImage:defaul];

        [backView addSubview:image];
        [image release];
        int height = -30;
        if ([_sportDic[@"img2"] length]>2) {
            //含有两张图片
            image =
            [[UIImageView alloc] initWithFrame:CGRectMake(10, 45+155, kDeviceWidth-40, 155)];
//            [CommonImage setPicImageQiniu:_sportDic[@"img2"] View:image Type:2 Delegate:nil];
//            [CommonImage setImageFromServer:_sportDic[@"img2"] View:image Type:2];
            [image sd_setImageWithURL:[NSURL URLWithString:_sportDic[@"img2"]] placeholderImage:defaul];

            [backView addSubview:image];
            [image release];
            height += 75;
            if ([_sportDic[@"img3"] length]>2) {
                //含有三张图片
                image =
                [[UIImageView alloc] initWithFrame:CGRectMake(10, 45+155*2, kDeviceWidth-40, 155)];
//                [CommonImage setPicImageQiniu:_sportDic[@"img3"] View:image Type:2 Delegate:nil];
//                [CommonImage setImageFromServer:_sportDic[@"img3"] View:image Type:2];
                [image sd_setImageWithURL:[NSURL URLWithString:_sportDic[@"img3"]] placeholderImage:defaul];

                [backView addSubview:image];
                [image release];
                height += 75;
            }
        }
        dataLab.frame = [Common rectWithOrigin:dataLab.frame x:0 y:image.bounds.size.height+image.bounds.origin.y+height];
    } else {
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kDeviceWidth-20, 1)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
        [backView addSubview:lineView];
        [lineView release];
    }

    return backView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

// headerView
- (UIView*)tableviewHeaderView
{
    UIView* headertView =
        [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 184)] autorelease];
    UIImageView* ima = [[UIImageView alloc] initWithFrame:headertView.frame];
    ima.image = [UIImage imageNamed:@"sportimage.png"];
    headertView.backgroundColor = [UIColor redColor];
    [headertView addSubview:ima];
    [ima release];

    return headertView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [Common heightForString:dataArr[indexPath.section]
                             Width:275
                              Font:[UIFont systemFontOfSize:15]].height + 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [dataArr count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellF = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellF];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellF] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"484848"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    if (indexPath.section < [dataArr count]) {
        cell.textLabel.text = dataArr[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    /**
 *  section上面的标题
 */
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [CommonImage colorWithHexString:@"F6F6F6"];

    UILabel* textLable = [Common createLabel:CGRectMake(20, 0, 100, 40)
                                   TextColor:@"333333"
                                        Font:[UIFont systemFontOfSize:20]
                               textAlignment:NSTextAlignmentLeft
                                    labTitle:nil];
    UILabel* rightLable;
    switch (section) {
    case 0:
        textLable.text = @"练习方法";
        rightLable = [Common createLabel:CGRectMake(200, 0, 100, 40)
                               TextColor:@"8A8A8A"
                                    Font:[UIFont systemFontOfSize:16]
                           textAlignment:NSTextAlignmentRight
                                labTitle:@"2300卡"];
        [cleanView addSubview:rightLable];
        break;
    case 1:
        textLable.text = @"注意事项";
        break;

    default:
        break;
    }
    [cleanView addSubview:textLable];

    return cleanView;
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
