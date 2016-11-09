//
//  FamilyInfoView.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-7-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FamilyInfoView.h"
//#import "UIImageView+WebCache.h"
#import "CommonUser.h"

#define LOCATION (self.height-380)
#define M_HEIGHTText 5

@implementation FamilyInfoView
@synthesize m_infoDic;

- (void)dealloc
{
    [m_labName release];
    [m_labNick release];
    [m_labSex release];
    [m_labDate release];
    [m_labHeight release];
    [m_labWidth release];
    [m_labWork release];
    [m_labLishiBing release];
    [m_labFamilyBing release];
//    [m_dicKeyValue release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSString* pathname = [[NSBundle mainBundle] pathForResource:@"keyValue" ofType:@"txt" inDirectory:@"/"];
//        NSString* str = [NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil];
//        m_dicKeyValue = [[NSDictionary alloc] initWithDictionary:[str KXjSONValueObject][0]];
        UIView* views = [[[UIView alloc] initWithFrame:CGRectMake(0, 47.5, frame.size.width, frame.size.height - 47.5)]autorelease];
        views.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        views.layer.cornerRadius = 3;
        [self addSubview:views];

        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, views.size.width, views.size.height)];
        view.tag = 130;
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
        view.layer.borderWidth = 0.5;
        view.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        [views addSubview:view];
        [view release];

        //头像
        m_butPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        m_butPhoto.clipsToBounds = YES;
        m_butPhoto.frame = CGRectMake((self.width - 95) / 2, 0, 95, 95);
        m_butPhoto.layer.cornerRadius = 95 / 2;
        UIImage* image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
        [m_butPhoto setImage:image forState:UIControlStateNormal];
        //        [Common setAssistantPicImage:nil View:m_butPhoto];
        [self addSubview:m_butPhoto];

