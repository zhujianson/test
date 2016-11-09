//
//  VideoDetailViewController.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/11.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "VideoDetailViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "KXMoviePlayer.h"
#import "RightCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "AlertView.h"
#import "KXPayManage.h"
#import "WebViewController.h"
#import "MobClick.h"

@interface VideoDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    KXMoviePlayer* m_moviePlayer;
    
    UIView *m_headerPlayAdv;//播放封面
    UIView *m_headerInfotView;//标题阅读数
    UIView *m_headerDescView;//简介
    
    NSMutableDictionary *m_dic;
    NSMutableArray *m_array;
    
    UICollectionView *_rightCollectionView;
    
    AlertView *m_av;
    AlertInputView *m_aInputV;
}

@end

@implementation VideoDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.m_isHideNavBar = YES;
    }
    return self;
}

- (void)dealloc
{
    [m_moviePlayer stopMoviePlayer];
}

- (void)createNavigation
{
    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(10, IOS_7?20:0, 44, 44);
    left.tag = 33;
    [left addTarget:self action:@selector(popMySelfNav) forControlEvents:UIControlEventTouchUpInside];
    left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [left setImage:[UIImage imageNamed:@"common.bundle/nav/nav_back_white2.png"] forState:UIControlStateNormal];
//    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_pressed.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:left];
}

- (void)popMySelfNav
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_array = [[NSMutableArray alloc] init];
    
    [self loadDataForServer];
    
    //播放
    UIView *viewPlayAdv = [self createPlayAdv];
    [self.view addSubview:viewPlayAdv];
    
    UIView *viewInfo = [self createHeaderViewInfo];
    viewInfo.top = viewPlayAdv.bottom;
    [self.view addSubview:viewInfo];
    
    [self createNavigation];
    
    [self CreatRightCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([m_dic[@"video_state"] intValue]) {
        [self loadDataForServer];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIImageView *imageV = [m_headerPlayAdv viewWithTag:400];
    imageV.hidden = NO;
    if (m_moviePlayer)
    {
//        [m_moviePlayer,av.moviePlayer pause];
        [m_moviePlayer stopMoviePlayer];
    }
}

- (void)loadDataForServer
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.m_superDic[@"id"] forKey:@"id"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:get_course_video_detail values:dic requestKey:get_course_video_detail delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"", nil)];
}

//播放视频
- (void)createMovPlay:(NSString*)URL
{
    [m_dic setObject:@"0" forKey:@"video_state"];
    UIImageView *imageV = [m_headerPlayAdv viewWithTag:400];
    imageV.hidden = YES;
    
    if (!m_moviePlayer)
    {
        m_moviePlayer = [[KXMoviePlayer alloc] init];
    }
    [m_moviePlayer stopMoviePlayer];
    [m_moviePlayer loadMoviePlayerWithUrl:URL inParentView:m_headerPlayAdv];
    
    UIButton *left = [self.view viewWithTag:33];
    [self.view bringSubviewToFront:left];
    
//    if (self.index) {
//        [MobClick event:[NSString stringWithFormat:@"home_video_click_play_%@", self.index] label:self.m_superDic[@"courseTitle"]];
//    }
}

- (UIView*)createPlayAdv
{
    m_headerPlayAdv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 180*(kDeviceWidth/320))];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:m_headerPlayAdv.bounds];
    imageV.backgroundColor = [UIColor blackColor];
    imageV.tag = 400;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [m_headerPlayAdv addSubview:imageV];
    imageV.userInteractionEnabled = YES;
