//
//  SendPkMesViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-29.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SendPkMesViewController.h"
#import "MyKeyValueView.h"
#import "PickerView.h"
#import "AppDelegate.h"
#import "LocationManager.h"

@interface SendPkMesViewController ()
{
    UIScrollView *myStepInfoScrollView;
    NSArray *circleTimeArray;
    NSArray *fenArray;
    __block int  circle;
    __block int fen;
    int myallPoint;
    __block MBProgressHUD* hub;
}

@end

@implementation SendPkMesViewController


- (void)dealloc
{
    hub = nil;
    self.userId = nil;
    if(circleTimeArray){
        
        [circleTimeArray release];
        circleTimeArray = nil;
    }
    if(fenArray){
        
        [fenArray release];
        fenArray = nil;
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"发起挑战";
        NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:0];
        for( int i = 1; i < 31; i++){
            [dateArray addObject:[NSString stringWithFormat:@"%d 天",i]];
        }
        circleTimeArray = [dateArray retain];
        self.log_pageID = 112;
    }
    return self;
}

- (void)getRuleAndPointRequest
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetRuleAndPoint values:requestDic requestKey:GetRuleAndPoint  delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
    

}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
//    if (![[dic objectForKey:@"state"] intValue])
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:GetRuleAndPoint]){
            
             NSDictionary *bodyDic = dic[@"body"];
            NSDictionary *resultDic = bodyDic[@"info"];
            
            myallPoint = [resultDic[@"point"] intValue];
            int allPoint = [resultDic[@"point"] intValue];
            int num = allPoint/5;
            if(num >= 20){
                num = 20;
            }
            NSMutableArray *fenPointArray = [NSMutableArray arrayWithCapacity:0];
            for( int i = 1; i <= num; i++){
                [fenPointArray addObject:[NSString stringWithFormat:@"%d 积分",i*5]];
            }
            fenArray = [fenPointArray retain];
            [self getSubView:resultDic[@"rule"]];
            
        }else if ([loader.username isEqualToString:LaunchPK]){
             NSString *msg = dic[@"head"][@"msg"];
             NSString *message = @"发起挑战成功，等待对方应战！";
            if([msg isEqualToString:@"success"]){
            
            
            }else if([msg isEqualToString:@"147"]){
            
               message = @"挑战申请中，请耐心等待!";
            
            }else if([msg isEqualToString:@"144"]){
                
                message = @"积分不足!";
            }
            
            UIButton *sendBtn = (UIButton *)[myStepInfoScrollView viewWithTag:1111];
            sendBtn.enabled = NO;
            
            if(hub){
                
                [hub removeFromSuperview];
                hub = nil;
            }
            
            hub = [Common ShowMBProgress:self.view MSG:message Mode:MBProgressHUDModeText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hub removeFromSuperview];
                hub = nil;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }
    }else{
    
        [Common TipDialog:dic[@"head"][@"msg"]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myStepInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44)];
    myStepInfoScrollView.userInteractionEnabled = YES;
    [self.view addSubview:myStepInfoScrollView];
    [myStepInfoScrollView release];
    myStepInfoScrollView.contentSize = CGSizeMake(kDeviceWidth, myStepInfoScrollView.size.height+1);
    [self getRuleAndPointRequest];
}

- (void)getSubView:(NSString *)rule
{
    //挑战规则
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 17)];
    textLabel.font = [UIFont boldSystemFontOfSize:16];
    textLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    textLabel.text = @"挑战规则：";
    textLabel.backgroundColor = [UIColor clearColor];
    [myStepInfoScrollView addSubview:textLabel];
    [textLabel release];
    //胜出
