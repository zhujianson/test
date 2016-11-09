//
//  HomeTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MulticolorView.h"
#import "DrawLineView.h"


typedef enum
{
	labTitleTag = 100,
	backgroundViewTag = 2000,
	labTitle,
//	footerViewTag,
//	labFooterDetailTag,
	imagePicTag,
}HomeTVCTag;

typedef enum
{
    xuetangTag,
    xueyaTag,
    tizhongTag
}showVCTag;

typedef enum
{
    xinshouzhinan,
    tangyoubidu,
}homeGuideEnum;


NSString *m_strType;

@protocol HomeTVCDelegate <NSObject>

- (void)betEventTouch:(NSMutableDictionary*)cell;

- (void)shuaxinCell:(NSMutableDictionary*)dic;

- (void)butEventOpen:(showVCTag)type;

- (void)butEventQiandao:(id)type;

- (void)butEventZhitongche:(NSDictionary*)dic;

- (void)butEventHomeGuide:(homeGuideEnum)type;

@end

@interface HomeTableViewCellCom : UITableViewCell <UIScrollViewDelegate>
{
	UILabel *m_labType;
//    UIView *m_headerView;
//    UILabel *m_labTitle;
    UILabel *m_labFooterDetail;
//    UIView *m_footerView;
    UIButton *m_butFooter;
}

@property (nonatomic, assign) NSMutableDictionary* infoDic;
@property (nonatomic, assign) id<HomeTVCDelegate> delegate;

- (void)setInfoDic:(NSMutableDictionary*)dic;

- (void)setIconImage:(NSString *)image Index:(int)i;

@end




//专家话题
@interface HomeTableViewCellTopic : HomeTableViewCellCom
{
//	UIImageView *m_imagePic;
	UILabel *m_labTDetail;
}
//@property (nonatomic, assign) UIImageView *m_imagePic;

@end



//动起来
@interface MoveTableViewCell : UITableViewCell
{
    UILabel *m_labType;
    UILabel *targetLabel;
    UILabel *todayLabel;
    UILabel *completeLabel;

}
@property (nonatomic,retain)MulticolorView *showView;

- (void)setInfoDic:(NSDictionary *)dic;

@end



//公告
@interface NoticeTableViewCell : HomeTableViewCellCom
{
    UIScrollView *m_scrollView;
    UIPageControl *m_pageCon;
}

- (void)setViewNumber:(int)number;

@end




//今日任务
@interface TodayTaskTableViewCell : HomeTableViewCellCom
{
	UILabel *m_labWeiwanChen;
	UIView *m_viewB;
	UIView *m_viewWancheng;
	UILabel *m_labQuanbu;
    
    UIButton *m_butQiandao;
}

//@property (nonatomic, assign) NSMutableDictionary *m_infoDic;

@end




//血糖趋势
@interface bloodGlucoseCell : HomeTableViewCellCom
{
    UIButton *m_butSelType;
    DrawLineView *m_drawLineView;
}

@end




//专家直通车
@interface expertTableViewCell : HomeTableViewCellCom
{
    UIScrollView *m_scrollView;
}

//@property (nonatomic, assign) NSMutableDictionary *m_infoDic;

@end




//新手指南
@interface homeGuideTableViewCell : HomeTableViewCellCom
{
}

//@property (nonatomic, assign) NSMutableDictionary *m_infoDic;

@end


