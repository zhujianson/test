//
//  WeekActivityView.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/6/3.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "WeekActivityView.h"
#import "ThinHeader.h"
#import "KXMoviePlayer.h"

static NSUInteger kStartWeekTag = 1000;
@interface WeekActivityView()
@property (nonatomic,strong) UILabel *m_nameLabel;
@property (nonatomic,strong) NSMutableArray *m_btnArray;
@property (nonatomic,strong) UILabel *m_desLabel;
@property (nonatomic,strong) UIImageView *m_calendarImage;
@property (nonatomic,strong) UIScrollView *m_weekView;
@property (nonatomic,strong) UIView *m_showContentView;

@property (nonatomic,strong) UIImageView *m_picImageView;//视频地址
@property (nonatomic,strong) UILabel *m_showContentLable;//文字地址
@property (nonatomic,strong) UIView *m_showContentLabelView;//文字地址

@end

@implementation WeekActivityView
{
    UIView *lastLineView;
    KXMoviePlayer* m_moviePlayerView;
    NSInteger indexSelectDay;
    NSInteger indexCurrentDay;
    UILabel * titleLabel;
    UIButton *playMovieBtn;
    NSString *m_playURL;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _m_btnArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

-(void)dealloc
{
    _thinPlanViewBlock = nil;
}

-(void)refreshDataWithIndex:(NSInteger)index
{
    NSArray *array = [_infoDict objectForKey:@"list"];
    if (array.count) {
        NSDictionary *indexDict = array[index];
        
        NSInteger sport_type = [indexDict[@"sport_type"] integerValue];// 1视频  2文字
        self.m_showContentLabelView.hidden = NO;
        self.m_picImageView.hidden = NO;
        if (sport_type == 1)
        {
            self.m_showContentLabelView.hidden = YES;
            [CommonImage setBackImageFromServer:indexDict[@"sport_img_url"] View:self.m_picImageView Type:2];
            titleLabel.text = indexDict[@"sport_title"];
            m_playURL = indexDict[@"sport_content"];
            titleLabel.top = self.m_picImageView.bottom;
        }
        else
        {
            self.m_picImageView.hidden = YES;
            self.m_showContentLable.text = indexDict[@"sport_content"];
            titleLabel.text = indexDict[@"sport_title"];
            //            float topSpace = 15.0;
            [_m_showContentLable sizeToFit];
            //            CGSize size = [Common sizeForAllString:_m_showContentLable.text andFont:_m_showContentLable.font.pointSize andWight:_m_showContentLable.width];
            //            _m_showContentLable.height = ceil(size.height) + topSpace*2;
            _m_showContentLabelView.height = _m_showContentLable.bottom + kLeftw;
            titleLabel.top = self.m_showContentLabelView.bottom;
        }
        _m_showContentView.height = titleLabel.bottom;
    }
    lastLineView.top = self.m_showContentView.bottom;
    self.height = lastLineView.bottom;
    
    if (indexSelectDay > 0)
    {
        UIButton *weekBtn = nil;
        NSInteger lastIndex = MAX(0, indexSelectDay-1);
        weekBtn = _m_btnArray[lastIndex];
        
        float offset = MIN(weekBtn.center.x, _m_weekView.contentSize.width-kDeviceWidth);
        [_m_weekView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

-(void)setUpWeekPuchState
{
    UIButton *weekBtn = nil;
    if (indexCurrentDay < _m_btnArray.count)
    {
        weekBtn = _m_btnArray[indexCurrentDay];
        
        [weekBtn setAttributedTitle:[[NSAttributedString alloc]initWithString: @""] forState:UIControlStateNormal];
        [weekBtn setTitle:@"" forState:UIControlStateNormal];
        weekBtn.layer.borderWidth = 0;
        
        UIImage* unlockImage = k_fetchImage(@"unlock");
        [weekBtn setImage:unlockImage forState:UIControlStateNormal];
        UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:@"333333"] ];
        [weekBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    }
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    _m_nameLabel.text = infoDict[@"title"];
    NSInteger indexDay = 0;
    //    is_clock;//0已经打卡，1未打卡
    BOOL is_clock = [infoDict[@"is_clock"] boolValue];
    NSArray *array = [infoDict objectForKey:@"list"];
    if (array.count) {
        indexDay = array.count-1;
    }
    indexSelectDay = indexDay;//观看的天数
    indexCurrentDay = indexDay;//当前选中的天
    [self refreshDataWithIndex:indexDay];
    self.height = lastLineView.bottom;
    
    UIButton *weekBtn = nil;
    for (int i = 0; i< _m_btnArray.count; i++)
    {
        weekBtn = _m_btnArray[i];
        weekBtn.enabled = YES;
        [weekBtn setAttributedTitle:[[NSAttributedString alloc]initWithString: @""] forState:UIControlStateNormal];
        [weekBtn setTitle:@"" forState:UIControlStateNormal];
        weekBtn.layer.borderWidth = 0;
        if (i < indexDay)
        {
            UIImage* unlockImage = k_fetchImage(@"unlock");
            [weekBtn setImage:unlockImage forState:UIControlStateNormal];
            UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:@"333333"] ];
            [weekBtn setBackgroundImage:backImage forState:UIControlStateNormal];
        }
        else if (i == indexDay)
        {
            if (0 == is_clock)
            {
                UIImage* unlockImage = k_fetchImage(@"unlock");
                [weekBtn setImage:unlockImage forState:UIControlStateNormal];
                UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:@"333333"] ];
                [weekBtn setBackgroundImage:backImage forState:UIControlStateNormal];
            }
            else
            {
                NSString *dayString = [NSString stringWithFormat:@"DAY\n%ld",(long)indexDay+1];
                [weekBtn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                NSAttributedString * attributedText = [NSString replaceRedColorWithNSString:dayString andUseKeyWord:@"DAY" andWithFontSize:11.0 andWithFrontColor:@"ffffff"];
                [weekBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
                UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:COLOR_Red]];
                [weekBtn setBackgroundImage:backImage forState:UIControlStateNormal];
                [weekBtn setImage:k_fetchImage(@"") forState:UIControlStateNormal];
            }
        }
        else
        {
            UIImage* HighlenbleImage =k_fetchImage(@"lock");
            [weekBtn setImage:HighlenbleImage forState:UIControlStateNormal];
            [weekBtn setTitle:@"" forState:UIControlStateNormal];
            UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:@"ebebeb"] ];
            [weekBtn setBackgroundImage:backImage forState:UIControlStateNormal];
            weekBtn.layer.borderColor = [CommonImage colorWithHexString:@"dcdcdc"].CGColor;
            weekBtn.layer.borderWidth = 0.5;
            weekBtn.enabled = NO;
        }
    }
}


