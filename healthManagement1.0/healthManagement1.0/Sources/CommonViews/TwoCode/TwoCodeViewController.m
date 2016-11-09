//
//  TwoCodeViewController.m
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-10-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "TwoCodeViewController.h"
#import "QRCodeGenerator.h"

@interface TwoCodeViewController ()
{
    //生成二维码的字符串
    NSString *codeProduceStr;
}
@end

@implementation TwoCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"扫描下载";
        codeProduceStr = [[NSString alloc] initWithFormat:@"http://www.kangxun360.com/mobile/index.html?fromid=%@",g_nowUserInfo.userid];
    }
    return self;
}
-(void)dealloc
{
    [codeProduceStr release];
    codeProduceStr = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createContentView];
}

-(void)createContentView
{
    NSString *titleTopString = @"把健康分享给您的家人或朋友";
    UILabel *titleTopLabel = [Common createLabel:CGRectMake(20, 10, kDeviceWidth-40, 30) TextColor:@"333333" Font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentLeft labTitle:titleTopString];
    [self.view addSubview:titleTopLabel];
    
    NSString *titleString = @"打开微信找到\"扫一扫\"对准屏幕上的二维码,扫描即可下载康迅360!";
    CGSize size = [Common sizeForAllString:titleString andFont:15 andWight:kDeviceWidth-40];
    
    UILabel *titleLabel = [Common createLabel:CGRectMake(20, titleTopLabel.bottom+5, kDeviceWidth-40, size.height) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:titleString];
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];

    UIImageView *twoCode = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-200)/2, titleLabel.bottom + 35, 200, 200)];
//    twoCode.image = [UIImage imageNamed:@"common.bundle/common/kangxun360.png"];
    twoCode.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoCode];
    [twoCode release];
    
    [self createTwoCodeWithImge:twoCode withImgeString:@"icon60.png"];
}

-(void)createTwoCodeWithImge:(UIImageView *)twoCodeImge withImgeString:(NSString *)imgeString
{
    UIColor *codeColor = [CommonImage colorWithHexString:@"0072bc"];
    UIImage* codeImage = [QRCodeGenerator qrImageForString:codeProduceStr imageSize:twoCodeImge.frame.size.width*2 withPointType:QRPointRect withPositionType:QRPositionNormal withColor:codeColor];
    [twoCodeImge setImage:codeImage];
    
 //   为了插入图片的完整性，我们选择在最中间插入，而且长宽建议为整个二维码的3/7至1/3
    UIImageView *logoImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, twoCodeImge.width*0.26, twoCodeImge.width*0.26)];
    logoImgeView.image = [UIImage imageNamed:imgeString];
    logoImgeView.backgroundColor = [UIColor whiteColor];
    logoImgeView.layer.cornerRadius = 4.0f;
    logoImgeView.center = CGPointMake(twoCodeImge.width/2.0, twoCodeImge.height/2.0);
    [twoCodeImge addSubview:logoImgeView];
    [logoImgeView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
