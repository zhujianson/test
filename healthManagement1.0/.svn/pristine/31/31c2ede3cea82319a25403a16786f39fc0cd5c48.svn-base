//
//  FamilyInfoView.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-7-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum butType {
	EDIT = 0,
	QUSHI = 1,
	DEL = 2,
    ADD
} butType;

@class FamilyInfoView;
@protocol FamilyinfoViewDelegate <NSObject>

- (void)pusNewView:(butType)type Dic:(NSMutableDictionary*)dic;

@end

@interface FamilyInfoView : UICollectionViewCell
{
    UIButton *m_butPhoto;
    UILabel *m_labName;
	UILabel *m_labNick;
	UILabel *m_labDevie;
    UILabel *m_labSex;
    UILabel *m_labDate;
    UILabel *m_labHeight;
    UILabel *m_labWidth;
    UILabel *m_labWork;
    UILabel *m_labLishiBing;
    UILabel *m_labFamilyBing;
    UILabel *m_labdevice;

    UIView *m_butAdd;
//    NSDictionary *m_dicKeyValue;
}
@property (nonatomic, assign) NSMutableDictionary *m_infoDic;
@property (nonatomic, assign) id<FamilyinfoViewDelegate>myDelegate;

@end
