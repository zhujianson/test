//
//  CustomDiseaseViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-22.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"
#import "InputDueDatePicker.h"

@protocol CustomDelegate <NSObject>

- (void)transmissionCustomData:(NSString*)arr;


@end

@interface CustomDiseaseViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) id<CustomDelegate>myDelegate;
@property (nonatomic,assign) int type;

@end