//    NSString *aString = @"胜出：在挑战时间内每天走5000步以上，挑战时间截止后平均每天步数多的人胜出。\n\n打平：在挑战时间内每天走步5000步以上结束后双方平均步数一样则打平，被挑战者将赢得积分。\n\n失败：挑战期间如有一天少于5000步即为失败。";
    NSString *aString = rule;
    CGSize size = [aString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kDeviceWidth-40+1, 9999)];
    
    UILabel *winLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, textLabel.origin.y+textLabel.size.height+8, kDeviceWidth-40, size.height)];
    winLabel.font = [UIFont systemFontOfSize:14];
    winLabel.numberOfLines = 0;
    winLabel.backgroundColor = [UIColor clearColor];
    winLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    winLabel.text = aString;
    [myStepInfoScrollView addSubview:winLabel];
    [winLabel release];
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, winLabel.origin.y+winLabel.size.height+18,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:lineView];
    [lineView release];
    
    
    //比赛周期
    MyKeyValueView *cicleView = [[MyKeyValueView alloc] initWithFrame:CGRectMake(0, lineView.origin.y+0.5, kDeviceWidth, 45)];
    NSAttributedString *value = [cicleView replaceWithNSString:@"3 天" andUseKeyWord:nil andWithFontSize:0 keywordColor:nil];
    circle = 3;//提交数据用
    [cicleView getCellViewWithKey:@"比赛周期" Value:value index:0  hasAccessView:YES];
    cicleView.tag = 1000;
    cicleView.backgroundColor = [UIColor whiteColor];
    [myStepInfoScrollView addSubview:cicleView];
    [cicleView release];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, lineView.origin.y+0.5, kDeviceWidth, 45);
    button.backgroundColor = [UIColor clearColor];
    button.tag = 90;
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [myStepInfoScrollView addSubview:button];
    //挑战筹码
    MyKeyValueView *fenView = [[MyKeyValueView alloc] initWithFrame:CGRectMake(0, cicleView.origin.y+cicleView.size.height, kDeviceWidth, 45)];
    fen = 5;
    
    
    NSAttributedString *value2 = [cicleView replaceWithNSString:@"5 积分" andUseKeyWord:nil andWithFontSize:0 keywordColor:nil];
    [fenView getCellViewWithKey:@"挑战筹码" Value:value2 index:0  hasAccessView:YES];
    fenView.tag = 1001;
    fenView.backgroundColor = [UIColor whiteColor];
    [myStepInfoScrollView addSubview:fenView];
    [fenView release];
    UIButton *fenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fenBtn.frame = CGRectMake(0, cicleView.origin.y+cicleView.size.height, kDeviceWidth, 45);
    fenBtn.backgroundColor = [UIColor clearColor];
    fenBtn.tag = 91;
    [fenBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [fenBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [myStepInfoScrollView addSubview:fenBtn];
    if(myallPoint < 5){
        
        fenBtn.enabled = NO;
    }
    
    //失败胜利说明
    CGFloat width = (kDeviceWidth - 40)/2.0f;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, fenView.origin.y+fenView.size.height, kDeviceWidth, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [myStepInfoScrollView addSubview:backView];
    [backView release];
    
    UILabel *showLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, fenView.origin.y+fenView.size.height, width, 45)];
    showLeftLabel.tag = 60;
    showLeftLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    showLeftLabel.backgroundColor = [UIColor clearColor];
    showLeftLabel.text = @"胜出：+5 积分";
    [myStepInfoScrollView addSubview:showLeftLabel];
    [showLeftLabel release];
    UILabel *showRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+width, fenView.origin.y+fenView.size.height, width, 45)];
    showRightLabel.tag = 61;
    showRightLabel.textAlignment = NSTextAlignmentRight;
    showRightLabel.textColor = [CommonImage colorWithHexString:@"479aff"];
    showRightLabel.backgroundColor = [UIColor clearColor];
    showRightLabel.text = @"失败：-5 积分";
    [myStepInfoScrollView addSubview:showRightLabel];
    [showRightLabel release];
    
    UIView *alineView  = [[UIView alloc] initWithFrame:CGRectMake(0, showLeftLabel.origin.y+showLeftLabel.size.height-0.5,kDeviceWidth, 0.5)];
    alineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:alineView];
    [alineView release];
    //发起挑战
    UIButton* withBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withBtn.tag = 1111;
    withBtn.frame = CGRectMake(17.5, alineView.origin.y+alineView.size.height+20, kDeviceWidth-35, 44);
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [withBtn setBackgroundImage:image forState:UIControlStateNormal];
    [withBtn setTitle:NSLocalizedString(@"发起挑战", nil)
             forState:UIControlStateNormal];
    withBtn.layer.cornerRadius = 4;
    withBtn.clipsToBounds = YES;
    
    [withBtn addTarget:self
                action:@selector(sendRequest)
      forControlEvents:UIControlEventTouchUpInside];
    [myStepInfoScrollView addSubview:withBtn];
    
    myStepInfoScrollView.contentSize = CGSizeMake(kDeviceWidth, withBtn.size.height+withBtn.origin.y+20);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //开启定位
    AppDelegate* myAppdelegate = [Common getAppDelegate];
    [myAppdelegate startSignificantChangeUpdates];

}
//发送请求
- (void)sendRequest
{
    if(myallPoint < 5){
    
        if(hub){
            [hub removeFromSuperview];
            hub = nil;
        }
        
        hub = [Common ShowMBProgress:self.view MSG:@"您的积分不足，快去走步赚积分吧！" Mode:MBProgressHUDModeText];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hub removeFromSuperview];
             hub = nil;
        });
        return;
    }
    
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"uidA"];
     [requestDic setObject:self.userId forKey:@"accountB"];
     [requestDic setObject:[NSString stringWithFormat:@"%d",circle] forKey:@"gameCycle"];
     [requestDic setObject:[NSString stringWithFormat:@"%d",fen]forKey:@"gameChips"];
     [requestDic setObject:[NSString stringWithFormat:@"%@#%@",[LocationManager sharedManager].localStateString,[LocationManager sharedManager].localSubLocationString] forKey:@"address"];

