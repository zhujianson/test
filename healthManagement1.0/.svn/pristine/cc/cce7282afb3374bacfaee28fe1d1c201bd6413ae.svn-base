//
//  HomeTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "CommonUser.h"
#import "PickerView.h"
#import "UIImageView+WebCache.h"


@implementation HomeTableViewCellCom
@synthesize infoDic;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        m_labType = [Common createLabel];
        m_labType.tag = labTitleTag;
        m_labType.frame = CGRectMake(15, 0, kDeviceWidth - 30, 50);
        m_labType.textColor = [CommonImage colorWithHexString:@"333333"];
//        m_labType.font = [UIFont systemFontOfSize:16];
        m_labType.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        [self addSubview:m_labType];
        

//        UILabel *labTitle = [Common createLabel];
//        labTitle.tag = labTitleTag;
//        labTitle.frame = CGRectMake(m_labType.right, 10, view.width-20, 17);
//        labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
//        labTitle.font = [UIFont systemFontOfSize:17];
//        labTitle.numberOfLines = 2;
//        [view addSubview:labTitle];
//        [labTitle release];
	}
	return self;
}

- (void)setIconImage:(NSString *)image Index:(int)i
{
}

- (void)setInfoDic:(NSMutableDictionary*)dic
{
    infoDic = dic;
    
    NSString *subTitle = [Common isNULLString3:[dic objectForKey:@"title"]];
    NSString *title = [NSString stringWithFormat:@"%@   %@", [dic objectForKey:@"typestr"], subTitle];
    if([[dic objectForKey:@"typestr"] isEqualToString:@"血糖趋势"]){
        m_labType.attributedText = [self replaceRedColorWithNSString:title andUseKeyWord:title andWithFontSize:14 TextColor:@"ff5232"];
        
    }else{
        m_labType.attributedText = [self replaceRedColorWithNSString:title andUseKeyWord:subTitle andWithFontSize:14 TextColor:@"999999"];
    }
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

- (void)dealloc
{
	[m_labType release];
	
	[super dealloc];
}

@end





/**
 *  专家话题
 */
@implementation HomeTableViewCellTopic
//@synthesize m_imagePic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, m_labType.bottom, kDeviceWidth, 160)];
        backgroundView.tag = backgroundViewTag;
        backgroundView.clipsToBounds = YES;
        backgroundView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        [self addSubview:backgroundView];
        [backgroundView release];
        
        //图片
        UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, backgroundView.width-30, (160/320.f)*kDeviceWidth)];
		imagePic.tag = imagePicTag;
        imagePic.contentMode = UIViewContentModeScaleAspectFill;
        imagePic.clipsToBounds = YES;
        [backgroundView addSubview:imagePic];
		[imagePic release];
        
        //详情
        m_labTDetail = [Common createLabel];
        m_labTDetail.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labTDetail.font = [UIFont systemFontOfSize:14];
        m_labTDetail.numberOfLines = 2;
        m_labTDetail.frame = CGRectMake(15, imagePic.bottom + 7, imagePic.width, 17);
        [backgroundView addSubview:m_labTDetail];
	}
	return self;
}

- (void)setInfoDic:(NSMutableDictionary*)dic
{
	//设置类型
	[super setInfoDic:dic];

    m_labTDetail.text = [dic objectForKey:@"content"];
    
	float height = [[dic objectForKey:@"contentHeight"] floatValue];
    CGRect rect = m_labTDetail.frame;
    rect.size.height = height;
    m_labTDetail.frame = rect;
    
    UIView *backgroundView = [self viewWithTag:backgroundViewTag];
    rect = backgroundView.frame;
    rect.size.height = m_labTDetail.bottom + 10;
    backgroundView.frame = rect;
}

- (void)setIconImage:(NSString *)image Index:(int)i
{
	UIView *backgroundView = [self viewWithTag:backgroundViewTag];
	UIImageView *imagePic = (UIImageView*)[backgroundView viewWithTag:imagePicTag];
//    [imagePic setImage:image];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
    [imagePic sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:defaul];
}

