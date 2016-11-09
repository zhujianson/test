//
//  RedPacketBaseCell.h
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"

static const CGFloat kRedPacketLeftMargin = 15.f;//左边空白
static const CGFloat kRedPacketTopMargin = 15.f;//上部空白
static const CGFloat kRedPacketImageToLabelSpace = 15.f;//图片和lable距离

static const CGFloat kRedPacketCellH = 85.f;//高度

@interface RedPacketBaseCell : UITableViewCell

@property (nonatomic,retain) UIImageView *redPaketImageView;//红包
@property (nonatomic,retain) UILabel *moneyCountLabel;//数量
@property (nonatomic,retain) UILabel *moneyUseDescriptionLabel;//使用门槛
@property (nonatomic,retain) UILabel *redPaketNameLabel;//名字
@property (nonatomic,retain) UILabel *redPaketCategoryLabel;//使用类别
@property (nonatomic,retain) UILabel *redPaketExpireLabel;//过期
@property (nonatomic,retain) NSDictionary *m_dictInfo;

- (void)setUpRedPaketImageViewPicetureWithCanUse:(BOOL)canUse;

- (void)setUpDict:(NSDictionary *)dict withModelType:(RedPacketUseType) m_redPacketUseType;

@end
