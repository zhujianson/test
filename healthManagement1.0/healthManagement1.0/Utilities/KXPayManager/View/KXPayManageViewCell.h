//
//  KXPayManageViewCell.h
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kImagePath = @"kImagePath";
static NSString *const kImageTitle = @"kImageTitle";
static NSString *const kPayType = @"kPayType";

static float kKXPayManageViewCellH = 50.0;

@interface KXPayManageViewCell : UITableViewCell

@property (nonatomic,retain) NSDictionary *m_dict;

@end
