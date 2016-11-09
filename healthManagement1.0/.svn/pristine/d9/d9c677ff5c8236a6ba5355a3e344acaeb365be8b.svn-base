//
//  FoodIntroduceViewController.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

typedef void (^IntroduceBlock)(NSDictionary*);

@interface FoodIntroduceViewController : CommonViewController
{
    NSMutableDictionary *m_dic;
    
    UIScrollView *m_scrollView;
    
    MBProgressHUD *m_progress_;
}

@property (nonatomic, assign) NSDictionary *m_dicInfo;
@property (nonatomic, assign) IntroduceBlock introBlock;

@end
