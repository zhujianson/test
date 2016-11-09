//
//  SettingViewController.h
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-3-17.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface SettingViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *m_tableView;
    
    NSArray *m_array;
    
    UIImage *m_userPhone;
        
    NSString *m_itunceversion;
    BOOL m_isNew;
}

@end
