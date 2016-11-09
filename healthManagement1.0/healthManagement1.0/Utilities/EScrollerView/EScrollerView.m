//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "Global.h"
#import "Global_Url.h"

#import "Common.h"

//#define BASEHEIGHT	284.0f
//#define NPAGES		5 // works better with 5 or more. will work with 3 minimum
#define BIGNUM		500
//#define Advertising	900

@implementation EScrollerView
@synthesize delegate;

- (id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr isAutoPlay:(BOOL)isAuto setImageKey:(NSString*)imageKey //pathSuffix:(NSString*)path
{
    if ((self=[super initWithFrame:rect])) {
        m_lastTime = [CommonDate getLongTime];
        
        m_isAuto = isAuto;
        
        m_imagePath = imageKey;
        
        pageNum = (int)[imgArr count];
        
        imageArray = [[NSMutableArray alloc]initWithArray:imgArr];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        scrollView.contentSize = CGSizeMake(pageNum * (rect.size.width+20), scrollView.frame.size.height);
        scrollView.contentOffset = CGPointMake(rect.size.width * BIGNUM * (pageNum<3?4:pageNum), 0.0f);
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        [scrollView addGestureRecognizer:Tap];
        [Tap release];
        
        for (int i = 0; i < (pageNum<3?4:pageNum); i++)
        {
            NSDictionary *dic = [imageArray objectAtIndex:i%pageNum];
            NSString *imgURL = [dic objectForKey:imageKey];
            UIImageView *imgView;
            if (imgURL) {
                //                imgURL = [imgURL stringByAppendingString:path];
                imgView = [[UIImageView alloc] init];
                imgView.tag = Advertising + i;
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                //            imgView.backgroundColor = [CommonImage colorWithHexString:[arra objectAtIndex:i]];
                imgView.frame = CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
                imgView.clipsToBounds = YES;
                [scrollView addSubview:imgView];
                [imgView release];
                
                //                [CommonImage setPicImageQiniu:imgURL View:imgView Type:2 Delegate:nil];
                [CommonImage setImageFromServer:imgURL View:imgView Type:2];
                
            }
        }
        
        float pageControlWidth = pageNum*15.0f+10.f;
        
        if (imageArray[0][@"newsType"]) {
            UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30,self.bounds.size.width,30)];
            noteView.backgroundColor = [UIColor blackColor];
            noteView.alpha = 0.6f;
            [self addSubview:noteView];
            [noteView release];
            UILabel * lab = [Common createLabel:CGRectMake(10, self.bounds.size.height-30,kDeviceWidth-100,30) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:imageArray[0][@"title"]];
            lab.tag = 55;
            [self addSubview:lab];
        }
        
        if (pageNum == 1) {
            scrollView.contentSize = CGSizeMake(kDeviceWidth, 0);
            
        }else{
            scrollView.contentSize = CGSizeMake(BIGNUM * 2 * (pageNum<3?4:pageNum) * (rect.size.width), scrollView.frame.size.height);
            [self creatPageControl:pageControlWidth];
        }
        cpage = 0;
        [self updatePagePlacement];
        if (pageNum > 1 && isAuto) {
            [self creatTimer];
        }
    }
    return self;
}

- (void)creatPageControl:(CGFloat)pageControlWidth
{
    float pagecontrolHeight = 3.5;
    if (!pageControl) {
        pageControl = [[MyPageViewController alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-11.5, kDeviceWidth, pagecontrolHeight)];
        pageControl.numberOfPages = pageNum;
        //        pageControl.contentMode = UIViewContentModeCenter;
        //        pageControl.enabled = NO;
        //        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        //        [self pageChanged:pageControl];
    }
    //    pageControl.frame = CGRectMake(kDeviceWidth-pageControlWidth, self.bounds.size.height-24, pageControlWidth, pagecontrolHeight);
    //    pageControl.frame = CGRectMake(0, self.bounds.size.height-24, kDeviceWidth, pagecontrolHeight);
}

