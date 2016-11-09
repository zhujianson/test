//
//  SelectionListView.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectionListViewBlock)(NSArray *arr);

@interface SelectionListView : UIView<UITableViewDataSource,UITableViewDelegate>

-(void)setSelectionListViewBlock:(SelectionListViewBlock)arr;

- (id)initWithdData:(NSArray*)dataArr andTitle:(NSString *)title andWithSelectArray:(NSArray *)selectArray;

@end