//    [CommonImage setPicImageQiniu:@"" View:imageV Type:3 Delegate:nil];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake((m_headerPlayAdv.width-100)/2, (m_headerPlayAdv.height-100)/2, 100, 100);
    [but setImage:[UIImage imageNamed:@"common.bundle/class/play.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:but];
    
    return m_headerPlayAdv;
}

- (void)setPlayAdv:(NSDictionary*)dic
{
    UIImageView *imageV = [m_headerPlayAdv viewWithTag:400];
    [CommonImage setPicImageQiniu:dic[@"video_icon"] View:imageV Type:3 Delegate:nil];
    
    if ([dic[@"video_state"] intValue]) {
        
        if (!m_av) {
            m_av = [[AlertView alloc] init];
            [m_av.butOK addTarget:self action:@selector(butEventTouch:) forControlEvents:UIControlEventTouchUpInside];
            [m_headerPlayAdv addSubview:m_av];
        }
        
        NSString *title, *title2 = @"", *pic, *image;
        //视频状态  0可以观看  1需要测评  2需要解锁   3需要付费   4等待解锁   5可以
        switch ([m_dic[@"video_state"] intValue]) {
            case 1:
            {
                title = @"当前课程需要进行体质测评后免费播放。";
                pic = @"去体质测评";
                image = @"common.bundle/class/video_state_infoi.png";
            }
                break;
            case 2:
            {
                title = @"当前课程已锁定，需代理人解锁方可免费观看。";
                pic = @"发送解锁请求";
                image = @"common.bundle/class/video_state_lockedi.png";
            }
                break;
            case 3:
            {
                title = @"当前课程需付费方可观看\n购买后，可无限次播放";
                title2 = @"购买后，可无限次播放";
                pic = [NSString stringWithFormat:@"%.2f元观看", [dic[@"video_price"] floatValue]/100];
                image = @"common.bundle/class/video_state_moneyi.png";
            }
                break;
            case 4:
            {
                title = @"解锁请求已发送给您绑定的代理人。";
                if (g_nowUserInfo.agent_mobile.length) {
                    title = [NSString stringWithFormat:@"解锁请求已发送给您绑定的手机尾号%@的代理人。", [g_nowUserInfo.agent_mobile substringFromIndex:7]];
                }
                pic = @"等待解锁中...";
                image = @"common.bundle/class/video_state_smilei.png";
                m_av.butOK.titleLabel.font = [UIFont systemFontOfSize:13];
                [m_av.butOK setTitleColor:[CommonImage colorWithHexString:The_ThemeColor] forState:UIControlStateNormal];
                [m_av.butOK setBackgroundImage:nil forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        m_av.imageV.image = [UIImage imageNamed:image];
        m_av.labTitle.attributedText = [Common replaceRedColorWithNSString:title andUseKeyWord:title2 andWithFontSize:13 TextColor:The_ThemeColor];
        [m_av.butOK setTitle:pic forState:UIControlStateNormal];
    }
    else {
        if (m_av) {
            [m_av removeFromSuperview];
            m_av = nil;
        }
    }
}

- (void)butEventTouch:(UIButton*)but
{
    //视频状态  0可以观看  1需要测评  2需要解锁   3需要付费
    switch ([m_dic[@"video_state"] intValue]) {
        case 1:
        {
            //跳转到活动页面
            WebViewController *noticeDetailVC = [[WebViewController alloc] init];
            noticeDetailVC.m_url = m_dic[@"junmp_url"];
            [self.navigationController pushViewController:noticeDetailVC animated:YES];
        }
            break;
        case 2:
        {
            if (g_nowUserInfo.agent_mobile.length) { //是否绑定过代理人
                
                [m_dic setObject:@"4" forKey:@"video_state"];
                
                [self setPlayAdv:m_dic];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:self.m_superDic[@"id"] forKey:@"id"];
                [[CommonHttpRequest defaultInstance] sendNewPostRequest:course_unlock_request values:dic requestKey:course_unlock_request delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
            }
            else {
                
                m_aInputV = [[AlertInputView alloc] init];
                [m_aInputV.butOK addTarget:self action:@selector(butBinDailiren:) forControlEvents:UIControlEventTouchUpInside];
//                m_aInputV.ablock = ^(){
//                    
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    [dic setObject:input.inputText.text forKey:@"mobile"];
//                    [[CommonHttpRequest defaultInstance] sendNewPostRequest:bind_account_agent values:dic requestKey:bind_account_agent delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
//                    
//                    
////                    [but setBackgroundImage:nil forState:UIControlStateNormal];
////                    [but setTitle:@"等待解锁中..." forState:UIControlStateNormal];
////                    but.titleLabel.font = [UIFont systemFontOfSize:13];
//                };
            }
        }
            break;
        case 3:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:m_dic[@"id"] forKey:@"id"];
            [dic setObject:kWXAppID forKey:@"appId"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_POSTREWARD values:dic requestKey:URL_POSTREWARD delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
        }
            break;
            
        default:
            break;
    }
}

- (void)butBinDailiren:(UIButton*)but
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:m_aInputV.inputText.text forKey:@"mobile"];
    g_nowUserInfo.agent_mobile = m_aInputV.inputText.text;
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:bind_account_agent values:dic requestKey:bind_account_agent delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)playVideo:(UIButton*)but
{
    [self createMovPlay:m_dic[@"video_url"]];
}

- (UIView*)createHeaderViewInfo
{
    m_headerInfotView = [[UIView alloc] initWithFrame:CGRectMake(0, m_moviePlayer.m_moviePlayerView.view.bottom, kDeviceWidth, 85)];
    m_headerInfotView.backgroundColor = [UIColor whiteColor];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    [m_headerInfotView addSubview:top];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.tag = 100;
    labTitle.frame = CGRectMake(15, 0, top.width-30, top.height);
    labTitle.font = [UIFont systemFontOfSize:17];
    labTitle.textColor = [UIColor blackColor];
    labTitle.numberOfLines = 2;
    labTitle.text = @"健身教练教你瘦大腿";
    [top addSubview:labTitle];
    
//    UILabel *labType = [Common createLabel];
//    labType.tag = 101;
//    labType.frame = CGRectMake(100, (50-18)/2.f, 50, 18);
//    labType.font = [UIFont systemFontOfSize:12];
//    labType.textColor = [UIColor whiteColor];
//    labType.layer.cornerRadius = 9;
//    labType.clipsToBounds = YES;
//    labType.text = @"评测后免费";
//    [top addSubview:labType];
    
    UIView *line = [Common createLineLabelWithHeight:50];
    [top addSubview:line];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, top.bottom, kDeviceWidth, m_headerInfotView.height - top.height)];
    [m_headerInfotView addSubview:bottom];
    
    NSArray *array = @[@"common.bundle/class/video_hoti", @"common.bundle/class/video_zani", @"common.bundle/class/video_cai"];
    UIButton *but;
    for (int i = 0; i < 3; i++) {
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(i*kDeviceWidth/3.f, 0, kDeviceWidth/3.f, bottom.height);
        but.userInteractionEnabled = i;
        but.tag = 200+i;
        [but setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [but setTitleColor:[CommonImage colorWithHexString:@"ff654c"] forState:UIControlStateSelected];
        but.titleLabel.font = [UIFont systemFontOfSize:11];
        [but setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", array[i]]] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_p.png", array[i]]] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(butEventHeader:) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:but];
        
        if (i != 2) {
            UIView* labelLine = [[UIView alloc] initWithFrame:CGRectMake(but.width-0.5, 8, 0.5, bottom.height-16)];
            labelLine.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
            [but addSubview:labelLine];
        }
    }
    
    return m_headerInfotView;
}

