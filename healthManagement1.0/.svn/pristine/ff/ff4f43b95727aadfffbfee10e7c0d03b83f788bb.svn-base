//
//  HealthAlertListTableViewController.h
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HealthAlertTableViewDelegate <NSObject>

- (void)showView:(NSDictionary*)dic Type:(id)type;

@end

@interface HealthAlertListTableViewController : UITableViewController
{
    BOOL _loadingMore;// 加载状态
    int m_nowPage;//当前页
    
    id m_PlanViewCon;
    
    NSMutableArray *m_array;
}

@property (nonatomic, assign) id<HealthAlertTableViewDelegate> myDelegate;

@property (nonatomic, retain) NSString *m_url;

@property(nonatomic) BOOL moreAlertGet;

//- (void)startClock:(NSDictionary *)clock;
//
//- (void)postLocalNotification:(NSDictionary *)clockDictionary;
//
//-(void)startClockZeroMorning;//计步器的定时清除

@end
