//
//  LeftSliderViewController.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/1/15.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "LeftSliderViewController.h"
#import <Accelerate/Accelerate.h>

static NSInteger const kLeftSliderViewTag = 100513;
//static NSInteger const kSidebarWidth = 240.0;// 侧栏宽度，设屏宽为320，右侧留一条空白可以看到背后页面内容
static float const duration = 0.3;

@interface LeftSliderViewController ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouchPotin; // 手指按下时的坐标
    CGFloat startContentOriginX; // 移动前的窗口位置
    BOOL _isMoving;
    UIPanGestureRecognizer *m_panGesture;
    float kSidebarWidth;
}

//@property (nonatomic, retain) UIImageView* snapImageView;
//@property (nonatomic, retain) UIView* blurView;

@end

@implementation LeftSliderViewController
@synthesize canSwipe;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        canSwipe = YES;
        kSidebarWidth = kDeviceWidth -75*kRelativity6DeviceWidth;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)] ;
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    CGRect rect = CGRectMake(-kSidebarWidth, 0, kSidebarWidth, self.view.bounds.size.height);
    self.contentView = [[UIView alloc] initWithFrame:rect];
    self.view.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.shadowColor = [CommonImage colorWithHexString:@"666666"].CGColor;//shadowColor阴影颜色
    self.contentView.layer.shadowOffset = CGSizeMake(5,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.contentView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
   self.contentView.layer.shadowRadius = 4;//阴影半径，默认3
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 手势响应
- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    [self autoShowHideSidebar];
}

#pragma mark Private

-(void)setUpContentView
{
    if (!self.canSwipe)
    {
        self.view.hidden = NO;
        return;
    }
    UIView *viewContent = [[UIView alloc] initWithFrame:self.contentView.bounds];
    viewContent.clipsToBounds = YES;
    
    for (UIView *subview in self.view.subviews)
    {
        [viewContent addSubview:subview];
    }
    [self.view removeAllSubviews];
    [self.contentView addSubview:viewContent];
    [self.view addSubview:self.contentView];
    self.view.backgroundColor = [UIColor clearColor];
}
#pragma mark - 显示/隐藏
- (BOOL)isSidebarShown
{
    return self.contentView.frame.origin.x > -kSidebarWidth ? YES :NO;
}

- (void)showHideSidebar
{
    if (self.contentView.frame.origin.x == -kSidebarWidth) {
        NSLog(@"开始时在-点");
        [self beginShowSidebar]; // step1
    }
    [self autoShowHideSidebar]; // step2
}


- (void)autoShowHideSidebar
{
    if (!self.isSidebarShown)
    {
        NSLog(@"自动弹出");
        self.view.hidden = NO;
        UIView *mainView  = self.view.superview;
        if (mainView)
        {
            UIView *leftView =  [mainView viewWithTag:kLeftSliderViewTag];
            [mainView bringSubviewToFront:leftView];
        }
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            [self sidebarDidShown];
        }];
    }
    else
    {
        NSLog(@"自动缩回");
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:-kSidebarWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if (point.x < kSidebarWidth) {
        return NO;
    }
    return  YES;
}

- (void)panDetected:(UIPanGestureRecognizer *)recoginzer
{
   
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    CGFloat offsetX = touchPoint.x - startTouchPotin.x;
    
    CGPoint translation = [recoginzer translationInView:recoginzer.view];
    if (translation.x < 0 && self.view.hidden)
    {
        return;
    }
     NSLog(@"\n pan Detected -- %@",NSStringFromCGPoint(translation));
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        startTouchPotin = touchPoint;
        if (absX > absY)
        {
            _isMoving = YES;
            self.view.hidden = NO;
            [self beginShowSidebar];
        }
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        NSLog(@"└ Pan End ---%d",offsetX);
        if (offsetX > 50 || ((int)startContentOriginX==0 && offsetX<0 && offsetX>-20)) // 右滑大于40，或展开时左滑一丁点
        {
            [self slideToRightOccured]; // 即将显示到底
            NSLog(@"显示到底----->");
            self.view.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [self setSidebarOriginX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                [self sidebarDidShown];
            }];
        }
        else
        {
            NSLog(@"<-----隐藏到底");
            [UIView animateWithDuration:0.3 animations:^{
                [self setSidebarOriginX:-kSidebarWidth];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.view.hidden = YES;
            }];
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"Pan Cancelled");
        [UIView animateWithDuration:0.3 animations:^{
            [self setSidebarOriginX:-kSidebarWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self setSidebarOffset:offsetX];
        NSLog(@"Moving …… touch=%f, offset=%f", touchPoint.x, offsetX);
    }
}