- (void)setHeaderViewInfo:(NSDictionary*)dic
{
    UILabel *labTitle = [m_headerInfotView viewWithTag:100];
    labTitle.text = dic[@"video_title"];
    labTitle.attributedText = [self setAttributed:[dic[@"video_title"] stringByAppendingString:@" "] withImage:[self getTypeString:dic[@"video_state"]]];
//    CGSize size = [Common sizeForString:labTitle.text andFont:labTitle.font.pointSize];
//    labTitle.width = MIN(m_headerInfotView.width-30, size.width);
    
//    UILabel *labType = [m_headerInfotView viewWithTag:101];
//    NSDictionary *item = [self getTypeString:dic[@"video_state"]];
//    labType.text = item[@"title"];//视频状态  0可以观看  1需要测评  2需要解锁   3需要付费
//    if (labType.text.length) {
//        labType.backgroundColor = item[@"color"];
//        float labTypeWidth = [Common sizeForString:labType.text andFont:labType.font.pointSize].width+10;
//        labType.width = labTypeWidth;
//        labType.top = labTitle.height-9;
//        if (size.width + labTypeWidth + 5 > m_headerInfotView.width-30) {
//            labType.top = labTitle.height/2+9;
//        }
//    }
    
    //0 无操作     1 喜欢    2 不喜欢

    UIButton *but = [m_headerInfotView viewWithTag:200];
    [but setTitle:[NSString stringWithFormat:@" %@", dic[@"video_show_times"]] forState:UIControlStateNormal];
    
    but = [m_headerInfotView viewWithTag:201];
    [but setTitle:[NSString stringWithFormat:@" %@", dic[@"like_num"]] forState:UIControlStateNormal];
    if ([m_dic[@"is_like"] intValue] == 1) {
//        [but setImage:[UIImage imageNamed:@"common.bundle/class/video_zani_p.png"] forState:UIControlStateNormal];
        but.selected = YES;
    }
    
    but = [m_headerInfotView viewWithTag:202];
    [but setTitle:[NSString stringWithFormat:@" %@", dic[@"dislike_num"]] forState:UIControlStateNormal];
    if ([m_dic[@"is_like"] intValue] == 2) {
        but.selected = YES;
//        [but setImage:[UIImage imageNamed:@"common.bundle/class/video_cai_p.png"] forState:UIControlStateNormal];
    }
}