//         [requestDic setValue:@"12456" forKey:@"address"];
    
    NSLog(@"---%@",requestDic);
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:LaunchPK values:requestDic requestKey:LaunchPK  delegate:self controller:self actiViewFlag:1 title:nil];
    
    [requestDic release];

    
}

- (void)touchDown:(UIButton *)btn
{
    if(btn.tag == 90){
        UIView *cicleView = [myStepInfoScrollView viewWithTag:1000];
        cicleView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        
    }else{
        UIView *fenView = [myStepInfoScrollView viewWithTag:1001];
        fenView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
    }
    
    
}

- (void)tapView:(UIButton *)btn
{
    if(btn.tag == 90){
        UIView *cicleView = [myStepInfoScrollView viewWithTag:1000];
        UILabel *valueLabel = (UILabel *)[cicleView viewWithTag:100];
        cicleView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        [UIView animateWithDuration:0.5 animations:^{
            cicleView.backgroundColor = [UIColor whiteColor];
        }];
        
        PickerView* myPickerCutom = [[PickerView alloc] init];
        [myPickerCutom createPickViewWithArray:@[ circleTimeArray ] andWithSelectString:nil setTitle:@"请选择比赛周期" isShow:NO];
        [myPickerCutom setPickerViewBlock:^(NSString* content) {
            
            circle =  (int)[circleTimeArray indexOfObject:content]+1;
            valueLabel.text = content;
        }];
        
    }else{
        UIView *fenView = [myStepInfoScrollView viewWithTag:1001];
        fenView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        UILabel *valueLabel = (UILabel *)[fenView viewWithTag:100];
        [UIView animateWithDuration:0.5 animations:^{
            fenView.backgroundColor = [UIColor whiteColor];
        }];
        PickerView* myPickerCutom = [[PickerView alloc] init];
        [myPickerCutom createPickViewWithArray:@[ fenArray ] andWithSelectString:nil setTitle:@"请选择挑战筹码" isShow:NO];
        [myPickerCutom setPickerViewBlock:^(NSString* content) {
            fen = ((int)[fenArray indexOfObject:content]+1)*5;
            valueLabel.text = content;
            UILabel *showLeftLabel = (UILabel *)[myStepInfoScrollView viewWithTag:60];
            showLeftLabel.text = [NSString stringWithFormat:@"胜出：+%@",content];
            UILabel *showRightLabel = (UILabel *)[myStepInfoScrollView viewWithTag:61];
            showRightLabel.text = [NSString stringWithFormat:@"失败：-%@",content];
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
