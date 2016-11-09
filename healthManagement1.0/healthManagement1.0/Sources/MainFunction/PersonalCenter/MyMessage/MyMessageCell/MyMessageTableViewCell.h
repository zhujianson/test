//
//  MyMessageTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-18.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface MyMessageTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView * m_headerView;

- (void)setMessageData:(NSDictionary*)dic;

- (void)hiddenRedImage;

//行高
+ (float)getCellHeightWithDict:(NSMutableDictionary *)dict withHandler:(id)handler;

@end
