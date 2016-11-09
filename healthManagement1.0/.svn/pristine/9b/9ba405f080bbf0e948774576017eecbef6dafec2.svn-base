//
//  LookingDoctorCell.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LookingDoctorBlock)(NSString *text);

@interface LookingDoctorCell : UITableViewCell
{
    LookingDoctorBlock m_block;
}
@property (nonatomic, assign) UIImageView *m_headerView;

- (void)setData:(NSMutableDictionary*)dic;
- (void)setPickerImage:(UIImage*)image;


- (void)setLookingDoctorBlock:(LookingDoctorBlock)look;
@end
