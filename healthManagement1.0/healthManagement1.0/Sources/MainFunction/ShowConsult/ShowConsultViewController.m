 //
//  ShowConsultViewController.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "ShowConsultViewController.h"
#import "Common.h"
#import "CommonHttpRequest.h"
#import "ChatTableViewCell.h"
#import "DBOperate.h"
#import "AppDelegate.h"
#import "ImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GetToken.h"
#import "ASIFormDataRequest.h"
#import "DocDetailViewController.h"
#import "ModifyViewController.h"
#import "ZBMessageManagerFaceView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "KXVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "XHAudioPlayerHelper.h"
#import "MsgDBOperate.h"
#import "AccountInformationViewController.h"
#import "DoctorViewController.h"
#import "PanViewRoom.h"
#import "WebViewController.h"

#define kDefaultToolbarHeight 50
#define kXTouchToRecord         @"按住 说话"
#define kXTouchToFinish         @"松开 结束"

@interface ShowConsultViewController () <chatTableCellDelegate, ZBMessageManagerFaceViewDelegate, MLEmojiLabelDelegate, XHAudioPlayerHelperDelegate, TapCallBackProtocol>
{
    CGRect originInputToolbarFrame;
    CGRect originMTableViewFrame;
    BOOL m_isGetDataForServer;
    NSTimer *m_timer;
    
    //
    UIButton *m_butRecord;
    
    UIButton *m_right;
    
    ZBMessageManagerFaceView *m_emgView;
    
    MLEmojiLabel *m_emojiLabel;
    NSRegularExpression *m_customEmojiRegularExpression;
    
    NSString *m_pathSuffix;
    
    PanViewRoom *m_flowManager;
}
@property (nonatomic, assign) KXVoiceRecordHUD *voiceRecordHUD;
@property (nonatomic, assign) XHVoiceRecordHelper *voiceRecordHelper;
@property (nonatomic, retain) NSString *m_inputText;
@end

@implementation ShowConsultViewController
//@synthesize ConsultInfo;
@synthesize delegate;
//@synthesize m_dicInfo;
@synthesize msgViewBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_chatArray = [[NSMutableArray alloc] init];
        self.log_pageID = 37;

    }
    return self;
}

- (void)butEventdf
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"forSelf"];
//    BOOL forSelf = [[dic valueForKey:@"forSelf"] boolValue];
    [self butEventShowConsult:dic];
}

- (void)refreshChatMsg
{
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    [dicc setObject:self.friendModel.accountId forKey:@"friendId"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:refreshChatMessage values:dicc requestKey:refreshChatMessage delegate:self controller:self actiViewFlag:0 title:nil];
    
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    ASIFormDataRequest *asi = [array objectAtIndex:array.count-1];
    NSLog(@"%@", asi);
    asi.winCloseIsNoCancle = YES;
}

- (BOOL)closeNowView
{
    int index = 0;
    for (id item in m_chatArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            if ([[item objectForKey:@"isSendOK"] intValue] == 1) {
                [self updateMsgState:index isSendOK:@"0" Time:0];
            }
        }
        index++;
    }
    
    if (m_chatArray.count) {
        NSDictionary *dicc = [m_chatArray objectAtIndex:m_chatArray.count-1];
        self.friendModel.chatContent = dicc[@"content"];
        self.friendModel.chatContentType = [dicc[@"contentType"] intValue];
        self.friendModel.chatTime = (long)([dicc[@"createTime"] longLongValue]/1000);
    }
    else {
        self.friendModel.chatTime = [CommonDate getLongTime];
    }
    
    NSMutableDictionary *dic = nil;
    NSString *caogao = inputToolbar.textView.text;
    if (caogao.length) {
        self.friendModel.chatContent = caogao;
        self.friendModel.chatContentType = 50;
        dic = [NSMutableDictionary dictionaryWithDictionary:@{[NSString stringWithFormat:@"%@", self.friendModel.accountId]:caogao}];
    }
    
    [self writeCaogao:dic];
    
//    [[MsgDBOperate shareInstance] updateDirft:m_dicInfo];
    
    m_isClose = YES;
    
    [self refreshChatMsg];
    
    [super closeNowView];
    
    UIViewController *listVC = nil;
    for (listVC in self.navigationController.viewControllers) {
        if ([listVC isKindOfClass:[DoctorViewController class]]) {
            [self.navigationController popToViewController:listVC animated:YES];
            return NO;
        }
    }
    
    return YES;
}

- (void)writeCaogao:(NSDictionary*)dic
{
    NSString *path = [Common datePath];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist", g_nowUserInfo.userid, @"caogao"]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist) {
        //不存在创建
        if (dic) {
            //            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            BOOL ok = [dic writeToFile:filePath atomically:YES];
            NSLog(@"-----ok:%d",ok);
        }
    }
    else {
        NSMutableDictionary *dicc = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if (dic) {
            
            for (NSString *key in [dic allKeys]) {
                [dicc setObject:dic[key] forKey:key];
            }
        }
        else {
            [dicc removeObjectForKey:[NSString stringWithFormat:@"%@", self.friendModel.accountId]];
        }
        
        [dicc writeToFile:filePath atomically:YES];
    }
}

