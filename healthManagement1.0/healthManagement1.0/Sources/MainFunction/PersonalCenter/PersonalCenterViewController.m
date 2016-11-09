//
//  PersonalCenterViewController.m
//  jiuhaoHealth2.1
//
//  Created by jiuhao-yangshuo on 14-7-25.
//  Copyright (c) 2014年 jiuhao. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterCell.h"
#import "LoginViewController.h"
//#import "FamilyListViewController.h"
#import "SettingViewController.h"
#import "AccountInformationViewController.h"
#import "MyMessageViewController.h"
#import "BoxListViewController.h"
#import "GuidePageView.h"
#import "FeedbackViewController.h"
#import "WalletViewController.h"
//#import "HealthAlertViewController.h"
//#import "ToolsViewController.h"
#import "WebViewController.h"
#import "DBOperate.h"
#import "TradingViewController.h"
#import "WalletWebView.h"
#import "AppDelegate.h"
#import "UIImageView+LBBlurredImage.h"
#import "EditPwdViewController.h"
#import "ImagePicker.h"
#import "GetToken.h"
#import "HealthRecordViewController.h"
#import "RedPacketViewController.h"
#import "DeviceViewController.h"
#import "UIButton+WebCache.h"
#import "TheAgentViewController.h"
#import "BindAgentViewController.h"

#define HEADER_HEIGHT 450/2*kDeviceWidth/375+70
@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_tabeleView;
    NSMutableArray *m_dataArray;
    NSDictionary * m_dic;
    UIImageView *m_navRedImage;
//    UIImage * m_headerImage;
    
}
@end

@implementation PersonalCenterViewController
- (void)dealloc
{
    [m_dataArray release];
    [m_tabeleView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getWallet" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"personReadNum" object:nil];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.log_pageID = 25;
        self.m_isHideNavBar = 64;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personReadNum) name:@"personReadNum" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWallet) name:@"getWallet" object:nil];

    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getWallet];
    [self personReadNum];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"image":@"common.bundle/personnal/wodedingdan.png", @"title":@"健康档案", @"value":@"2份"}]];
    [array addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"image":@"common.bundle/personnal/passWord.png", @"title":@"密码修改"}]];
    [array addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"image":@"common.bundle/personnal/yijianfankui.png", @"title":@"意见反馈"}]];

    [array addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"image":@"common.bundle/personnal/wodehongbao.png", @"title":@"添加／更改代理人", @"value":@"2份"}]];
    [array addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"image":@"common.bundle/personnal/shezhi.png", @"title":@"设置"}]];
    m_dataArray = [[NSMutableArray alloc ]initWithObjects:array, nil];
    
    [self creatMytableViewContnet];
}

- (void)butEventShowEmail
{
    BoxListViewController *email = [[BoxListViewController alloc] init];
    //    [email createBack];
    [self.navigationController pushViewController:email animated:YES];
    [email release];
}

/**
 *  获取我的钱包数据
 */
- (void)getWallet
{
    if (m_tabeleView) {
        UIButton *butUserPhone = (UIButton*)[m_tabeleView viewWithTag:890];
        NSString *imagePath = [g_nowUserInfo.filePath stringByAppendingString:@"?imageView2/1/w/140/h/140"];
        UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
        [butUserPhone sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:defaul];
        UILabel * lab = (UILabel*)[m_tabeleView.tableHeaderView viewWithTag:40];;
        //姓名
        lab.text = g_nowUserInfo.nickName;
    }
    [m_tabeleView reloadData];
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_ACCOUNTINFO_URL values:dic1 requestKey:GET_ACCOUNTINFO_URL delegate:self controller:self actiViewFlag:0 title:nil];
    //
}

- (void)creatMytableViewContnet
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, HEADER_HEIGHT-70)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 999;
    imageView.image = [UIImage imageNamed:@"common.bundle/personnal/personBlack"];
    [self.view addSubview:imageView];
    [imageView release];

    m_tabeleView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,kDeviceHeight+64) style:UITableViewStyleGrouped];
    m_tabeleView.delegate = self;
    m_tabeleView.dataSource = self;
    m_tabeleView.showsVerticalScrollIndicator = NO;
    m_tabeleView.backgroundColor = [UIColor clearColor];
