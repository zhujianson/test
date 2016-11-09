//
//  ShowConsultViewController.h
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"
#import "Common.h"
#import "MJPhotoBrowser.h"
#import "FriendModel.h"

@protocol ShowConsultViewDelegate <NSObject>

- (void)moveYiduToWeidu:(NSDictionary*)dic;

@end

typedef void (^MsgViewBlock)(NSDictionary *dataDic);

@interface ShowConsultViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UIInputToolbarDelegate, MJPhotoBrowserDelegate>
{
    UITableView *m_tableView;
    
    NSMutableArray *m_chatArray;
    
//    BOOL _loadingMore;// 加载状态
//    int m_nowPage;//当前页
	
    UIInputToolbar *inputToolbar;
	
	long long m_lastTime;
	
	CGRect m_inputToolbarFrame;
	
	int m_msgPageNum;
    
    NSMutableDictionary *m_newDic;
    
    BOOL m_isadd;
    
    BOOL m_isFrist;

    NSMutableDictionary *m_consultInfo;
    
//    IconOperationQueue *m_OperationQueue;
    
    UIImageView *m_imageKeyView;
    
    float m_startY;
}
@property (nonatomic, assign) id<ShowConsultViewDelegate> delegate;

@property (nonatomic, retain) NSDictionary *FoodImageDic;

//@property (nonatomic, retain) NSMutableDictionary *m_dicInfo;

@property (nonatomic, retain) FriendModel *friendModel;

@property (nonatomic, copy) MsgViewBlock msgViewBlock;

//添加数据到界面
- (void)addMessage:(NSMutableDictionary*)msg isLishi:(BOOL)is;

//- (void)addMessage:(NSMutableDictionary*)msg;
//- (void)setFoodImageDic:(NSDictionary*)foodDic;

//- (void)addPic:(NSArray*)array;

@end
