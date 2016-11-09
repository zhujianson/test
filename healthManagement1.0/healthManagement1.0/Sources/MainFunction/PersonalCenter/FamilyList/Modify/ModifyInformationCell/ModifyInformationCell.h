//
//  ModifyInformationCell.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/6/15.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifyInfoBlock)(NSDictionary *dic);

@interface ModifyInformationCell : UITableViewCell<UITextFieldDelegate>
{
    ModifyInfoBlock m_block;
}

- (void)setInfoWithDic:(NSDictionary*)dic object:(id)object isHide:(BOOL)isShow headerImage:(UIImage*)h_image;
@property (nonatomic,retain) UIImageView * headerImage;;
- (void)setHeaderImageView:(UIImage*)image;
- (void)setP_block:(ModifyInfoBlock)P_block;
- (void)setResignFirstResponder;
- (void)setbecomeFirstResponder;
@end
