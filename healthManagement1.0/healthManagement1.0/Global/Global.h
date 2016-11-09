//
//  Header.h
//  cyclistsShare
//
//  Created by hong on 13-6-6.
//  Copyright (c) 2013年 hong. All rights reserved.
//

#ifndef cyclistsShare_Header_h
#define cyclistsShare_Header_h

#import <sqlite3.h>
#import "UIView+category.h"
#import "UserInfoModel.h"
#import "AdviserInfoModel.h"
#import "SetInfoModel.h"
#import "UIView+convenience.h"

//手机尺寸
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight ([UIScreen mainScreen].bounds.size.height-64)

//版本号对外2.1.6
#define BundleVersion					[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//对内6
#define CFBundleVersion					[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//根据弧度求角度
#define DEGREES_TO_RADIANS(d)			(d * M_PI / 180.f)

//每页多小条
#define g_everyPageNum					20

#define netNotTishi(title)				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"\
														message:title\
														delegate:nil\
														cancelButtonTitle:@"确定"\
														otherButtonTitles:nil];\
										[alert show];\
										[alert release];
//cell的高度
#define G_TableViewCellRowHeight		60

//允许输入字符
#define kAlphaNum						@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*_.-=+~\\/"
#define kAlphaNum2						@"0123456789."

#define ONLYALPHANUM                    @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#define ONLYANUM                        @"0123456789"
#define SPECIALMARK                     @"!@#$%^&*_.-=+~\\/／：；¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+"

#if DEBUG
#define NSLog(s,...) NSLog(@"%s LINE:%d < %@ >",__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
//#define NSLog(...) {}
#define NSLog(s,...) NSLog(@"%s LINE:%d < %@ >",__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#endif

#define ENABLE_APP_DEBUG YES //开启后打开debug模式

#define USEING_NETWORK YES

#define DEVICE_TOKEN @"devicetoken"
#define SAVED_TIME @"savedtime"

//#define kDeviceWidth (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? [[UIScreen mainScreen] bounds].size.width : 1024)

#define SCREEN_HEIGHT (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? ([[UIScreen mainScreen] bounds].size.height - 20) : 748)

#define APP_DELEGATE [[UIApplication sharedApplication] keyWindow]

#define APP_DELEGATE2 ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define DOC_PATH ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define BUNDLE_IDENTIFIER [[NSBundle mainBundle] bundleIdentifier]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//友盟appkey
#define UMENG_APPKEY @"561f06c5e0f55aedc2006cc6"

//#define DB_PATH [DOCUMENT_DIRECTORY_PATH stringByAppendingPathComponent:@"JiuHaoDatabase.db"]
#define DB_PATH [[NSBundle mainBundle] pathForResource:@"kangxun" ofType:@"db"]

#define SCREEN_SHOT_IMG_PATH [DOCUMENT_DIRECTORY_PATH stringByAppendingPathComponent:@"screenshot.img"]

#define IS_4_INCH_SCREEN  (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)

#define IS_Small_INCH_SCREEN  (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)

#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

#define BUNDLE_FILE_PATH(filename) [[NSBundle mainBundle] pathForAuxiliaryExecutable:filename]

#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]

#define NAV_BAR_HEIGHT 45

#define NUMBERS @"0123456789\n"

#define kKey @"china-bj-jiuhao@"

//大号字体
#define M_FRONT_SEVENTEEN 17
#define M_FRONT_TWELEVE 12
#define M_FRONT_FOURTEEN 14
#define M_FRONT_THREETEEN 13
#define M_FRONT_FIFTEEN 15
#define M_FRONT_SIXTEEN 16
#define M_FRONT_NINTEEN 19
#define M_FRONT_EIGHTEEN 18
#define M_FRONT_TWENTY 20
#define M_FRONT_THIRTY 30

#define cellWeightFixation 2
//左边留空
#define LEFTWEIGHT 28

#define JSONFILENAME @"json.txt"
#define NAMEARRAY @"nameArray"
#define REPEARTTEXT @"99999" //永不
//删除按钮

#define HUBPREGRESSTITLE @"加载中..."
#define kDeleteButtonWidth  80
#define kDeleteButtonHeight  44

#define ANSWERBACKBACKCOLOR @"f4f4f4"
//yangshuo


#define VERSION_INFO 0

