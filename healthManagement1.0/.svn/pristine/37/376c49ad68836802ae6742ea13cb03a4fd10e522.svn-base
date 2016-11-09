//
//  BookChallengeViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-12-1.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "BookChallengeViewController.h"
#import "StepUserHeadView.h"
#import "MyKeyValueView.h"

@interface BookChallengeViewController ()
{
    UIScrollView *myStepInfoScrollView;
    __block  MBProgressHUD *hub;
    
    BOOL isDoFlag;//是否是拒绝;
    
    NSMutableDictionary *m_dicInfo;
}
@end

@implementation BookChallengeViewController

- (void)dealloc
{
    hub = nil;
    self.resultDic = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"挑战书";
        isDoFlag = NO;
        self.log_pageID = 118;
        
        m_dicInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.resultDic[@"broadcastId"] forKey:@"id"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetLetterOfChallenge values:dic requestKey:GetLetterOfChallenge  delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)sendChallengeResultRequest:(NSString *)type
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    [requestDic setValue:self.resultDic[@"pkId"] forKey:@"id"];
    [requestDic setValue:type forKey:@"type"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UpdateChallenge  values:requestDic requestKey:UpdateChallenge  delegate:self controller:self actiViewFlag:1 title:nil];
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
    
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        
         NSDictionary *bodyDic = dic[@"body"];
        
//        NSString *msgString = dic[@"head"][@"msg"];
        

        
        if ([loader.username isEqualToString:UpdateChallenge]){
            NSString *tell =  @"操作成功!";

            hub =  [Common ShowMBProgress:self.view MSG:tell Mode:MBProgressHUDModeText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hub removeFromSuperview];
                hub =   nil;
            });          
        }
        else if ([loader.username isEqualToString:ConfirmChallengeRequest] ||[loader.username isEqualToString:RefuseChallengeRequest] ){
        
            //操作成功后，操作按钮置为灰色
            isDoFlag = YES;
            
            UIButton *refuseBtn = (UIButton *)[myStepInfoScrollView viewWithTag:110];
            UIButton *agreeBtn = (UIButton *)[myStepInfoScrollView viewWithTag:111];
            refuseBtn.enabled = NO;
            agreeBtn.enabled = NO;
            
            NSString *tell =  @"操作成功!";
            
            hub =  [Common ShowMBProgress:self.view MSG:tell Mode:MBProgressHUDModeText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hub removeFromSuperview];
                hub =   nil;
            });
            
        }else if ([loader.username isEqualToString:GetLetterOfChallenge]) {
        
            self.resultDic = bodyDic[@"info"];
            [self getViews];
        }
    }
    else {
        
          [Common TipDialog:dic[@"head"][@"msg"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getData];
    

}

- (void)getViews
{

    myStepInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44)];
    myStepInfoScrollView.userInteractionEnabled = YES;
    [self.view addSubview:myStepInfoScrollView];
    [myStepInfoScrollView release];

    myStepInfoScrollView.backgroundColor = [UIColor whiteColor];
