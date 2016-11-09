//
//  AlertTableViewCell.h
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertTableViewCellBlock)(NSMutableDictionary *content);

@interface AlertTableViewCell : UITableViewCell
{
    UILabel *m_labTitle;
    UILabel *m_labCon;
    UILabel *m_labCyclist;
    
    UISwitch *m_switch;
    
    AlertTableViewCellBlock _inBlobk;
}

@property (nonatomic,retain)  NSMutableDictionary *dicInfo;
@property(nonatomic,retain)   UIView *view;
@property(nonatomic,retain)  UILabel *m_labCyclist;
- (void)setAlertTableViewCellBlock:(AlertTableViewCellBlock)_handler;

@end