//    m_tabeleView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_tabeleView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    if (IOS_7) {
        m_tabeleView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    m_tabeleView.rowHeight = 55;
    UIView *topView = [self createTabelHeaderView];
    m_tabeleView.tableHeaderView = topView;
    
    [self.view addSubview:m_tabeleView];
    
    float f = HEADER_HEIGHT+55*[m_dataArray.firstObject count]+7;
    
    UIView*m_footView = [[UIView alloc]initWithFrame:CGRectMake(0, f+20, kDeviceWidth, kDeviceHeight)];
    m_footView.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    [m_tabeleView addSubview:m_footView];
    [m_footView release];

}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)createTabelHeaderView
{
    
    UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, HEADER_HEIGHT)]autorelease];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;

    
    UIImageView * headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.alpha = 0.5;
    headerView.layer.cornerRadius = headerView.width/2;
    headerView.center = CGPointMake(kDeviceWidth/2, (view.height-80)/2);
    headerView.clipsToBounds = YES;
    [view addSubview:headerView];

    UIButton * butUserPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    butUserPhone.frame =CGRectMake(0, 0, 70, 70);
    butUserPhone.center = CGPointMake(kDeviceWidth/2, (view.height-80)/2);
    butUserPhone.layer.cornerRadius = butUserPhone.width/2;
    butUserPhone.clipsToBounds = YES;
    butUserPhone.tag = 890;
    NSString *imagePath = [g_nowUserInfo.filePath stringByAppendingString:@"?imageView2/1/w/150/h/150"];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
    [butUserPhone sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:defaul];
    [butUserPhone addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butUserPhone];
    
//    UIImageView *UserPhoneVIP = [[UIImageView alloc] initWithFrame:CGRectMake(butUserPhone.width+butUserPhone.origin.x-23, butUserPhone.bottom-23, 23, 23)];
//    UserPhoneVIP.tag = 891;
//    UserPhoneVIP.layer.cornerRadius = 23/2;
//    UserPhoneVIP.clipsToBounds = YES;
//    NSString * imageV = [NSString stringWithFormat:@"common.bundle/personnal/VIPlevel%d.png",g_nowUserInfo.check_code];
//    UserPhoneVIP.image = [UIImage imageNamed:imageV];
//    [view addSubview:UserPhoneVIP];
//    [UserPhoneVIP release];
//    [butUserPhone release];
    
    //姓名
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(0, butUserPhone.bottom+17.5, view.width, 17)];
    labName.backgroundColor = [UIColor clearColor];
    labName.textAlignment = NSTextAlignmentCenter;
    
    labName.text = g_nowUserInfo.nickName;
    labName.tag = 40;
    labName.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    labName.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
    labName.textColor = [CommonImage colorWithHexString:@"ffffff"];
    [view addSubview:labName];
    [labName release];
    
    UIView * lineV;
    UIButton * btn;
    NSArray * arr = @[@"我的订单",@"系统消息",@"微课红包"];
    CGSize s;
    for (int i = 0; i<3; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kDeviceWidth/3*i, view.height-70, kDeviceWidth/3, 70);
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:@"000000"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(setNewView:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * image =[UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/personnal/personIcon%d",i]];
        [btn setImage:image forState:UIControlStateNormal];
        s = [Common sizeForString:btn.titleLabel.text andFont:btn.titleLabel.font.pointSize];
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, s.width/2, 0, -s.width/2)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, -image.size.width/2, 0, image.size.width/2)];
        [view addSubview:btn];
        if (i) {
            lineV = [[UIView alloc]initWithFrame:CGRectMake(btn.left-0.25, btn.top+15, 0.5, 40)];
            [view addSubview:lineV];
            lineV.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
            [lineV release];
        }
        if (i==1) {
            UIImage *redHeartImageContent = [UIImage imageNamed:@"common.bundle/topic/conversation_icon_redpoint.png"];
            UIImageView *redHeartImage = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width/2+12, btn.height/2-22, redHeartImageContent.size.width, redHeartImageContent.size.height)];
            redHeartImage.tag = 200;
            redHeartImage.image = redHeartImageContent;
            redHeartImage.hidden = YES;
            [btn addSubview:redHeartImage];
            [redHeartImage release];
        }
    }
    return view;
}

- (void)healthArchives
{
    CommonViewController *VC = (CommonViewController*)self.view.superview.viewController;
    CommonNavViewController *navVC = nil;
    if ([VC isKindOfClass:[UINavigationController class]])
    {
        navVC = (CommonNavViewController*)VC;
    }
    else
    {
        navVC = (CommonNavViewController*)VC.navigationController;
    }
    
//    [self showHideSidebar];
    
    HealthRecordViewController *healthRecordVC  = [[HealthRecordViewController alloc] init];
    
    [navVC pushViewController:healthRecordVC animated:YES];
    [healthRecordVC release];
}

