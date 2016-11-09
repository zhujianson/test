//
//  ChangesReginViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-10-11.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"

typedef void (^ChangesReginBlock)(NSDictionary *dic);
@interface ChangesReginViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    ChangesReginBlock block;
}
@property (nonatomic,retain) NSDictionary * textDic;
- (void)setChangesReginBlock:(ChangesReginBlock)back;
@end
