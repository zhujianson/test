//
//  CommonViewController.h
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-1.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController <UIGestureRecognizerDelegate>
{
    //@protected
    //    float autoSize;
    //    float autoV;
    //    float height;
    //    float width;
    //    float statusBarHeight;
    
    BOOL m_loadingMore;
    BOOL m_isClose;
    int m_nowPage;//当前页
    BOOL hasMoreFlag;
    MBProgressHUD *m_show_progress;
    LoadingAnimation * loadView;
    BOOL m_isInNav;
}

@property (nonatomic,assign) BOOL  noBackBtn;
@property (nonatomic,assign) BOOL  showingFlag;
@property (nonatomic,assign) id    m_superClass;
@property (nonatomic,assign) float autoSize;
@property (nonatomic,assign) float autoV;
@property (nonatomic,assign) float height;
@property (nonatomic,assign) float width;
@property (nonatomic,assign) float statusBarHeight;//ios7以上，布局从statusbar的位置开始
@property (nonatomic, assign) int m_nowPage;
@property (nonatomic, assign) int m_isHideNavBar;
//@property (nonatomic, assign) BOOL m_isHideNavBar;
@property (nonatomic, retain) NSMutableDictionary *m_superDic;

@property (nonatomic, assign) int log_pageID;

@property (nonatomic, assign) NSString *log_pageIDs;

@property (nonatomic, copy) NSString *customTitle;

@property (nonatomic,retain) NSString *shareTitle;//分享的title
@property (nonatomic,retain) NSString *shareContentString;//分享的内容
@property (nonatomic,retain) id shareImage;//分享的图片
@property (nonatomic,retain) NSString *shareURL;//分享的URL
@property (nonatomic,assign) BOOL shareCustomItem;//分享的自定义图标

@property (nonatomic,assign) BOOL m_isPopAndPushing;//pop/push进行

- (void)removeAllSubClassFromNetDic;

- (void)hiddenNavigationBarLine;

- (void)showLoadingActiview;
- (void)stopLoadingActiView;
- (void)showNavigationBarLine;

- (void)sendStatisticsLog;
/**
 *  分享功能
 */
- (void)goToShare;

/**
 *  获得分享的链接
 *
 *  @param type post--话题 news--新闻  theme--主题
 *  @param idString 对应的id号
 *
 *  @return  url ok
 */
- (NSString *)getShareURLType:(NSString *)type andId:(NSString *)idString;

@end