//    self.view = myStepInfoScrollView;
    
    //头信息
    StepUserHeadView *userHeadView = [[StepUserHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100)];
    userHeadView.resultDic = self.resultDic;
    [userHeadView getHeadView];
    [myStepInfoScrollView addSubview:userHeadView];
    [userHeadView release];
    
    //累计计步
    MyKeyValueView *view1 = [[MyKeyValueView alloc] initWithFrame:CGRectMake(0, userHeadView.size.height, kDeviceWidth, 45)];
    
    [view1 getCellViewWithKey:@"总步数" ValueString:[NSString stringWithFormat:@"%@ 步",self.resultDic[@"totalStepCnt"]] index:0 hasAccessView:NO];
    [myStepInfoScrollView addSubview:view1];
    [view1 release];
    //累计里程
    MyKeyValueView *view2 = [[MyKeyValueView alloc] initWithFrame:CGRectMake(0, view1.origin.y+view1.size.height, kDeviceWidth, 45)];
    [view2 getCellViewWithKey:@"总里程" ValueString:[NSString stringWithFormat:@"%.2f 公里",[self.resultDic[@"totalDistance"] floatValue]/1000 ] index:0 hasAccessView:NO];
    [myStepInfoScrollView addSubview:view2];
    [view2 release];
    //全国排名
    MyKeyValueView *view3 = [[MyKeyValueView alloc] initWithFrame:CGRectMake(0, view2.origin.y+view2.size.height, kDeviceWidth, 45)];
    [view3 getCellViewWithKey:@"总排名" ValueString:[NSString stringWithFormat:@"%@ 名",self.resultDic[@"rank"]] index:0 hasAccessView:NO];
    [myStepInfoScrollView addSubview:view3];
    //开始时间
    //全国排名
    MyKeyValueView *view4 = [[MyKeyValueView alloc] initWithFrame:CGRectMake(0, view3.origin.y+view3.size.height, kDeviceWidth, 45)];//self.resultDic[@"startTime"]
    [view4 getCellViewWithKey:@"发送时间" ValueString:[NSString stringWithFormat:@"%@",self.resultDic[@"createDate"]] index:0 hasAccessView:NO];
    [myStepInfoScrollView addSubview:view4];
    
    
    [view3 release];
    //比赛周期 多少 天
    CGFloat originY = 15;
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, view4.origin.y+view4.size.height+originY, 200, 15)];
    keyLabel.font = [UIFont systemFontOfSize:16];
    keyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    keyLabel.attributedText = [self replaceWithNSString:[NSString stringWithFormat:@"比赛周期 %@ 天",self.resultDic[@"gameCycle"]] andUseKeyWord:[NSString stringWithFormat:@"%@",self.resultDic[@"gameCycle"]] andWithFontSize:16 keywordColor:@"fe6339"];
    [myStepInfoScrollView addSubview:keyLabel];
    [keyLabel release];
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(15, view4.origin.y+view4.size.height+44.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView  addSubview:lineView];
    [lineView release];
    //失败胜利说明
    CGFloat width = (kDeviceWidth - 40)/2.0f;
    UILabel *showLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.origin.y+lineView.size.height, width, 45)];
    showLeftLabel.tag = 60;
    showLeftLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    showLeftLabel.text = [NSString stringWithFormat:@"胜出：+%@ 积分",self.resultDic[@"gameChips"]];;
    [myStepInfoScrollView addSubview:showLeftLabel];
    [showLeftLabel release];
    UILabel *showRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+width, lineView.origin.y+lineView.size.height, width, 45)];
    showRightLabel.tag = 61;
    showRightLabel.textAlignment = NSTextAlignmentRight;
    showRightLabel.textColor = [CommonImage colorWithHexString:@"479aff"];
    showRightLabel.text = [NSString stringWithFormat:@"失败：-%@ 积分",self.resultDic[@"gameChips"]];
    [myStepInfoScrollView addSubview:showRightLabel];
    [showRightLabel release];
    
    UIView *alineView  = [[UIView alloc] initWithFrame:CGRectMake(0, showLeftLabel.origin.y+showLeftLabel.size.height-0.5,kDeviceWidth, 0.5)];
    alineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:alineView];
    [alineView release];
    
    //挑战规则
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, alineView.origin.y+alineView.size.height+20, 80, 17)];
    textLabel.font = [UIFont boldSystemFontOfSize:16];
    textLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    textLabel.text = @"挑战规则：";
    [myStepInfoScrollView addSubview:textLabel];
    [textLabel release];
    //胜出
    NSString *aString = self.resultDic[@"rule"];//@"胜出：在挑战时间内每天走5000步以上，挑战时间截止后平均每天步数多的人胜出。\n\n打平：在挑战时间内每天走步5000步以上结束后双方平均步数一样则打平，被挑战者将赢得积分。\n\n失败：挑战期间如有一天少于5000步即为失败。";
    CGSize size = [aString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kDeviceWidth-40+1, 9999)];
    
    UILabel *winLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, textLabel.origin.y+textLabel.size.height+8, kDeviceWidth-40, size.height)];
    winLabel.font = [UIFont systemFontOfSize:14];
    winLabel.numberOfLines = 0;
    winLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    winLabel.text = aString;
    [myStepInfoScrollView addSubview:winLabel];
    [winLabel release];
    
    if([self.resultDic[@"pk_status"] intValue] ==  1){//1为申请中 2为进行中 3为完成
        
        //拒绝
        [self getBtnWithTitle:@"这次算了" Frame:CGRectMake(20,winLabel.origin.y + winLabel.size.height +30, 135, 44) imageName:@"common.bundle/move/move_btn_orange_normal.png" tag:110];
        //同意
        [self getBtnWithTitle:@"应战" Frame:CGRectMake(kDeviceWidth-20-135,winLabel.origin.y + winLabel.size.height +30, 135, 44) imageName:@"common.bundle/common/green_normal.png" tag:111];
        
        myStepInfoScrollView.contentSize = CGSizeMake(kDeviceWidth,winLabel.origin.y + winLabel.size.height+30 + 44 +20);
    }else{
        myStepInfoScrollView.contentSize = CGSizeMake(kDeviceWidth,winLabel.origin.y + winLabel.size.height+30 +20);
        
    }

    
}


/**
 *  获得头部
 *
 *  @param aString
 *  @param rect
 *  @param imageName
 *  @param aTag      
 */
- (void)getBtnWithTitle:(NSString *)aString Frame:(CGRect)rect imageName:(NSString *)imageName tag:(int)aTag
{
    
    //发起挑战
    UIButton* withBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withBtn.frame = rect;
    withBtn.tag = aTag;
    
    UIImage* image =
    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:5
                                                        topCapHeight:5];
    
    [withBtn setBackgroundImage:image forState:UIControlStateNormal];
    [withBtn setTitle:NSLocalizedString(aString, nil)
             forState:UIControlStateNormal];
    withBtn.layer.cornerRadius = 4;
    
    [withBtn addTarget:self
                action:@selector(btnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [myStepInfoScrollView addSubview:withBtn];
    
}

- (void)btnClicked:(UIButton *)btn
{
    if(btn.tag == 110){
        //这次算了
//        [self sendChallengeResultRequest:@"0"];
        [self refuseChangllengeRequest];

        
    }else if(btn.tag == 111){
        //应战
//        [self sendChallengeResultRequest:@"2"];
        [self confirmChallengeRequest];

    }
    
}

- (void)confirmChallengeRequest
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.resultDic[@"pkId"] forKey:@"id"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:ConfirmChallengeRequest values:dic requestKey:ConfirmChallengeRequest delegate:self controller:self actiViewFlag:0 title:nil];
    
}

- (void)refuseChangllengeRequest
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.resultDic[@"pkId"] forKey:@"id"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:RefuseChallengeRequest values:dic requestKey:RefuseChallengeRequest delegate:self controller:self actiViewFlag:0 title:nil];

}

- (NSMutableAttributedString *)replaceWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size keywordColor:(NSString *)colorString
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    if(!keyWord){
        return attrituteString;
    }
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:colorString], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
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
