//
//  CalculatorToolsViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-7-30.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "CalculatorToolsViewController.h"

#define BALLHIGHLIGHT 123456
@interface CalculatorToolsViewController () <UITextFieldDelegate> {
    int calculatorType;
    //    CalcutorProgram *my_calcutorProgram;
    NSMutableDictionary* calculatorDict;
}
@end

@implementation CalculatorToolsViewController

- (id)initWithCalculatorType:(int)type
{
    self = [super init];
    if (self) {
        // Custom initialization
        calculatorType = type; // type;

        calculatorDict = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"type" : [NSNumber numberWithInt:calculatorType]
        }];
        [self createContentView];
    }
    return self;
}
#pragma mark 计算器
- (void)share
{
    /**
 *  开始计算
 */
    switch (calculatorType) {
    case 1:
        //体重
        [calculatorDict setObject:FiledOneStr forKey:@"bodyHeight"];
        [calculatorDict setObject:FiledTwoStr forKey:@"bodyWeight"];
        break;
    case 2:
        //血脂
        [calculatorDict setObject:FiledOneStr forKey:@"bodyWaistline"];
        [calculatorDict setObject:FiledTwoStr forKey:@"bodyWeight"];
        [calculatorDict setObject:FiledThreeStr forKey:@"bodyAge"];
        break;
    case 3:
        //基础代谢计算器
        [calculatorDict setObject:FiledOneStr forKey:@"bodyHeight"];
        [calculatorDict setObject:FiledTwoStr forKey:@"bodyWeight"];
        [calculatorDict setObject:FiledThreeStr forKey:@"bodyAge"];
        break;
    case 4:
        //血糖单位转换
        [calculatorDict setObject:FiledOneStr forKey:@"sugerUnitMgdl"];
        [calculatorDict setObject:FiledTwoStr forKey:@"sugerUnitMmmoll"];
        break;
    case 5:
        //糖化血红蛋白
        [calculatorDict setObject:FiledOneStr forKey:@"hemoglobinScale"];
        [calculatorDict setObject:FiledTwoStr forKey:@"hemoglobinMmmoll"];
        break;
    case 6:
        //平均血糖转换
        [calculatorDict setObject:FiledOneStr forKey:@"hemoglobinScale"];
        [calculatorDict setObject:FiledTwoStr forKey:@"averageBloodSuger"];
        break;
    default:
        break;
    }
    [self linkCalcutorWithDic:calculatorDict];
}