- (void)dealloc
{
//    [m_imagePic release];
    [m_labTDetail release];
    
//    [m_footerView release];

    [super dealloc];
}

@end




#define StepCounterDataPlist  @"StepCounterData"
@implementation MoveTableViewCell

- (void)dealloc
{
    AppDelegate *myDelegate = [Common getAppDelegate];
    
    [myDelegate.stepCounterObj removeObserver:self
                                   forKeyPath:@"targetStep"];
    [myDelegate.stepCounterObj removeObserver:self
                                   forKeyPath:@"stepCount"];

    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization
        
        [self getStepView];
        
        AppDelegate *myDelegate = [Common getAppDelegate];
        [myDelegate.stepCounterObj addObserver:self forKeyPath:@"targetStep" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [myDelegate.stepCounterObj addObserver:self forKeyPath:@"stepCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return self;
}

- (void)setInfoDic:(NSDictionary *)dic
{
}

/**
 *  观察属性变化
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"---KEYPATH:%@,OBJECT:%@,CHANGE:%@",keyPath,object,change);
    //获得新值

    NSString *newString = [change objectForKey:@"new"];
    
    if([newString isKindOfClass:[NSNull class]]){
        return;
    }
    
    if([keyPath isEqualToString:@"targetStep"]){
        
        targetLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n目标步数",newString] andUseKeyWord:@"目标步数" andWithFontSize:15];
         AppDelegate *myDelegate = [Common getAppDelegate];
        self.showView.percent = (float)[myDelegate.stepCounterObj.stepCount intValue]/newString.intValue;
        
    }else if([keyPath isEqualToString:@"stepCount"]){
        //总步数
        //        speedLabel.text = newString;
        todayLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n今日完成",newString] andUseKeyWord:@"今日完成" andWithFontSize:15];
        AppDelegate *myDelegate = [Common getAppDelegate];
        self.showView.percent = (float)[newString intValue]/myDelegate.stepCounterObj.targetStep;
    }
}

- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

/**
 *  获得本地数据
 *
 *  @return
 */
- (NSMutableDictionary *)getDataPList
{
    
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString * path = [paths  objectAtIndex:0];
//    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,StepCounterDataPlist]];
    
    NSString * path =  [Common datePath];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,StepCounterDataPlist]];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!isExist){
        //不存在创建
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic writeToFile:filePath atomically:YES];
        return dic;
    }
    //存在直接返回
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
    
}

/**
 *  获取当前天的字典
 */
- (NSDictionary *)getCurrentDic
{
    //获取本地本次的数据记录--根据日期获得，如果没有创建临时创建
    //包含为24个时间的点数和，总的卡路里 总的速度 总的步数
    //结构为stepList，
    NSDictionary *allDic = [self getDataPList];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"------%@", date);
    [formatter release];
    NSDictionary *currentDic = allDic[date];
    if(currentDic.allKeys){
        //存在
        return currentDic;
        
    }else{
        //不存在时
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        //目标步数
        NSString *targetNum = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"targetStepNum%@",g_nowUserInfo.userid]];
        if(targetNum.length){
        }else{
            targetNum = @"5000";//设置默认目标步数
        }

        [dictionary setObject:@"0" forKey:@"all_step_count"];//所有的步数
        [dictionary setObject:targetNum forKey:@"targetStepCnt"];
        return dictionary;
    }
}


//计步子页面
- (void)getStepView
{
    NSDictionary *currentDic = [self getCurrentDic];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 105)];
//    backView.layer.cornerRadius = 4;
    backView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN].CGColor;
