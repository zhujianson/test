//
//  ListCellTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListCellDelegate <NSObject>

- (void)butShowEvent:(NSDictionary*)dic;
- (void)butAddEvent:(NSDictionary*)dic;

@end

@interface ListCellTableViewCell : UITableViewCell
{
    UIButton *m_butShwo;
    UIButton *m_butAdd;
    UILabel *m_labTitle;
    UILabel *m_labCon;
    
    UIImageView *m_imageIsOK;
}

@property (nonatomic, assign) id<ListCellDelegate> delegate;
@property (nonatomic, assign) NSDictionary *m_dicInfo;

@end