//        //名称
//        m_labName = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 67, 62, 16)];
//        m_labName.textColor = [UIColor whiteColor];
//        m_labName.textAlignment = NSTextAlignmentCenter;
//        m_labName.font = [UIFont systemFontOfSize:12];
//        m_labName.layer.cornerRadius = 8.0f;
//        m_labName.clipsToBounds = YES;
//        m_labName.backgroundColor = [CommonImage colorWithHexString:@"333333" alpha:0.6];
//        [m_butPhoto addSubview:m_labName];

        //姓名
        UILabel* labName = [Common createLabel];
        labName.frame = CGRectMake(kDeviceWidth<375?15:30, 56 + 0.1*LOCATION, 45, 17);
        labName.textColor = [CommonImage colorWithHexString:@"333333"];
        labName.font = [UIFont systemFontOfSize:15];
        labName.text = @"姓名:";
        [view addSubview:labName];
        [labName setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [labName release];

        m_labNick = [Common createLabel];
        m_labNick.frame = CGRectMake(labName.right, labName.origin.y, view.frame.size.width-labName.frame.size.width-110, 18);
        m_labNick.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labNick.font = [UIFont systemFontOfSize:15];
		[view addSubview:m_labNick];
		
		m_labDevie = [Common createLabel];
		m_labDevie.frame = CGRectMake(view.frame.size.width-85, labName.origin.y, 70, 18);
		m_labDevie.layer.cornerRadius = 8;
		m_labDevie.layer.borderWidth = 0.5;
		m_labDevie.textAlignment = NSTextAlignmentCenter;
		m_labDevie.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
		m_labDevie.textColor = [CommonImage colorWithHexString:@"666666"];
		m_labDevie.font = [UIFont systemFontOfSize:12];
		[view addSubview:m_labDevie];

//        m_labdevice = [Common createLabel];
//        m_labdevice.frame = cg
        
        //用户编号
        UILabel* labSex = [Common createLabel];
        labSex.frame = CGRectMake(labName.left, m_labNick.bottom + M_HEIGHTText+ 0.1*LOCATION, 74, 17);
        labSex.textColor = [CommonImage colorWithHexString:@"333333"];
        labSex.font = [UIFont systemFontOfSize:15];
        labSex.text = @"用户编号: ";
        [view addSubview:labSex];
        [labSex release];
        

        m_labSex = [Common createLabel];
        m_labSex.frame = CGRectMake(labSex.right, labSex.origin.y, 130, 17);
        m_labSex.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labSex.font = [UIFont systemFontOfSize:15];
        [view addSubview:m_labSex];

        UIButton * instructions = [UIButton buttonWithType:UIButtonTypeCustom];
        instructions.frame = CGRectMake(view.width-55, labSex.top-1.5, 40, 20);
        [instructions setTitle:@"说明" forState:UIControlStateNormal];
        instructions.titleLabel.font = [UIFont systemFontOfSize:12];
        [instructions setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
        instructions.clipsToBounds = YES;
        instructions.layer.cornerRadius = 10;
        instructions.layer.borderWidth = 0.5;
        instructions.layer.borderColor = [CommonImage colorWithHexString:COLOR_FF5351].CGColor;
        [instructions addTarget:self action:@selector(createHelp) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:instructions];
        
        
        //shengri
        UILabel* labDate = [Common createLabel];
        labDate.frame = CGRectMake(labName.left, m_labSex.bottom + M_HEIGHTText+ 0.1*LOCATION, 45, 17);
        labDate.textColor = [CommonImage colorWithHexString:@"333333"];
        labDate.font = [UIFont systemFontOfSize:15];
        labDate.text = @"生日: ";
        [view addSubview:labDate];
        [labDate release];

        m_labDate = [Common createLabel];
        m_labDate.frame = CGRectMake(labDate.right, labDate.origin.y, 130, 17);
        m_labDate.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labDate.font = [UIFont systemFontOfSize:15];
        [view addSubview:m_labDate];

        //shengao
        UILabel* labHeight = [Common createLabel];
        labHeight.frame = CGRectMake(labName.left, m_labDate.bottom + M_HEIGHTText+ 0.1*LOCATION, 45, 17);
        labHeight.textColor = [CommonImage colorWithHexString:@"333333"];
        labHeight.font = [UIFont systemFontOfSize:15];
        labHeight.text = @"身高: ";
        [view addSubview:labHeight];
        [labHeight release];

        m_labHeight = [Common createLabel];
        m_labHeight.frame = CGRectMake(labHeight.right, labHeight.origin.y, 130, 17);
        m_labHeight.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labHeight.font = [UIFont systemFontOfSize:15];
        [view addSubview:m_labHeight];

        //tizhong
        UILabel* labWidht = [Common createLabel];
        labWidht.frame = CGRectMake(labName.left, m_labHeight.bottom + M_HEIGHTText+ 0.1*LOCATION, 45, 17);
        labWidht.textColor = [CommonImage colorWithHexString:@"333333"];
        labWidht.font = [UIFont systemFontOfSize:15];
        labWidht.text = @"体重: ";
        [view addSubview:labWidht];
        [labWidht release];

        m_labWidth = [Common createLabel];
        m_labWidth.frame = CGRectMake(labWidht.right, labWidht.origin.y, 130, 17);
        m_labWidth.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labWidth.font = [UIFont systemFontOfSize:15];
        [view addSubview:m_labWidth];

        //zhiye
        UILabel* labWork = [Common createLabel];
        labWork.frame = CGRectMake(labName.left, m_labWidth.bottom + M_HEIGHTText+ 0.1*LOCATION, 90, 17);
        labWork.textColor = [CommonImage colorWithHexString:@"333333"];
        labWork.font = [UIFont systemFontOfSize:15];
        labWork.text = @"糖尿病类型: ";
        [view addSubview:labWork];
        [labWork release];

        m_labWork = [Common createLabel];
        m_labWork.frame = CGRectMake(labWork.right, labWork.origin.y, view.width-labWork.right, 17);
        m_labWork.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labWork.font = [UIFont systemFontOfSize:15];
        [view addSubview:m_labWork];

        //jiwangbingshi
        UILabel* labLishiBing = [Common createLabel];
        labLishiBing.frame = CGRectMake(labName.left, labWork.bottom + M_HEIGHTText+ 0.1*LOCATION, 74, 17);
        labLishiBing.textColor = [CommonImage colorWithHexString:@"333333"];
        labLishiBing.font = [UIFont systemFontOfSize:15];
        labLishiBing.text = @"既往病史: ";
        [view addSubview:labLishiBing];
        [labLishiBing release];

        m_labLishiBing = [Common createLabel];
        m_labLishiBing.frame = CGRectMake(labLishiBing.right, labLishiBing.origin.y, view.width-labLishiBing.right, 17);
        m_labLishiBing.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labLishiBing.font = [UIFont systemFontOfSize:15];
        //        m_labLishiBing.numberOfLines = 2;
        [view addSubview:m_labLishiBing];

        //jiazubingshi
        UILabel* FamilyBing = [Common createLabel];
        FamilyBing.tag = 120;
        FamilyBing.frame = CGRectMake(labName.left, labLishiBing.bottom + M_HEIGHTText+ 0.1*LOCATION, 74, 17);
        FamilyBing.textColor = [CommonImage colorWithHexString:@"333333"];
        FamilyBing.font = [UIFont systemFontOfSize:15];
        FamilyBing.text = @"并发症: ";
        [view addSubview:FamilyBing];
        [FamilyBing release];

        m_labFamilyBing = [Common createLabel];
        m_labFamilyBing.frame = CGRectMake(FamilyBing.right, FamilyBing.origin.y, 130, 17);
        m_labFamilyBing.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labFamilyBing.font = [UIFont systemFontOfSize:15];
        //        m_labFamilyBing.numberOfLines = 2;
        [view addSubview:m_labFamilyBing];

        //功能按钮
        NSLog(@"%f",kDeviceWidth);
        CGFloat offset = kDeviceHeight>600?40:30;
        float widht = (view.width-60-47*3)/2;
        NSArray* funcImageArray = @[ @"common.bundle/personnal/edit.png", @"common.bundle/personnal/report.png", @"common.bundle/personnal/delete.png" ];
//        NSArray* funcImageArray = @[ @"编辑", @"图标", @"删除" ];

        for (int i = 0; i < 3; i++) {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100 + i;
            btn.frame = CGRectMake(30+i*(widht+47), view.frame.size.height - offset - 47, 47, 47);
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIImage* image = [UIImage imageNamed:funcImageArray[i]];
            [btn setBackgroundImage:image forState:UIControlStateNormal];
//            [btn setTitle:funcImageArray[i] forState:UIControlStateNormal];
//            [btn setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
            [view addSubview:btn];
        }

        m_butAdd = [[UIView alloc] initWithFrame:view.frame];
        m_butAdd.hidden = YES;
        m_butAdd.backgroundColor = [UIColor clearColor];
        [views addSubview:m_butAdd];

        UIButton* m_but = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_but setBackgroundImage:[UIImage imageNamed:@"common.bundle/personnal/center_my-family_btn_add_nor.png"] forState:UIControlStateNormal];
//        [m_but setBackgroundImage:[UIImage imageNamed:@"common.bundle/personnal/center_my-family_btn_add_pre.png"] forState:UIControlStateHighlighted];
        m_but.tag = 103;
        m_but.frame = CGRectMake(0, 0, 75, 75);
//        m_but.layer.cornerRadius = 75 / 2;
        m_but.clipsToBounds = YES;
        m_but.center = CGPointMake(view.width / 2, view.height / 2 - 20);
        [m_but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_butAdd addSubview:m_but];

        UILabel* textLab = [Common createLabel:CGRectMake(0, m_but.frame.origin.y + m_but.frame.size.height + 15, m_butAdd.frame.size.width, 15) TextColor:@"666666" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:@"点击添加我的家人"];
        [m_butAdd addSubview:textLab];
    }
    return self;
}