//    backView.layer.borderWidth = 0.5;
    backView.clipsToBounds = YES;
    backView.backgroundColor = [CommonImage colorWithHexString:VERSION_CELL_BACKGROUD];
    [self addSubview:backView];
	[backView release];
	
	float widht = (backView.width-50)/2;
    float height = (backView.height - 50)/2.0;
	
	//今日
	todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widht, 105)];
	todayLabel.backgroundColor = [UIColor clearColor];
	todayLabel.font = [UIFont boldSystemFontOfSize:25.0f];
	todayLabel.numberOfLines = 2;
	todayLabel.textAlignment = NSTextAlignmentCenter;
	todayLabel.adjustsFontSizeToFitWidth = YES;
	todayLabel.textColor = [CommonImage colorWithHexString:@"ff6e37"];
	todayLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n今日完成",currentDic[@"all_step_count"]] andUseKeyWord:@"今日完成" andWithFontSize:15];
	[backView addSubview:todayLabel];
    [todayLabel release];
    
    //
    UIImageView *imagview = [[UIImageView alloc] initWithFrame:CGRectMake(todayLabel.right, height, 50, 50)];
    imagview.image = [UIImage imageNamed:@"common.bundle/move/move_circle_back_sm.png"];
    [backView addSubview:imagview];
    [imagview release];
    
    self.showView = [[MulticolorView alloc] initWithFrame:CGRectMake(imagview.origin.x, height, 50, 50)];
    _showView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common.bundle/move/move_circle_colour_sm.png"]];
    _showView.lineWidth = 6.f;
    _showView.sec       = 2.f;
    //    _showView.colors    = @[(id)[UIColor greenColor].CGColor,
    //                            (id)[UIColor yellowColor].CGColor,
    //                            (id)[UIColor redColor].CGColor];
    _showView.colors = @[(id)[UIColor clearColor].CGColor];
    
    [backView addSubview:self.showView];
    [self.showView release];
    [self.showView startAnimation];
    _showView.percent = (float)[currentDic[@"all_step_count"] intValue]/[currentDic[@"targetStepCnt"] intValue];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(imagview.origin.x, height, 50, 50)];
    logoView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_nor.png"];
    [backView addSubview:logoView];
    [logoView release];
	
    //目标
    targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(imagview.right, 0, widht, 105)];
    targetLabel.backgroundColor = [UIColor clearColor];
    targetLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    targetLabel.numberOfLines = 2;
    targetLabel.textAlignment = NSTextAlignmentCenter;
    targetLabel.adjustsFontSizeToFitWidth = YES;
    targetLabel.textColor = [CommonImage colorWithHexString:@"ffb700"];
    targetLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n目标步数",currentDic[@"targetStepCnt"]] andUseKeyWord:@"目标步数" andWithFontSize:15];
    [backView addSubview:targetLabel];
    [targetLabel release];
}

@end





@implementation NoticeTableViewCell
{
    BOOL isiPhone6;
}
//@synthesize m_scrollView;
//@synthesize m_pageCon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        isiPhone6 = NO;
        m_pageCon = [[UIPageControl alloc]initWithFrame:CGRectMake(301, 2, 60, 38)];
        NSLog(@"%f",m_pageCon.origin.x);
//        m_pageCon.enabled = NO;
        m_pageCon.hidden = NO;
        m_pageCon.contentMode = UIViewContentModeLeft;
        m_pageCon.userInteractionEnabled = NO;
        m_pageCon.currentPageIndicatorTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
        m_pageCon.pageIndicatorTintColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
        [self addSubview:m_pageCon];
        [m_pageCon release];
        
        float height = (120/320.f)*kDeviceWidth;
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, m_labType.bottom, kDeviceWidth, height + 15)];
        m_scrollView.clipsToBounds = YES;
        m_scrollView.showsHorizontalScrollIndicator = NO;
        m_scrollView.showsVerticalScrollIndicator = NO;
        m_scrollView.pagingEnabled = YES;
        m_scrollView.delegate = self;
        m_scrollView.bounces = NO;
        [self addSubview:m_scrollView];
        [m_scrollView release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:)];
        [m_scrollView addGestureRecognizer:tap];
        [tap release];
        
        //图片
        UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, m_scrollView.width - 30, height)];
		imagePic.tag = backgroundViewTag;
		imagePic.contentMode = UIViewContentModeScaleAspectFill;
		imagePic.image = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
        imagePic.clipsToBounds = YES;
        [m_scrollView addSubview:imagePic];
		[imagePic release];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES; // Recognizers of this class are the first priority
}