- (NSMutableAttributedString*)setAttributed:(NSString*)title withImage:(UIImage*)image
{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title];
    NSTextAttachment *textA = [[NSTextAttachment alloc] init];
    textA.image = image;
    textA.bounds = CGRectMake(0, -2.5, image.size.width, image.size.height);
    NSAttributedString *upAttrStr = [NSAttributedString attributedStringWithAttachment:textA];
//    [textA release];
    [titleString insertAttributedString:upAttrStr atIndex:title.length];
    
    return titleString;
}

- (UIImage*)getTypeString:(NSString*)type
{
//    NSString *title, *color = @"";
    UIImage *image;
    //视频状态  0可以观看  1需要测评  2需要解锁   3需要付费
    switch ([type intValue]) {
        case 0:
            //            title = @"";
//            image = [UIImage imageNamed:@"common.bundle/class/video_button_info.png"];
            break;
        case 1:
//            title = @"评测后免费";
//            color = The_ThemeColor;
            image = [UIImage imageNamed:@"common.bundle/class/video_button_info.png"];
            break;
        case 2:
//            title = @"锁定";
//            color = @"729bfc";
            image = [UIImage imageNamed:@"common.bundle/class/video_button_lock.png"];
            break;
        case 3:
//            title = @"付费";
//            color = @"ff654c";
            image = [UIImage imageNamed:@"common.bundle/class/video_button_pay.png"];
            break;
            
        default:
            break;
    }
    
    return image;
}

- (void)butEventHeader:(UIButton*)but
{
    //0 无操作     1 喜欢    2 不喜欢
    if ([m_dic[@"is_like"] intValue]) {
        [Common TipDialog:[m_dic[@"is_like"] intValue] == 1 ? @"已赞" : @"已踩"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:m_dic[@"id"] forKey:@"id"];
    
    int num;
    if (but.tag == 201) {
        [m_dic setObject:@"1" forKey:@"is_like"];
        num = [m_dic[@"like_num"] intValue]+1;
        [m_dic setObject:[NSNumber numberWithInt:num] forKey:@"like_num"];
        [dic setObject:@"1" forKey:@"type"];//1 喜欢  2 不喜欢
        [but setTitle:[NSString stringWithFormat:@" %d", num] forState:UIControlStateNormal];
        but.selected = YES;
    }
    else {
        [m_dic setObject:@"2" forKey:@"is_like"];
        num = [m_dic[@"dislike_num"] intValue]+1;
        [m_dic setObject:[NSNumber numberWithInt:num] forKey:@"dislike_num"];
        [dic setObject:@"2" forKey:@"type"];//1 喜欢  2 不喜欢
        [but setTitle:[NSString stringWithFormat:@" %d", num] forState:UIControlStateNormal];
//        [but setImage:[UIImage imageNamed:@"common.bundle/class/video_cai_p.png"] forState:UIControlStateNormal];
        but.selected = YES;
    }
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:course_like_or_dislike values:dic requestKey:course_like_or_dislike delegate:self controller:self actiViewFlag:1 title:@""];
}