- (void)dealloc
{
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    self.voiceRecordHUD = nil;
    self.voiceRecordHelper = nil;
    
    if (m_timer) {
        [m_timer invalidate];
        m_timer = nil;
    }
    self.FoodImageDic = nil;
    
//    [m_dicInfo release];
    
    [m_consultInfo release];
    
    [m_chatArray release];
    m_chatArray = nil;
    
    [inputToolbar release];
    inputToolbar = nil;
    
    [m_tableView release];
    m_tableView = nil;
    
    [super dealloc];
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)setFriendModel:(FriendModel *)friendModel
{
    _friendModel = [friendModel retain];
    
    g_nowUserInfo.doctorMsgCount = MAX(g_nowUserInfo.doctorMsgCount - self.friendModel.unReadCount, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_nowPage = 0;
	m_lastTime = 0;
    m_isadd = NO;
    
    if (!self.friendModel.isPay) {
        m_right = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_right setBackgroundImage:[UIImage imageNamed:@"common.bundle/scoreMall/navigationbar_icon_explain_normal.png"] forState:UIControlStateNormal];
        m_right.frame = CGRectMake(0, 7, 32, 32);
        m_right.layer.cornerRadius = 16.0f;
        m_right.clipsToBounds = YES;
        [m_right addTarget:self action:@selector(butEventdf) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:m_right];
        self.navigationItem.rightBarButtonItem = rightBar;
        [rightBar release];
    }

    m_pathSuffix = @"?imageView2/1/w/80/h/80";
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kDefaultToolbarHeight)];
    originMTableViewFrame = m_tableView.frame;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.separatorColor = [UIColor clearColor];
    m_tableView.backgroundColor = [UIColor whiteColor];
    m_tableView.dataSource = self;
    m_tableView.delegate = self;
    UIView *header = [Common createTableFooter];
    CGRect rect = header.frame;
    rect.size.height = 40;
    header.frame = rect;
    m_tableView.tableHeaderView = header;
    [self.view addSubview:m_tableView];
    
    //输入框
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kDefaultToolbarHeight, kDeviceWidth, kDefaultToolbarHeight)];
    originInputToolbarFrame = inputToolbar.frame;//获得原始frame
    inputToolbar.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
    inputToolbar.mydelegate = self;
    UIView *inputView = [self createInputView];
    inputToolbar.m_inputView = inputView;
    inputToolbar.textView = (UIExpandingTextView*)[inputView viewWithTag:9080];
    [inputView release];
    [self.view addSubview:inputToolbar];
    
    if (self.friendModel.chatContentType == 50) {
        self.m_inputText = self.friendModel.chatContent;
        inputToolbar.textView.text = self.m_inputText;
//        [inputToolbar.textView.internalTextView becomeFirstResponder];
    }
    
//    [self selLeaveMsg];
    [NSThread detachNewThreadSelector:@selector(selLeaveMsg) toTarget:self withObject:nil];
    
    
//    m_flowManager = [[PanViewRoom alloc] initWithTargetView:self.view];
//    m_flowManager.delegate = self;
}


//点击回调
- (void)tapPanView
{
    WebViewController *web = [[WebViewController alloc] init];
    web.m_url = @"";
    [self.navigationController pushViewController:web animated:YES];
    [web release];
}


