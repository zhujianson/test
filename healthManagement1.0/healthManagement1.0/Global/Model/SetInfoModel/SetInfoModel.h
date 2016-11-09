//
//  SetInfoModel.h
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetInfoModel : NSObject

@property (nonatomic, retain) NSString *additionrecordtime;  //healthcheckAdditionRecord:检测类的  ;   healthrecordAdditionRecord:确认类
@property (nonatomic, retain) NSString *attentionusermaxnum;
@property (nonatomic, retain) NSString *doctorhandlemessagetimelimit;
@property (nonatomic, retain) NSString *doctorreplynumnonpaymentuser;
@property (nonatomic, retain) NSString *doctorreplynumpayinguser;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *ispromptcountdown;
@property (nonatomic, retain) NSString *maxasknumnonpaymentusereveryday;
@property (nonatomic, retain) NSString *maxasknumpayingusereveryday;
@property (nonatomic, retain) NSString *maxfamilynumnonpaymentuser;
@property (nonatomic, retain) NSString *maxfamilynumpayinguser;
@property (nonatomic, retain) NSString *maxnumplannonpaymentuser;
@property (nonatomic, retain) NSString *maxnumplanpayinguser;
@property (nonatomic, retain) NSString *maxnumsendmessagenonpaymentusereveryask;
@property (nonatomic, retain) NSString *maxnumsendmessagepayingusereveryask;
@property (nonatomic, retain) NSString *mergeorsplit;
@property (nonatomic, retain) NSString *planexecuteremind;
@property (nonatomic, retain) NSString *pushknowledgetime;
@property (nonatomic, retain) NSString *reportCreateCycle;
//  评估报告周期
@property (nonatomic, retain) NSString *dangerReportCycle;

- (id)initWithDic:(NSDictionary*)dic;

@end
