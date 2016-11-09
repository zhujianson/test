//
//  ChallengeListCell.h
//  jiuhaohealth2.1
//
//  Created by 王敏 on 14-9-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeListCell : UITableViewCell

@property (nonatomic,retain) UIImageView *otherPhotoImageView;//别人头像

- (void)setIconImage:(UIImage*)image;
@property (nonatomic,retain) NSDictionary *dataDic;

@end
