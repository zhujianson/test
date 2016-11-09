//
//  NoticeDetailViewController.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-5-10.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

static NSString *const  kWebTitle = @"kWebTitle";
@interface NoticeDetailViewController : WebViewController
@property (nonatomic,retain)NSString *newsId;//新闻id

@property (nonatomic,retain)NSString *titleName;
@property (nonatomic,retain)NSString *subTitle;
@property (nonatomic,retain)NSString *dateString;

@property (nonatomic, retain) NSDictionary *m_dicInfo;

@end