///  页面赋值根据内容
///
///  @param page 当前的页面
-(void)assignValuebyTheIndexPage:(int)page
{
    NSDictionary *dic = nil;
    @try {
        dic = [imageArray objectAtIndex:page%pageNum];
    }
    @catch (NSException *exception) {
        
    }
    UIView *backView = [self viewWithTag:2003];
    if (backView)
    {
        [self bringSubviewToFront:backView];
        UILabel * dateLabel = (UILabel *)[self viewWithTag:2005];
        if (dic.allKeys.count)
        {
            dateLabel.text = dic[@"timeType"];
            [delegate changeViewDataWith:dic];
        }
    }
}

- (void)creatTimer
{
    m_playPicTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(setPlayAdv) userInfo:nil repeats:YES];
}

- (void)setCreatBackViewStr:(NSMutableArray*)str
{
    UIImageView *imgView;
    if (str.count<pageNum) {
        for (int i =(int)str.count; i<pageNum; i++) {
            imgView = (UIImageView*)[self viewWithTag:Advertising + i];
            [imgView removeFromSuperview];
        }
    }
    
    pageNum = (int)[str count];
    //		pageNum = 3;
    [imageArray removeAllObjects];
    [imageArray addObjectsFromArray:str];
    float pageControlWidth = pageNum*15.0f+10.f;
    
    for (int i = 0; i < (pageNum<3?4:pageNum); i++)
    {
        imgView = (UIImageView*)[self viewWithTag:Advertising + i];
        NSDictionary *dic = [imageArray objectAtIndex:i%pageNum];
        NSString *imgURL = [dic objectForKey:m_imagePath];
        if (!imgView) {
            if (imgURL) {
                //                imgURL = [imgURL stringByAppendingString:path];
                imgView = [[UIImageView alloc] init];
                imgView.tag = Advertising + i;
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                //            imgView.backgroundColor = [CommonImage colorWithHexString:[arra objectAtIndex:i]];
                imgView.frame = CGRectMake(0.0f, 0.0f, kDeviceWidth, scrollView.height);
                imgView.clipsToBounds = YES;
                [scrollView addSubview:imgView];
                [imgView release];
                //                [CommonImage setPicImageQiniu:imgURL View:imgView Type:2 Delegate:nil];
                [CommonImage setImageFromServer:imgURL View:imgView Type:2];
            }
        }else{
            //            [CommonImage setPicImageQiniu:imgURL View:imgView Type:2 Delegate:nil];
            [CommonImage setImageFromServer:imgURL View:imgView Type:2];
        }
    }
    
    if (pageNum == 1) {
        scrollView.contentSize = CGSizeMake(kDeviceWidth, 0);
        
    }else{
        scrollView.contentSize = CGSizeMake(BIGNUM * 2 * (pageNum<3?4:pageNum) * (self.size.width), scrollView.frame.size.height);
        [self creatPageControl:pageControlWidth];
    }
    cpage = 0;
    [self updatePagePlacement];
    if (pageNum > 1 && m_isAuto) {
        [self creatTimer];
    }
}

- (void)pageChanged:(UIPageControl*)pc
{
    NSArray *subViews = pc.subviews;
    for (int i = 0; i < [subViews count]; i++) {
        UIView* subView = [subViews objectAtIndex:i];
        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
            ((UIImageView*)subView).image = (pc.currentPage == i ? [UIImage imageNamed:@"img.bundle/common/dianyi.png"] : [UIImage imageNamed:@"img.bundle/common/dianer.png"]);
        }
    }
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if ([imageArray count]) {
        if ([delegate respondsToSelector:@selector(touchAdvertising:)]) {
            [delegate touchAdvertising:[imageArray objectAtIndex:cpage%pageNum]];
        }
    }
}

