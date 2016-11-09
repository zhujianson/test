//
//  MyQrcode.m
//  jiuhaohealth3.0
//
//  Created by xjs on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "MyQrcode.h"
#import "QRCodeGenerator.h"

@implementation MyQrcode

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"asdasdad");
    UIImageView *twoCode = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-200)/2, 100, 200, 200)];
    //    twoCode.image = [UIImage imageNamed:@"common.bundle/common/kangxun360.png"];
    twoCode.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoCode];
    [twoCode release];
    [self createTwoCodeWithImge:twoCode withImgeString:@"common.bundle/personnal/icon60.png"];
    
    UILabel * textLab = [Common createLabel:CGRectMake(0, twoCode.bottom+10, kDeviceWidth, 30) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:@"扫一扫上面的二维码,添加好友"];
    [self.view addSubview:textLab];
}

-(void)createTwoCodeWithImge:(UIImageView *)twoCodeImge withImgeString:(NSString *)imgeString
{
    UIColor *codeColor = [CommonImage colorWithHexString:@"000000"];
    UIImage* codeImage = [QRCodeGenerator qrImageForString:g_nowUserInfo.userid imageSize:twoCodeImge.frame.size.width*2 withPointType:QRPointRect withPositionType:QRPositionNormal withColor:codeColor];
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
@end