- (void)dealloc
{
    [calcutor release];
    [calculatorDict release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    calcutor = [[CalcutorProgram alloc] init];
    self.view.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
}

-(void)createContentView
{
    switch (calculatorType) {
        case 1:
            [self createBMIview]; //体重指数
            self.title = @"体重指数计算器";
             self.log_pageID = 34;
            break;
        case 2:
             self.log_pageID = 35;
            [self createBodyFatView]; //身体脂肪率
            self.title = @"身体脂肪比例计算器";
            break;
        case 3:
             self.log_pageID = 36;
            [self createBMRview]; //基础代谢计算器
            self.title = @"基础代谢计算器";
            break;
        case 4:
             self.log_pageID = 37;
            [self createConvertSugerUnitViewIsScaleToMolView:NO]; //血糖单位转换
            self.title = @"血糖单位换算";
            break;
        case 5:
             self.log_pageID = 38;
            [self createConvertSugerUnitViewIsScaleToMolView:YES]; //糖化血红蛋白
            self.title = @"糖化血红蛋白单位换算";
            break;
        case 6:
             self.log_pageID = 39;
            [self createAverageBloodView]; //平均血糖转换
            self.title = @"糖化血红蛋白与平均血糖";
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//平均血糖转换
- (void)createAverageBloodView
{
    NSArray* textFieldColor = @[ VERSION_TEXT_COLOR, @"666666" ];
    NSArray* titleArray = @[ @"糖化血红蛋白", @"平均血糖" ];

    int titlePointY[2] = { 35, 160 };
    float leftWeight = (kDeviceWidth - 296)/2;
    for (int i = 0; i < titleArray.count; i++) {
        UILabel* titleLabel =
            [Common createLabel:CGRectMake(leftWeight, titlePointY[i],135, 30)
                      TextColor:@"666666"
                           Font:[UIFont systemFontOfSize:16]
                  textAlignment:NSTextAlignmentCenter
                       labTitle:titleArray[i]];
        
        [self.view addSubview:titleLabel];
    }

    int pointY[2] = { 130 / 2, 380 / 2 };
    for (int i = 0; i < titleArray.count; i++) {
        [self createCustomTextFieldWithSuperView:self.view
                                    andWithFrame:CGRectMake(leftWeight, pointY[i], 135,
                                                            50)
                                   withTextColor:textFieldColor[i]
                                          andTag:i + 5];
    }
    [self createConvertImgeViewWithFrame:CGRectMake(146 / 2, 254 / 2, 21, 26)];

    NSArray* unitArrayOne = @[@"%", @"mmol/mol" ];
    NSArray* unitArrayTwo = @[@"mg/dL", @"mmol/L" ];

    for (int i = 0; i < unitArrayOne.count; i++) {
        UIButton* unitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            unitBtn.frame = CGRectMake(leftWeight + 135 + 10, pointY[0], 50, 50);
            unitBtn.selected = YES;
        } else {
            unitBtn.frame = CGRectMake(leftWeight + 135 + 10 + 51, pointY[0], 100, 50);
        }
        unitBtn.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_FIFTEEN];
        [unitBtn setTitleColor:[CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN]
                      forState:UIControlStateNormal];
        [unitBtn setTitleColor:[CommonImage colorWithHexString:@"666666"]
                      forState:UIControlStateSelected];
        [unitBtn setTitle:unitArrayOne[i] forState:UIControlStateNormal];
        unitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [unitBtn addTarget:self
                      action:@selector(unitBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        unitBtn.tag = 10 + i;
        [self.view addSubview:unitBtn];
    }
    //    分割线
    UIImageView* imgeViewOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common.bundle/calculator/cal_line.png"]];
    imgeViewOne.frame = CGRectMake(leftWeight + 135 + 10 + 50, pointY[0] - 10, 1, 71);
    [self.view addSubview:imgeViewOne];
    [imgeViewOne release];

    for (int i = 0; i < unitArrayTwo.count; i++) {
        UIButton* unitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            unitBtn.frame = CGRectMake(leftWeight + 135 + 10, pointY[1], 80, 50);
            unitBtn.selected = YES;
        } else {
            unitBtn.frame = CGRectMake(leftWeight + 135 + 10 + 81, pointY[1], 70, 50);
        }
        unitBtn.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_FIFTEEN];
        [unitBtn setTitleColor:[CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN]
                      forState:UIControlStateNormal];
        [unitBtn setTitleColor:[CommonImage colorWithHexString:@"666666"]
                      forState:UIControlStateSelected];
        [unitBtn setTitle:unitArrayTwo[i] forState:UIControlStateNormal];
        [unitBtn addTarget:self
                      action:@selector(unitBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        unitBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        unitBtn.tag = 20 + i;
        [self.view addSubview:unitBtn];
        
    }

    UIImageView* imgeViewTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common.bundle/calculator/cal_line.png"]];
    imgeViewTwo.frame = CGRectMake(leftWeight + 135 + 10 + 80, pointY[1] - 10, 1, 71);
    [self.view addSubview:imgeViewTwo];
    [imgeViewTwo release];
    [textFiledOne becomeFirstResponder];
}

- (void)unitBtnClick:(UIButton*)btn
{
    if (btn.tag == 10 || btn.tag == 11) {
        if (btn.tag==11 && !btn.selected) {
            textFiledOne.text = [NSString stringWithFormat:@"%.1f",([textFiledOne.text floatValue]-2.15)*10.929];
        }
        if (btn.tag==10 && !btn.selected) {
            textFiledOne.text = [NSString stringWithFormat:@"%.1f",[textFiledOne.text floatValue]/10.929+2.15];
        }
        for (int i = 10; i < 12; i++) {
            UIView* view = [self.view viewWithTag:i];
            if (![view isKindOfClass:[UIButton class]]) {
                continue;
            }
            if (view.tag == btn.tag) {
                ((UIButton*)view).selected = YES;
                
            } else {
                ((UIButton*)view).selected = NO;
            }
        }
//        [calculatorDict setObject:@"1" forKey:@"personMany"];
        
    } else if (btn.tag == 20 || btn.tag == 21) {
        if (btn.tag==20 && !btn.selected) {
            textFiledTwo.text = [NSString stringWithFormat:@"%.1f",[textFiledTwo.text floatValue]*18];
        }
        if (btn.tag==21 && !btn.selected) {
            textFiledTwo.text = [NSString stringWithFormat:@"%.1f",[textFiledTwo.text floatValue]/18];
        }
        for (int i = 20; i < 22; i++) {
            UIView* view = [self.view viewWithTag:i];
            if (![view isKindOfClass:[UIButton class]]) {
                continue;
            }
            if (view.tag == btn.tag) {
                ((UIButton*)view).selected = YES;
            } else {
                ((UIButton*)view).selected = NO;
            }
        }
//        [calculatorDict setObject:@"0" forKey:@"personMany"];
    }
//    FiledOneStr = textFiledOne.text;
//    FiledTwoStr = textFiledTwo.text;
    //平均血糖转换
//    [self share];

    if ([textFiledOne.text floatValue]<0) {
        textFiledOne.text = @"0";
    }
    if ([textFiledTwo.text floatValue]<0) {
        textFiledTwo.text = @"0";
    }

}

//血糖单位转换no  糖化血红蛋白Yes
- (void)createConvertSugerUnitViewIsScaleToMolView:(BOOL)state
{
    NSArray* textFieldColor = @[ VERSION_TEXT_COLOR, @"666666" ];
    NSArray* unitArray = nil;
    if (state) {
        unitArray = @[@"%", @"mmol/mol" ];
    } else {
        unitArray = @[@"mmol/L", @"mg/dL" ];
    }
    float leftWeight = (kDeviceWidth - 178 - 80 - 20)/2;
    int pointY[2] = { 80 / 2, 256 / 2 };
    for (int i = 0; i < unitArray.count; i++) {
     UITextField *textField = [self createCustomTextFieldWithSuperView:self.view
                                    andWithFrame:CGRectMake(leftWeight, pointY[i],178, 50)
                                   withTextColor:textFieldColor[i]
                                          andTag:i + 5];
        UILabel* unitsLabel =
            [Common createLabel:CGRectMake(textField.right+20, pointY[i], 80, 50)
                      TextColor:@"666666"
                           Font:[UIFont systemFontOfSize:16]
                  textAlignment:NSTextAlignmentLeft
                       labTitle:unitArray[i]];
        [self.view addSubview:unitsLabel];
    }
    [self
        createConvertImgeViewWithFrame:CGRectMake(leftWeight+178/2-10.5, 97, 21, 26)];
    [textFiledOne becomeFirstResponder];
}

- (void)createConvertImgeViewWithFrame:(CGRect)frame
{
    UIImageView* imgeView = [[UIImageView alloc]
        initWithImage:[UIImage
                          imageNamed:@"common.bundle/calculator/covert.png"]];
    imgeView.frame = frame;
    [self.view addSubview:imgeView];
    [imgeView release];
}

//身体脂肪率
- (void)createBodyFatView
{
    [self createSegmentView];
    NSArray* textNameArray = @[ @"身高", @"体重", @"年龄" ];
    NSArray* unitArray = @[ @"厘米", @"公斤", @"岁" ];
    //创建输入项
    NSString *weight = [NSString stringWithFormat:@"%d", (int)(g_nowUserInfo.weight >0 ?g_nowUserInfo.weight:50)];

    NSDictionary* dic1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"50", @"300", @"170", @"600", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    NSDictionary* dic2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"15", @"150", weight, @"601", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    NSDictionary* dic3 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"120", @"20", @"602", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    m_unitArr = [[NSArray alloc] initWithObjects:dic1, dic2, dic3, nil];

    for (int i = 0; i < textNameArray.count; i++) {
        [self createCustomFieldWithPointy:55 * (i + 1)
                     andWithTextFiledName:textNameArray[i]
                          andWithUnitName:unitArray[i]];
    }

    NSArray* customColorArray = @[ @"e75442", @"32ccfe" ];
    NSArray* customTitleArray = @[ @"体脂状态", @"体脂率" ];
    
    float leftWeight = (kDeviceWidth -75*2-20)/2;
    
    for (int i = 0; i < customColorArray.count; i++) {
        [self createCustomLabelWithColor:customColorArray[i]
                       andWithStartPoint:CGPointMake(leftWeight + (75 + 20) * i,
                                                     242)
                               withTitle:customTitleArray[i]
                                     tag:i + 5];
    }
    textFiledOne.text = dic1[@"default"];
    textFiledTwo.text = dic2[@"default"];
    textFiledThree.text = dic3[@"default"];
    FiledOneStr = textFiledOne.text;
    FiledTwoStr = textFiledTwo.text;
    FiledThreeStr = textFiledThree.text;
    [self share];
}

//体重指数
- (void)createBMIview
{
    NSArray* textNameArray = @[ @"身高", @"体重" ];
    NSArray* unitArray = @[@"厘米", @"公斤" ];

    //创建输入项
    NSString *weight = [NSString stringWithFormat:@"%d", (int)(g_nowUserInfo.weight >0 ?g_nowUserInfo.weight:50)];
    NSDictionary* dic1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"50", @"300", @"170", @"600", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    NSDictionary* dic2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"15", @"150", weight, @"601", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    m_unitArr = [[NSArray alloc] initWithObjects:dic1, dic2, nil];

    for (int i = 0; i < textNameArray.count; i++) {
        [self createCustomFieldWithPointy:55 * i + 34
                     andWithTextFiledName:textNameArray[i]
                          andWithUnitName:unitArray[i]];
    }
    NSArray* customColorArray = @[ @"f1aa3f", @"e75441", @"33ccff" ];
    NSArray* customTitleArray =
        @[ @"体重指数(kg/㎡)", @"体重状态", @"理想体重(kg)" ];
    
    float leftWeight = (kDeviceWidth -75*3)/4;
    
    for (int i = 0; i < customColorArray.count; i++) {
        [self createCustomLabelWithColor:customColorArray[i]
                       andWithStartPoint:CGPointMake(leftWeight + (75 + leftWeight) * i, 374 / 2)
                               withTitle:customTitleArray[i]
                                     tag:i + 5];
    }
    textFiledOne.text = dic1[@"default"];
    textFiledTwo.text = dic2[@"default"];
    FiledOneStr = textFiledOne.text;
    FiledTwoStr = textFiledTwo.text;
    [self share];
}

//基础代谢计算器
- (void)createBMRview
{
    [self createSegmentView];
    NSArray* textNameArray = @[ @"身高", @"体重", @"年龄" ];
    NSArray* unitArray = @[ @"厘米", @"公斤", @"岁" ];

    NSString *weight = [NSString stringWithFormat:@"%d", (int)(g_nowUserInfo.weight >0 ?g_nowUserInfo.weight:50)];
    //创建输入项
    NSDictionary* dic1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"50", @"300", @"170", @"600", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    NSDictionary* dic2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"15", @"150", weight, @"601", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    NSDictionary* dic3 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"120", @"20", @"602", nil] forKeys:[NSArray arrayWithObjects:@"min", @"max", @"default", @"tag", nil]];
    m_unitArr = [[NSArray alloc] initWithObjects:dic1, dic2, dic3, nil];
    for (int i = 0; i < textNameArray.count; i++) {
        [self createCustomFieldWithPointy:55 * (i + 1)
                     andWithTextFiledName:textNameArray[i]
                          andWithUnitName:unitArray[i]];
    }
    [self createCustomLabelWithColor:VERSION_TEXT_COLOR
                   andWithStartPoint:CGPointMake((kDeviceWidth - 75) / 2, 242)
                           withTitle:@"基础代谢率(千卡)"
                                 tag:99];
    textFiledOne.text = dic1[@"default"];
    textFiledTwo.text = dic2[@"default"];
    textFiledThree.text = dic3[@"default"];
    FiledOneStr = textFiledOne.text;
    FiledTwoStr = textFiledTwo.text;
    FiledThreeStr = textFiledThree.text;
    [self share];
}

#pragma cutomUI
//分段选择器
- (void)createSegmentView
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth-180)/2, 11, 180, 30)];
    bgView.layer.cornerRadius = 4;
    bgView.clipsToBounds = YES;
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR].CGColor;
    [self.view addSubview:bgView];
    [bgView release];

    [self createLabelGreenWithWeight:bgView.width / 2 withSuperView:bgView];

    NSArray* titleArray =
        [[NSArray alloc] initWithObjects:NSLocalizedString(@"男", nil),
                                         NSLocalizedString(@"女", nil), nil];
    for (int i = 0; i < 2; i++) {
        [self createButtonWithPointX:bgView.width / 2 * i
                    andWithSuperView:bgView
                     withTitleString:[titleArray objectAtIndex:i]
                       andWithBtnTag:i + 10];
    }
    [titleArray release];
}

