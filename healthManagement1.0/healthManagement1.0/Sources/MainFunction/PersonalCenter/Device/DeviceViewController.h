//
//  DeviceViewController.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-20.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "IconOperationQueue.h"

@interface DeviceViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *m_tableView;
//    IconOperationQueue *m_OperationQueue;

    NSMutableArray *m_array;
}
- (void)beginLoadIng;
@end