- (void)setNewView:(UIButton*)btn
{
    switch (btn.tag-100) {
        case 0:
        {
            WebViewController *help = [[WebViewController alloc] init];
            help.log_pageID = 26;

            help.m_url = [NSString stringWithFormat:@"%@?token=%@",m_dic[@"orderUrl"],g_nowUserInfo.userToken];
            help.title = btn.titleLabel.text;
            [self.navigationController pushViewController:help animated:YES];
            [help release];
        }
            break;
        case 1:
        {
            [self butEventShowEmail];
            
        }
            break;
        case 2:
        {
            WebViewController *help = [[WebViewController alloc] init];
            help.log_pageID = 41;
            help.m_url =  [NSString stringWithFormat:@"%@?token=%@",m_dic[@"redUrl"],g_nowUserInfo.userToken];
            help.title = btn.titleLabel.text;
            [self.navigationController pushViewController:help animated:YES];
            [help release];
        }
            break;
        default:
            break;
    }
}

/**
 *  跳转帐号信息界面
 */
- (void)takePicture
{
//    NSString *imagePath = [g_nowUserInfo.filePath stringByAppendingString:@"?imageView2/1/w/80/h/80"];
//    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
//    [butUserPhone sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];

    ImagePicker *picker = [[ImagePicker alloc] initWithId:self];
    [picker setPickerViewBlock:^(UIImage *image) {
//        butUserPhone.image = image;
//        m_headerImage = image;
        
//        UIImageView * imageView = (UIImageView*)[self.view viewWithTag:999];
//        [imageView setImageToBlur:image
//                       blurRadius:kLBBlurredImageDefaultBlurRadius
//                  completionBlock:^(){
//                      NSLog(@"The blurred image has been set");
//                  }];
        
//        [self showLoadingActiview];
        NSData *data = UIImageJPEGRepresentation(image, Define_picScale);
        [GetToken submitData:data withBlock:^(BOOL isOK,NSString*st) {
//            [self stopLoadingActiView];
            if (!isOK) {
                [Common TipDialog2:@"图片上传失败，请检查网络是否正常!"];
            }else
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:st forKey:@"filePath"];
                [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATAField_API_URL values:dic requestKey:UPDATAField_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"修改中...", nil)];
                [picker release];
            }
        } withName:nil];
        
    }];

    
//    CommonViewController *VC = self.view.superview.viewController;
//    CommonNavViewController *navVC = nil;
//    if ([VC isKindOfClass:[UINavigationController class]])
//    {
//        navVC = VC;
//    }
//    else
//    {
//        navVC = VC.navigationController;
//    }
//    
//    AccountInformationViewController * acccount =[[AccountInformationViewController alloc]init];
//    acccount.log_pageID = 79;
//    [self showHideSidebar];
//    [navVC pushViewController:acccount animated:YES];
//    [acccount release];
    
    //    [self.navigationController pushViewController:acccount animated:YES];
    //    [acccount release];
}

#pragma mark tableviewcellDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 0.01;
    if (section == m_dataArray.count-1) {
        height = 49;
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[PersonalCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
    }
    
    NSDictionary * dic = [m_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    [(PersonalCenterCell*)cell setDicInfo:dic];
    //cell点击背景颜色
    cell.selectedBackgroundView = [Common creatCellBackView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            //健康档案
            [self healthArchives];
            
        }
            break;
        case 1:
        {
            //修改密码
            EditPwdViewController* showVC = [[EditPwdViewController alloc] init];
            [self.navigationController pushViewController:showVC animated:YES];
            [showVC release];
        }
            break;
        case 2:
        {
            //意见反馈
            FeedbackViewController* showVC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:showVC animated:YES];
            [showVC release];

        }
            break;
        case 3:
        {
            //代理人
            id vc;
            if (g_nowUserInfo.agent_mobile.length) {
                vc = [[TheAgentViewController alloc] init];
            }
            else {
                vc = [[BindAgentViewController alloc] init];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        case 4:
        {
            //设置
            SettingViewController* showVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:showVC animated:YES];
            [showVC release];

        }
            break;
            
        default:
            break;
    }
}
//
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]init]autorelease];
    view.backgroundColor = [CommonImage colorWithHexString:@"f0f0f0"];
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]init]autorelease];
    view.backgroundColor = [CommonImage colorWithHexString:@"f0f0f0"];
    return view;
}
//
- (void)setting
{
    SettingViewController * seting = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:seting animated:YES];
    [seting release];
}

