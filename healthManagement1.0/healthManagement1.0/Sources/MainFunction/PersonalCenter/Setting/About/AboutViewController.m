//
//  AboutViewController.m
//  bulkBuy1.0
//
//  Created by 徐国洪 on 13-10-22.
//  Copyright (c) 2013年 徐国洪. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIActionSheetDelegate>

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"关于我们", nil);
        self.hidesBottomBarWhenPushed = YES;
        self.log_pageID = 15;
    }
    return self;
}

//点击返回按钮返回主界面
- (void)LeftBarButtonItemPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //	UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(115, 50, 90, 90)];
    UIImage * image = [UIImage imageNamed:@"common.bundle/login/logingIcon"];;

    UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, image.size.height)];//257 × 254
    imageLogo.contentMode = UIViewContentModeCenter;
    imageLogo.image =image;
//    imageLogo.center = CGPointMake(kDeviceWidth/2, 0);
    [self.view addSubview:imageLogo];
    [imageLogo release];
    
//    UILabel *nameLabel= [Common createLabel:CGRectMake(0, imageLogo.bottom, kDeviceWidth, 30) TextColor:VERSION_TEXT_COLOR Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:[NSString stringWithFormat:@"%@", @""]];
//    [self.view addSubview:nameLabel];
    //    大版本2.0
    NSArray *titleArray = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"V%@ for iOS", BundleVersion],NSLocalizedString(@"中国九号健康管理有限公司 · 版权所有", nil), nil];
    
    for (int i = 0;i<titleArray.count;i++)
    {
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, imageLogo.bottom+20 +i*30, kDeviceWidth-50, 30)];
        labTitle.backgroundColor = [UIColor clearColor];
        labTitle.font = [UIFont systemFontOfSize:15];
        labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
        labTitle.numberOfLines = 0;
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.lineBreakMode = NSLineBreakByWordWrapping;
        //        labTitle.text = @"　　太平康迅360是中国9号健康管理有限公司发旗下的一款健康管理软件。建立具有海量数据处理能力的云端数据库和线上线下相结合的完备的健康服务管理体系。产品将为客户提供健康档案管理、健康数据收集整理分析、健康状况预警、个性化健康信息推送、医院绿色通道、乐活养生通道等精细化互动式的“一站式”健康管理服务。";
        labTitle.text = [titleArray objectAtIndex:i];
        [self.view addSubview:labTitle];
        [labTitle release];
    }
    [titleArray release];
    
    
    CGFloat x = 16*5+ [HOTLINEPHONE length]*10;
    
    UILabel* textLab = [Common createLabel:CGRectMake((kDeviceWidth-x)/2, kDeviceHeight-80, 16*5, 18) TextColor:@"999999" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"客服电话:"]];
    [self.view addSubview:textLab];
    
    UIButton * phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(textLab.right, textLab.top, [HOTLINEPHONE length]*10, 18);
    [phoneBtn setTitleColor:[CommonImage colorWithHexString:The_ThemeColor] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [phoneBtn setTitle:HOTLINEPHONE forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(isPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(phoneBtn.left, phoneBtn.bottom, phoneBtn.width, 1)];
    lineView.backgroundColor = [CommonImage colorWithHexString:The_ThemeColor];
    [self.view addSubview:lineView];
    [lineView release];
}

- (void)butEventPingjia
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id776558877?mt=8"]];
}

- (void)isPhone
{
    UIActionSheet* sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:HOTLINEPHONE
                            otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    [sheet release];
}
//
- (void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",HOTLINEPHONE]]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end