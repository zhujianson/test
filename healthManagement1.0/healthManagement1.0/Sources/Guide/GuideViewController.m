//
//  ViewController.m
//  GuideViewController
//
//  Created by 发兵 杨 on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "Common.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LocationManager.h"
#import "Global_Url.h"

@interface GuideViewController()
{
    
    UIButton *musicBtn;
    __block AVAudioPlayer *player;

    
}

@property (nonatomic,retain) NSArray *imageArray;
@property (nonatomic,retain) UIImageView * imageView;
@property (nonatomic,retain) UIImageView * backImageView;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) BOOL working;

@end

@implementation GuideViewController

@synthesize imageView,backImageView,imageArray,index;


- (void)dealloc
{
    self.imageArray = nil;
    self.backImageView = nil;
    self.imageView = nil;
    [player release];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    self.imageArray = @[@"common.bundle/guide/001.jpg",@"common.bundle/guide/002.jpg",@"common.bundle/guide/003.jpg",@"common.bundle/guide/004.jpg",@"common.bundle/guide/005.jpg"];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backImageView];
    [backImageView release];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:imageArray[0]];
    [self.view addSubview:imageView];
    [imageView release];

    
    UIImageView  *backeImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backeImageView.image = [UIImage imageNamed:@"common.bundle/guide/backview.png"];
    [self.view addSubview:backeImageView];
    [backeImageView release];
    
    UIImage *rightImage = [UIImage imageNamed:@"common.bundle/guide/rightimage.png"];
    CGFloat radio = 1;//kDeviceWidth/1142*2.0f;
    CGFloat width = rightImage.size.width * radio;
    CGFloat height = width * rightImage.size.height/rightImage.size.width;
    
    UIImageView  *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-15-width, 35, width, height)];
    rightImageView.image = [UIImage imageNamed:@"common.bundle/guide/rightimage.png"];
    [self.view addSubview:rightImageView];
    [rightImageView release];
    
    UIImage *leftImage = [UIImage imageNamed:@"common.bundle/guide/leftimage.png"];
    width = leftImage.size.width * radio;
    height = width * leftImage.size.height/leftImage.size.width;
    
    UIImageView  *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, width, height)];
    leftImageView.image = leftImage;
    [self.view addSubview:leftImageView];
    [leftImageView release];
    

    UIImage *musicImage = [UIImage imageNamed:@"common.bundle/guide/music_nor.png"];
    CGFloat m_width = musicImage.size.width * radio;
    height = m_width * musicImage.size.height/musicImage.size.width;

    musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    musicBtn.frame = CGRectMake(15+(width-m_width)/2.0f, leftImageView.bottom+10, m_width, height);
    [musicBtn setImage:[UIImage imageNamed:@"common.bundle/guide/music_pre.png"] forState:UIControlStateNormal];
    [musicBtn setImage:[UIImage imageNamed:@"common.bundle/guide/music_nor.png"] forState:UIControlStateHighlighted];
    [musicBtn setImage:[UIImage imageNamed:@"common.bundle/guide/music_nor.png"] forState:UIControlStateSelected];
    [self.view addSubview:musicBtn];
    [musicBtn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *startImage = [UIImage imageNamed:@"common.bundle/guide/beginimage.png"];
    width = startImage.size.width * radio;
    height = width * startImage.size.height/startImage.size.width;

    gotoMainViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];//
    gotoMainViewBtn.frame = CGRectMake((kDeviceWidth-width)/2, SCREEN_HEIGHT+20-120, width, height);

    [gotoMainViewBtn setImage:startImage forState:UIControlStateNormal];
    [gotoMainViewBtn addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoMainViewBtn];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusicFunc) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startMusicFunc) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    [self startMusicFunc];
    
    [self playMusic:musicBtn];//默认播放

}

- (void)stopMusicFunc
{
     musicBtn.selected = NO;
    [self removeAnimation];
    [player pause];


}

- (void)startMusicFunc
{
    if(player){
    musicBtn.selected = YES;
    [self actionbuttonAnamation];
    [player play];
    }
}


-(void)actionbuttonAnamation
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotation.duration = 2; // Speed
    rotation.removedOnCompletion = NO;
    rotation.fillMode = kCAFillModeForwards;
    rotation.repeatCount = 9999; // Repeat forever. Can be a finite number.
    [musicBtn.imageView.layer addAnimation:rotation forKey:@"Spin"];
}

- (void)removeAnimation
{
    [musicBtn.imageView.layer removeAllAnimations];
}

- (void)playMusic:(UIButton *)btn
{
    if(player){
        if(player.playing){
            //暂停转
            btn.selected = NO;
             [self removeAnimation];
            [player pause];
        }else{
            // 转
            btn.selected = YES;
            [self actionbuttonAnamation];
            [player play];
        }
        
        return;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"common.bundle/mp3/guidemusic.mp3" ofType:nil];
    NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
    NSError * error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    player.volume = 0.5;
    player.numberOfLoops = -1; //Infinite
    [player prepareToPlay];
    [player play];
    [self actionbuttonAnamation];
    btn.selected = YES;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.index = 1;
    self.working = YES;
    [self addImageFun];

}

- (void)addImageFun
{
    if(self.working == NO){
        
        return;
    }
    
    __block typeof(self) wself = self;
    
    int locaIndex = index;
    if(locaIndex == 5){
        locaIndex = 0;
    }
    wself.backImageView.image = [UIImage imageNamed:wself.imageArray[locaIndex]];
    wself.imageView.alpha = 1;
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{

        wself.imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{

            wself.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            wself.imageView.alpha = 0;
            
            wself.backImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            
//            wself.imageView.transform = CGAffineTransformIdentity;
            wself.imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            wself.backImageView.transform = CGAffineTransformIdentity;
            
//            imageView.alpha = 1;
            if(index == 5){
                index = 0;
            }
            wself.imageView.image = [UIImage imageNamed:wself.imageArray[index]];
            
            index++;
            [wself addImageFun];
            
        }];
        
    }];
    
}


- (IBAction)gotoMainView:(id)sender
{
    self.working = NO;
    [player stop];
    
    gotoMainViewBtn.enabled = NO;
    
	NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
	NSString *newGuideVersion = [infoDic objectForKey:@"GuideVersion"];
	[[NSUserDefaults standardUserDefaults] setObject:newGuideVersion forKey:@"GuideVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginViewController *mainViewController = [[LoginViewController alloc] init];
    
    UIViewController *view = [[CommonNavViewController alloc] initWithRootViewController:mainViewController];
    mainViewController.navigationController.navigationBar.hidden = YES;
    [mainViewController release];
    
    UIImage *nowViewImage = [CommonImage imageWithView:self.view];
    UIImage *mainViewImage = [CommonImage imageWithView:mainViewController.view];
    
    UIImageView *mainView = [[UIImageView alloc] initWithImage:mainViewImage];
    mainView.frame = self.view.bounds;
    [self.view addSubview:mainView];
    [mainView release];
    
    UIImageView *nowView = [[UIImageView alloc] initWithImage:nowViewImage];
    nowView.frame = self.view.bounds;
    [self.view addSubview:nowView];
    [nowView release];
    
    [UIView animateWithDuration:0.35 animations:^ {
        nowView.transform = CGAffineTransformMakeTranslation(0, -kDeviceHeight);
    }completion:^(BOOL finished) {
        APP_DELEGATE.rootViewController = view;
        [view release];
    }];

    //申请地理位置权限
    [[LocationManager sharedManager] requestLocationAuthorization];
}

@end
