//
//  HealthManagerViewController.m
//  healthManagement1.0
//
//  Created by 徐国洪 on 16/1/19.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HealthManagerViewController.h"
#import "WebViewController.h"
#import "ShowConsultViewController.h"
#import "WebViewController.h"

@interface HealthManagerViewController () <UIActionSheetDelegate>
{
    WebViewController *m_webView;
}
@property (nonatomic, strong) NSMutableDictionary *m_dicInfo;

@end

@implementation HealthManagerViewController
//@synthesize m_dicInfo;

- (id)init
{
    self = [super init];
    if (self) {
        self.log_pageID = 34;
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    }
    return self;
}

- (void)dealloc
{
    m_scrollView = nil;
    self.m_dicInfo = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getServerData];
}

//- (void)createView

- (void)getServerData
{
    if (!self.m_dicInfo || ![self.m_dicInfo[@"needBuy"] boolValue]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_medicalIndex_new values:dic requestKey:URL_medicalIndex_new delegate:self controller:self actiViewFlag:1 title:nil];
    }
}

//没有购买
- (UIView*)createView:(NSDictionary*)dic
{
    m_webView = [[WebViewController alloc] init];
    m_webView.m_url = dic[@"managerUrl"];
    m_webView.m_superClass = self;
    [self.view addSubview:m_webView.view];
    return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 300)];
    
    //提示
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(15, 0, kDeviceWidth-30, 30);
    labTitle.font = [UIFont systemFontOfSize:13];
    labTitle.textColor = [CommonImage colorWithHexString:@"999999"];
    labTitle.text = dic[@"title"];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.numberOfLines = 0;
    [view addSubview:labTitle];
    float height = [Common sizeForAllString:labTitle.text andFont:labTitle.font.pointSize andWight:labTitle.width].height;
    CGRect rect = labTitle.frame;
    rect.size.height = MAX(height, 30);
    labTitle.frame = rect;
    
    //网格
    NSArray *array = dic[@"service"];
    int list = [Common getJingYi:(int)[array count] BeiChuShu:2];
    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake(0, labTitle.bottom, kDeviceWidth, list * 65)];
    gridView.backgroundColor = [UIColor whiteColor];
    [view addSubview:gridView];
    
    UIView *item;
    for (int i = 0; i < [array count]; i++) {
        item = [self createGrid:array[i] withIndex:i];
        rect = item.frame;
        rect.origin.x = (i%2)*rect.size.width;
        rect.origin.y = (i/2)*rect.size.height;
        item.frame = rect;
        [gridView addSubview:item];
    }
    
    //详细说明
    UILabel *labDeatil = [Common createLabel];
    labDeatil.frame = CGRectMake(0, gridView.bottom, kDeviceWidth, 110);
    labDeatil.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    labDeatil.font = [UIFont systemFontOfSize:14];
    labDeatil.textColor = [CommonImage colorWithHexString:@"333333"];
    labDeatil.text = dic[@"content"];
    labDeatil.numberOfLines = 0;
    labDeatil.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labDeatil];
    
    //购买项
    float width = (kDeviceWidth-60)/3.f;
    height = width*1.03;
    NSArray *imageArray = dic[@"goods"];
    list = [Common getJingYi:(int)[imageArray count] BeiChuShu:3];
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, labDeatil.bottom, kDeviceWidth, list*(height+15)+15)];
    [view addSubview:imageView];
    
    UIButton *but;
    for (int i = 0; i < imageArray.count; i++) {
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(15 + (i%3)*(width+15), 15 + (i/3)*(height+15), width, height);
        but.dicInfo = imageArray[i];
        [CommonImage setPicImageQiniu:imageArray[i][@"imgUrl"] View:but Type:2 Delegate:nil];
        [but addTarget:self action:@selector(butEventBuy:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:but];
    }
    
    height = imageView.bottom+5;
    
    BOOL isFree = [dic[@"isFree"] boolValue]; //是否享有免费问诊机会 0、没有 1、有
    
    if (!isFree) {
        //提示
        UILabel *labTishi = [Common createLabel];
        labTishi.frame = CGRectMake(15, imageView.bottom+5, kDeviceWidth-30, 20);
        //    labTishi.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        labTishi.font = [UIFont systemFontOfSize:14];
        labTishi.textColor = [CommonImage colorWithHexString:@"999999"];
        labTishi.numberOfLines = 0;
        [view addSubview:labTishi];
        NSString *commentCounts = !isFree ? @"你有一次免费体验健康管家服务的机会！" : @"你的免费体验健康管家服务已使用过期，请购买！";//评论数
        labTishi.attributedText = [self setAttributed:commentCounts withImage:[UIImage imageNamed:@"common.bundle/msg/doctor_card_free.png"]];
        height = [Common sizeForAllString:labTishi.text andFont:labTishi.font.pointSize andWight:labTishi.width].height;
        rect = labTishi.frame;
        rect.size.height = MAX(height, 20);
        labTishi.frame = rect;
        
        //使用
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.userInteractionEnabled = !isFree;
        but.frame = CGRectMake(15, labTishi.bottom+6, kDeviceWidth-30, 44);
        UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:isFree ? @"cccccc" : @"00c6ff"]];
        but.clipsToBounds = YES;
        [but setBackgroundImage:image forState:UIControlStateNormal];
        but.layer.cornerRadius = 3;
        [but setTitle:@"去使用" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butEventShiyong) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        height = but.bottom +15;
    }
    
    view.frame = CGRectMake(0, 0, kDeviceWidth, height);
    
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, view.height);
    
    return view;
}