//录音按钮
- (UIButton*)createSpeakBut:(UIView*)bView
{
    UIButton *but = [[UIButton alloc] init];
    but.layer.borderColor = bView.layer.borderColor;
    but.layer.cornerRadius = bView.layer.cornerRadius;
    but.layer.borderWidth = bView.layer.borderWidth;
    UIImage *NormalImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"f5f5f5"]];
    [but setBackgroundImage:NormalImage forState:UIControlStateNormal];
    UIImage *HighlightedImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"dcdcdc"]];
    [but setBackgroundImage:HighlightedImage forState:UIControlStateHighlighted];
    [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [but setTitle:kXTouchToRecord forState:UIControlStateNormal];
    [but setTitle:kXTouchToFinish forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [but addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [but addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [but addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [but addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
    
    return but;
}

//创建tabbar
- (UIView*)createInputView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDefaultToolbarHeight)];
    
    UIButton *butAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    butAudio.tag = 9070;
    butAudio.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    butAudio.buttonDefultString = @"音频";
    butAudio.frame = CGRectMake(8, (view.height-31)/2.f, 31, 31);
    UIImage *image = [UIImage imageNamed:@"common.bundle/msg/luyin_btn_nor.png"];
    [butAudio setImage:image forState:UIControlStateNormal];
    [butAudio addTarget:self action:@selector(butEventBA:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butAudio];
    
    UIButton *butPic = [UIButton buttonWithType:UIButtonTypeCustom];
    butPic.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    butPic.frame = CGRectMake(kDeviceWidth - 8 - 31, (view.height-31)/2.f, 31, 31);
    image = [UIImage imageNamed:@"common.bundle/msg/camera_btn_nor.png"];
    [butPic setImage:image forState:UIControlStateNormal];
    [butPic addTarget:self action:@selector(inputButtonPressedPic) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butPic];
    
    UIButton *butEmg = [UIButton buttonWithType:UIButtonTypeCustom];
    butEmg.tag = 9090;
    butEmg.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    butEmg.buttonDefultString = @"表情";
    butEmg.frame = CGRectMake(butPic.left - 8 -32, (view.height-32)/2.f, 32, 32);
    image = [UIImage imageNamed:@"common.bundle/msg/inputFace.png"];
    [butEmg setImage:image forState:UIControlStateNormal];
    [butEmg addTarget:self action:@selector(butEventEmg:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butEmg];
    
    UIExpandingTextView *textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(butAudio.right + 8, 8, butPic.left -butAudio.right -2*8, kDefaultToolbarHeight-16)];
    textView.tag = 9080;
    textView.internalTextViewOffSet = 20;
    textView.placeholder = NSLocalizedString(@"请输入咨询内容",nil);
    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastMsg_%@", g_nowUserInfo.userid]];
    textView.text = text;
    [textView setReturnKeyType:UIReturnKeySend];//设为发送
    [view addSubview:textView];
    
    CGRect rect = [textView.textViewBackgroundImage convertRect:textView.textViewBackgroundImage.bounds toView:view];
    m_butRecord = [self createSpeakBut:textView.textViewBackgroundImage];
    m_butRecord.frame = rect;
    m_butRecord.hidden = YES;
    [view addSubview:m_butRecord];
    
    [view bringSubviewToFront:butEmg];
    return view;
}

//
- (void)setTabRecordIsShow:(BOOL)isShow
{
    UIButton *butEmg = (UIButton*)[inputToolbar.m_inputView viewWithTag:9090];
    if (isShow) {//录音按钮隐藏 输入框显示
        self.m_inputText = inputToolbar.textView.text;
        inputToolbar.textView.text = nil;
//        if (inputToolbar.textView.internalTextView.isFocused) {
            [inputToolbar.textView.internalTextView resignFirstResponder];
//        }
//        else {
//        }
    }
    else {
        if (self.m_inputText.length) {
            [inputToolbar.textView.internalTextView becomeFirstResponder];
        }
        inputToolbar.textView.text = self.m_inputText;
        self.m_inputText = nil;
    }
    
    butEmg.hidden = isShow;
    inputToolbar.textView.hidden = isShow;
    m_butRecord.hidden = !isShow;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *title = @"在线问诊";
    if (!self.friendModel.isPay) {
        title = self.friendModel.nickName;
    }
    
    self.title = title;
    
//    [CommonImage setPicImageQiniu:[m_dicInfo objectForKey:@"imgUrl"] View:m_right Type:0 Delegate:nil];
    if (m_right) {
        [CommonImage setImageFromServer:self.friendModel.userPhoto View:m_right Type:0];
    }
    
    [[XHAudioPlayerHelper shareInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

//添加默认消息
- (NSMutableDictionary*)createDefindView
{
    NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObject:@"尊敬的会员，您好！康迅360医师专家团队竭诚为您提供快捷的咨询服务！任何与血糖相关问题，我们都会给您最满意的答案！请您提问" forKey:@"content"];
    [msgDic setObject:@"0" forKey:@"forSelf"];
    [msgDic setObject:@"0" forKey:@"contentType"];
    [msgDic setObject:g_nowUserInfo.userid forKey:@"userId"];
    NSString *strDate = [NSString stringWithFormat:@"%lld", [CommonDate getLonglongTime]];
    [msgDic setObject:strDate forKey:@"createTime"];
    [msgDic setObject:@"1" forKey:@"isInsertDB"];
    
    return msgDic;
}

//- (void)addShanshiku
//{
//    //膳食库
//    if (_FoodImageDic) {
//        NSString *title = _FoodImageDic[@"text"];
//        if (title) {
//            [self inputButtonPressed:title isLishi:YES];
//        }
//        NSArray *assets = _FoodImageDic[@"image"];
//        if (assets) {
//            [self senPickerImgeGroupAsstes:assets isLishi:YES];
//        }
//    }
//}

//加载中
- (void)createHeader
{
    UIView *view = [Common createTableFooter];
    m_tableView.tableHeaderView = view;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    return YES;
}

- (void)selLeaveMsg
{
    m_loadingMore = YES;
    
    NSMutableArray *array = [[DBOperate shareInstance] getChatRecordData:m_nowPage withFriendId:self.friendModel.accountId];
    
    m_nowPage += array.count;
    
    __block long long longtime = 0;
    
    NSMutableArray *chatArray = [NSMutableArray array];
    for (int i = (int)array.count-1; i >= 0; i--) {
        NSMutableDictionary *dic = [array objectAtIndex:i];
        
        longtime = [[dic objectForKey:@"createTime"] longLongValue];

        if (longtime - m_lastTime > 5*60*1000) {
            [chatArray addObject:[NSString stringWithFormat:@"%@", [CommonDate getServerTime:longtime type:9]]];
        }
        m_lastTime = longtime;
        
        switch ([[dic objectForKey:@"contentType"] intValue]) {
            case 0://文字
            {
                CGSize size;
                NSString *content = [dic objectForKey:@"content"];
                if ([self panduanEmg:content]) {
                    MLEmojiLabel *emg = [self setEmgText:content];
                    size = emg.frame.size;
                    [dic setObject:@1 forKey:@"isEmo"];
                }
                else {
                    size = [Common heightForString:content Width:cellMsgWidth Font:[UIFont systemFontOfSize:16]];
                    size.height = MAX(size.height+2, 20);
                }
                [dic setObject:[NSNumber numberWithFloat:size.height] forKey:@"height"];
                [dic setObject:[NSNumber numberWithFloat:size.width] forKey:@"width"];
                
//                float height = MAX([Common heightForString:[dic objectForKey:@"content"] Width:cellMsgWidth Font:[UIFont systemFontOfSize:16]].height+2, 20);
//                [dic setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
            }
                break;
            case 1://图片
            {
                [dic setObject:@80 forKey:@"height"];
                //缩略图
                NSString *strTest = [[dic objectForKey:@"content"] stringByAppendingString:m_pathSuffix];
//                strTest = [strTest stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                strTest = [SDImageCache cachedFileNameForKey:strTest];
                UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strTest]];
                CGSize scaleSize = [self getImageSize:image];
                [dic setObject:[NSNumber numberWithFloat:scaleSize.height] forKey:@"height"];
                [dic setObject:[NSNumber numberWithFloat:scaleSize.width] forKey:@"width"];
            }
                break;
            case 2://音频
            {
                [dic setObject:[NSNumber numberWithFloat:20] forKey:@"height"];
                int yongshi = [[dic objectForKey:@"audioTime"] intValue];
                float width = yongshi*((cellMsgWidth - 50)/60) + 50;
                [dic setObject:[NSNumber numberWithInt:width] forKey:@"width"];
            }
                break;
            case 3:
            {
                [dic setObject:[NSNumber numberWithFloat:60] forKey:@"height"];
            }
                break;
        }
        
        [chatArray addObject:dic];
    }
    if (chatArray) {
        NSRange range = NSMakeRange(0, [chatArray count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [m_chatArray insertObjects:chatArray atIndexes:indexSet];
    }
    
    dispatch_async( dispatch_get_main_queue(), ^(void){
    
        if ([array count] < 15) {
            if (m_tableView.tableHeaderView) {
                [m_tableView.tableHeaderView removeFromSuperview];
                m_tableView.tableHeaderView = nil;
            }
        }
        else {
            m_loadingMore = NO;
        }
        
        if (!m_isGetDataForServer) {
//            long long time = 0;
//            if (m_chatArray.count) {
//                time = [[[m_chatArray objectAtIndex:m_chatArray.count-1] objectForKey:@"createTime"] longLongValue];
//            }
            [self loadHrstoryMsg:longtime];
            m_isGetDataForServer = YES;
            
//            [self addShanshiku];
        }
    
        [m_tableView reloadData];
        [self yidongdaodixia:chatArray];
    });
}

- (void)loadHrstoryMsg:(long long)time
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.friendModel.accountId forKey:@"friendId"];
    
    NSString *time2 = [NSString stringWithFormat:@"%lld", time];

    if (!time) {
        time2 = @"0";
    }
    else if (time2.length<13) {
        for (int i = 0; i < 13-time2.length; i++) {
            time2 = [time2 stringByAppendingString:@"9"];
        }
    }
    [dic setObject:time2 forKey:@"createTime"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:getChatMsgList values:dic requestKey:getChatMsgList delegate:self controller:self actiViewFlag:1 title:0];
}

//点击表情
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    if (dele) {
        inputToolbar.textView.text = [MLEmojiLabel deleteWithOriginalString:inputToolbar.textView.text];
    }
    else {
        inputToolbar.textView.text = [inputToolbar.textView.text stringByAppendingString:faceStr];
    }
}

- (void)SendBig:(NSString *)big
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"0" forKey:@"isInsertDB"];//
    [dic setObject:@"0" forKey:@"forSelf"];//自己发的
    [dic setObject:@"1" forKey:@"isSendOK"];//发送状态
    [dic setObject:big forKey:@"content"];//发送内容 必填
    [dic setObject:@3 forKey:@"contentType"];//内容类型 必填
    [dic setObject:self.friendModel.accountId forKey:@"friendId"];// 好友的userId
    [dic setObject:@0 forKey:@"audioTime"];//当内容类型为2 也就是音频时，需传
    
    [self addMessage:dic isLishi:NO];
    
    [self sendMsgToServer:dic];
}

