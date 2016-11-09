//
//  SelFamilyView.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-9-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selFamilyViewBlock)(NSArray *dataArray);

@protocol selFamilyViewDelegate <NSObject>

- (void)butEventShowFamily:(NSMutableDictionary*)dic;
- (void)showSelFamily:(NSMutableDictionary*)dic;

@end

@interface SelFamilyView : UIView
{
    float m_picHeight;
    int selIndex;
    
    NSString *m_selFamilyId;
}

//@property (nonatomic, assign)
@property (nonatomic, assign) id<selFamilyViewDelegate> delegate;
@property (nonatomic,assign) int selIndex;
@property (nonatomic,assign) BOOL noAddingBtn;//没有add按钮

- (void)setSelFamilyId:(NSString*)string;

- (id)initWithFrame:(CGRect)frame PicHeight:(float)height;

- (NSMutableDictionary*)getFamilySel;

- (void)reloadView;

-(void)setSelFamilyViewBlock:(selFamilyViewBlock)_handler andHidenLine:(BOOL)hiden;

- (void)setButEnabled;

@end
