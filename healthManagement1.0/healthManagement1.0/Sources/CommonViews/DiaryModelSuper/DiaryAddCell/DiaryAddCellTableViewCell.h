//
//  DiaryAddCellTableViewCell.h
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryModelView.h"
#import "TimeFrameView.h"

#define kAddRowHieght 65
#define IsAddSection @"IsAddSection" //是头部
#define ExpendsFlag @"expendsFlag" //展开

@interface DiaryAddCellTableViewCell : UITableViewCell
{
    UIImageView *m_addIcon;
}

- (void)openCloseAnimation:(BOOL)isOpen;
@property (nonatomic, assign) NSMutableDictionary *m_infoDic;

@end

typedef enum {
     DiaryEventAdd = 0,
     DiaryEventDelete,
     DiaryEventUpate
} DiaryEventType;

//no 删除 yes 保存
typedef void (^DiaryZhanshiCellBlock)(DiaryEventType diaryEventType,NSDictionary*infoDict);
@interface DiaryZhanshiCell : UITableViewCell
{
    UIView *m_familyView;
}

@property (nonatomic, assign) UIViewController *superVC;

@property (nonatomic,assign)DiraryTimeType m_diraryTimeType;

@property (nonatomic, assign) NSMutableDictionary *m_infoDic;

@property (nonatomic,copy) DiaryZhanshiCellBlock diaryZhanshiCellBlock;

@property(nonatomic,retain) NSMutableArray *m_textViewArray;

- (UIView*)createFamily;
- (UIView*)createTimeView;
- (UIView*)createSaveBut;
- (UITextField*)createTextField:(NSString*)title;
- (UIView *)setUpBackViewWithCount:(int)count;

- (void)savebtn:(UIButton*)btn;

- (void)hiddleKey;

@end