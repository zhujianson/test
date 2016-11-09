//
//  AccountCell.h
//  jiuhaohealth4.1
//
//  Created by xjs on 15/9/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ModifyInfoBlock)(NSDictionary *dic);

@interface AccountCell : UITableViewCell<UITextFieldDelegate>
{
    ModifyInfoBlock m_block;
}

- (void)setInfoWithDic:(NSString*)titleT object:(id)object;
@property (nonatomic,retain) UIImageView * headerImage;;
- (void)setHeaderImageView:(UIImage*)image;
- (void)setP_block:(ModifyInfoBlock)P_block;
- (void)setResignFirstResponder;
- (void)setbecomeFirstResponder;
@end