- (void)sendMsgChar
{
    BOOL is = [self inputButtonPressed:inputToolbar.textView.text isLishi:NO];
    if (is) {
        [inputToolbar.textView clearText];
    }
}

//发送文字消息
- (BOOL)inputButtonPressed:(NSString *)inputText isLishi:(BOOL)islishi
{
    inputText = [inputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(inputText.length == 0){
        return YES;
    }
    else if (inputText.length > 200) {
        [Common TipDialog:NSLocalizedString(@"一次最多只能输入200个字符",nil)];
        return NO;
    }
    
    BOOL is = [Common stringContainsEmoji:inputText];
    if (is) {
        [Common TipDialog:NSLocalizedString(@"暂不支持表情信息",nil)];
        return NO;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"0" forKey:@"isInsertDB"];//
    [dic setObject:@"0" forKey:@"forSelf"];//自己发的
    [dic setObject:@"1" forKey:@"isSendOK"];//发送状态
    [dic setObject:inputText forKey:@"content"];//发送内容 必填
    [dic setObject:@0 forKey:@"contentType"];//内容类型 必填
    [dic setObject:self.friendModel.accountId forKey:@"friendId"];// 好友的userId
    [dic setObject:@0 forKey:@"audioTime"];//当内容类型为2 也就是音频时，需传
    
    [self addMessage:dic isLishi:islishi];
    
    [self sendMsgToServer:dic];
    
    return YES;
}

- (void)inputTextBegin
{
    UIButton *but = (UIButton*)[inputToolbar.m_inputView viewWithTag:9070];
    but.buttonDefultString = @"文字";
    [self butEventBA:but];
}

- (void)butEventBA:(UIButton*)but
{
    UIImage *image;
    if ([but.buttonDefultString isEqualToString:@"音频"]) {
        but.buttonDefultString = @"文字";
        image = [UIImage imageNamed:@"common.bundle/msg/jianpan.png"];
        [self setTabRecordIsShow:YES];
        
        if (m_emgView) {
            
            UIButton *butEmg = (UIButton*)[inputToolbar.m_inputView viewWithTag:9090];
            butEmg.buttonDefultString = @"表情";
            [self hideInputDate];
            [self hideEmoView];
        }
    }
    else {
        but.buttonDefultString = @"音频";
        image = [UIImage imageNamed:@"common.bundle/msg/luyin_btn_nor.png"];
        [self setTabRecordIsShow:NO];
    }
    [but setImage:image forState:UIControlStateNormal];
}

- (void)butEventEmg:(UIButton*)but
{
    UIImage *image;
    if ([but.buttonDefultString isEqualToString:@"表情"]) {
        but.buttonDefultString = @"文字";
        image = [UIImage imageNamed:@"common.bundle/msg/inputText.png"];
        [but setImage:image forState:UIControlStateNormal];
        [self inputButtonEmg:YES];
    }
    else {
//        but.buttonDefultString = @"表情";
//        image = [UIImage imageNamed:@"common.bundle/msg/inputFace.png"];
        [self inputButtonEmg:NO];
    }
}

//发送图片消息
- (void)inputButtonPressedPic
{
    [self.view endEditing:YES];
    ImagePicker *picker = [[ImagePicker alloc] initWithId:self];
    picker.selectHeadPhoto = NO;
    [picker setPickerViewBlock:^(id content) {
    
        if ([content isKindOfClass:[NSArray class]])
        {
            [self senPickerImgeGroupAsstes:content isLishi:NO];
        }
        else {
            
            [self sendPic:(UIImage*)content isLishi:NO];
        }
        [picker release];
    }];
}

#pragma mark - 语音
- (void)inputButtonEmg:(BOOL)isShow
{
    float y;
    if (isShow) {
        if (!m_emgView) {
            emoStruct *emo = [[emoStruct alloc] init];
            emo.m_bigEmo = YES;
            emo.m_smallEmo = YES;
            m_emgView = [[ZBMessageManagerFaceView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 203+45) withDic:emo];//216-->196
            m_emgView.delegate = self;
            [self.view addSubview:m_emgView];
        }
        
        [inputToolbar.textView.internalTextView resignFirstResponder];
        
        [self showInputDataView:m_emgView.height];
        y = m_emgView.height;
        
        [UIView animateWithDuration:0.3 animations:^ {
            CGRect frame = m_emgView.frame;
            frame.origin.y -= m_emgView.height;
            m_emgView.frame = frame;
        }];
    }
    else {
        [inputToolbar.textView.internalTextView becomeFirstResponder];
        
//        [self hideEmoView];
    }
    
    [self.view bringSubviewToFront:inputToolbar];
}

- (void)hideEmoView
{
    UIButton *but = (UIButton*)[inputToolbar.m_inputView viewWithTag:9090];
    but.buttonDefultString = @"表情";
    UIImage *image = [UIImage imageNamed:@"common.bundle/msg/inputFace.png"];
    [but setImage:image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^ {
        CGRect frame = m_emgView.frame;
        frame.origin.y = kDeviceHeight;
        m_emgView.frame = frame;
    }];
}

- (void)setAudioChange:(double)value
{
    [self.voiceRecordHUD setPeakPower:value];
}

#pragma mark -- 音频
- (KXVoiceRecordHUD *)voiceRecordHUD
{
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[KXVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

- (XHVoiceRecordHelper *)voiceRecordHelper
{
    if (!_voiceRecordHelper) {
        WS(weakSelf);
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxRecordTime = 60;
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            [weakSelf finishRecorded];
//            _voiceRecordHelper.isSend = YES;
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel, NSTimeInterval currentTimeInterval) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
            int time = weakSelf.voiceRecordHelper.maxRecordTime - currentTimeInterval;
            if (time <= 10) {
                [weakSelf.voiceRecordHUD showCountdown:time];
            }
        };
    }
    return _voiceRecordHelper;
}

- (void)holdDownButtonTouchDown
{
    NSLog(@"111111111111111");
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.voiceRecordHelper startRecorderCompletion:^{
            [weakSelf.voiceRecordHUD startRecord];
        }];
    });
}