//竖线
- (void)createLabelGreenWithWeight:(int)weight
                     withSuperView:(UIView*)superView
{
    UILabel* greenLable = [Common createLabel:CGRectMake(weight, 0, 0.5, 30)
                                    TextColor:nil
                                         Font:nil
                                textAlignment:NSTextAlignmentLeft
                                     labTitle:nil];
    greenLable.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
    [superView addSubview:greenLable];
}

- (void)createButtonWithPointX:(int)pointX
              andWithSuperView:(UIView*)superView
               withTitleString:(NSString*)titleString
                 andWithBtnTag:(int)btnTag
{
    UIButton* numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numberBtn.frame = CGRectMake(pointX, 0, 90, 30);
    numberBtn.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_FIFTEEN];
    [numberBtn setTitleColor:[CommonImage colorWithHexString:VERSION_TEXT_COLOR]
                    forState:UIControlStateNormal];
    [numberBtn setTitleColor:[CommonImage colorWithHexString:@"ffffff"]
                    forState:UIControlStateSelected];
    ;
    [numberBtn setTitle:titleString forState:UIControlStateNormal];
    [numberBtn addTarget:self
                  action:@selector(btnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    numberBtn.tag = btnTag;
    UIImage* image = [CommonImage
        createImageWithColor:[CommonImage colorWithHexString:VERSION_TEXT_COLOR]];
    [numberBtn setBackgroundImage:image forState:UIControlStateSelected];
    [superView addSubview:numberBtn];
    if (btnTag == 10) {
        numberBtn.selected = YES;
        [calculatorDict setObject:[NSNumber numberWithBool:NO] forKey:@"sex"];
    }
}

- (void)createCustomFieldWithPointy:(int)pointY
               andWithTextFiledName:(NSString*)titleString
                    andWithUnitName:(NSString*)unitName
{
    UIView* bgView =
        [[UIView alloc] initWithFrame:CGRectMake(0, pointY, kDeviceWidth, 55)];
    [self.view addSubview:bgView];
    [bgView release];

    float leftWeight = (kDeviceWidth -234)/2;
    UILabel* titleLabel =
        [Common createLabel:CGRectMake(leftWeight, (bgView.height - 30) / 2, 60, 30)
                  TextColor:@"333333"
                       Font:[UIFont systemFontOfSize:M_FRONT_SEVENTEEN]
              textAlignment:NSTextAlignmentLeft
                   labTitle:titleString];
    [bgView addSubview:titleLabel];
    //    输入框
    [self createCustomTextFieldWithSuperView:bgView
                                andWithFrame:CGRectMake(titleLabel.right, 4,
                                                        114, 45)
                               withTextColor:VERSION_TEXT_COLOR
                                      andTag:(pointY - 30) / 55 + 5];
    //    单位
    //    CGSize unitSize = [Common sizeForString:numberString
    //    andFont:M_FRONT_SEVENTEEN];
    UILabel* unitsLabel =
        [Common createLabel:CGRectMake(titleLabel.right + 114 + 23,
                                       titleLabel.top, 60, 30)
                  TextColor:@"666666"
                       Font:[UIFont systemFontOfSize:16]
              textAlignment:NSTextAlignmentLeft
                   labTitle:unitName];
    [bgView addSubview:unitsLabel];
    
}

//创建输入框
- (UITextField *)createCustomTextFieldWithSuperView:(UIView*)superView
                              andWithFrame:(CGRect)frame
                             withTextColor:(NSString*)textColor
                                    andTag:(int)tag
{
    UITextField* textFiled =
        [Common createTextField:@"" setDelegate:self setFont:28.0];
    textFiled.frame = frame;
    textFiled.delegate = self;
    [textFiled setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:36.0]];
    textFiled.layer.cornerRadius = 4;
    textFiled.layer.borderColor = [CommonImage colorWithHexString:@"e5e5e5"].CGColor;
    textFiled.clipsToBounds = YES;
    textFiled.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28.0];
    //    textFiled.font = [UIFont fontWithName:@"Arial" size:36];
    textFiled.textAlignment = NSTextAlignmentCenter;
    textFiled.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    textFiled.textColor = [CommonImage colorWithHexString:textColor];
    textFiled.keyboardType = UIKeyboardTypeDecimalPad;

    [superView addSubview:textFiled];
    switch (tag) {
    case 5:
        textFiledOne = textFiled;
        break;
    case 6:
        textFiledTwo = textFiled;
        break;
    case 7:
        textFiledThree = textFiled;
        break;

    default:
        break;
    }
    return textFiled;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self resignFirstResponderWithTextfield];
}

