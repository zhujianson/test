//
//  MedicalHistoryViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"
#import "InputDueDatePicker.h"
#import "CustomDiseaseViewController.h"

@interface MedicalHistoryViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomDelegate>
{
    NSMutableArray * dataArray;
    
    UITableView*myTable;
    
    NSMutableArray * diseaseNameArr;
    
    NSDictionary *m_dicKeyValue;
    
    NSMutableDictionary *m_selDic;
    
//    NSIndexPath *m_nowSelIndex;
}
@property (nonatomic, assign) NSMutableDictionary *m_infoDic;
@property (nonatomic, assign) NSString *m_strUrl;
@property (nonatomic, retain) NSMutableDictionary *m_Dic;
@property (nonatomic) BOOL m_isAdd;

@end
