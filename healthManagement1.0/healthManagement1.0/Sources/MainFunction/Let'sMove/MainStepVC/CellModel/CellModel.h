//
//  CellModel.h
//  jiuhaohealth4.0
//
//  Created by jiuhao-yangshuo on 15-4-22.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TitleType = 0,
    SwipeType
} CellModelType;

@interface CellModel : NSObject

@property(nonatomic,copy) NSString * cellModelTitle;

@property(nonatomic,copy) NSString * cellModelContent;

@property(nonatomic,assign) CellModelType  cellModelType;

@end
