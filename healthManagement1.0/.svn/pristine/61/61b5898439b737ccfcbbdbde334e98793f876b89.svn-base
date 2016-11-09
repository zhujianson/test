//
//  MedicalHistoryTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-10-13.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MedicalCellDelegate <NSObject>

- (void)butEventName:(NSMutableDictionary*)dic;
- (void)butEventTime:(NSMutableDictionary*)dic;

@end

@interface MedicalHistoryTableViewCell : UITableViewCell
{
    UILabel *m_MedicalName;
    UILabel *m_MedicalTime;
    
    UIButton *butN;
    UIButton *butT;
    
    
}

@property (nonatomic, assign) id<MedicalCellDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *m_dicInfo;

@property (nonatomic, assign) BOOL isEdit;

- (void)setButEvent;

@end
