//
//  MyMessageViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-18.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"

@interface MyMessageViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>

///  计算高度
///
///  @param dataDict        原始数据
///  @param keyConentString 关键字
///  @param width           宽度
///
///  @return 计算高度
-(float)getContentHeightWithDict:(NSMutableDictionary *)dataDict withKeyConentString:(NSString *)conentString withContentWidth:(float)width;

@end