- (void)resignFirstResponderWithTextfield
{
//    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView* firstResponderView = [keyWindow performSelector:@selector(firstResponder)];
//    if ([firstResponderView isKindOfClass:[UITextField class]]) {
//        [firstResponderView resignFirstResponder];
//    }
     [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)creatPickerView:(NSUInteger)teg textField:(UITextField*)text
{
    NSMutableArray* fiisrtArray = [Common createArrayWithBeginInt:[[m_unitArr[teg] objectForKey:@"min"] intValue] andWithOverInt:[[m_unitArr[teg] objectForKey:@"max"] intValue] haveZero:YES];

    PickerView* myPicker = [[PickerView alloc] init];
    NSString* strTitle = [m_unitArr[teg] objectForKey:@"default"];
    NSLog(@"%@",fiisrtArray);
    if ([strTitle integerValue]==50) {
        [myPicker createPickViewWithArray:@[fiisrtArray,@[@"."],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]] andWithSelectString:nil setTitle:nil isShow:NO];

    }else{
        [myPicker createPickViewWithArray:[NSArray arrayWithObject:fiisrtArray] andWithSelectString:strTitle setTitle:nil isShow:NO];

    }
    
    [myPicker setPickerViewBlock:^(NSString* content) {
        content = [content stringByReplacingOccurrencesOfString:@"..." withString:@"."];
        text.text = content;
        switch (teg) {
            case 0:
                FiledOneStr = text.text;
                break;
            case 1:
                FiledTwoStr = text.text;
                
                break;
            case 2:
                FiledThreeStr = text.text;
                break;
                
            default:
                break;
        }
        [self share];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if (calculatorType < 4) {
        [textField resignFirstResponder];
        if (textField == textFiledOne) {
            [self creatPickerView:0 textField:textField];
        } else if (textField == textFiledTwo) {
            [self creatPickerView:1 textField:textField];
        } else {
            [self creatPickerView:2 textField:textField];
        }
    }
}

/**
 *  输入进行数据转换
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return 开始执行转换方法
 */
- (BOOL)textField:(UITextField*)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString*)string
{
    if (![Common textField:textField replacementString:string]) {
        return NO;
    }

    FiledOneStr = textFiledOne.text;
    FiledTwoStr = !textFiledTwo.text.length ?@"":textFiledTwo.text;
    FiledThreeStr = textFiledThree.text;
    /**
     *  区分不同的textfield
     */
    if (textField == textFiledOne) {
        if (range.length == 1) {
            FiledOneStr = [FiledOneStr substringToIndex:[FiledOneStr length] - 1];
        } else if (range.length == 0) {
            FiledOneStr = [FiledOneStr stringByAppendingString:string];
        } else {
            FiledOneStr = @"0";
        }
        //下面的切换判断
        if (calculatorType == 6)
        {
            UIButton *selectButton = (UIButton *)[self.view viewWithTag:20];//糖化蛋白mg/dl
            if (selectButton && selectButton.selected)
            {
                [calculatorDict setObject:@"1" forKey:@"unitMG/DL"];
            }
            else
                [calculatorDict setObject:@"0" forKey:@"unitMG/DL"];
        }
        
    } else if (textField == textFiledTwo) {
        if (range.length == 1) {
            FiledTwoStr = [FiledTwoStr substringToIndex:[FiledTwoStr length] - 1];

        } else if (range.length == 0) {
            FiledTwoStr = [FiledTwoStr stringByAppendingString:string];

        } else {
            FiledTwoStr = @"0";
        }
        //下面的切换判断
        if (calculatorType == 6)
        {
            UIButton *selectButton = (UIButton *)[self.view viewWithTag:20];//糖化蛋白mg/dl
            if (selectButton && selectButton.selected)
            {
                [calculatorDict setObject:@"1" forKey:@"unitMG/DL"];
            }
            else
                [calculatorDict setObject:@"0" forKey:@"unitMG/DL"];
        }
        
    } else {
        if (range.length == 1) {
            FiledThreeStr =
                [FiledThreeStr substringToIndex:[FiledThreeStr length] - 1];

        } else if (range.length == 0) {
            FiledThreeStr = [FiledThreeStr stringByAppendingString:string];

        } else {
            FiledThreeStr = @"0";
        }
    }
    //血糖单位转换 //糖化血红蛋白 //平均血糖转换3
    if (textFiledOne == textField) {
        [calculatorDict setObject:@"1" forKey:@"personMany"];

    } else {
        [calculatorDict setObject:@"0" forKey:@"personMany"];
    }
    
    UIButton *selectButton = (UIButton *)[self.view viewWithTag:10];//糖化蛋白%
    if (selectButton &&!selectButton.selected)
    {
        FiledOneStr = [NSString stringWithFormat:@"%.1f",[FiledOneStr floatValue]/10.929+2.15];
    }
    [self share];
    return YES;
}

- (void)createCustomLabelWithColor:(NSString*)colorString
                 andWithStartPoint:(CGPoint)startPoint
                         withTitle:(NSString*)titleString
                               tag:(int)tag
{
    UILabel* cutomLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(startPoint.x, startPoint.y, 75, 75)];
    cutomLabel.layer.cornerRadius = CGRectGetWidth(cutomLabel.frame) / 2;
    cutomLabel.layer.borderWidth = 0;
    cutomLabel.backgroundColor = [CommonImage colorWithHexString:colorString];
    cutomLabel.layer.masksToBounds = YES;
    //    cutomLabel.layer.borderColor = [[CommonImage colorWithHexString:@"e3e3d7"]
    //    CGColor];
    [self.view addSubview:cutomLabel];
    [cutomLabel release];

    UILabel* numberLabel = [Common createLabel:CGRectMake(0, 45 / 2, 75, 30)
                                     TextColor:@"fbead7"
                                          Font:[UIFont systemFontOfSize:17]
                                 textAlignment:NSTextAlignmentCenter
                                      labTitle:@""];
    numberLabel.tag = tag;
    [cutomLabel addSubview:numberLabel];
    if ([titleString isEqualToString:@"体重状态"] ||
        [titleString isEqualToString:@"体脂状态"]) {
        numberLabel.font = [UIFont systemFontOfSize:17];
    }

    UILabel* titleLabel = [Common
          createLabel:CGRectMake(cutomLabel.left - 27, cutomLabel.bottom + 5, cutomLabel.width + 54, 30)
            TextColor:colorString
                 Font:[UIFont systemFontOfSize:15]
        textAlignment:NSTextAlignmentCenter
             labTitle:titleString];
    if ([titleString isEqualToString:@"基础代谢率(KJ/m2/h)"]) {
        titleLabel.frame = CGRectMake(20, cutomLabel.bottom + 5, 280, 30);
        
    }

    [self.view addSubview:titleLabel];
}