-(void)createContentView
{
    UIImage *calendarPng = k_fetchImage(@"calendar");
    UIImageView *m_calendarImage = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftw, 12.0, calendarPng.size.width, calendarPng.size.height)];
    m_calendarImage.image = calendarPng;
    m_calendarImage.layer.cornerRadius = 4.0;
    m_calendarImage.layer.masksToBounds = YES;
    m_calendarImage.backgroundColor = [UIColor whiteColor];
    [self addSubview:m_calendarImage];
    self.m_nameLabel.left = m_calendarImage.right +10;
    _m_nameLabel.text = @"准备期第一周";
    _m_nameLabel.top = m_calendarImage.top;
    
    self.m_weekView.top = _m_nameLabel.bottom +  self.m_nameLabel.top;
    
    UIView *lineView = [self createSepratorView];
    lineView.top = self.m_weekView.bottom + 15.0;
    self.m_showContentView.top = lineView.bottom;
    
    lastLineView = [self createSepratorView];
    lastLineView.top = self.m_showContentView.bottom;
    //    self.height = lastLineView.bottom;
}

#pragma mark - Event response
-(void)butEventTool:(UIButton *)btn
{
    NSLog(@"------%@",btn);
    NSInteger index = btn.tag - kStartWeekTag;
    if (index != indexSelectDay)
    {
        [self closeWebViewItem];
        indexSelectDay = index;
        [self refreshDataWithIndex:index];
        _thinPlanViewBlock(@(index));
    }
}

- (void)createMovPlay:(NSString*)URL
{
    if(0 == URL.length)
    {
        return;
    }
    if (!m_moviePlayerView)
    {
        m_moviePlayerView = [[KXMoviePlayer alloc] init];
        m_moviePlayerView.m_KXMoviePlayerType = KXMoviePlayerTypeViewController;
        m_moviePlayerView.movieViewFrame =  self.m_picImageView.frame;
    }
    [m_moviePlayerView loadMoviePlayerWithUrl:URL inParentView:self.m_picImageView.superview];
}

- (void)closeWebViewItem
{
    if (m_moviePlayerView) {
        [m_moviePlayerView  stopMoviePlayer];//关闭视频
    }
}

#pragma mark - Set-getUi
-(UIView *)createSepratorView
{
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth,7)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"ededed"];
    [self addSubview:lineView];
    return lineView;
}

-(UIView *)m_showContentLabelView
{
    if (_m_showContentLabelView) {
        return _m_showContentLabelView;
    }
    _m_showContentLabelView = [[UIView alloc] initWithFrame:CGRectMake(kLeftw, kLeftw, kDeviceWidth-kLeftw*2, 180)];
    _m_showContentLabelView.backgroundColor =[CommonImage colorWithHexString:@"ffffff"];
    _m_showContentLabelView.layer.borderWidth = 0.5;
    _m_showContentLabelView.clipsToBounds = YES;
    _m_showContentLabelView.layer.cornerRadius = 4;
    _m_showContentLabelView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    [_m_showContentView addSubview:_m_showContentLabelView];
    return _m_showContentLabelView;
}

