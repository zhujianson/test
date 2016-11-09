//
//  PhysicalDetailsViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "PhysicalDetailsViewController.h"
#import "AppDelegate.h"

#define TEXTFONT 15  //内容字体大小
#define TEXTLONG kDeviceWidth-100 //内容宽度
#define MIXHEIGHT 50 //最小宽度

@interface PhysicalDetailsViewController ()

@end

@implementation PhysicalDetailsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.log_pageID = 28;

        // Custom initialization
//        UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(goToShare) withNormalImge:@"common.bundle/nav/top_more_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_more_icon_pre.png"];
//        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    return self;
}

- (void)share
{
//    UIImage *screenShotImage = [Common  screenshotWithView:self.view];
//    AppDelegate *myDelegate = [Common getAppDelegate];
//    [myDelegate noneUIShareAllButtonClickHandler:self.view Content:@"来自康迅的分享@康迅360" ImagePath:screenShotImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",_phydic);
    self.title = _phyTitle;

    [self creatLableAndView];
    // Do any additional setup after loading the view.
}

/**
 *  创建视图控件
 */
- (void)creatLableAndView
{
    //更改数据只需要改变这5个字符串就可以
    NSString * oneStr = _phydic[@"item"];
    NSString * twoStr = _phydic[@"normal"];
    NSString * threeStr = _phydic[@"clinical_high"];
    
    NSString * fourStr = _phydic[@"clinical_low"];
    NSString * fiveStr = _phydic[@"objective"];

    //根据数字的多少来判断需要的高度
    CGSize imageOne = [Common heightForString:oneStr
                                        Width:TEXTLONG
                                         Font:[UIFont systemFontOfSize:TEXTFONT]];
    CGSize imageTwo = [Common
        heightForString:twoStr
                  Width:TEXTLONG
                   Font:[UIFont systemFontOfSize:TEXTFONT]];
    CGSize imageThree = [Common
        heightForString:threeStr
                  Width:TEXTLONG
                   Font:[UIFont systemFontOfSize:TEXTFONT+1]];
    CGSize imageFour = [Common
                         heightForString:fourStr
                         Width:TEXTLONG
                         Font:[UIFont systemFontOfSize:TEXTFONT+1]];
    CGSize imageFive = [Common
                         heightForString:fiveStr
                         Width:TEXTLONG
                         Font:[UIFont systemFontOfSize:TEXTFONT]];

    //不足50的情况下赋值为50
    if (imageOne.height<MIXHEIGHT) {
        imageOne.height = MIXHEIGHT;
    }
    if (imageTwo.height<MIXHEIGHT) {
        imageTwo.height = MIXHEIGHT;
    }
    if (imageThree.height<MIXHEIGHT) {
        imageThree.height = MIXHEIGHT;
    }
    if (imageFour.height<MIXHEIGHT) {
        imageFour.height = MIXHEIGHT;
    }
    if (imageFive.height<MIXHEIGHT) {
        imageFive.height = MIXHEIGHT;
    }

    NSLog(@"%f", imageOne.height+imageTwo.height+imageThree.height+imageFour.height+imageFive.height+100);

    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(0, imageOne.height+imageTwo.height+imageThree.height+imageFour.height+imageFive.height+320);
    
    [scroll release];

    UILabel* nameLable;//标题
    UILabel* nameDataLable;//数据内容
    UIImage* iamge;
    UIView * backView;
    UIImageView * iconImv;//标识图
    for (int i = 0; i < 5; i++) {
        //白色背景
        backView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, kDeviceWidth-40, 100)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 6.0f;
        backView.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
        backView.layer.borderWidth = 0.5f;
        [scroll addSubview:backView];
        [backView release];
        //分隔线
        UIView *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth-40, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"e3e3e3"];
        [backView addSubview:lineView];
        [lineView release];
        
        if (i>2) {
            iamge = [[UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/common/BigImage/physical_kuang%d.png",2]]
                     stretchableImageWithLeftCapWidth:50
                     topCapHeight:70];

        }else{
            iamge = [[UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/common/BigImage/physical_kuang%d.png",i]]
                     stretchableImageWithLeftCapWidth:50
                     topCapHeight:70];
        }

        //标题
        nameLable = [Common createLabel:CGRectMake(33, 0, TEXTLONG, 50)
                              TextColor:@"333333"
                                   Font:[UIFont systemFontOfSize:17]
                          textAlignment:NSTextAlignmentLeft
                               labTitle:@"检查项目"];
        [backView addSubview:nameLable];
        //内容
        nameDataLable =
            [Common createLabel:CGRectMake(33, 50, kDeviceWidth-80, 50)
                      TextColor:@"666666"
                           Font:[UIFont systemFontOfSize:TEXTFONT]
                  textAlignment:NSTextAlignmentLeft
                       labTitle:oneStr];
        nameDataLable.numberOfLines = 0;
        [backView addSubview:nameDataLable];
        
        switch (i) {
        case 0:
            backView.frame = CGRectMake(30, 10, kDeviceWidth-40, 50 + imageOne.height);
            nameDataLable.frame = [Common rectWithSize:nameDataLable.frame
                                                 width:0
                                                height:imageOne.height];
            break;
        case 1:
            nameLable.text = @"正常范围";
            nameDataLable.text = twoStr;
            backView.frame = CGRectMake(30, 70 + imageOne.height, kDeviceWidth-40,
                                         50+ imageTwo.height);
            nameDataLable.frame = [Common rectWithSize:nameDataLable.frame
                                                 width:0
                                                height:imageTwo.height];
            break;
        case 2:
            nameLable.text = @"临床意义(升高)";
            nameDataLable.text = threeStr;
            backView.frame = CGRectMake(30, 130+ imageOne.height  + imageTwo.height,
                                         kDeviceWidth-40, 50 + imageThree.height);

            nameDataLable.frame = [Common rectWithSize:nameDataLable.frame
                                                 width:0
                                                height:imageThree.height];
            break;
            case 3:
                nameLable.text = @"临床意义(降低)";
                nameDataLable.text = fourStr;
                backView.frame = CGRectMake(30, 190+ imageOne.height  + imageTwo.height+ imageThree.height,
                                             kDeviceWidth-40, 50 + imageFour.height);
                
                nameDataLable.frame = [Common rectWithSize:nameDataLable.frame
                                                     width:0
                                                    height:imageFour.height];
                break;
            case 4:
                nameLable.text = @"糖尿病控制目标（参考）";
                nameDataLable.text = fiveStr;
                backView.frame = CGRectMake(30, 250+ imageOne.height  + imageTwo.height+ imageThree.height+ imageFour.height,
                                             kDeviceWidth-40, 50 + imageFive.height);
                
                nameDataLable.frame = [Common rectWithSize:nameDataLable.frame
                                                     width:0
                                                    height:imageFive.height];
                break;

        default:
            break;
        }
        //背景圆角
//        iconImv = [[UIImageView alloc] initWithFrame:CGRectMake(-21, 32, 41, 41)];
//        iconImv.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
//        iconImv.layer.cornerRadius = iconImv.height/2;
//        iconImv.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
//        iconImv.layer.borderWidth = 0.5;
//        iconImv.clipsToBounds = YES;
//        [backView addSubview:iconImv];
//        [iconImv release];
        
        
        backView.clipsToBounds = YES;
        
        //覆盖半角
        iconImv = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 32, 41, 41)];
        iconImv.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
        iconImv.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
        iconImv.layer.borderWidth = 0.5;
        iconImv.layer.cornerRadius = iconImv.height/2;
        iconImv.clipsToBounds = YES;
        [backView addSubview:iconImv];
        [iconImv release];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(backView.origin.x-iconImv.width/2, backView.origin.y + 32+0.5, 40, 40)];
        view1.layer.cornerRadius = 20;
        view1.clipsToBounds = YES;
        view1.backgroundColor = self.view.backgroundColor;
        [scroll addSubview:view1];
        [view1 release];
        
        //背景图
        iconImv = [[UIImageView alloc]
                     initWithImage:iamge];
        iconImv.frame = CGRectMake(13, backView.frame.origin.y+35, 35, 35);
        [scroll addSubview:iconImv];
        [iconImv release];
        
    }
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
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