- (NSMutableAttributedString*)setAttributed:(NSString*)title withImage:(UIImage*)image
{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title];
    NSTextAttachment *textA = [[NSTextAttachment alloc] init];
    textA.image = image;
    textA.bounds = CGRectMake(0, -6.5, image.size.width, image.size.height);
    NSAttributedString *upAttrStr = [NSAttributedString attributedStringWithAttachment:textA];
    [titleString insertAttributedString:upAttrStr atIndex:0];
    
    return titleString;
}

- (NSMutableAttributedString *)replaceWithNSString:(NSString*)str andUseKeyWord:(NSString*)keyWord andWithFontSize:(float)size backColor:(NSString*)colorString
{
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:str];
    if(!keyWord){
        return attrituteString;
    }
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName: [CommonImage colorWithHexString:colorString], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (UIView*)createGrid:(NSString*)title withIndex:(int)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 65)];
    view.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    
    UILabel *labNum = [Common createLabel];
    labNum.textAlignment = NSTextAlignmentCenter;
    labNum.backgroundColor = [CommonImage colorWithHexString:@"dcdcdc"];
    labNum.frame = CGRectMake((int)((view.width-104)/2), (view.height-30)/2, 30, 30);
    labNum.font = [UIFont systemFontOfSize:16];
    labNum.clipsToBounds = YES;
    labNum.layer.cornerRadius = 15;
    labNum.text = [NSString stringWithFormat:@"%d", index+1];
    labNum.textColor = [UIColor whiteColor];
    [view addSubview:labNum];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(labNum.right+4, 0, view.width-labNum.right, view.height);
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
    labTitle.text = title;
//    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.numberOfLines = 0;
    [view addSubview:labTitle];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-0.5, view.width, 0.5)];
    line1.backgroundColor = [CommonImage colorWithHexString:@"ebebeb"];
    [view addSubview:line1];
    
    if (!(index%2)) {
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(view.width-0.5, 0, 0.5, view.height)];
        line2.backgroundColor = [CommonImage colorWithHexString:@"ebebeb"];
        [view addSubview:line2];
    }
    
    return view;
}

- (void)butEventBuy:(UIButton*)but
{
    WebViewController *web = [[WebViewController alloc] init];
    web.m_url = but.dicInfo[@"detailUrl"];
    web.title = @"健康管家";
    [web setKXBlock:^(id cc) {
        [self getServerData];
    }];
    [((CommonViewController*)self.m_superClass).navigationController pushViewController:web animated:YES];
}

