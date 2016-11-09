//
//  ShowSelectBaseView.h
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/23.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KXSelectBaseViewBlock)(id selecteContent);

@interface ShowSelectBaseView : UIView

@property (nonatomic,strong) NSMutableArray *m_dataArray;
@property (nonatomic,copy) NSString *m_titleString;
@property (nonatomic,assign)float m_cellHight;

-(id)initWithKXPayManageViewBlock:(KXSelectBaseViewBlock)block;

-(void)setUpCustomData;

-(void)show;

-(void)updateFrame;

+(void)showShowSelectViewWithBlock:(KXSelectBaseViewBlock )block;

@end