- (void)holdDownButtonTouchUpOutside
{
    [self cancelRecord];
}

- (void)holdDownButtonTouchUpInside
{
    if (_voiceRecordHelper.maxRecordTime > _voiceRecordHelper.currentTimeInterval) {
        
        [self finishRecorded];
    }
}

- (void)holdDownDragOutside
{
    [self resumeRecord];
}

- (void)holdDownDragInside
{
    [self pauseRecord];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord
{
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecorderCompletion:^{
        
    }];
}

- (void)pauseRecord
{
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord
{
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord
{
    WS(weakSelf);
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

- (void)finishRecorded
{
    WS(weakSelf);
    if (self.voiceRecordHelper.currentTimeInterval < 1) {
        [self.voiceRecordHUD showShort:^(BOOL fnished) {
            weakSelf.voiceRecordHUD = nil;
        }];
        
        [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
            
        }];
        return;
    }
    
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        
        NSString *audioName = weakSelf.voiceRecordHelper.m_audioName;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"0" forKey:@"isInsertDB"];
        [dic setObject:@"0" forKey:@"forSelf"];//自己发的
        [dic setObject:@"1" forKey:@"isSendOK"];//发送状态
        [dic setObject:audioName forKey:@"content"];//发送内容 必填
        [dic setObject:@2 forKey:@"contentType"];//内容类型 必填
        [dic setObject:[NSNumber numberWithInt:weakSelf.voiceRecordHelper.currentTimeInterval] forKey:@"audioTime"];//当内容类型为2 也就是音频时，需传
        [dic setObject:self.friendModel.accountId forKey:@"friendId"];//接收者id，必填
        
        [self addMessage:dic isLishi:NO];
        
        NSData *data = [NSData dataWithContentsOfFile:weakSelf.voiceRecordHelper.recordPath];
        [self sendPicAudioQiniu:data withDic:dic withName:audioName];
    }];
}

#pragma mark - 语音

//停止播放
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer
{
    XHAudioPlayerHelper *audioPlay = [XHAudioPlayerHelper shareInstance];
    NSMutableDictionary *dic = audioPlay.dicInfo;
    if (dic) {
        [dic setObject:[NSNumber numberWithBool:0] forKey:@"isPlay"];
        int index = (int)[m_chatArray indexOfObject:dic];
        ChatTableViewCell *cell = (ChatTableViewCell*)[m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (cell) {
            [cell.m_bubblePlay stopAnimating];
        }
    }
}

#pragma end 语音

- (void)senPickerImgeGroupAsstes:(NSArray *)assets isLishi:(BOOL)is
{
    for (ALAsset *asset in assets)
    {
        if ([asset isKindOfClass:[ALAsset class]]) {
            CGImageRef ref = [[asset defaultRepresentation] fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:ref];
            
            if (image) {
                [self sendPic:image isLishi:is];
            }
        }
        else if ([asset isKindOfClass:[UIImage class]]) {
            
            [self sendPic:(UIImage*)asset isLishi:is];
        }
    }
}

#pragma mark - 图片
- (void)sendPic:(UIImage*)image isLishi:(BOOL)is
{
    __block NSString *strName = [[NSString stringWithFormat:@"%@_%ld_%d", g_nowUserInfo.userid, [CommonDate getLongTime], arc4random()%1000] retain];
    
    NSString *strPath = [QINIUURL stringByAppendingString:strName];
    
    __block NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"0" forKey:@"isInsertDB"];
    [dic setObject:@"0" forKey:@"forSelf"];//自己发的
    [dic setObject:@"1" forKey:@"isSendOK"];//发送状态
    [dic setObject:strPath forKey:@"content"];//发送内容 必填
    [dic setObject:@1 forKey:@"contentType"];//内容类型 必填
    [dic setObject:self.friendModel.accountId forKey:@"friendId"];//接收者id，必填
    //缩略图
    CGSize scaleSize = [self getImageSize:image];
    [dic setObject:[NSNumber numberWithFloat:scaleSize.height] forKey:@"height"];
    [dic setObject:[NSNumber numberWithFloat:scaleSize.width] forKey:@"width"];
    
    NSString *strSmail = [SDImageCache cachedFileNameForKey:[strPath stringByAppendingString:m_pathSuffix]];
    NSString *strBig = [SDImageCache cachedFileNameForKey:strPath];
    
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        UIImage *imageIcon = [CommonImage zoomImage:image toScale:scaleSize];
        NSData *data = UIImagePNGRepresentation(imageIcon);
        NSString *strCon1 = [[Common getImagePath] stringByAppendingFormat:@"/%@", strSmail];
        [data writeToFile:strCon1 atomically:YES];
        
        //全图
        data = UIImageJPEGRepresentation(image, Define_picScale);
        strCon1 = [[Common getImagePath] stringByAppendingFormat:@"/%@", strBig];
        [data writeToFile:strCon1 atomically:YES];
        
        dispatch_async( dispatch_get_main_queue(), ^(void){
            
            [weakSelf addMessage:dic isLishi:is];
            [weakSelf sendPicAudioQiniu:data withDic:dic withName:strName];
            [strName release];
//            NSLog(@"//缩略图//缩略图//缩略图//缩略图//缩略图//缩略图//缩略图缩略图%d", [data length]);
        });
    });
}

- (CGSize)getImageSize:(UIImage*)image
{
    //缩略图
    CGSize size = image.size;
    CGSize scaleSize = size;
    if (!image) {
        scaleSize = CGSizeMake(80, 80);
    }
    
    float zoom;
    if (size.height > size.width && size.height > 150) {
        zoom = size.height/150.f;
        scaleSize.height = 150;
        scaleSize.width = size.width/zoom;
    }
    else if (size.width > 100) {
        zoom = size.width/100.f;
        scaleSize.height = size.height/zoom;
        scaleSize.width = 100;
    }
    
    return scaleSize;
}