- (void)touchesBegan:(UITapGestureRecognizer*)image
{
    [self.delegate betEventTouch:self.infoDic];
    NSLog(@"123123123123123123123123123123123123123123123");
}

- (void)setViewNumber:(int)number
{
    //pageview
    m_pageCon.numberOfPages = number;
    m_pageCon.hidden = YES;
    if (number > 1) {
        m_pageCon.hidden = NO;
    }
    
    int iphone6Bug =(kDeviceWidth>350?(isiPhone6?0:(kDeviceWidth>400?48:28)):0);
    isiPhone6 = YES;
    
    float pageControlWidth = number*15.0f;
    CGRect rect = m_pageCon.frame;
    rect.origin.x = kDeviceWidth - pageControlWidth - 14-iphone6Bug;
    rect.size.width = pageControlWidth;
    m_pageCon.frame = rect;
    //pageview
    rect = m_labType.frame;
    rect.size.width = kDeviceWidth - 30 -m_pageCon.width;
    m_labType.frame = rect;
    
    //隐藏
    for (int i = 0; i < m_scrollView.subviews.count; i++) {
        int tag = backgroundViewTag+i;
        UIView *backView = [m_scrollView viewWithTag:tag];
        if (backView) {
            backView.hidden = YES;
        }
    }
    
    //显示
    NSLog(@"%f",rect.size.width);
    UIView *backgroundView = [m_scrollView viewWithTag:backgroundViewTag];
    backgroundView.hidden = NO;
    for (int i = 1; i < number; i++) {
        int tag = backgroundViewTag+i;
        UIView *backView = [m_scrollView viewWithTag:tag];
        if (!backView) {
            
            NSData *dataV = [NSKeyedArchiver archivedDataWithRootObject:backgroundView];
            backView = [NSKeyedUnarchiver unarchiveObjectWithData:dataV];
            backView.tag = tag;
            CGRect rect = backView.frame;
            rect.origin.x = i*(m_scrollView.width) + 15;
            rect.origin.y = backgroundView.origin.y;
            rect.size.height = backgroundView.height;
            backView.frame = rect;
            [m_scrollView addSubview:backView];
        }
        backView.hidden = NO;
    }
}

- (void)setInfoDic:(NSMutableDictionary*)dic
{
    NSArray *array = [dic objectForKey:@"array"];

    int index = [[dic objectForKey:@"index"] intValue];
    NSMutableDictionary *item = array[index];
    
    [super setInfoDic:dic];
    
//    NSString *subTitle = [Common isNULLString3:[item objectForKey:@"title"]];
//    NSString *title = [NSString stringWithFormat:@"%@   %@", [item objectForKey:@"typestr"], subTitle];
//    
//    m_labType.attributedText = [self replaceRedColorWithNSString:title andUseKeyWord:subTitle andWithFontSize:14 TextColor:@"999999"];
    [self setTitleValue:item];
    
	m_scrollView.contentOffset = CGPointMake(index*(m_scrollView.width), 0);
	m_scrollView.contentSize = CGSizeMake((m_scrollView.width)*array.count, m_scrollView.height);
}

- (void)setIconImage:(NSString *)image Index:(int)i
{
    UIImageView *imagePic = (UIImageView*)[m_scrollView viewWithTag:backgroundViewTag+i];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
    [imagePic sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:defaul];
//    [imagePic setImage:image];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	m_pageCon.currentPage = page;
	
	[self.infoDic setObject:[NSNumber numberWithInt:page] forKey:@"index"];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = [[self.infoDic objectForKey:@"index"] intValue];
    NSArray *array = [self.infoDic objectForKey:@"array"];
    NSMutableDictionary *item = array[index];
    [self setTitleValue:item];
}

- (void)setTitleValue:(NSDictionary*)item
{
    NSString *subTitle = [Common isNULLString3:[item objectForKey:@"title"]];
    NSString *title = [NSString stringWithFormat:@"%@   %@", [item objectForKey:@"typestr"], subTitle];
    
    m_labType.attributedText = [self replaceRedColorWithNSString:title andUseKeyWord:subTitle andWithFontSize:14 TextColor:@"999999"];
}

