//
//  MessageFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "ZBMessageManagerFaceView.h"

@implementation emoStruct

@end



@implementation ZBMessageManagerFaceView
{
    UIButton *m_lastBut;
    
    emoStruct *m_dicInfo;
    
    NSMutableArray *m_array;
    
    UIView *m_showView;
    UIView *m_barView;
}

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withDic:(emoStruct*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        m_dicInfo = dic;
        
        m_array = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
        
        NSMutableArray *array = [NSMutableArray array];
        if (m_dicInfo.m_smallEmo) {
            [self createSmall];
            [array addObject:@"common.bundle/msg/emo/emo.png"];
        }
        if (m_dicInfo.m_bigEmo) {
            [self createBig];
            [array addObject:@"common.bundle/msg/emo/emo_kx.png"];
        }
        [array addObject:@""];//common.bundle/msg/emo/emoji_delete.png
        [self createBar:array];
    }
    return self;
}

- (void)createSmall
{
    NSArray *array = @[@"emo_049", @"emo_022", @"emo_032", @"emo_035", @"emo_040", @"emo_039", @"emo_034", @"emo_023",
                       @"emo_05", @"emo_015", @"emo_063", @"emo_026", @"emo_028", @"emo_024", @"emo_061", @"emo_051",
                       @"emo_07", @"emo_08", @"emo_036", @"emo_03", @"emo_011", @"emo_020", @"emo_021", @"emo_052",
                       @"emo_014", @"emo_045", @"emo_031", @"emo_037", @"emo_030", @"emo_04", @"emo_058", @"emoji_delete",//@"emo_038",
                       @"emo_02", @"emo_048", @"emo_046", @"emo_057", @"emo_044", @"emo_062", @"emo_050", @"emo_060",
                       @"emo_042", @"emo_047", @"emo_012", @"emo_06", @"emo_017", @"emo_010", @"emo_027", @"emo_059",
                       @"emo_064", @"emo_054", @"emo_01", @"emo_019", @"emo_013", @"emo_09", @"emo_025", @"emo_016",
                       @"emo_033", @"emo_018", @"emo_041", @"emo_055", @"emo_056", @"emo_029", @"emo_053", @"emoji_delete"];//@"emo_043"
    
    ZBFaceView *face = [[ZBFaceView alloc] createSmall:CGRectMake(0, 0, CGRectGetWidth(self.frame), 203) withArray:array];
    face.tag = 1000;
    face.delegate = self;
    [m_array addObject:face];
    m_showView = face;
    [self addSubview:m_showView];
}

- (void)createBig
{
    NSArray *array = @[@[@"kx_zhuakuang", @"抓狂"], @[@"kx_tiaopi", @"调皮"], @[@"kx_fangsong", @"放松"], @[@"kx_fennu", @"愤怒"],
                       @[@"kx_huankuai", @"欢快"], @[@"kx_jinzhang", @"紧张"], @[ @"kx_jusang", @"沮丧"], @[@"kx_mimang", @"迷茫"],
                       @[@"kx_pingjing", @"平静"], @[@"kx_weiqu", @"委屈"], @[@"kx_xingfen", @"兴奋"], @[@"kx_wuliao", @"无聊"]];
    ZBFaceView *face = [[ZBFaceView alloc] createBig:CGRectMake(0, 0, CGRectGetWidth(self.frame), 203) withArray:array];
    face.tag = 2000;
    face.delegate = self;
    [m_array addObject:face];
}

- (void)createBar:(NSArray*)array
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, m_showView.bottom, CGRectGetWidth(self.frame), 45)];
    view.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
    [self addSubview:view];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:@"cccccc"];
    [view addSubview:line];
    [line release];
    
    UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"c8c8c8"]];
    
    UIButton *but;
    int i = 0, width = 71;
    for (NSString *str in array) {
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = 100+i;
        but.frame = CGRectMake(i*width, 0, width, view.height);
        [but setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        [but setBackgroundImage:image forState:UIControlStateSelected];
        [but setBackgroundImage:image forState:UIControlStateHighlighted];
        [but addTarget:self action:@selector(butEventType:) forControlEvents:UIControlEventTouchUpInside];
        if (!i) {
            but.selected = YES;
            m_lastBut = but;
        }
        else if (i == array.count-1) {
            but.frame = CGRectMake(view.width-width-5, 0, width+5, view.height);
            but.buttonDefultString = @"发送";
            but.titleLabel.font = [UIFont systemFontOfSize:17];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [but setTitle:@"发送" forState:UIControlStateNormal];
            image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
            [but setBackgroundImage:image forState:UIControlStateNormal];
//            [but setBackgroundImage:image forState:UIControlStateSelected];
//            [but setBackgroundImage:image forState:UIControlStateHighlighted];
        }
        [view addSubview:but];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(but.width-0.5, 0, 0.5, but.height)];
        line.backgroundColor = [CommonImage colorWithHexString:@"cccccc"];
        [but addSubview:line];
        [line release];
        
        i++;
    }
}

- (void)butEventType:(UIButton*)but
{
    
    if ([but.buttonDefultString isEqualToString:@"发送"]) {

        if ([self.delegate respondsToSelector:@selector(sendMsgChar)]) {
            [self.delegate sendMsgChar];
        }
    }
    else {
        if (![but isEqual:m_lastBut]) {
            m_lastBut.selected = NO;
            but.selected = YES;
            
            [m_showView removeFromSuperview];
            m_showView = [m_array objectAtIndex:but.tag - 100];
            [self addSubview:m_showView];
            m_lastBut = but;
        }
    }
}

#pragma mark ZBFaceView Delegate
- (void)didSelecteFace:(NSString *)faceName andIsBig:(BOOL)is
{
    if (is) {
        if ([self.delegate respondsToSelector:@selector(SendBig:)])
        {
            [self.delegate SendBig:faceName];
        }
    }
    else {
        
        if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:)])
        {
            if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:)]) {
                BOOL isDel = NO;
                if ([faceName isEqualToString:@"删除"]) {
                    isDel = YES;
                }
                [self.delegate SendTheFaceStr:faceName isDelete:isDel];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
