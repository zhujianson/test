//
//  RadarDoctorCell.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXTextView.h"

typedef void(^RadarDoctorBlock)(NSString *text);
@interface RadarDoctorCell : UITableViewCell<UITextViewDelegate,UITextFieldDelegate>
{
    RadarDoctorBlock m_radar;
}
@property (nonatomic, retain) UITextField * m_textView;
@property (nonatomic, assign) UIImageView *m_headerView;

- (void)setUserData:(NSMutableDictionary*)dic;//糖友

- (void)setPickerImage:(UIImage*)image;

- (void)setRadarDoctorBlock:(RadarDoctorBlock)look;

- (void)resign;
@end