- (void)dealloc
{
    [super dealloc];
}


@end





//今日任务
@implementation TodayTaskTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
        CGRect rect = m_labType.frame;
        rect.origin.y = 8;
        rect.size.height = 19;
        m_labType.frame = rect;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, m_labType.bottom, kDeviceWidth, 60 - m_labType.bottom)];
//        backgroundView.tag = backgroundViewTag;
        backgroundView.clipsToBounds = YES;
        backgroundView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        [self addSubview:backgroundView];
        [backgroundView release];
        
		m_labWeiwanChen = [Common createLabel];
		m_labWeiwanChen.frame = CGRectMake(15, 7, 80, 16);
		m_labWeiwanChen.textColor = [CommonImage colorWithHexString:@"999999"];
//		m_labWeiwanChen.textAlignment = NSTextAlignmentCenter;
		m_labWeiwanChen.font = [UIFont systemFontOfSize:14];
		[backgroundView addSubview:m_labWeiwanChen];
		
		m_viewB = [[UIView alloc] initWithFrame:CGRectMake(m_labWeiwanChen.right, 13, rect.size.width - m_labWeiwanChen.right - 20 - 65, 5)];
		m_viewB.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
		[backgroundView addSubview:m_viewB];
		
		m_viewWancheng = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
		m_viewWancheng.backgroundColor = [CommonImage colorWithHexString:@"2fcd58"];
		[m_viewB addSubview:m_viewWancheng];
		
		m_labQuanbu = [Common createLabel];
		m_labQuanbu.textAlignment = NSTextAlignmentCenter;
		m_labQuanbu.frame = CGRectMake(m_viewB.right, 7, 50, 16);
		m_labQuanbu.textColor = [CommonImage colorWithHexString:@"999999"];
		m_labQuanbu.font = [UIFont systemFontOfSize:14];
		[backgroundView addSubview:m_labQuanbu];
        
        m_butQiandao = [UIButton buttonWithType:UIButtonTypeCustom];
        m_butQiandao.frame = CGRectMake(kDeviceWidth - 50- 15, (60-25)/2.f, 50, 25);
        m_butQiandao.layer.cornerRadius = 2;
        m_butQiandao.clipsToBounds = YES;
        m_butQiandao.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
        m_butQiandao.layer.borderWidth = 0.5;
        [m_butQiandao setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"cccccc"]] forState:UIControlStateHighlighted];
        m_butQiandao.titleLabel.font = [UIFont systemFontOfSize:13];
        [m_butQiandao setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [m_butQiandao addTarget:self action:@selector(butEventQiandao) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_butQiandao];
	}
	
	return self;
}

- (void)butEventQiandao
{
    [self.infoDic setObject:[NSNumber numberWithBool:YES] forKey:@"registration"];
    [m_butQiandao setTitle:@"已签到" forState:UIControlStateNormal];
    [self.delegate butEventQiandao:self];
    m_butQiandao.enabled = NO;
//    int completeNum = [[self.infoDic objectForKey:@"completeNum"] intValue];
//    [self.infoDic setObject:[NSNumber numberWithInt:completeNum+1] forKey:@"completeNum"];
}

- (void)setInfoDic:(NSMutableDictionary*)dic
{
	[super setInfoDic:dic];
	
	int completeNum = [[dic objectForKey:@"completeNum"] intValue];
    int sum = [[dic objectForKey:@"sum"] intValue];
    
    m_butQiandao.enabled = YES;
    [m_butQiandao setTitle:@"签到" forState:UIControlStateNormal];
    if ([[dic objectForKey:@"registration"] boolValue]) {
        [m_butQiandao setTitle:@"已签到" forState:UIControlStateNormal];
        m_butQiandao.enabled = NO;
    }
	
	NSString *weiwancheng = [NSString stringWithFormat:@"%d个未完成", sum-completeNum];
	m_labWeiwanChen.attributedText = [self replaceRedColorWithNSString:weiwancheng andUseKeyWord:[NSString stringWithFormat:@"%d",sum-completeNum] andWithFontSize:14 TextColor:@"fe6339"];
	
	
	CGRect rect = m_viewWancheng.frame;
	rect.size.width = sum ? m_viewB.width/sum*completeNum : m_viewB.width;
	m_viewWancheng.frame = rect;
	

	weiwancheng = [NSString stringWithFormat:@"%d/%d", completeNum, sum];
	m_labQuanbu.attributedText = [self replaceRedColorWithNSString:weiwancheng andUseKeyWord:[NSString stringWithFormat:@"%d",completeNum] andWithFontSize:14 TextColor:@"2fcd58"];
}