#define VERSION_LIN_COLOR_SHEN @"cccccc"
#define VERSION_LIN_COLOR_QIAN @"e5e5e5"
#define VERSION_BACKGROUD_COLOR @"f4f4f4"
#define Color_fafafa @"fafafa"
#define VERSION_BACKGROUD_COLOR2 @"f2f2f2"
//#define VERSION_TEXT_COLOR @"ff5232"//@"1cc0c1"
#define VERSION_TEXT_COLOR @"00c6ff"//@"1cc0c1"

#define The_ThemeColor @"42dc83"//主题颜色

#define COLOR_Red @"#ff5232"

#define LINE_COLOR @"ebebeb"//分割线颜色
#define COLOR_333333 @"#333333"
#define COLOR_666666 @"#666666"
#define COLOR_999999 @"#999999"

#define COLOR_FF5351 @"00c6ff"
#define VERSION_ERROR_TEXT_COLOR @"1e1e1e"
#define VERSION_TYPE_NAME @"太平吉象"
#define VERSION_TYPE_NAME2 @"康迅360"
#define VERSION_APPID @"868032868"
#define VERSION_CELL_BACKGROUD @"ffffff"
#define COLOR_BlUE @"479aff"

#define M_FONT_TYPE @"HelveticaNeue-Bold"
//#endifdia

#define VERSION_CHANNEL_ID @"11110005"
#define VERSION_CHANNEL_KEY @"77d71cc62b86c11193856f66048e8dfe"

//图片压缩比例
#define Define_picScale 0.7

//本地图片路径
#define g_picPath @"image"

//1  康迅360    2  极速版   3  健康小屋
#define CLIENT_TYPE     3

#pragma end

typedef enum {
	statusbarWindowlabTitle = 8204,
	tableHeaderButSortByTag = 700,
	tableHeaderButTypeTag,
	tableHeaderButSearchTag,
	Advertising	= 300,
	PageViewTag = 1200,
	shareButTag = 1300,
	tableFooterViewActivityTag = 2900,
	tableFooterViewLabTag,
	CommodityBigPicUIViewTag = 2990,
	UserVC_LabNameTag = 3100,
	UserVC_LabIntegralTag,
	UserVC_ButLoginTag,
	ImagePickerImageViewTag = 3200,
	SubmitUsedViewCIPCarmerScrollTag = 3300,
	ImagePreviewViewCScrollTag = 3400,
	SubmitUsedViewCIPCCancel = 3500,
	SubmitUsedViewCIPCPaishe,
	SubmitUsedViewCIPCOK,
} globalTag;

NSMutableDictionary *g_winDic;

UserInfoModel *g_nowUserInfo;
AdviserInfoModel *g_adviserInfo;
SetInfoModel *g_setInfo;

NSMutableArray *g_familyList;


//数据库对象
sqlite3* g_database_;

float g_tabbarHeight;

//
NSLock *g_iconArrayLock;
NSLock *g_iconDownDelegateLock;

NSLock *g_submitData;

long g_lastLcationTime;

NSMutableDictionary *g_imageArrayDic;

UIWindow *g_statusbarWindow;

//监测的数据传递
NSMutableDictionary *m_MornitDict;
NSMutableDictionary *sendDict;
NSString *m_selectedDateString;

NSString *g_url;

long g_longTime;

typedef enum
{
    LoginPlatformSina = 1, 
    LoginPlatformQQ = 2,
}LoginPlatform;


typedef enum
{
    DiarySuger= 1,
    DiaryBlood = 2,
    DiaryWight = 3,
    DiaryFood = 4,
    DiaryMood = 5,
    DiaryReport = 3,
}diaryRecord;


typedef enum {
	NetWorkType_None = 0,
	NetWorkType_WIFI,
	NetWorkType_2G,
	NetWorkType_3G,
} NetWorkType;

#define kTodayWidget_ONE  @"BoolSugarVC"
#define kTodayWidget_TWO  @"StepHomeViewController"
#define kTodayWidget_THREE  @"ToolsViewController"
#define kTodayWidget_FOUR  @"FriendListViewController"
#define WS(weakSelf)  __block __typeof(self)weakSelf = self;
#define WSS(weakSelf)  __weak __typeof(self)weakSelf = self;

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//block 声明
#ifdef NS_BLOCKS_AVAILABLE
typedef void (^KXBasicBlock)(id content);
#endif
#define kRelativity6DeviceWidth ([UIScreen mainScreen].bounds.size.width/375.0)

#endif