//简介
- (UIView*)createDescView
{
    m_headerDescView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    
    HeaderCollectionReusableView *top = [[HeaderCollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    top.label.text = @"简介";
    top.butMore.hidden = YES;
    [m_headerDescView addSubview:top];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(15, top.bottom, top.width-30, 50);
    labTitle.tag = 300;
    labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.text = @"太平吉象有幸邀请到中医协会主席黄老邪，著名体质调理专家给大家做这一次的线上讲座。本次主要针对亚健康人群，白领上班族常见的一些身体不适做了一些中医方面的建议……";
    [m_headerDescView addSubview:labTitle];
    
    return m_headerDescView;
}

- (void)setDescView:(NSDictionary*)dic
{
    UILabel *labTitle = [m_headerInfotView viewWithTag:300];
    labTitle.text = dic[@"video_title"];
    CGSize size = [Common sizeForAllString:labTitle.text andFont:labTitle.font.pointSize andWight:kDeviceWidth-30];
    labTitle.height = size.height;
    m_headerDescView.height = labTitle.bottom;
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    
    NSDictionary * dic = dict[@"head"];
    if (![[dic objectForKey:@"state"] intValue]) {
        NSMutableDictionary *body = dict[@"body"];
        if ([loader.username isEqualToString:get_course_video_detail]) {
            [m_array removeAllObjects];
            
            m_dic = [[NSMutableDictionary alloc] initWithDictionary:body];
            
            [self setPlayAdv:body];
            [self setHeaderViewInfo:body];
            
            [m_array addObject:body[@"video_introduction"]];
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary * d in body[@"list"]) {
                [array addObject:d];
            }
            [m_array addObject:array];
            
            [_rightCollectionView reloadData];
            
        }
        else if ([loader.username isEqualToString:course_like_or_dislike]) {
            
        }
        else if ([loader.username isEqualToString:URL_POSTREWARD]) {
//            NSDictionary * d= dict[@"body"];
            if (![body[@"rewardStatus"] intValue]) {
                [self createMovPlay:m_dic[@"video_url"]];
            }
            else {
                WS(weakSelf);
                [KXPayManage wxPayWithHandleServerResult:body result:^(int statusCode, NSString *statusMessage, id resultDict, NSError *error, NSData *data) {
                    [weakSelf handlerPayResultWithStatusMessage:statusMessage];
                }];
            }
        }
        else if ([loader.username isEqualToString:course_unlock_request]) {
            
        }
        else if ([loader.username isEqualToString:bind_account_agent]) {
            
            [m_aInputV removeFromSuperview];
            m_aInputV = nil;
            [Common MBProgressTishi:@"绑定代理人成功" forHeight:kDeviceHeight];
            
            [m_dic setObject:@"4" forKey:@"video_state"];
            
            [self setPlayAdv:m_dic];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.m_superDic[@"id"] forKey:@"id"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:course_unlock_request values:dic requestKey:course_unlock_request delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
        }
    }
    else {
        if ([loader.username isEqualToString:URL_POSTREWARD]) {
            if ([dic[@"state"] intValue] == 2004) {
                
                [self createMovPlay:m_dic[@"video_url"]];
                
                return;
            }
        }
        [Common TipDialog:dic[@"msg"]];
    }
}

- (void)handlerPayResultWithStatusMessage:(NSString *)statusMessage
{
    if (![kPaySuccess isEqualToString:statusMessage])
    {
        return;
    }
    [self createMovPlay:m_dic[@"video_url"]];

    [[KXPayManage sharePayEngine] setUpNilBlock];
}

- (void)CreatRightCollectionView
{
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    flowayout.minimumInteritemSpacing = 0.f;
    flowayout.minimumLineSpacing = 0.5f;
//    flowayout.itemSize = CGSizeMake((kDeviceWidth-40)/2, 55+190/2*kDeviceWidth/375);
    flowayout.headerReferenceSize = CGSizeMake(kDeviceWidth, 48);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, kDeviceWidth, 400)];
    headerView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, m_headerInfotView.bottom, self.view.width, self.view.height-m_headerInfotView.bottom) collectionViewLayout:flowayout];
    [_rightCollectionView registerClass:[Header2CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader"];
//    [_rightCollectionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwFooter"];
    _rightCollectionView.alwaysBounceVertical = YES;

    [_rightCollectionView addSubview:headerView];
    
    [_rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
    [_rightCollectionView registerClass:[DescCollectionViewCell class] forCellWithReuseIdentifier:@"DescCollectionViewCell"];
    
    [_rightCollectionView setBackgroundColor:[CommonImage colorWithHexString:@"ffffff"]];
    
    //    _rightCollectionView.dele
    _rightCollectionView.delegate = self;
    _rightCollectionView.dataSource = self;
    
    [self.view addSubview:_rightCollectionView];
}

#pragma mark------CollectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = m_array[section];
    if ([array isKindOfClass:[NSString class]]) {
        return 1;
    }
    else {
        return array.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    NSArray *array = m_array[indexPath.section];
    if ([array isKindOfClass:[NSString class]]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DescCollectionViewCell" forIndexPath:indexPath];
        ((DescCollectionViewCell*)cell).titleLabel.text = (NSString*)array;
        CGSize size = [Common sizeForAllString:(NSString*)array andFont:14 andWight:kDeviceWidth-30];
        ((DescCollectionViewCell*)cell).titleLabel.height = size.height+36;
    }
    else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
        
        ((RightCollectionViewCell*)cell).titleLabel.text = array[indexPath.row][@"courseTitle"];
        ((RightCollectionViewCell*)cell).readingLab.text = [NSString stringWithFormat:@"%@",array[indexPath.row][@"browseNum"]];
        ((RightCollectionViewCell*)cell).titleLabel.textColor = [CommonImage colorWithHexString:@"666666"];
        
        [CommonImage setImageFromServer:[NSString stringWithFormat:@"%@",array[indexPath.row][@"iconUrl"]] View:((RightCollectionViewCell*)cell).imageview Type:2];
        
        ((RightCollectionViewCell*)cell).viedoType.image = [Common setImageTypeWithStr:[NSString stringWithFormat:@"%@",array[indexPath.row][@"isFree"]]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return m_array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    Header2CollectionReusableView *headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
//    headView.butMore.hidden = YES;
//    headView.rightI.hidden = YES;
//    
//    headView.viewheader2.top = 8;
    headView.viewheader2.backgroundColor = [UIColor whiteColor];
    headView.label.text = indexPath.section ? @"推荐" : @"简介";
    headView.label.textColor = [UIColor blackColor];
//    headView.label.top = 8;
//    headView.viewheader.frame  = [Common rectWithOrigin:headView.viewheader.frame x:0 y:(45-13)/2+8];//
//    
//    headView.lineView.top = 51.5;
    
    return headView;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    NSArray *array = m_array[indexPath.section];
    if ([array isKindOfClass:[NSString class]]) {
        size = [Common sizeForAllString:(NSString*)array andFont:14 andWight:kDeviceWidth-30];
        size.height += 36;
        size.width = kDeviceWidth;
    }
    else {
        size = CGSizeMake((kDeviceWidth-40)/2, 55+190/2*kDeviceWidth/375);//lab高度＋图片高度＋图片位置高度
    }
    return size;
}

//返回头footerView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    CGSize size = {kDeviceWidth, 0};
//    //    if (m_allData.count-1 == section) {
//    size = CGSizeMake(kDeviceWidth, 10);
//    //    }
//    return size;
//}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = m_array[indexPath.section];
    if ([array isKindOfClass:[NSString class]]) {
        return;
    }
    
    VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
    detail.m_superDic = m_array[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