//描红
//- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler
//{
//	NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
//	NSRange range = [str rangeOfString:keyWord];
//	[attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
//	return attrituteString;
//}

- (void)dealloc
{
	[m_labWeiwanChen release];
	[m_viewWancheng release];
	[m_labQuanbu release];
	[m_viewB release];
//    [m_butQiandao release];
	
	[super dealloc];
}

@end






//血糖趋势
@implementation bloodGlucoseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect rect = m_labType.frame;
        rect.origin.y = 5;
        m_labType.frame = rect;
        
        m_butSelType = [UIButton buttonWithType:UIButtonTypeCustom];
        m_butSelType.layer.cornerRadius = 2;
        m_butSelType.clipsToBounds = YES;
        m_butSelType.layer.borderColor = [CommonImage colorWithHexString:COLOR_FF5351].CGColor;
        m_butSelType.layer.borderWidth = 0.5;
        m_butSelType.frame = CGRectMake(kDeviceWidth - 60 - 15, 12, 60, 25);
        m_butSelType.titleLabel.font = [UIFont systemFontOfSize:14];
        [m_butSelType setTitle:@"早餐前" forState:UIControlStateNormal];
        [m_butSelType setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
        [m_butSelType addTarget:self action:@selector(createBloodSugarTimer:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_butSelType];
        
        m_drawLineView = [[DrawLineView alloc] initWithFrame:CGRectMake(0, m_butSelType.bottom-30, kDeviceWidth, (240/320.f)*kDeviceWidth)];
        m_drawLineView.backgroundColor = [UIColor clearColor];
        m_drawLineView.isYClipTo5 = NO;
        m_drawLineView.m_strType = @"血糖趋势";
        m_drawLineView.currentTimeType = SevenDaysType;//设置类型
        [self addSubview:m_drawLineView];
        [self bringSubviewToFront:m_butSelType];
        
        NSDictionary *dic1 = @{@"image":@"common.bundle/home/home_xuetang.png", @"title":@"血糖录入"};
        NSDictionary *dic2 = @{@"image":@"common.bundle/home/home_xueya.png", @"title":@"血压录入"};
        NSDictionary *dic3 = @{@"image":@"common.bundle/home/home_tizhong.png", @"title":@"体重录入"};
        NSArray *array = @[dic1, dic2, dic3];
        UIButton *but;
        float widht = 80;
        float y = (kDeviceWidth-(widht*3))/4;
        for (int i = 0; i < array.count; i++) {
            dic1 = [array objectAtIndex:i];
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.tag = 100+i;
            but.frame = CGRectMake((widht+y)*i +y, m_drawLineView.bottom + 10, widht, 102);
            but.titleLabel.font = [UIFont systemFontOfSize:14];
            [but setTitle:[dic1 objectForKey:@"title"] forState:UIControlStateNormal];
            [but setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:[dic1 objectForKey:@"image"]] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(createBloodSugar:) forControlEvents:UIControlEventTouchUpInside];
            CGSize size = but.currentImage.size;
            [but setTitleEdgeInsets:UIEdgeInsetsMake(26, -size.width, -26, 0)];
            [but setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 20, -[[dic1 objectForKey:@"title"] sizeWithFont:but.titleLabel.font].width)];
            [self addSubview:but];
        }
    }
    
    return self;
}

- (void)createBloodSugar:(UIButton*)but
{
    switch (but.tag) {
        case 100:
            break;
        case 101:
            break;
        case 102:
            break;

        default:
            break;
    }
}