- (void)butEventShiyong
{
    //isUseFree 0
    if ([self.m_dicInfo[@"isUseFree"] boolValue] && ![self.m_dicInfo[@"isFree"] boolValue]) {
        
        ShowConsultViewController *show = [[ShowConsultViewController alloc] init];
        FriendModel *friendMo = [[FriendModel alloc] init];
        friendMo.accountId = self.m_dicInfo[@"accountId"];
        friendMo.userPhoto = self.m_dicInfo[@"userPhoto"];
        friendMo.nickName = self.m_dicInfo[@"nickName"];
        friendMo.isPay = YES;
        show.friendModel = friendMo;
        [((CommonViewController*)(self.m_superClass)).navigationController pushViewController:show animated:YES];
    }
    else {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.m_dicInfo[@"free"][@"goodsId"] forKey:@"goodsId"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_buy values:dic requestKey:URL_buy delegate:self controller:self actiViewFlag:1 title:nil];
    }
}

//购买成功
- (UIView*)createGoumai:(NSDictionary*)dic
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 4000)];
//    view.backgroundColor = [UIColor redColor];
    
    UIView *tishiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 4000)];
    tishiView.backgroundColor = [UIColor whiteColor];
    [view addSubview:tishiView];
    //
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(14, 10, kDeviceWidth-30, 20);
    labTitle.font = [UIFont systemFontOfSize:17];
    labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
    labTitle.numberOfLines = 0;
    [tishiView addSubview:labTitle];
    NSString *commentCounts = dic[@"promptTitle"];//
    labTitle.attributedText = [self setAttributed:commentCounts withImage:[UIImage imageNamed:@"common.bundle/msg/doctor_tip_smile.png"]];
    float height = [Common sizeForAllString:labTitle.text andFont:labTitle.font.pointSize andWight:labTitle.width].height;
    CGRect rect = labTitle.frame;
    rect.size.height = MAX(height, 30);
    labTitle.frame = rect;
    
    UILabel *labTishi = [Common createLabel];
    labTishi.frame = CGRectMake(15, labTitle.bottom+5, kDeviceWidth-30, 30);
    labTishi.font = [UIFont systemFontOfSize:17];
    labTishi.textColor = [CommonImage colorWithHexString:@"666666"];
    labTishi.numberOfLines = 0;
    [tishiView addSubview:labTishi];
    commentCounts = [dic[@"prompt"] stringByReplacingOccurrencesOfString:@"#day#" withString:[NSString stringWithFormat:@"%@", dic[@"day"]]];
    labTishi.attributedText = [self replaceWithNSString:commentCounts andUseKeyWord:[NSString stringWithFormat:@"%@", dic[@"day"]] andWithFontSize:17 backColor:@"ff5232"];
    height = [Common sizeForAllString:labTishi.text andFont:18 andWight:labTishi.width].height;
    rect = labTishi.frame;
    rect.size.height = MAX(height, 30);
    labTishi.frame = rect;
    
    rect = tishiView.frame;
    rect.size.height = labTishi.bottom + 15;
    tishiView.frame = rect;
    
    NSArray *array = @[@{@"color":@"69d136", @"imageName":@"common.bundle/msg/doctor_server_online.png", @"name":@"在线问诊", @"time":@"8:30-17:30"},
                       @{@"color":@"ffba27", @"imageName":@"common.bundle/msg/doctor_server_call.png", @"name":@"电话问诊", @"time":@"7x24小时"}];
    UIView *itemBut;
    for (int i = 0; i < array.count; i++) {
        itemBut = [self createButItem:array[i]];
        rect = itemBut.frame;
        rect.origin.x = 25 + (rect.size.width+25)*i;
        rect.origin.y = tishiView.bottom + 25;
        itemBut.frame = rect;
        [view addSubview:itemBut];
    }
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_scrollView.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    m_scrollView.userInteractionEnabled = YES;
    [m_scrollView addSubview:view];
    [self.view addSubview:m_scrollView];
    
    return view;
}