- (void)setImageHeight:(UIImage*)image withDic:(NSMutableDictionary*)dic
{
    if ([dic objectForKey:@"width"]) {
        return;
    }
    
    CGSize size = image.size;
    
    if (size.width > size.height) {
        float x = size.width / 100.f;
        float height = size.height / x;
        [dic setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
        [dic setObject:[NSNumber numberWithFloat:100] forKey:@"width"];
    }
    else {
        float x = size.height / 100.f;
        float height = size.width / x;
        [dic setObject:[NSNumber numberWithFloat:height] forKey:@"width"];
        [dic setObject:[NSNumber numberWithFloat:100] forKey:@"height"];
    }
    
//    [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath inde]] withRowAnimation:<#(UITableViewRowAnimation)#>]
}
#pragma end - 图片

#pragma make - 发送消息
- (void)sendMsg:(NSMutableDictionary *)dic
{
    int type = [[dic objectForKey:@"contentType"] intValue];
    switch (type) {
        case 0://文字
        {
            [self sendMsgToServer:dic];
        }
            break;
        default:
        {
            NSString *strCon;
            switch ([[dic objectForKey:@"isSendOK"] intValue]) {
                case 2:
                    [self sendMsgToServer:dic];
                    break;
                    
                case 3:
                    if (type == 1) {
                        strCon = [[Common getImagePath] stringByAppendingFormat:@"/%@", [dic objectForKey:@"content"]];
                    }
                    else if (type == 2) {
                        strCon = [[Common getAudioPath] stringByAppendingFormat:@"/%@", [dic objectForKey:@"content"]];
                    }
                    NSData *data = [NSData dataWithContentsOfFile:strCon];
                    [self sendPicAudioQiniu:data withDic:dic withName:[dic objectForKey:@"content"]];
                    break;
                    
                default:
                    break;
            }
        }
            break;
    }
    [dic setObject:@"1" forKey:@"isSendOK"];
//    [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[m_chatArray indexOfObject:dic] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [m_tableView reloadData];
}

//
- (void)sendPicAudioQiniu:(NSData*)data withDic:(NSMutableDictionary*)dic withName:(NSString*)name
{
    WS(weakSelf);
    [GetToken submitData:data withBlock:^(BOOL isOK, NSString *path) {
        if (isOK) {
            [dic setObject:name forKey:@"imageName"];
            [weakSelf sendMsgToServer:dic];
        }
        else {
            int index = (int)[m_chatArray indexOfObject:dic];
            [weakSelf updateMsgState:index isSendOK:@"3" Time:0];
        }
    } withName:name];
}

- (void)sendMsgToServer:(NSMutableDictionary *)dic
{
    NSMutableDictionary *dicc = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicc removeObjectForKey:@"height"];
    [dicc removeObjectForKey:@"width"];
    [dicc removeObjectForKey:@"createTime"];
    [dicc removeObjectForKey:@"forSelf"];
    [dicc removeObjectForKey:@"isInsertDB"];
    [dicc removeObjectForKey:@"isSendOK"];
    [dicc removeObjectForKey:@"egmView"];
    [dicc removeObjectForKey:@"isEmo"];
    [dicc removeObjectForKey:@"fromId"];
    [dicc removeObjectForKey:@"isreply"];
    
    NSString *imageName = [dic objectForKey:@"imageName"];
    if (imageName) {
        [dicc setObject:imageName forKey:@"content"];
        [dicc removeObjectForKey:@"imageName"];
    }
    
    NSUInteger index = [m_chatArray indexOfObject:dic];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:SEND_FRIEND_MSG values:dicc requestKey:[NSString stringWithFormat:@"%@_%d", SEND_FRIEND_MSG, (int)index] delegate:self controller:self actiViewFlag:0 title:nil];
    
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    ASIFormDataRequest *asi = [array objectAtIndex:array.count-1];
    NSLog(@"%@", asi);
    asi.winCloseIsNoCancle = YES;
}
#pragma end

#pragma make - 添加信息到页面
- (MLEmojiLabel*)setEmgText:(NSString*)text
{
    if (!m_emojiLabel) {
        m_emojiLabel = [[MLEmojiLabel alloc] init];
        m_emojiLabel.numberOfLines = 0;
        m_emojiLabel.font = [UIFont systemFontOfSize:16.0f];
        m_emojiLabel.emojiDelegate = self;
        m_emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        m_emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        m_emojiLabel.customEmojiPlistName = @"expression.plist";
    }
    m_emojiLabel.frame = CGRectMake(0, 0, cellMsgWidth, 30);
    [m_emojiLabel setEmojiText:text];
    [m_emojiLabel sizeToFit];
    
    return m_emojiLabel;
}

- (BOOL)panduanEmg:(NSString*)emojiText
{
    //自定义表情正则
    m_customEmojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *emojis = [m_customEmojiRegularExpression matchesInString:emojiText
                                                        options:NSMatchingWithTransparentBounds
                                                          range:NSMakeRange(0, [emojiText length])];
    
    return emojis.count;
}

