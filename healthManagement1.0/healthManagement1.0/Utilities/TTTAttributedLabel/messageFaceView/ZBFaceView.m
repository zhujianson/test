//
//  ZBFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "ZBFaceView.h"

#define NumPerLine 7
#define Lines    3
#define FaceSize  24
/*
** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 5

@implementation ZBFaceView
{
    UIPageControl *pageControl;
    NSMutableArray *m_array;
    NSDictionary *m_plistDic;
}

- (void)dealloc
{
    [m_array release];
    [pageControl release];
    [m_plistDic release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
        m_plistDic = [[NSDictionary alloc] initWithContentsOfFile:plistStr];
    }
    return self;
}

- (id)createSmall:(CGRect)frame withArray:(NSArray*)array
{
    self = [self initWithFrame:frame];
    if (self)
    {
        m_array = [array mutableCopy];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        scrollView.delegate = self;
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:scrollView];
        [scrollView release];
        
        UIButton *but;
        int row, test = 0, list, width = (kDeviceWidth-7)/8, height = 45;
        for (int i = 0; i < array.count; i++)
        {
            test = i/8;
            row = test%4;
            list = i%8 + (test/4)*8;
            
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.tag = 100+i;
            but.frame = CGRectMake(list*(width+1), row*(height+1), width, height);
            [but setImage:[UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/msg/emo/small/%@.png", array[i]]] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(faceClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:but];
        }
        int page = [Common getJingYi:test BeiChuShu:8]+1;
        [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*page,CGRectGetHeight(scrollView.frame))];
        
        pageControl = [[UIPageControl alloc] init];
        [pageControl setFrame:CGRectMake(0, 185, CGRectGetWidth(self.bounds), 13)];
        [self addSubview:pageControl];
        [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        pageControl.numberOfPages = page;
        pageControl.currentPage = 0;
    }
    return self;
}

- (id)createBig:(CGRect)frame withArray:(NSArray*)array
{
    self = [self initWithFrame:frame];
    if (self)
    {
        m_array = [array mutableCopy];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        scrollView.delegate = self;
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:scrollView];
        [scrollView release];
        
        UIButton *but;
        int row, test = 0, list, width = (kDeviceWidth-3)/4, height = 93;
        UIImage *image;
        for (int i = 0; i < array.count; i++)
        {
            test = i/4;
            row = test%2;
            list = i%4 + (test/2)*4;
            
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.tag = 100+i;
            but.frame = CGRectMake(list*(width+1), row*(height+1), width, height);
            image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/msg/emo/big/%@.png", array[i][0]]];
            [but setImage:image forState:UIControlStateNormal];
            [but setTitle:array[i][1] forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:10];
            [but setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(butEventBig:) forControlEvents:UIControlEventTouchUpInside];
            CGSize size = image.size;
            
            float widht = [array[i][1] sizeWithAttributes:@{NSFontAttributeName:but.titleLabel.font}].width;
            [but setTitleEdgeInsets:UIEdgeInsetsMake(size.height/2+5, -size.width, -size.height/2-5, 0)];
            [but setImageEdgeInsets:UIEdgeInsetsMake(-6, 0, 6, -widht)];
            
            [scrollView addSubview:but];

        }
        int page = [Common getJingYi:test BeiChuShu:2]+1;
        [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*page,CGRectGetHeight(scrollView.frame))];
        
        pageControl = [[UIPageControl alloc] init];
        [pageControl setFrame:CGRectMake(0, 185, CGRectGetWidth(self.bounds), 13)];
        [self addSubview:pageControl];
        [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        pageControl.numberOfPages = [Common getJingYi:(int)array.count BeiChuShu:8];
        pageControl.currentPage = 0;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.width;
    pageControl.currentPage = page;
}

- (void)faceClick:(UIButton *)button
{
    NSString *faceName = @"删除";

    NSString *expressstring = [m_array objectAtIndex:(int)button.tag-100];
    
    for (int j = 0; j<[[m_plistDic allKeys] count]; j++)
    {
        if ([[m_plistDic objectForKey:[[m_plistDic allKeys] objectAtIndex:j]] isEqualToString:[NSString stringWithFormat:@"%@",expressstring]])
        {
            faceName = [[m_plistDic allKeys] objectAtIndex:j];
        }
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelecteFace:andIsBig:)]) {
        [self.delegate didSelecteFace:faceName andIsBig:NO];
    }
}

- (void)butEventBig:(UIButton*)but
{
    NSString *expressstring = [m_array objectAtIndex:(int)but.tag-100][0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelecteFace:andIsBig:)]) {
        [self.delegate didSelecteFace:expressstring andIsBig:YES];
    }
}

@end