- (void)updatePagePlacement
{
    CGPoint offset = scrollView.contentOffset;
    // Current Page
    UIView *v = [scrollView viewWithTag:Advertising + cpage];
    CGRect newframe = CGRectMake(offset.x, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
    //赋值
    [self assignValuebyTheIndexPage:cpage];
    if (!CGRectEqualToRect(newframe, v.frame)) v.frame = newframe;
    
    // Pages to the left
    int half = ((pageNum<3?4:pageNum) / 2);
    float dx = -scrollView.frame.size.width * half;
    for (int i = 0; i < half; i++)
    {
        int tag = (cpage + i + (pageNum<3?4:pageNum) - half) % (pageNum<3?4:pageNum);
        
        UIView *v = [scrollView viewWithTag:Advertising + tag];
        CGRect newframe = CGRectMake(offset.x + dx, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        if (!CGRectEqualToRect(newframe, v.frame))
            v.frame = newframe;
        dx += scrollView.frame.size.width;
    }
    
    // Pages to the right
    int nleft = (pageNum<3?4:pageNum) - half;
    dx = scrollView.frame.size.width;
    for (int i = 1; i < nleft; i++)
    {
        int tag = (cpage + i + (pageNum<3?4:pageNum)) % (pageNum<3?4:pageNum);
        
        UIView *v = [scrollView viewWithTag:Advertising + tag];
        CGRect newframe = CGRectMake(offset.x + dx, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        if (!CGRectEqualToRect(newframe, v.frame))
            v.frame = newframe;
        dx += scrollView.frame.size.width;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewt
{
    [self updatePagePlacement];
    UILabel * lab = (UILabel*)[self viewWithTag:55];
    if (lab) {
        lab.text = imageArray[pageControl.currentPage][@"title"];
    }
    m_lastTime = [CommonDate getLongTime];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGFloat pageWidth = aScrollView.frame.size.width;
    //    NSLog(@"%f",offset.x);
    cpage = (int)(floor((offset.x - pageWidth / 2) / pageWidth) + 1 ) % (pageNum<3?4:pageNum);
    
    pageControl.currentPage = cpage%pageNum;
    //	[self pageChanged:pageControl];
    
    //	NSDictionary *dic = [imageArray objectAtIndex:cpage];
    //	[noteTitle setText:[dic objectForKey:@"description"]];
}

- (void)setShowImageViewIndex:(int)index
{
    int page = index - cpage;
    CGPoint offset = CGPointMake(scrollView.contentOffset.x+ self.frame.size.width*page,0);
    
    [UIView animateWithDuration:0.5//速度0.7秒
                     animations:^{//修改坐标
                         //                         scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+self.frame.size.width,0);
                         scrollView.contentOffset = offset;
                     } completion:^(BOOL f){
                         [self updatePagePlacement];
                     }];
    
    m_lastTime = [CommonDate getLongTime]+4;
}

- (void)setPlayAdv
{
    long nowTime = [CommonDate getLongTime];
    if (nowTime - m_lastTime < 4) {
        return;
    }
    
    m_lastTime = [CommonDate getLongTime];
    
    [UIView animateWithDuration:0.5//速度0.7秒
                     animations:^{//修改坐标
                         scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+self.frame.size.width,0);
                     } completion:^(BOOL f){
                         [self updatePagePlacement];
                         UILabel * lab = (UILabel*)[self viewWithTag:55];
                         if (lab) {
                             lab.text = imageArray[pageControl.currentPage][@"title"];
                         }
                     }];
}

- (void)startPlayAdv
{
    if (!m_playPicTimer) {
        return;
    }
    [m_playPicTimer setFireDate:[NSDate date]]; //继续。
    //	[m_playPicTimer setFireDate:[NSDate distantPast]];//开启
    //	[m_playPicTimer setFireDate:[NSDate distantFuture]];//暂停
}

- (void)pausePlayAdv
{
    if (!m_playPicTimer) {
        return;
    }
    [m_playPicTimer setFireDate:[NSDate distantFuture]];//暂停
}

- (int)getCpage
{
    return cpage;
}

- (void)dealloc
{
    [scrollView release];
    scrollView = nil;
    
    if (m_playPicTimer) {
        [m_playPicTimer invalidate];
        m_playPicTimer = nil;
    }
    
    //    [noteTitle release];
    delegate=nil;
    
    if (pageControl) {
        [pageControl release];
    }
    if (imageArray) {
        [imageArray release];
        imageArray=nil;
    }
    [super dealloc];
}

@end