//添加数据到界面
- (void)addMessage:(NSMutableDictionary*)msg isLishi:(BOOL)is
{
//    long long longtime;
    long long longtime = [[msg objectForKey:@"createTime"] longLongValue];
    if (!longtime) {
        longtime = [CommonDate getLonglongTime];
        [msg setObject:[NSNumber numberWithLongLong:longtime] forKey:@"createTime"];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    if (longtime - m_lastTime > 5*60*1000) {
        [m_chatArray addObject:[NSString stringWithFormat:@"%@", [CommonDate getServerTime:longtime type:9]]];
        
        int row = (int)[m_chatArray count]-1;
        row = row < 0 ? 0 : row;
        [array addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }
    m_lastTime = longtime;
    
    switch ([[msg objectForKey:@"contentType"] intValue]) {
        case 0://文字
        {
            CGSize size;
            NSString *content = [msg objectForKey:@"content"];
            if ([self panduanEmg:content]) {
                MLEmojiLabel *emg = [self setEmgText:content];
                size = emg.frame.size;
                [msg setObject:@1 forKey:@"isEmo"];
//                [emg release];
            }
            else {
                size = [Common heightForString:[msg objectForKey:@"content"] Width:cellMsgWidth Font:[UIFont systemFontOfSize:16]];
                size.height = MAX(size.height+2, 20);
            }
            [msg setObject:[NSNumber numberWithFloat:size.height] forKey:@"height"];
            [msg setObject:[NSNumber numberWithFloat:size.width] forKey:@"width"];
        }
            break;
        case 1://图片
        {
//            [msg setObject:[NSNumber numberWithFloat:80] forKey:@"height"];
//            [msg setObject:[NSNumber numberWithFloat:80] forKey:@"height"];
        }
            break;
        case 2://音频
        {
            [msg setObject:[NSNumber numberWithFloat:20] forKey:@"height"];
            int yongshi = [[msg objectForKey:@"audioTime"] intValue];
            float width = yongshi*((cellMsgWidth - 50)/60) + 50;
            [msg setObject:[NSNumber numberWithInt:width] forKey:@"width"];
        }
            break;
        case 3:
        {
            [msg setObject:[NSNumber numberWithFloat:60] forKey:@"height"];
        }
            break;
        default:
        {
//            [msg setObject:@"此版本过底,无法查看,请尽快升级查看." forKey:@"msgContent"];
            float height = MAX([Common heightForString:@"此版本过底,无法查看,请尽快升级查看." Width:cellMsgWidth Font:[UIFont systemFontOfSize:16]].height+2, 20);
            [msg setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
        }
            break;
    }
    
    
    if (![[msg objectForKey:@"isInsertDB"] intValue]) {
        [[DBOperate shareInstance] insertChatRecordToDBWithData:msg];
    }
    
	[m_chatArray addObject:msg];
	
    @try {
        if (!is) {
            int row = (int)[m_chatArray count]-1;
            row = row < 0 ? 0 : row;
            [array addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            [m_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
//            [m_tableView reloadData];
            
            [self yidongdaodixia:m_chatArray];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"addMessage-------NSException");
    }
    @finally {
        
    }
    
    m_nowPage++;
}

- (void)yidongdaodixia:(NSArray*)array
{
    if([array count])
    {
        [m_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[array count]-1 inSection:0]
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:NO];
    }
}
#pragma end

#pragma mark - UIScrollView滚动
//UIScrollView滚动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//上拉加载  拖动过程中
	if (scrollView.contentOffset.y < 46) {
        if (!m_loadingMore) {
            [self selLeaveMsg];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
//
//    [self inputButtonLuyin:NO];
}

//- (void)setSellerTableCellImage:(NSDictionary*)canshu
//{
//	UIImage *image = [canshu objectForKey:@"image"];
//	NSIndexPath *indexPath = [canshu objectForKey:@"indexPath"];
//	[canshu release];
//    
//    //缩略图
//    NSMutableDictionary *dic = [m_chatArray objectAtIndex:indexPath.row];
//    CGSize scaleSize = [self getImageSize:image];
//    [dic setObject:[NSNumber numberWithFloat:scaleSize.height] forKey:@"height"];
//    [dic setObject:[NSNumber numberWithFloat:scaleSize.width] forKey:@"width"];
//    
////    NSDictionary *dic = [m_chatArray objectAtIndex:indexPath.row];
////    if ([dic isKindOfClass:[NSDictionary class]]) {
////        int contentType = [[dic objectForKey:@"contentType"] intValue];
////        if (contentType == 1 && contentType == 2) {
////    }
//    
////    NSMutableDictionary *dic = [m_chatArray objectAtIndex:indexPath.row];
////    
////    [self setImageHeight:image withDic:dic];
//    
//	ChatTableViewCell *cell = (ChatTableViewCell*)[m_tableView cellForRowAtIndexPath:indexPath];
//	[cell setImage:image];
//    [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//}
#pragma end

#pragma mark - 显示图片
- (void)showPic:(NSMutableDictionary*)dic withID:(id)vc
{
    switch ([[dic objectForKey:@"contentType"] intValue]) {
        case 0://文字
        {
        }
            break;
        case 1://图片
        {
            ChatTableViewCell *cell;
            int index, row;
            NSString *imgURL;
            // 1.封装图片数据
            NSMutableArray *photos = [NSMutableArray array];
            for (NSDictionary *dicItem in m_chatArray) {
                if ([dicItem isKindOfClass:[NSDictionary class]] && [[dicItem objectForKey:@"contentType"] intValue] == 1) {
                    
                    if ([dic isEqual:dicItem]) {
                        index = (int)photos.count;
                    }
                    
                    imgURL = [dicItem objectForKey:@"content"];
                    row = (int)[m_chatArray indexOfObject:dicItem];
                    cell = (ChatTableViewCell*)[m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.url = [NSURL URLWithString:imgURL]; // 图片路径
                    photo.srcView = cell.m_imageTitle; // 来源于哪个UIImageView
                    [photos addObject:photo];
                    [photo release];
                }
            }
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.delegate = self;
            browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
            [browser release];
        }
            break;
        case 2://音频
        {
            BOOL is = [[dic objectForKey:@"isPlay"] boolValue];
            if (!is) {
                [((ChatTableViewCell*)vc).m_bubblePlay startAnimating];
            } else {
                [((ChatTableViewCell*)vc).m_bubblePlay stopAnimating];
            }
            [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:dic[@"content"] toPlay:!is withDic:dic];
            
            [dic setObject:[NSNumber numberWithBool:!is] forKey:@"isPlay"];
        }
            break;
        case 3:
        {
        }
            break;
    }
}

#pragma end

#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_chatArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id dic = [m_chatArray objectAtIndex:[indexPath row]];
    
    float height;
    
	if ([dic isKindOfClass:[NSString class]]) {
		height = 25;
	}else {
        height = [[dic objectForKey:@"height"] floatValue];
        
        int contentType = [[dic objectForKey:@"contentType"] intValue];
        if (contentType == 1) {
            
            float width = [[dic objectForKey:@"width"] floatValue];
            height = width ? height : 80;
            height += 19;
        }
        else {
            height += 35;
        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id classType = [m_chatArray objectAtIndex:[indexPath row]];
	
    if ([classType isKindOfClass:[NSString class]]) {
        UILabel *labTime1;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDate"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellDate"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            labTime1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
            labTime1.textAlignment = NSTextAlignmentCenter;
            labTime1.backgroundColor = [UIColor clearColor];
            labTime1.textColor = [CommonImage colorWithHexString:@"999999"];
            labTime1.font = [UIFont systemFontOfSize:12];
            labTime1.tag = 1456;
            [cell addSubview:labTime1];
            [labTime1 release];
        }
        labTime1 = (UILabel*)[cell viewWithTag:1456];
        labTime1.text = classType;
        
        return cell;
    }
    else {
        ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellChat"];
        if (!cell) {
            cell = [[[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellChat"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
            [cell setFriendPhoto:self.friendModel.userPhoto];
        }
        [cell setDicInfo:classType ];
        
        int contentType = [[classType objectForKey:@"contentType"] intValue];
        if (contentType == 1) { //图片
            
            NSString *imagePath = [classType[@"content"] stringByAppendingString:m_pathSuffix];
            UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
            [cell.m_imageTitle sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];
        }
        else if (contentType == 2) { //音频
            
        }
        
        return cell;
    }
}
#pragma end

- (void)updateMsgState:(int)index isSendOK:(NSString*)str Time:(long long)time
{
    NSMutableDictionary *dic = [m_chatArray objectAtIndex:index];
    NSString *sql;
    if (time) {
        sql = [NSString stringWithFormat:@"UPDATE chatrecord SET isSendOK = '%@', createTime = '%lld' WHERE createTime = '%@'", str, time, dic[@"createTime"]];
    }
    else {
        sql = [NSString stringWithFormat:@"UPDATE chatrecord SET isSendOK = '%@' WHERE createTime = '%@'", str, dic[@"createTime"]];
    }
    [[DBOperate shareInstance] insertLocalDataForSQL:sql];

    [dic setObject:str forKey:@"isSendOK"];
    if (!m_isClose) {
        [m_tableView reloadData];
    }
}

#pragma mark - 网络回调

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    
    NSDictionary *dictionary = [responseString KXjSONValueObject];
    
    NSDictionary *head = [dictionary objectForKey:@"head"];
    
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dictionary objectForKey:@"body"];
        
        if ([loader.username rangeOfString:SEND_FRIEND_MSG].length > 1)
        {   
            int index = [[loader.username substringFromIndex:SEND_FRIEND_MSG.length+1] intValue];
            
            NSDictionary *message = [body objectForKey:@"message"];
			long long time = [[message objectForKey:@"createTime"] longLongValue];
            [self updateMsgState:index isSendOK:@"0" Time:time];
        }
        else if ([loader.username isEqualToString:getChatMsgList])
        {
            NSLog(@"%@", body);

			NSMutableArray *array = [body objectForKey:@"msgList"];

            NSMutableDictionary *dicc;
//            NSString *fromId;
            for (int i = (int)array.count; i > 0; i--) {
                dicc = [array objectAtIndex:i-1];
                
//                if ([[m_dicInfo objectForKey:@"friendType"] intValue] == 2) {
//
//                    [dicc setObject:g_nowUserInfo.userid forKey:@"fromId"];
//                    [dicc setObject:[m_dicInfo objectForKey:@"friendId"] forKey:@"toId"];
//                    [dicc setObject:[dicc objectForKey:@"senderType"] forKey:@"forSelf"];
//                }
//                else {
//                    
//                    BOOL is = [[dicc objectForKey:@"toId"] isEqualToString:g_nowUserInfo.userid];
//                    [dicc setObject:[NSString stringWithFormat:@"%d", is] forKey:@"forSelf"];
//                    
//                    if (is) {
//                        fromId = [dicc objectForKey:@"fromId"];
//                        [dicc setObject:[dicc objectForKey:@"toId"] forKey:@"fromId"];
//                        [dicc setObject:fromId forKey:@"toId"];
//                    }
//                }
                
                [dicc setObject:@"0" forKey:@"isSendOK"];
				[dicc setObject:@"0" forKey:@"isInsertDB"];
				
                [self addMessage:dicc isLishi:NO];
            }
            
            [m_tableView reloadData];
            [self yidongdaodixia:m_chatArray];
        }
    }
    else {
        if ([loader.username rangeOfString:SEND_FRIEND_MSG].length > 1)
        {
            int index = [[loader.username substringFromIndex:SEND_FRIEND_MSG.length+1] intValue];
            [self updateMsgState:index isSendOK:@"2" Time:0];
        }
        [Common TipDialog:[head objectForKey:@"msg"]];
    }
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    if ([loader.username rangeOfString:SEND_FRIEND_MSG].length > 1)
    {
        int index = [[loader.username substringFromIndex:SEND_FRIEND_MSG.length+1] intValue];
        [self updateMsgState:index isSendOK:@"2" Time:0];
    }
}
#pragma end 网络回调

#pragma mark - 键盘移坐标
//当键盘出现时候上移坐标
- (void	)keyboardWillShow:(NSNotification *)aNotification
{	
	// 获得键盘大小
	NSDictionary *info = [aNotification userInfo];
	NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
    
    [self showInputDataView:keyboardSize.height];
    
	// 将textView滚动到最后
    
    if (m_emgView) {
        [self hideEmoView];
    }
}

- (void)showInputDataView:(float)height
{
    [UIView animateWithDuration:0.3 animations:^{
        // 将toolBar的位置放到键盘上方
        CGRect frame = inputToolbar.frame;
        frame.origin.y = kDeviceHeight- inputToolbar.height - height;
        inputToolbar.frame = frame;
        //调整textView的高度
        frame = m_tableView.frame;
        frame.size.height = inputToolbar.frame.origin.y;
        m_tableView.frame = frame;
        
        [self yidongdaodixia:m_chatArray];
    }];
}

//当键盘消失时候下移坐标
- (void)keyboardWillHide:(NSNotification *)aNotification {
    //    self.view.userInteractionEnabled = NO;
    [self hideInputDate];
}

- (void)hideInputDate
{
    UIButton *but = (UIButton*)[inputToolbar.m_inputView viewWithTag:9090];
    if ([but.buttonDefultString isEqualToString:@"表情"]) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = inputToolbar.frame;
            frame.origin.y = kDeviceHeight- inputToolbar.height;
            inputToolbar.frame = frame;
            frame = m_tableView.frame;
            frame.size.height = inputToolbar.frame.origin.y;
            m_tableView.frame = frame;
            
            [self yidongdaodixia:m_chatArray];
        }];
    }
}
#pragma end

//查看顾问信息
- (void)butEventShowConsult:(NSMutableDictionary *)dic
{
    NSLog(@"--%@",g_nowUserInfo.userid);
    BOOL forSelf = [[dic valueForKey:@"forSelf"] boolValue];
    if (forSelf) {
        if (!self.friendModel.isPay) {
            DocDetailViewController *docVC = [[DocDetailViewController alloc] init];
            docVC.friendModel = self.friendModel;
            [self.navigationController pushViewController:docVC animated:YES];
            [docVC release];
        }
    }
    else {
        AccountInformationViewController * modify = [[AccountInformationViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
        [modify release];
    }
}

#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"didReceiveMemoryWarning");
}

@end