-(UILabel *)m_showContentLable
{
    if (_m_showContentLable) {
        return _m_showContentLable;
    }
    _m_showContentLable = [Common createLabel:CGRectMake(kLeftw, kLeftw, _m_showContentLabelView.width-kLeftw*2, 180) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentLeft labTitle:@""];
    [_m_showContentLabelView addSubview:_m_showContentLable];
    _m_showContentLable.numberOfLines = 0;
    return _m_showContentLable;
}


-(UIImageView *)m_picImageView
{
    if (_m_picImageView) {
        return _m_picImageView;
    }
    _m_picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftw, kLeftw, kDeviceWidth-kLeftw*2, 195)];
    _m_picImageView.backgroundColor = [UIColor redColor];
    _m_picImageView.userInteractionEnabled = YES;
    _m_picImageView.layer.cornerRadius = 4.0;
    _m_picImageView.layer.masksToBounds = YES;
    [_m_showContentView addSubview:_m_picImageView];
    
    playMovieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playMovieBtn.frame = CGRectMake(0, 0, 100, 100);
    playMovieBtn.backgroundColor = [UIColor clearColor];
    playMovieBtn.center = _m_picImageView.center;
    [playMovieBtn setImage:[UIImage imageNamed:@"common.bundle/class/play.png"] forState:UIControlStateNormal];
    [playMovieBtn addTarget:self action:@selector(playMovie:) forControlEvents:UIControlEventTouchUpInside];
    [_m_picImageView addSubview:playMovieBtn];
    
    return _m_picImageView;
}


/**
 *  播放视频
 *
 */
- (void)playMovie:(UIButton *)btn
{
    NSLog(@"-------放视频");
    //      m_playURL=  @"http://7rflwf.com2.z0.glb.clouddn.com/yin20.mp4";
    if (m_playURL.length)
    {
        [self createMovPlay:m_playURL];
    }
}

-(UIView *)m_showContentView
{
    if (_m_showContentView) {
        return _m_showContentView;
    }
    _m_showContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 470/2.0)];
    [self addSubview:_m_showContentView];
    
    titleLabel = [Common createLabel:CGRectMake(kLeftw, 0, kDeviceWidth-kLeftw*2, 40) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentLeft labTitle:@"今日运动:有氧拉伸"];
    [_m_showContentView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    
    _m_showContentView.height = titleLabel.bottom;
    return _m_showContentView;
}

//- (void)tapHeaderPicture:(UITapGestureRecognizer *)gesture
//{
//    NSLog(@"-------放视频");
//    //    [self createMovPlay:@""];
//}

-(UIScrollView *)m_weekView
{
    if (_m_weekView) {
        return _m_weekView;
    }
    
    _m_weekView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 55.0)];
    _m_weekView.showsHorizontalScrollIndicator = NO;
    _m_weekView.showsVerticalScrollIndicator = NO;
    [self addSubview:_m_weekView];
    
    float  leftWeight = 10;
    float kBtnw = _m_weekView.height;
    float kBtnSpacew = 10.0;
    UIButton *planBtn = nil;
    
    for (int i = 0; i<7; i++) {
        planBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        planBtn.frame = CGRectMake(leftWeight+i*(kBtnw+kBtnSpacew), 0, kBtnw,kBtnw);
        planBtn.tag = kStartWeekTag+i;
        [planBtn setTitle:@"DAY\n2" forState:UIControlStateNormal];
        [planBtn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        planBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:COLOR_Red]];
        planBtn.titleLabel.numberOfLines = 0;
        planBtn.layer.cornerRadius = planBtn.width/2.0;
        planBtn.layer.masksToBounds = YES;
        planBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [planBtn setBackgroundImage:backImage forState:UIControlStateNormal];
        [planBtn addTarget:self action:@selector(butEventTool:) forControlEvents:UIControlEventTouchUpInside];
        [_m_weekView addSubview:planBtn];
        [_m_btnArray addObject:planBtn];
    }
    _m_weekView.contentSize = CGSizeMake(planBtn.right+leftWeight, _m_weekView.height);
    return _m_weekView;
}

-(UILabel *)m_nameLabel
{
    if (_m_nameLabel) {
        return _m_nameLabel;
    }
    _m_nameLabel = [Common createLabel:CGRectMake(0, 0, 200, 20) TextColor:@"666666" Font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentLeft labTitle:@"享瘦计划"];
    [self addSubview:_m_nameLabel];
    return _m_nameLabel;
}

@end