- (void)createBloodSugarTimer:(UIButton*)btn
{
    NSArray *array = [CommonUser getBloodSugarArray];
    PickerView *myPickerCutom = [[PickerView alloc] init];
    [myPickerCutom createPickViewWithArray:@[array] andWithSelectString:btn.titleLabel.text setTitle:@"请选择测量时段" isShow:NO];
    [myPickerCutom setPickerViewBlock:^(NSString *content) {
        [m_butSelType setTitle:content forState:UIControlStateNormal];
        m_strType = content;
        [self.infoDic setObject:content forKey:@"selType"];
        [self reloadLineViewAndTableView];
        [myPickerCutom release];
    }];

}

- (void)butEventOpenRiji:(UIButton*)but
{
    [self.delegate butEventOpen:(int)but.tag - 100];
}

- (void)setInfoDic:(NSMutableDictionary *)dic
{
    [super setInfoDic:dic];
    NSString *title = [dic objectForKey:@"selType"];
    [m_butSelType setTitle:title forState:UIControlStateNormal];
    [self reloadLineViewAndTableView];
}

- (void)reloadLineViewAndTableView
{
    NSArray *chartArray;
    NSArray *localArray;
    NSArray *dateArray;
    NSDictionary *itemDic = [self.infoDic objectForKey:m_butSelType.titleLabel.text];
    if (itemDic) {
        chartArray = [itemDic objectForKey:@"chartArray"];
        localArray = [itemDic objectForKey:@"localArray"];
        dateArray = [itemDic objectForKey:@"dateArray"];
    }
    else {
        chartArray = [NSArray arrayWithObjects:@"2",nil];
        dateArray =  [NSArray arrayWithObjects:@"",nil];
        localArray = [NSArray arrayWithObjects:@"",nil];
    }
    
    [m_drawLineView setLineDataArray:[NSArray arrayWithObject:chartArray] andTimeArray:dateArray normalValueArray:[self getBloodSugarType] lineMeansArray:nil aboutMultiLocaInOriginalArray:[NSArray arrayWithObject:localArray]];
    [m_drawLineView reloadSubViews];
}

//获得血糖选择的类型
- (NSArray*)getBloodSugarType
{
    NSArray *arrayType = @[@"早餐前",@"午餐前",@"晚餐前",@"睡前"];
    for (NSString *str in arrayType) {
        
        if ([m_butSelType.titleLabel.text isEqualToString:str]) {
            return @[@[@"6.1",@"3.9"]];
        }
    }
    return  @[@[@"7.8",@"3.9"]];
}

@end




//专家直通车
@implementation expertTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = m_labType.frame;
        [but addTarget:self action:@selector(butEventTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(but.width-10, 19, 10, 12)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"common.bundle/common/right_normal.png"];
        [but addSubview:imageView];
        [imageView release];
        
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, m_labType.bottom, kDeviceWidth, 105)];
        m_scrollView.clipsToBounds = YES;
        m_scrollView.showsHorizontalScrollIndicator = NO;
        m_scrollView.showsVerticalScrollIndicator = NO;
//        m_scrollView.pagingEnabled = YES;
        m_scrollView.delegate = self;
        [self addSubview:m_scrollView];
        [m_scrollView release];
    }
    
    return self;
}

- (void)butEventTouch
{
    
}

