//
//  FristRunFMViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FristRunFMViewController.h"
#import "PickerView.h"
#import "FoodMatchViewController.h"

@interface FristRunFMViewController ()

@end

@implementation FristRunFMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"膳食配餐工具";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_index = 0;
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 50)];
    labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
    labTitle.font = [UIFont systemFontOfSize:15];
    labTitle.numberOfLines = 0;
    labTitle.text = @"我们根据用户身体情况与营养膳食指南帮助糖尿病人计算每日的进食量和每餐食物比例";
    labTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labTitle];
    [labTitle release];
    
    //选择家人头像
    UIView *familyView = [self createSelFamilyView];
    [self.view addSubview:familyView];
    [familyView release];
    
    //创建输入项
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"身高", @"厘米", @"50", @"250", @"170", @"600", nil] forKeys:[NSArray arrayWithObjects:@"name", @"unit", @"min", @"max", @"default", @"tag", nil]];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"体重", @"公斤", @"20", @"200", @"65", @"601", nil] forKeys:[NSArray arrayWithObjects:@"name", @"unit", @"min", @"max", @"default", @"tag", nil]];
    m_inputArray = [[NSArray alloc] initWithObjects:dic1, dic2, nil];
    UIView *input = nil;
    CGRect rect;
    for (int i = 0; i < 2; i++) {
        input = [self createInputItem:[m_inputArray objectAtIndex:i]];
        rect = input.frame;
        rect.origin.y += i*input.height + familyView.bottom;
        input.frame = rect;
        [self.view addSubview:input];
        [input release];
    }
    
    //选择劳动力
    m_pickerArray = [[NSArray alloc] initWithObjects:@"重体力", @"中体力", @"轻体力", @"卧床", nil];
}

