//
//  AlertView.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/12.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, 180*(kDeviceWidth/320))];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.width-300)/2.f, (self.height-125)/2.f, 300, 125)];
        view.layer.cornerRadius = 8;
        view.backgroundColor = [CommonImage colorWithHexString:@"ffffff" alpha:0.2];
        [self addSubview:view];
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 22, 38, 38)];
        _imageV.contentMode = UIViewContentModeCenter;
//        video_state_infoi.png
//        video_state_lockedi.png
//        video_state_moneyi.png
//        video_state_smilei.png
        [view addSubview:self.imageV];
        
        self.labTitle = [Common createLabel];
        self.labTitle.frame = CGRectMake(self.imageV.right+12, 17, view.width-(self.imageV.right+12)-30, 45);
        self.labTitle.numberOfLines = 0;
        self.labTitle.textColor = [UIColor whiteColor];
        self.labTitle.font = [UIFont systemFontOfSize:15];
        [view addSubview:self.labTitle];
        
        self.butOK = [UIButton buttonWithType:UIButtonTypeCustom];
        self.butOK.frame = CGRectMake((view.width-150)/2.f, view.height-35-16, 150, 35);
        self.butOK.layer.cornerRadius = 35/2.f;
        self.butOK.clipsToBounds = YES;
        self.butOK.titleLabel.font = [UIFont systemFontOfSize:15];
        UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
        [self.butOK setBackgroundImage:image forState:UIControlStateNormal];
        [view addSubview:self.butOK];
    }
    
    return self;
}

- (void)butEventTouch
{
    self.ablock();
}

@end






@implementation AlertInputView

- (void)butClose
{
    [self removeFromSuperview];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
    if (self) {
        
        [APP_DELEGATE addSubview:self];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.width-300)/2.f, (self.height-238)/2.f, 600/2.f, 476/2.f)];
        view.layer.cornerRadius = 8;
        view.backgroundColor = [CommonImage colorWithHexString:@"ffffff" alpha:1];
        [self addSubview:view];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(view.width-45, 0, 45, 45);
        [but setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_nor.png"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butClose) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        self.labTitle = [Common createLabel];
        self.labTitle.frame = CGRectMake(0, 30, view.width, 45);
        self.labTitle.numberOfLines = 0;
        self.labTitle.textAlignment = NSTextAlignmentCenter;
        self.labTitle.textColor = [UIColor blackColor];
        self.labTitle.font = [UIFont systemFontOfSize:15];
        self.labTitle.text = @"绑定代理人，免费观看视频";
        [view addSubview:self.labTitle];
        
        _inputText = [self createTextField:@"请输入代理人手机号码"];
        [self.inputText setFont:[UIFont systemFontOfSize:16]];
        self.inputText.clearButtonMode = YES;
        self.inputText.returnKeyType = UIReturnKeyDone;
        self.inputText.textAlignment = NSTextAlignmentCenter;
        self.inputText.layer.cornerRadius = 22.5;
        self.inputText.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
        self.inputText.layer.borderColor = [CommonImage colorWithHexString:@"dcdcdc"].CGColor;
        self.inputText.layer.borderWidth = 0.5;
        self.inputText.frame = CGRectMake(40, self.labTitle.bottom, view.width-80, 45);
        [view addSubview:self.inputText];
        
        self.butOK = [UIButton buttonWithType:UIButtonTypeCustom];
        self.butOK.frame = CGRectMake((view.width-self.inputText.width)/2.f, self.inputText.bottom+20, self.inputText.width, self.inputText.height);
        self.butOK.layer.cornerRadius = self.inputText.layer.cornerRadius;
        self.butOK.clipsToBounds = YES;
        self.butOK.titleLabel.font = [UIFont systemFontOfSize:15];
        UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
        [self.butOK setTitle:@"绑定" forState:UIControlStateNormal];
        [self.butOK setBackgroundImage:image forState:UIControlStateNormal];
//        [self.butOK addTarget:self action:@selector(butEventTouch) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.butOK];
    }
    
    return self;
}
- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:17]];
    return text;
}

- (void)butEventTouch
{
    self.ablock();
//    [self butClose];
}

@end