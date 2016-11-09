//
//  SetInfoModel.m
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "SetInfoModel.h"
#import "Common.h"

@implementation SetInfoModel

- (id)initWithDic:(NSDictionary*)dic
{
    self.additionrecordtime = [Common isNULLString:[dic objectForKey:@"additionrecordtime"]];
//    self.attentionusermaxnum = [Common isNULLString:[dic objectForKey:@"attentionusermaxnum"]];
//    self.doctorhandlemessagetimelimit = [Common isNULLString:[dic objectForKey:@"doctorhandlemessagetimelimit"]];
//    self.doctorreplynumnonpaymentuser = [Common isNULLString:[dic objectForKey:@"doctorreplynumnonpaymentuser"]];
//    self.doctorreplynumpayinguser = [Common isNULLString:[dic objectForKey:@"doctorreplynumpayinguser"]];
//    self.ID = [Common isNULLString:[dic objectForKey:@"id"]];
//    self.ispromptcountdown = [Common isNULLString:[dic objectForKey:@"ispromptcountdown"]];
//    self.maxasknumnonpaymentusereveryday = [Common isNULLString:[dic objectForKey:@"maxasknumnonpaymentusereveryday"]];
//    self.maxasknumpayingusereveryday = [Common isNULLString:[dic objectForKey:@"maxasknumpayingusereveryday"]];
//    self.maxfamilynumnonpaymentuser = [Common isNULLString:[dic objectForKey:@"maxfamilynumnonpaymentuser"]];
//    self.maxfamilynumpayinguser = [Common isNULLString:[dic objectForKey:@"maxfamilynumpayinguser"]];
//    self.maxnumplannonpaymentuser = [Common isNULLString:[dic objectForKey:@"maxnumplannonpaymentuser"]];
//    self.maxnumplanpayinguser = [Common isNULLString:[dic objectForKey:@"maxnumplanpayinguser"]];
//    self.maxnumsendmessagenonpaymentusereveryask = [Common isNULLString:[dic objectForKey:@"maxnumsendmessagenonpaymentusereveryask"]];
//    self.maxnumsendmessagepayingusereveryask = [Common isNULLString:[dic objectForKey:@"maxnumsendmessagepayingusereveryask"]];
//    self.mergeorsplit = [Common isNULLString:[dic objectForKey:@"mergeorsplit"]];
//    self.planexecuteremind = [Common isNULLString:[dic objectForKey:@"planexecuteremind"]];
//    self.pushknowledgetime = [Common isNULLString:[dic objectForKey:@"pushknowledgetime"]];
    self.reportCreateCycle = [Common isNULLString:[dic objectForKey:@"reportcreatecycle"]];
    //    评估报告周期
//    self.dangerReportCycle = [Common isNULLString:[dic objectForKey:@"dangerreportcycle"]];
    
    return self;
}

- (void)dealloc
{
    self.additionrecordtime = nil;  //healthcheckAdditionRecord:检测类的  ;   healthrecordAdditionRecord:确认类
//    self.attentionusermaxnum = nil;
//    self.doctorhandlemessagetimelimit = nil;
//    self.doctorreplynumnonpaymentuser = nil;
//    self.doctorreplynumpayinguser = nil;
//    self.ID = nil;
//    self.ispromptcountdown = nil;
//    self.maxasknumnonpaymentusereveryday = nil;
//    self.maxasknumpayingusereveryday = nil;
//    self.maxfamilynumnonpaymentuser = nil;
//    self.maxfamilynumpayinguser = nil;
//    self.maxnumplannonpaymentuser = nil;
//    self.maxnumplanpayinguser = nil;
//    self.maxnumsendmessagenonpaymentusereveryask = nil;
//    self.maxnumsendmessagepayingusereveryask = nil;
//    self.mergeorsplit = nil;
//    self.planexecuteremind = nil;
//    self.pushknowledgetime = nil;
    self.reportCreateCycle = nil;
    //  评估报告周期
//    self.dangerReportCycle = nil;
    
    [super dealloc];
}

@end