- (UIView*)createButItem:(NSDictionary*)dic
{
    float width = (kDeviceWidth-25*3)/2.f;
    float height = width*1.17;
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = [UIColor whiteColor];
    view.dicInfo = dic;
    [view addTarget:self action:@selector(butEventZixun:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height/1.5)];
    viewTop.userInteractionEnabled = NO;
    viewTop.backgroundColor = [CommonImage colorWithHexString:dic[@"color"]];
    [view addSubview:viewTop];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:viewTop.frame];
    imageV.contentMode = UIViewContentModeCenter;
    imageV.image = [UIImage imageNamed:dic[@"imageName"]];
    [viewTop addSubview:imageV];
    
    UILabel *labTishi = [Common createLabel];
    labTishi.frame = CGRectMake(15, viewTop.bottom, width-30, height-viewTop.height);
    labTishi.font = [UIFont systemFontOfSize:17];
    labTishi.textColor = [CommonImage colorWithHexString:@"666666"];
    labTishi.textAlignment = NSTextAlignmentCenter;
    labTishi.numberOfLines = 0;
    [view addSubview:labTishi];
    NSString *commentCounts = [NSString stringWithFormat:@"%@\n%@", dic[@"name"], dic[@"time"]];//评论数
    labTishi.attributedText = [self replaceWithNSString:commentCounts andUseKeyWord:dic[@"name"] andWithFontSize:17 backColor:@"333333"];
//    height = [Common sizeForAllString:labTishi.text andFont:labTishi.font.pointSize andWight:labTishi.width].height;
//    CGRect rect = labTishi.frame;
//    rect.size.height = MAX(height, 30);
//    labTishi.frame = rect;
    
    return view;
}

- (void)butEventZixun:(UIButton*)but
{
    if ([but.dicInfo[@"name"] isEqualToString:@"在线问诊"]) {
        
        ShowConsultViewController *show = [[ShowConsultViewController alloc] init];
        FriendModel *friendMo = [[FriendModel alloc] init];
        friendMo.accountId = self.m_dicInfo[@"accountId"];
        friendMo.userPhoto = self.m_dicInfo[@"userPhoto"];
        friendMo.nickName = self.m_dicInfo[@"nickName"];
        friendMo.isPay = YES;
        show.friendModel = friendMo;
        [((CommonViewController*)(self.m_superClass)).navigationController pushViewController:show animated:YES];
    }
    else {
        [self isPhone];
    }
}

- (void)isPhone
{
    UIActionSheet* sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:self.m_dicInfo[@"telephone"]
                            otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}
//
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.m_dicInfo[@"telephone"]]]];
    }
}

#pragma mark - 网络回调

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSLog(@"%@",dic);
    
    
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
//        isFree 0、没使用过免费或使用过免费没过期  1、使用过免费
//        isUseFree 0、没用过免费 1、使用过免费
//        isOverdue; //是否过期 0 过期 1 没过期
        NSMutableDictionary *body = [dic objectForKey:@"body"];
        if ([loader.username isEqualToString:URL_medicalIndex_new]) {
            
            if (self.m_dicInfo[@"needBuy"]) {
                
                BOOL lastIsoverdue = [self.m_dicInfo[@"needBuy"] boolValue];
                self.m_dicInfo = body;
                if (lastIsoverdue == [self.m_dicInfo[@"needBuy"] boolValue]) {
                    return;
                }
                
                m_scrollView = nil;
                m_webView = nil;
            }
            else {
                self.m_dicInfo = body;
            }
            
            if (![self.m_dicInfo[@"needBuy"] boolValue]) { //是否需要购买 0、去购买 1、去咨询
                
                [self createView:body];
            }
            else {
                [self createGoumai:body];
            }
            
        }
        else if ([loader.username isEqualToString:URL_buy]) {
            
            ShowConsultViewController *show = [[ShowConsultViewController alloc] init];
            FriendModel *friendMo = [[FriendModel alloc] init];
            friendMo.accountId = body[@"accountId"];
            friendMo.userPhoto = body[@"userPhoto"];
            friendMo.nickName = body[@"nickName"];
            friendMo.isPay = YES;
            [self.m_dicInfo setObject:friendMo.accountId forKey:@"accountId"];
            [self.m_dicInfo setObject:friendMo.userPhoto forKey:@"userPhoto"];
            [self.m_dicInfo setObject:friendMo.nickName forKey:@"nickName"];
            [self.m_dicInfo setObject:[NSNumber numberWithInt:1] forKey:@"isUseFree"];
            show.friendModel = friendMo;
            [((CommonViewController*)(self.m_superClass)).navigationController pushViewController:show animated:YES];
        }
    }
    else {
        [Common TipDialog:[head objectForKey:@"msg"]];
        if ([loader.username isEqualToString:URL_getDoctorList]){
            
        }
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
}
#pragma end

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