- (void)btnClicked:(UIButton*)btn
{
    
    [_myDelegate pusNewView:(int)btn.tag - 100 Dic:self.m_infoDic];
}

- (void)setM_infoDic:(NSMutableDictionary*)dic
{
    UIImage* image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
    [m_butPhoto setImage:image forState:UIControlStateNormal];
//    16851933140
//    16952842160
    m_infoDic = dic;
    UIView* view = [self viewWithTag:130];
    if (!dic.count) {
        
        view.hidden = YES;
        m_butAdd.hidden = NO;
        m_labName.hidden = YES;
    }
    else {
        view.hidden = NO;
        m_butAdd.hidden = YES;
        m_labName.hidden = NO;
        
        NSLog(@"%@", [dic objectForKey:@"filePath"]);
        //头像
        if ([[dic objectForKey:@"filePath"] length]) {
            NSString *filePath = [dic objectForKey:@"filePath"];
            if (filePath) {
//                [CommonImage setPicImageQiniu:filePath View:m_butPhoto Type:0 Delegate:^(NSString *strCon) {
//                    NSString *filePath1 = [filePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//                    if ([strCon rangeOfString:filePath1].length != NSNotFound) {
//                        UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//                        [m_butPhoto setImage:image forState:UIControlStateNormal];
//                    }
//                }];
//                NSString *imagePath = [filePath stringByAppendingString:@"?imageView2/1/w/80/h/80"];
                [CommonImage setImageFromServer:filePath View:m_butPhoto Type:0];

            }
        }
        UIButton* btn = (UIButton*)[self viewWithTag:102];
//        NSString * strId = dic[@"id"];
        
        BOOL isSelf = [dic[@"is_current_user"] boolValue];
        btn.hidden = isSelf;
        float widht;
        if (isSelf) {
            widht = ((kDeviceWidth-80)-47*2)/3;
        }else{
            widht = ((kDeviceWidth-80)-47*3)/4;
        }
//        UIButton* but;
//        for (int i = 0; i<2; i++) {
//            but = (UIButton*)[self viewWithTag:100 + i];
//            but.frame = [Common rectWithOrigin:but.frame x:widht+i*(widht+47) y:0];
//        }

        //姓名
        m_labNick.text = [dic objectForKey:@"nickName"];
		
		int temp = [dic[@"is_bind_device"] intValue];
        NSString * str = nil;
		if (temp) {
			str = @"已绑定设备";
            m_labDevie.textColor = [CommonImage colorWithHexString:COLOR_FF5351];
		}
		else {
			str = @"未绑定设备";
            m_labDevie.textColor = [CommonImage colorWithHexString:@"999999"];
		}
		m_labDevie.text = str;
//        CGSize size = [Common heightForString:m_labNick.text Width:170 Font:m_labNick.font];
//        m_labDevie.frame = [Common rectWithOrigin:m_labDevie.frame x:size.width+m_labNick.left+10 y:0];
        
        //用户编号
        m_labSex.text = [dic objectForKey:@"user_no"];
        //生日
        m_labDate.text = [dic objectForKey:@"birthday"];
        
        //身高
        m_labHeight.text = [[dic objectForKey:@"hight"] stringByAppendingString:@"cm"];
        
        //体重
        m_labWidth.text = [[dic objectForKey:@"weight"] stringByAppendingString:@"kg"];
        
        //糖尿病类型
        m_labWork.text = [Common isNULLString6:[dic objectForKey:@"diseaseType"]];
        
        m_labLishiBing.text = [Common isNULLString5:dic[@"history"]];
        
        m_labFamilyBing.text = [Common isNULLString2:dic[@"complication"]];
    }
}