#pragma 选择家人头像
- (UIView*)createSelFamilyView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 80, 180, 150)];
    
    //左边
    UIButton *butLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 122)];
    butLeft.tag = 1001;
    [butLeft setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    butLeft.backgroundColor = [UIColor redColor];
    [butLeft addTarget:self action:@selector(butEventSelFamily:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butLeft];
    [butLeft release];
    
    //头像
    NSDictionary *dic = [m_familyArray objectAtIndex:1];
    UIView *photo = [self createPhoto:dic];
    photo.frame = CGRectMake(butLeft.right, 0, 120, 122);
    [view addSubview:photo];
    [photo release];
    
    //右边
    UIButton *butRight = [[UIButton alloc] initWithFrame:CGRectMake(photo.right, 0, 30, 122)];
    butRight.tag = 1002;
    [butRight setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    butRight.backgroundColor = [UIColor redColor];
    [butRight addTarget:self action:@selector(butEventSelFamily:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butRight];
    [butRight release];
    
    return view;
}

//创建头像
- (UIView*)createPhoto:(NSDictionary*)dic
{
    UIView *view = [[UIView alloc] init];
    view.tag = 500;
    
    UIImageView *imagePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    imagePhoto.tag = 501;
    imagePhoto.layer.cornerRadius = imagePhoto.width/2;
//    imagePhoto.layer.borderColor = [CommonImage colorWithHexString:@"ff0000"].CGColor;
//    imagePhoto.layer.borderWidth = 2;
    imagePhoto.image = [dic objectForKey:@"image"];
    [view addSubview:imagePhoto];
    [imagePhoto release];
    
    UILabel *labName = [Common createLabel:CGRectMake(30, 80, 60, 20) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:[dic objectForKey:@"name"]];
    labName.tag = 502;
    labName.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    labName.layer.cornerRadius = labName.height/2+2;
    labName.clipsToBounds = YES;
    [view addSubview:labName];
    
    UIImageView *imagePhotoYY = [[UIImageView alloc] initWithFrame:CGRectMake(10, imagePhoto.bottom+10, 100, 10)];
    imagePhotoYY.image = [UIImage imageNamed:@""];
    [view addSubview:imagePhotoYY];
    [imagePhotoYY release];
    
    return view;
}

- (void)butEventSelFamily:(UIButton*)but
{
//    if (m_index == 0) {
//        
//        but.enabled = NO;
//    }
//    else if (m_index == [m_familyArray count]) {
//        
//    }
    switch (but.tag) {
        case 1001:
            m_index--;
            if (m_index == 0) {
                but.enabled = NO;
            }
            else {
                but.enabled = YES;
            }
            
            break;
        case 1002:
            m_index++;
            if (m_index == [m_familyArray count]) {
                but.enabled = NO;
            }
            else {
                but.enabled = YES;
            }
            break;
            
        default:
            break;
    }
    [self setPhotoInfo:[m_familyArray objectAtIndex:m_index] isRight:but.tag == 1002];
}

- (void)setPhotoInfo:(NSDictionary*)dic isRight:(BOOL)is
{
    UIView *view = [self.view viewWithTag:500];
    
    UIImageView *imageBefor = [[UIImageView alloc] initWithImage:[CommonImage screenshotWithView:view]];
    imageBefor.frame = view.frame;
    [view.superview addSubview:imageBefor];
    [imageBefor release];
    
    UIImageView *imagePhoto = (UIImageView*)[view viewWithTag:501];
    imagePhoto.image = [dic objectForKey:@"image"];
    
    UILabel *labName = (UILabel*)[view viewWithTag:502];
    labName.text = [dic objectForKey:@"name"];
    
    view.transform = CGAffineTransformMakeTranslation(120 * (is ? 1 : -1), 0);
    view.alpha = 0.1;
    
    [UIView animateWithDuration:2.5 animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1;
        imageBefor.transform = CGAffineTransformMakeTranslation(120 * (is ? -1 : 1), 0);
        imageBefor.alpha = 0.1;
    } completion:^(BOOL finished){
        [imageBefor removeFromSuperview];
    }];
}
#pragma end

#pragma 创建输入项
- (UIView*)createInputItem:(NSDictionary*)dic
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
	
	//标题
	UILabel *labTitle = [Common createLabel:CGRectMake(40, 0, 60, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:[dic objectForKey:@"name"]];
	[view addSubview:labTitle];
	
	UIButton *butSel = [[UIButton alloc] initWithFrame:CGRectMake(labTitle.right + 10, 0, 120, 20)];
    butSel.tag = [[dic objectForKey:@"tag"] integerValue];
    [butSel setDicInfo:dic];
//    butSel.buttonDefultString = @"170";
	[butSel setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	[butSel setTitle:@"" forState:UIControlStateNormal];
	[butSel addTarget:self action:@selector(butEventSel:) forControlEvents:UIControlEventTouchUpInside];
    butSel.backgroundColor = [UIColor greenColor];
	[view addSubview:butSel];
	[butSel release];
	
	UILabel *labUnit = [Common createLabel:CGRectMake(butSel.right+10, 0, 40, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:[dic objectForKey:@"unit"]];
	[view addSubview:labUnit];
	
	return view;
}

- (void)butEventSel:(UIButton*)btn
{
    NSLog(@"%@",btn.dicInfo);
	NSMutableArray *fiisrtArray = [Common createArrayWithBeginInt:[[btn.dicInfo objectForKey:@"min"] intValue] andWithOverInt:[[btn.dicInfo objectForKey:@"max"] intValue] haveZero:YES];
	
	PickerView *myPicker = [[PickerView alloc] init];
	NSString *strTitle = nil;
	if (!btn.titleLabel.text)
	{
		strTitle = [btn.dicInfo objectForKey:@"default"];
	}
	else
	{
		strTitle = btn.titleLabel.text;
	}
	[myPicker createPickViewWithArray:[NSArray arrayWithObject:fiisrtArray] andWithSelectString:@"170" setTitle:@"你的身高" isShow:NO];
	[myPicker setPickerViewBlock:^(NSString *content) {
		[btn setTitle:content forState:UIControlStateNormal];
		[btn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
		NSLog(@"%@",content);
        
        if (!m_butStart.enabled) {
            UIButton *but1;
            BOOL isSel = YES;
            for (NSDictionary *dic in m_inputArray) {
                but1 = (UIButton*)[self.view viewWithTag:[[dic objectForKey:@"tag"] integerValue]];
                if (!but1.titleLabel.text.length) {
                    isSel = NO;
                }
            }
            if (isSel) {
                m_butStart.enabled = YES;
            }
        }
//        [myPicker release];
	}];
//	[self.view addSubview:myPicker];
}
#pragma end

#pragma 选择劳动力
#pragma end

- (void)butEventStart
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:[m_familyArray objectAtIndex:m_index] forKey:@"defaultP"];
    [dic setObject:[NSNumber numberWithInt:m_index2] forKey:@"laodongli"];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"FristFoodMatch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FoodMatchViewController *foodmatch = [[FoodMatchViewController alloc] init];
    [self.navigationController pushViewController:foodmatch animated:YES];
    [foodmatch release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//    [m_picker release];
    [m_pickerArray release];
    [m_butStart release];
    [m_familyArray release];
    
    [super dealloc];
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