- (UIView*)createExpert:(int)tag withX:(float)x
{
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 80, 105)];
    view.tag = tag*1000+1;
    [view addTarget:self action:@selector(touchesBegan:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageView.tag = 150;
    imageView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    imageView.layer.borderWidth = 1;
    imageView.layer.cornerRadius = 2;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [view addSubview:imageView];
    [imageView release];
    
    UILabel *labName = [Common createLabel];
    labName.tag = 151;
    labName.frame = CGRectMake(0, imageView.bottom+9, imageView.width, 18);
    labName.font = [UIFont systemFontOfSize:14];
    labName.textAlignment = NSTextAlignmentCenter;
    labName.textColor = [CommonImage colorWithHexString:@"666666"];
    [view addSubview:labName];
    [labName release];
    
    UILabel *labZhicheng = [Common createLabel];
    labZhicheng.tag = 152;
    labZhicheng.frame = CGRectMake(0, labName.bottom, imageView.width, 16);
    labZhicheng.font = [UIFont systemFontOfSize:11];
    labZhicheng.textAlignment = NSTextAlignmentCenter;
    labZhicheng.textColor = [CommonImage colorWithHexString:@"999999"];
    [view addSubview:labZhicheng];
    [labZhicheng release];
    
    return view;
}

- (void)setInfoDic:(NSMutableDictionary*)dic
{
    [super setInfoDic:dic];
    
    NSDictionary *item;
    UIView *view;
    UILabel *labName, *labZhicheng;
    float x = 15;
    NSArray *array = [dic objectForKey:@"array"];
    for (int i = 0; i < [array count]; i++) {
        item = [array objectAtIndex:i];
        view = [m_scrollView viewWithTag:i*1000+1];
        if (!view) {
            view = [self createExpert:i withX:x];
            [m_scrollView addSubview:view];
            [view release];
        }
        x += view.width;
        
        labName = (UILabel*)[view viewWithTag:151];
        labName.text = [item objectForKey:@"name"];
        labZhicheng = (UILabel*)[view viewWithTag:152];
        labZhicheng.text = [item objectForKey:@"zhicheng"];
    }
    //隐藏
    for (int i = (int)array.count; i < m_scrollView.subviews.count; i++) {
        int tag = i*1000+1;
        UIView *backView = [m_scrollView viewWithTag:tag];
        if (backView) {
            backView.hidden = YES;
        }
    }
    x -= 5;
    
    [m_scrollView setContentSize:CGSizeMake(x, 105)];
    [m_scrollView setContentOffset:CGPointMake([[dic objectForKey:@"index"] floatValue], 0)];
}

- (void)touchesBegan:(UIButton*)but
{
    int index = (int)but.tag / 1000 -1;
    NSDictionary *dic = self.infoDic[@"array"][index];
    [self.delegate butEventZhitongche:dic];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.infoDic setObject:[NSNumber numberWithFloat:scrollView.contentOffset.x] forKey:@"index"];
}

- (void)setIconImage:(NSString *)image Index:(int)i
{
    UIView *view = [m_scrollView viewWithTag:i*1000+1];
    UIImageView *imagePic = (UIImageView*)[view viewWithTag:150];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
    [imagePic sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:defaul];
}

- (void)dealloc
{
    [super dealloc];
}

@end






//
@implementation homeGuideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 0.5)];
        line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [self addSubview:line];
        [line release];
        
        m_labType.hidden = YES;
        
        UIButton *butLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2.f, 60)];
        [butLeft setImage:[UIImage imageNamed:@"common.bundle/home/zhinan.png"] forState:UIControlStateNormal];
        [butLeft setTitle:@"  新手指南" forState:UIControlStateNormal];
        [butLeft setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        butLeft.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        butLeft.tag = 2000;
        [butLeft addTarget:self action:@selector(butEventTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:butLeft];
        [butLeft release];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(butLeft.right-0.5, 15, 0.5, 30)];
        line.backgroundColor = [CommonImage colorWithHexString:@"e6e6e6"];
        [butLeft addSubview:line];
        [line release];
        
        UIButton *butRight = [[UIButton alloc] initWithFrame:CGRectMake(butLeft.right, 0, kDeviceWidth/2.f, 60)];
        [butRight setImage:[UIImage imageNamed:@"common.bundle/home/bidu.png"] forState:UIControlStateNormal];
        [butRight setTitle:@"  关于我们" forState:UIControlStateNormal];
        [butRight setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        butRight.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        butRight.tag = 2001;
        [butRight addTarget:self action:@selector(butEventTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:butRight];
        [butRight release];
    }
    
    return self;
}

- (void)butEventTouch:(UIButton*)but
{
    if (but.tag == 2000) {
        [self.delegate butEventHomeGuide:xinshouzhinan];
    }
    else
    {
        [self.delegate butEventHomeGuide:tangyoubidu];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end