////查找编码对应的疾病
//- (NSString*)transformationDisease:(NSString*)dis
//{
//    NSArray* arr = [dis componentsSeparatedByString:@","];
//    NSMutableArray* dataArr = [[NSMutableArray alloc] init];
//    [dataArr addObjectsFromArray:arr];
//    [dataArr removeObject:@""];
//    NSString* keystr = nil;
//    NSString* allstr = nil;
//    for (int i = 0; i < [dataArr count]; i++) {
//        if (m_dicKeyValue[dataArr[i]]) {
//            keystr = m_dicKeyValue[dataArr[i]];
//        } else {
//            keystr = dataArr[i];
//        }
//        if (i == 0) {
//            allstr = keystr;
//        } else {
//            allstr = [allstr stringByAppendingString:[NSString stringWithFormat:@",%@", keystr]];
//        }
//    }
//    [dataArr release];
//    return allstr;
//    
//}

- (NSString*)isAllspace:(NSString*)ling
{
    NSString *str = [ling stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length]) {
        return ling;
    }
    return @"未绑定";
}


- (void)createHelp
{
    UIView * app_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
    app_view.tag = 404;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [app_view addGestureRecognizer:tap];
    [tap release];
    
    UIView * mask_view = [[UIView alloc]initWithFrame:app_view.frame];
    mask_view.backgroundColor = [UIColor blackColor];
    mask_view.alpha = 0.6f;
    [app_view addSubview:mask_view];
    [mask_view release];
    [APP_DELEGATE addSubview:app_view];
    
    UIView * backView= [[UIView alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 650/2)];
    backView.backgroundColor = [CommonImage colorWithHexString:@"f5f5f5"];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 4;
    backView.center = CGPointMake(app_view.width/2, app_view.height/2);
    [app_view addSubview:backView];
    UILabel * titleLab = [Common createLabel:CGRectMake(0, 0, backView.width, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentCenter labTitle:@"家人独立管理健康及血糖数据"];
    [backView addSubview:titleLab];
    
    //关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(backView.size.width-45, 0, 45, 45);
    [closeBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_nor.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_pre.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];

    
    UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, titleLab.bottom-0.25, backView.width, 0.5)];
    lineview.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [backView addSubview:lineview];
    [lineview release];

    titleLab = [Common createLabel:CGRectMake(15, lineview.bottom-0.25, backView.width-30, 105) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"1. 帮助家人注册独立账户时，在新注册页面输入家人编号完成注册，即可一键导入家人历史记录信息，如下图："];
    titleLab.numberOfLines = 0;
    [backView addSubview:titleLab];
    
    UIView * imageView = [[UIView alloc]initWithFrame:CGRectMake(15, titleLab.bottom, backView.width-30, 90)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 4;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    [backView addSubview:imageView];
    
    titleLab = [Common createLabel:CGRectMake(0, 0, imageView.width, 45) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter labTitle:@"已帮助家人管理血糖，一键导入历史数据。（选填）"];
    [imageView addSubview:titleLab];
    
    lineview = [[UIView alloc] initWithFrame:CGRectMake(0, titleLab.bottom-0.25, imageView.width, 0.5)];
    lineview.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [imageView addSubview:lineview];
    [lineview release];
    
    titleLab = [Common createLabel:CGRectMake(0, 45, 95, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:@"家人编号"];
    [imageView addSubview:titleLab];
    
    titleLab = [Common createLabel:CGRectMake(105, 45, imageView.width-105, 45) TextColor:@"999999" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"请输入11位的家人编号"];
    [imageView addSubview:titleLab];
    
    [imageView release];
    
    titleLab = [Common createLabel:CGRectMake(15, imageView.bottom, backView.width-30, backView.height-imageView.bottom-10) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"2. 数据不丢失，持续为您家人的健康护航。"];
    titleLab.numberOfLines = 0;
    [backView addSubview:titleLab];
    [backView release];

}

- (void)removeView
{
    UIView * view = (UIView *)[APP_DELEGATE viewWithTag:404];
    [view removeFromSuperview];
}

@end