- (void)setChangeText:(NSDictionary*)dic
{
    //    UILabel * lab = (UILabel*)[m_tabeleView viewWithTag:4000];
    //    NSString * str=[NSString stringWithFormat:@"%d\n订单",[dic[@"orderCounts"] intValue]];
    //    lab.attributedText =[self replaceRedColorWithNSString:str andUseKeyWord:[NSString stringWithFormat:@"%d",[dic[@"orderCounts"] intValue]] andWithFontSize:25 TextColor:@"333333"];
    //    UILabel * lab2 = (UILabel*)[m_tabeleView viewWithTag:4001];
    //    str=[NSString stringWithFormat:@"%d\n红包",[dic[@"orderCounts"] intValue]];
    //    lab2.attributedText =[self replaceRedColorWithNSString:str andUseKeyWord:[NSString stringWithFormat:@"%d",[dic[@"orderCounts"] intValue]] andWithFontSize:25 TextColor:@"333333"];
    
    //    UILabel * lab3 = (UILabel*)[m_tabeleView viewWithTag:4002];
    //    str=[NSString stringWithFormat:@"%@\n余额",@"30.00"];
    //    lab3.attributedText =[self replaceRedColorWithNSString:str andUseKeyWord:[NSString stringWithFormat:@"%@",@"30.00"] andWithFontSize:25 TextColor:@"333333"];
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIView * view = (UIView*)[self.view viewWithTag:888];
//    view.alpha = scrollView.contentOffset.y/(155-64);
//    NSLog(@"%f",scrollView.contentOffset.y);
    UIImageView * imageView = (UIImageView*)[self.view viewWithTag:999];
    if (scrollView.contentOffset.y<0) {
//        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1-scrollView.contentOffset.y/80, 1-scrollView.contentOffset.y/80);
        imageView.frame = [Common rectWithSize:imageView.frame width:0 height:HEADER_HEIGHT-70-scrollView.contentOffset.y];
    }else{
        imageView.frame = [Common rectWithOrigin:imageView.frame x:0 y:-scrollView.contentOffset.y];
    }
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dic objectForKey:@"body"];
        if ([loader.username isEqualToString:GET_ACCOUNTINFO_URL]) {
            if (!m_dic) {
                m_dic = [body retain];
            }
            //            [self setChangeText:body];
            NSMutableDictionary * d;
            NSMutableArray * arr = m_dataArray[0];
            for (int i = 0; i<arr.count; i++) {
                d = arr[i];
                if ([d[@"title"] isEqualToString:@"我的订单"]) {
                    [d setObject:[NSString stringWithFormat:@"%d",[body[@"orderCounts"] intValue]] forKey:@"value"];
                }else if ([d[@"title"] isEqualToString:@"我的红包"]){
                    [d setObject:[NSString stringWithFormat:@"%d",[body[@"redCounts"] intValue]] forKey:@"value"];
                }else if ([d[@"title"] isEqualToString:@"体检报告"]){
                    [d setObject:[NSString stringWithFormat:@"%d份",[body[@"reportCounts"] intValue]] forKey:@"value"];
                }
            }
            [m_tabeleView reloadData];
        }else if ([loader.username isEqualToString:UPDATAField_API_URL]) {
        UIButton *butUserPhone = (UIButton*)[m_tabeleView viewWithTag:890];
        NSString *imagePath = [body[@"data"] stringByAppendingString:@"?imageView2/1/w/140/h/140"];
        UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
        [butUserPhone sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:defaul];

        MBProgressHUD* progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
        progress_.labelText = @"修改成功";
        progress_.mode = MBProgressHUDModeText;
        progress_.userInteractionEnabled = NO;
        [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
        [progress_ show:YES];
        [progress_ showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [progress_ release];
            [progress_ removeFromSuperview];
        }];
        }
    }
    else {
        [Common TipDialog:[head objectForKey:@"msg"]];
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
}

- (void)personReadNum
{
    UIImageView * red = (UIImageView*)[m_tabeleView.tableHeaderView viewWithTag:200];
    int count = [[DBOperate shareInstance] getNoReadCount];
    red.hidden = !MAX(count + g_nowUserInfo.broadcastNotReadNum, 0);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