/*
 * 设置侧栏相对于开始点击时的偏移
 * offset>0向右，offset<0向左
 */
- (void)setSidebarOffset:(CGFloat)offset
{
    NSLog(@"startContentOriginX = %f", startContentOriginX);
    CGRect rect = self.contentView.frame;
    
    if (offset >=0) { // 右滑
        // 如果不在最右
        if (rect.origin.x<0) {
            rect.origin.x = startContentOriginX + offset; // 直接向右偏移这么多
            if (rect.origin.x > 0) {
                rect.origin.x = 0;
            }
        }
    } else { // 左滑
        // 如果不在最左
        if (rect.origin.x > -kSidebarWidth) {
            rect.origin.x = startContentOriginX + offset;
            if (rect.origin.x < -kSidebarWidth) {
                rect.origin.x = -kSidebarWidth;
            }
        }
    }
    [self.contentView setFrame:rect];
    //    [self setBlurViewAlpha];
}

- (void)beginShowSidebar
{
    // 记录按下时的x位置
    startContentOriginX = self.contentView.frame.origin.x;
    
    if (self.contentView.frame.origin.x < 0) { //self.blurView.alpha < 0.5 &&
        // 截图
//        self.snapImageView.image = [CommonImage imageWithView:self.view.superview];
//        __block typeof(self) bself = self;
//        dispatch_queue_t queue = dispatch_queue_create("cn.lugede.LLBlurSidebar", NULL);
//        dispatch_async(queue, ^ {
//           UIImage *blurImage = [self blurryImage:bself.snapImageView.image withBlurLevel:0.2];
//            UIImage *blurImage = self.snapImageView.image;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                bself.blurView.layer.contents = (id)blurImage.CGImage;
//                NSLog(@"Blur Success !~~~~~~~~~~~~~~~~~");
//            });
//        });
    }
}

#pragma mark - 侧栏出来
/*
 * 设置侧栏位置
 * 完全不显示时为x=-kSidebarWidth，显示到最右时x=0
 */
- (void)setSidebarOriginX:(CGFloat)x
{
    CGRect rect = self.contentView.frame;
    rect.origin.x = x;
    [self.contentView setFrame:rect];
    //    [self setBlurViewAlpha];
}

#pragma mark 子类中可用的
- (void)slideToRightOccured
{
    NSLog(@"触发了右滑事件，需要时可以在子类中用");
}

- (void)sidebarDidShown
{
    NSLog(@"已经完成显示，需要时可以在子类中用");
}
#pragma mark - PrivateMethod
+(LeftSliderViewController *)showLeftSliderViewControllerWithMainViewController:(CommonViewController *)mainViewController
{
    LeftSliderViewController *leftView = [[self alloc] init];
    leftView.view.tag = kLeftSliderViewTag;
    [mainViewController.navigationController.view addSubview:leftView.view];
    
    [leftView panGestureRecognizerEnble:YES WithMainViewController:mainViewController];
    return leftView;
}

-(void)panGestureRecognizerEnble:(BOOL)enble WithMainViewController:(CommonViewController *)mainViewController
{
    if (!m_panGesture)
    {
        m_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMainDetected:)];
        [mainViewController.navigationController.view addGestureRecognizer:m_panGesture];
    }
    m_panGesture.enabled = enble;
}

- (void)panMainDetected:(UIPanGestureRecognizer*)recoginzer
{
    UIView *mainView  =  recoginzer.view;
    UIView *leftView =  [mainView viewWithTag:kLeftSliderViewTag];
    [mainView bringSubviewToFront:leftView];
    LeftSliderViewController *leftViewController = leftView.nextResponder;
    if (leftViewController)
    {
        [leftViewController panDetected:recoginzer];
    }
}

@end
