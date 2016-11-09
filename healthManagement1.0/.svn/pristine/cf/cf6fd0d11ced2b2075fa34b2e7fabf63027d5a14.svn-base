//
//  DiseaseInfoViewController.m
//  jiuhaoHealth2.0
//
//  Created by wangmin on 14-4-11.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "DiseaseInfoViewController.h"

@interface DiseaseInfoViewController ()
<UIWebViewDelegate>
{
    
    UIView *headView;//头view
    int currentChoice;
    UIWebView *webView;
}

@property (nonatomic,retain) UIButton *currentSelectedBtn;//当前选中的button
@property (nonatomic,retain) NSMutableArray *selectedArray;//选中的数组
@end

@implementation DiseaseInfoViewController
- (void)dealloc
{
    self.thirdName = nil;
    self.currentSelectedBtn = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.selectedArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 55, kDeviceWidth, SCREEN_HEIGHT-44-55)];
    webView.delegate = self;
    webView.backgroundColor = self.view.backgroundColor;
    webView.opaque = NO;
    [self.view addSubview:webView];
    [webView release];
//    [webView loadHTMLString:self.diseaseArray[0] baseURL:[[NSBundle mainBundle] resourceURL]];
//    for (UIView *aView in [webView subviews])
//    {
//        if ([aView isKindOfClass:[UIScrollView class]])
//        {
//            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
//            
//            for (UIView *shadowView in aView.subviews)
//            {
//                
//                if ([shadowView isKindOfClass:[UIImageView class]])
//                {
//                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
//                }
//            }
//        }
//    }
    //获得选择按钮
    [self getChoiceView];

}
/**
 *  得到选项卡view
 */
- (void)getChoiceView
{
    NSArray *titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"简介", nil),NSLocalizedString(@"病因", nil) , self.thirdName,NSLocalizedString(@"诊断", nil), nil];
    
    UIButton *button = nil;
    
    CGFloat width = kDeviceWidth/4.0f;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 55)];
    headView.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];
    [self.view addSubview:headView];
    [headView release];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, kDeviceWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    line.alpha = 0.3;
    [headView addSubview:line];
    [line release];
    
    CGFloat offset = 10.0f;
    
    width = 75.0f;
    
    NSArray *normalImgArray = @[@"img.bundle/check/left_nor.png",@"img.bundle/check/mid_nor.png",@"img.bundle/check/mid_nor.png",@"img.bundle/check/right_nor.png"];
    NSArray *selectedImgArray = @[@"img.bundle/check/left_sel.png",@"img.bundle/check/mid_sel.png",@"img.bundle/check/mid_sel.png",@"img.bundle/check/right_sel.png"];
    
    for(int i = 0;i < 4; i++){
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offset+i*width, 12, width, 30);
        button.tag = 100+i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[CommonImage colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        button.titleLabel.font =[ UIFont systemFontOfSize:15.0f];
        UIImage *norImg = [UIImage imageNamed:normalImgArray[i]];
        UIImage *selectedImg = [UIImage imageNamed:selectedImgArray[i]];
        [button setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        [button setBackgroundImage:norImg forState:UIControlStateNormal];
        [button setBackgroundImage:selectedImg forState:UIControlStateSelected];
        
        
        [button addTarget:self action:@selector(choiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        if(i == 1 || i == 2 || i == 3){
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10+i*width-1, 12, 1, 30)];
            line.backgroundColor = [CommonImage colorWithHexString:@"87c843"];
            line.alpha = 0.3;
            [headView addSubview:line];
            [line release];
        }
        if(i == 0){//默认选中男或女
//            [self choiceButtonClicked:button];
            self.currentSelectedBtn = button;
            self.currentSelectedBtn.selected = YES;
            [webView loadHTMLString:self.diseaseArray[0] baseURL:[[NSBundle mainBundle] resourceURL]];

        }
        
    }
}


#pragma mark - ChoiceButtonClicked Function
- (void)choiceButtonClicked:(UIButton *)choiceBtn
{
    
//    if(isScrolling){
//        
//        return;
//    }
    
    if(self.currentSelectedBtn.tag == choiceBtn.tag){
        
        return;
    }
    
    [self.selectedArray removeAllObjects];
    currentChoice = (int)choiceBtn.tag;
    if(self.currentSelectedBtn){
        self.currentSelectedBtn.selected = NO;
        self.currentSelectedBtn = choiceBtn;
        self.currentSelectedBtn.selected = YES;
    }else{
        
        self.currentSelectedBtn = choiceBtn;
        self.currentSelectedBtn.selected = YES;
    }
    
    //    [choiceBtn setBackgroundColor:[CommonImage colorWithHexString:VERSION_TEXT_COLOR]];
    
    //改变数据源-------
    switch (choiceBtn.tag) {
        case 100:
        {//男
            [webView loadHTMLString:self.diseaseArray[0] baseURL:[[NSBundle mainBundle] resourceURL]];
            
        }
            break;
        case 101:
        {//女
            

            [webView loadHTMLString:self.diseaseArray[1] baseURL:[[NSBundle mainBundle] resourceURL]];

            
        }
            break;
        case 102:
        {//老

            [webView loadHTMLString:self.diseaseArray[2] baseURL:[[NSBundle mainBundle] resourceURL]];

            
        }
            break;
        case 103:
        {//幼

            [webView loadHTMLString:self.diseaseArray[3] baseURL:[[NSBundle mainBundle] resourceURL]];
 
        }
            break;
        default:
            break;
    }
    
    //刷新数组
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