- (void)btnClick:(UIButton*)ss
{
    for (UIView* view in ss.superview.subviews) {
        if (![view isKindOfClass:[UIButton class]]) {
            continue;
        }
        if (view.tag == ss.tag) {
            ((UIButton*)view).selected = YES;
        } else {
            ((UIButton*)view).selected = NO;
        }
    }
    [calculatorDict setObject:[NSNumber numberWithBool:ss.tag == 10 ? NO : YES]
                       forKey:@"personSex"];
    [self share];
    //    [self planInfoLsitWithStartDate:date];
}

#pragma mark 根据当地的状态 更换颜色
-(void)changeLableColorWithTitleArray:(NSArray *)titleArray andWIthCurrentString:(NSString *)currentString withLabel:(UIView *)currentLabel
{
    NSArray *colorArray = @[@"00cf97",@"e75440",@"fea24d",@"1ac0bc",];
    int indexColor = (int)[titleArray indexOfObject:currentString];
    currentLabel.backgroundColor = [CommonImage colorWithHexString:colorArray[indexColor]];
}

/**
*  连接处理界面
*
*  @param dic 传输字典
*/
- (void)linkCalcutorWithDic:(NSDictionary*)dic
{
    NSLog(@"%@", dic);
    NSDictionary* dics = [calcutor calculatorResultDict:dic];
    int caculatorType = [dic[@"type"] intValue];
    UILabel* lab;
    switch (caculatorType) {
    case 1:
        //体重指数
        NSLog(@"%@", dics);
        for (int i = 0; i < 3; i++) {
            lab = (UILabel*)[self.view viewWithTag:i + 5];
            switch (i) {
            case 0:
                lab.text = [dics objectForKey:@"BMIString"];
                break;
            case 1:
                lab.text = [dics objectForKey:@"bodyStatue"];
          [self changeLableColorWithTitleArray:@[@"正常!",@"肥胖!",@"过轻!",@"超重!" ] andWIthCurrentString:lab.text withLabel:lab.superview];
                break;
            case 2:
                lab.text = [dics objectForKey:@"ideaWeight"];
                break;
            default:
                break;
            }
        }
        break;
    case 2:
        //身体脂肪率
        for (int i = 0; i < 2; i++) {
            lab = (UILabel*)[self.view viewWithTag:i + 5];
            switch (i) {
            case 0:
                lab.text = [dics objectForKey:@"bodyFatStatue"];
        [self changeLableColorWithTitleArray:@[@"正常值",@"体脂偏高",@"体脂偏低"] andWIthCurrentString:lab.text withLabel:lab.superview];
                break;
            case 1:
                lab.text = [dics objectForKey:@"bodyFatScale"];
                break;

            default:
                break;
            }
        }
        break;
    case 3:
        //基础代谢计算器
        lab = (UILabel*)[self.view viewWithTag:99];
//            lab.font = [UIFont systemFontOfSize:13];
        lab.text = [dics objectForKey:@"BMRString"];
        break;
    case 4:
        //血糖单位转换
        if ([calculatorDict[@"personMany"] intValue] == 1 ? YES : NO) {
            textFiledTwo.text = [dics objectForKey:@"sugerUnitMgdl"];
            FiledTwoStr = textFiledTwo.text;
        } else {
            textFiledOne.text = [dics objectForKey:@"sugerUnitMmmoll"];
            FiledOneStr = textFiledOne.text;
        }
        break;
    case 5:
        //糖化血红蛋白
        if ([calculatorDict[@"personMany"] intValue] == 1 ? YES : NO) {
            textFiledTwo.text = [dics objectForKey:@"hemoglobinMmmoll"];
            FiledTwoStr = textFiledTwo.text;
//            [resultDict setObject:hemoglobinScale forKey:@"hemoglobinScale"];
//            [resultDict setObject:hemoglobinMmmoll forKey:@"hemoglobinMmmoll"];

        } else {
            textFiledOne.text = [dics objectForKey:@"hemoglobinScale"];
            FiledOneStr = textFiledOne.text;
        }
        break;
    case 6:
        //平均血糖转换
        if ([calculatorDict[@"personMany"] intValue] == 1 ? YES : NO) {
            textFiledTwo.text = [dics objectForKey:@"averageBloodSuger"];
            FiledTwoStr = textFiledTwo.text;
//            [resultDict setObject:hemoglobinScale forKey:@"hemoglobinScale"];
//            [resultDict setObject:averageBloodSuger forKey:@"averageBloodSuger"];
        } else {
            
            NSString *resultScale = [dics objectForKey:@"hemoglobinScale"];
            UIButton *selectButton = (UIButton *)[self.view viewWithTag:10];//糖化蛋白%
            if (selectButton &&!selectButton.selected)
            {
                 textFiledOne.text = [NSString stringWithFormat:@"%.1f",([resultScale floatValue]-2.15)*10.929];
                 textFiledOne.text = [resultScale floatValue] <=0 ?@"0":textFiledOne.text;//判断空
            }
            else
                textFiledOne.text = resultScale;
            FiledOneStr = textFiledOne.text;
        }
        break;
    default:
        break;
    }
}

