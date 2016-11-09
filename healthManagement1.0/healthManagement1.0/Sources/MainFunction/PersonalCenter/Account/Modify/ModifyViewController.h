//
//  ModifyViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-4.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"
#import "InputDueDatePicker.h"

typedef void(^ModifyRemarksBlock)(NSString * remarks);

@interface ModifyViewController : CommonViewController
@property (nonatomic, retain) NSMutableDictionary *m_infoDic;
@property (nonatomic, copy) NSString *m_strUrl;
//@property (nonatomic, retain) NSMutableDictionary *m_Dic;
@property (nonatomic) BOOL m_isAdd;
@property (nonatomic) BOOL m_isModify;
@property (nonatomic) BOOL m_isFriend;//是朋友yes

@property (nonatomic, copy) ModifyRemarksBlock remarkBlock;

- (void)setModifyRemarksBlock:(ModifyRemarksBlock)block;

//@property (nonatomic,copy) NSString * titleStr;
@end