/**
*  代理获取返回的数据
6
*  @param dics 数据字典
*/
- (void)calculateData:(NSDictionary*)dics
{
}
@end

@implementation CalculatorToolsViewC

- (id)init
{
    self = [super init];
    if (self) {
        
        self.title = @"常用工具";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];

    self.log_pageID = 33;
    m_array = [[NSArray alloc]
        initWithObjects:
            [NSArray arrayWithObjects:@"体重指数计算器",
                                      @"身体脂肪比例计算器",
                                      @"基础代谢计算器", nil],
            [NSArray arrayWithObjects:@"血糖单位换算",
                                      @"糖化血红蛋白单位换算",
                                      @"糖化血红蛋白与平均血糖", nil],
            nil];

    m_tableView = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                style:UITableViewStyleGrouped];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = view;
    [view release];
    m_tableView.separatorColor = [CommonImage colorWithHexString:@"e5e5e5"];
    m_tableView.rowHeight = 44;
    [self.view addSubview:m_tableView];
}

#pragma mark - tableViewDataDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return m_array.count;
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[m_array objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier] autorelease];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];

    }

    cell.textLabel.text =
        [[m_array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    CalculatorToolsViewController* calculator = nil;
    switch (indexPath.section) {
    case 0:
        switch (indexPath.row) {
        case 0:
            calculator = [[CalculatorToolsViewController alloc]
                initWithCalculatorType:1]; //体重指数
            break;
        case 1:
            calculator = [[CalculatorToolsViewController alloc]
                initWithCalculatorType:2]; //身体脂肪率
            break;
        case 2:
            calculator = [[CalculatorToolsViewController alloc]
                initWithCalculatorType:3]; //基础代谢计算器
            break;
        }
        break;
    case 1:
        switch (indexPath.row) {
        case 0:
            calculator = [[CalculatorToolsViewController alloc]
                initWithCalculatorType:4]; //血糖单位转换
            break;
        case 1:
            calculator = [[CalculatorToolsViewController alloc]
                initWithCalculatorType:5]; //糖化血红蛋白
            break;
        case 2:
            calculator = [[CalculatorToolsViewController alloc]
                initWithCalculatorType:6]; //平均血糖转换
            break;
        }
        break;
    }
    [self.navigationController pushViewController:calculator animated:YES];
    [calculator release];

    //    int num = self.navigationController.viewControllers.count;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
    [m_tableView release];
    [m_array release];
    [super dealloc];
}

@end