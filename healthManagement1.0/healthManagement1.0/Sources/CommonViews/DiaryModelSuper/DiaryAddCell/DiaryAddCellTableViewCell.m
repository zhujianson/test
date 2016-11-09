//
//  DiaryAddCellTableViewCell.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "DiaryAddCellTableViewCell.h"
#import "GetFamilyList.h"
//#import "NewPickerView.h"
#import "FamilyListView.h"
#import "PickerView.h"
#import "ModifyInformationViewController.h"

@implementation DiaryAddCellTableViewCell
@synthesize m_infoDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSString *title = @"点击此处添加记录";
        CGSize size = [Common sizeForString:title andFont:15.0];
        float ttitleHeight = ceilf(size.width);
        UIImage *addDataImage = [UIImage imageNamed:@"common.bundle/diary/V4.0/addData.png"];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = [CommonImage colorWithHexString:@"999999"];
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.text = title;
        textLabel.frame = CGRectMake((kDeviceWidth - ttitleHeight)/2.0+(addDataImage.size.width+10)/2.0,(kAddRowHieght-16)/2.0f, ttitleHeight, 16);
        [self.contentView addSubview:textLabel];
        [textLabel release];
        
        //add
        m_addIcon = [[UIImageView alloc] initWithFrame:CGRectMake(textLabel.origin.x-addDataImage.size.width-10, (kAddRowHieght-addDataImage.size.height)/2.0f, addDataImage.size.width, addDataImage.size.height)];
        m_addIcon.image = addDataImage;
        [self.contentView addSubview:m_addIcon];
        [m_addIcon release];
    }
    
    return self;
}

- (void)openCloseAnimation:(BOOL)isOpen
{
    float d = isOpen ? DEGREES_TO_RADIANS(135) : DEGREES_TO_RADIANS(0);
    
    [UIView animateWithDuration:0.3 animations:^{
        m_addIcon.transform = CGAffineTransformMakeRotation(d);
    } completion:^(BOOL f) {
        
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





@implementation DiaryZhanshiCell

@synthesize diaryZhanshiCellBlock;
@synthesize m_diraryTimeType;
@synthesize m_textViewArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
        self.contentView.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
        
        m_textViewArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    if (diaryZhanshiCellBlock)
    {
       [diaryZhanshiCellBlock release];
    }
    [m_textViewArray release];
    [super dealloc];
}

- (UIView*)createFamily
{
//    if (g_familyList.count) {
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        
        UILabel *familyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 44)];
        familyLabel.text = @"家庭成员";
        familyLabel.backgroundColor = [UIColor clearColor];
        familyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        familyLabel.font = [UIFont systemFontOfSize:15.0f];
        [view addSubview:familyLabel];
        [familyLabel release];
        
        //家庭成员名字
        UILabel *familyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(familyLabel.right +20, 0, view.width-40-(familyLabel.right +20), 44)];
        familyNameLabel.text = [[FamilyListView getSelectFamilyInfoByUserid] objectForKey:@"nickName"];
        familyNameLabel.tag = 900;
        familyNameLabel.textAlignment = NSTextAlignmentRight;
        familyNameLabel.backgroundColor = [UIColor clearColor];
        familyNameLabel.textColor = [CommonImage colorWithHexString:@"999999"];
        familyNameLabel.font = [UIFont systemFontOfSize:15.0f];
        [view addSubview:familyNameLabel];
        [familyNameLabel release];
        
        //箭头
        UIImage *arrow = [UIImage imageNamed:@"arrow_bl.png"];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width-40, 0, 40, 44)];
        arrowImageView.contentMode = UIViewContentModeCenter;
        arrowImageView.image = arrow;
        [view addSubview:arrowImageView];
        [arrowImageView release];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 0, view.width, view.height);
        [but addTarget:self action:@selector(butEventSelFamily) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-0.5, view.width, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"DADADA"];
        [view addSubview:lineView];
        [lineView release];
        
        return view;
//    }
//    else {
//        return nil;
//    }
}

- (void)hiddleKey
{
    for (UITextField *text in m_textViewArray) {
        [text resignFirstResponder];
    }
}

- (UIView*)createTimeView
{
    TimeFrameView *timeFrameView = [[TimeFrameView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 2*35 +15) withArray:@[@"凌晨",@"早餐前",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后",@"睡前"]];
    timeFrameView.tag = TimeFrameViewTag;
    timeFrameView.selectedTimeBlock = ^(long index){
//        [self hiddleKey];
        [self endEditing:YES];
        if (index == TimeRandomType)
        {
            [self.m_infoDic setObject:@(self.m_diraryTimeType) forKey:@"timeBucket"];
            [self.m_infoDic setObject:@0 forKey:@"isRandom"];
        }
        else
        {
            [self.m_infoDic setObject:@(index) forKey:@"timeBucket"];
            [self.m_infoDic setObject:@1 forKey:@"isRandom"];
        }
        NSLog(@"------%ld",index);
    };
    return timeFrameView;
}

- (UIView*)createSaveBut
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    
    float buttonWeight = (kDeviceWidth - 45)/2.0;
    
    UIImage* backImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
    UIButton * delBut = [UIButton buttonWithType:UIButtonTypeCustom];
    delBut.frame = CGRectMake(15, 0, buttonWeight, 44);
    delBut.tag = 5000;
    delBut.layer.borderColor = [CommonImage colorWithHexString:@"cccccc"].CGColor;
    delBut.layer.borderWidth = 0.5;
    [delBut addTarget:self action:@selector(savebtn:) forControlEvents:UIControlEventTouchUpInside];
    [delBut setTitle:@"删除" forState:UIControlStateNormal];
    delBut.titleLabel.font = [UIFont systemFontOfSize:18.];
    [delBut setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [delBut setBackgroundImage:backImage forState:UIControlStateNormal];
    delBut.layer.cornerRadius = 4;
    delBut.clipsToBounds = YES;
    [view addSubview:delBut];
    
    backImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
    UIButton * saveBut = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBut.tag = 5001;
    saveBut.titleLabel.font = [UIFont systemFontOfSize:18.];
    saveBut.frame = CGRectMake(delBut.right+15, delBut.top, buttonWeight, 44);
    [saveBut addTarget:self action:@selector(savebtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBut setTitle:@"保存" forState:UIControlStateNormal];
    [saveBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBut setBackgroundImage:backImage forState:UIControlStateNormal];
    saveBut.layer.cornerRadius = 4;
    saveBut.clipsToBounds = YES;
    [view addSubview:saveBut];
    
    return view;
}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.textAlignment = NSTextAlignmentCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.clearButtonMode = YES;
//    text.keyboardType = UIKeyboardType;
//    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [text setFont:[UIFont systemFontOfSize:50]];
    return text;
}

- (void)setM_infoDic:(NSMutableDictionary*)infoDict
{
    _m_infoDic = infoDict;
    UIButton *butDel = (UIButton*)[self viewWithTag:5000];
    butDel.hidden = NO;
    UIButton *butSave = (UIButton*)[self viewWithTag:5001];
//    CGRect rect = butSave.frame;
//    rect.origin.x = butDel.right+15;
//    rect.size.width = butDel.width;
    if ([[infoDict objectForKey:IsAddSection] boolValue]) {
        butDel.hidden = YES;
        butSave.frameX = 15;
        butSave.width = kDeviceWidth - 30;
    }
    else
    {
        butSave.frameX = butDel.right+15;
        butSave.width = butDel.width;
//        butSave.frame = rect;
    }
    //时间段
    TimeFrameView *timeFrameView = (TimeFrameView*)[self viewWithTag:TimeFrameViewTag];
    if (![infoDict.allKeys containsObject:@"timeBucket"])
    {
        [infoDict setObject:@1 forKey:@"timeBucket"];
    }
  
    BOOL isRandom = YES;
    if (![infoDict.allKeys containsObject:@"isRandom"] || [infoDict[@"isRandom"] intValue] == 1)
    {
        isRandom = NO;
    }
    if (isRandom)
    {
         timeFrameView.selBut = TimeRandomType;
    }
    else
    {
         timeFrameView.selBut = [[infoDict objectForKey:@"timeBucket"] intValue];
    }
    UILabel *familyNameLabel = (UILabel*)[self viewWithTag:900];
    NSString *familyName = [infoDict objectForKey:@"nickName"];
    if (!familyName) {
        NSDictionary *dic = [FamilyListView getSelectFamilyInfoByUserid];
        [infoDict setObject:dic[@"nickName"] forKey:@"nickName"];
        [infoDict setObject:dic[kIdKeyString] forKey:@"accountId"];
    }
    familyNameLabel.text = infoDict[@"nickName"];
    BOOL hidenState = YES; //1设备 2手工
    if ([infoDict[@"device"] intValue] == 1) {
        hidenState = NO;
    }
    
    for (UITextField * textField in self.m_textViewArray)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            textField.userInteractionEnabled = hidenState;
        }
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)butEventSelFamily
{
//    [self hiddleKey];
    [self endEditing:YES];
    __block NSInteger num = 0;
    [[GetFamilyList alloc] initWithBlcok:^(NSMutableArray *farray){
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for (int i =0; i<farray.count; i++) {
            if (farray[i][@"id"]==nil) {
                break;
            }else{
                if ([farray[i][@"id"] isEqualToString:[_m_infoDic objectForKey:@"accountId"]]) {
                    num = i;
                }
            }
            [arr addObject:farray[i][@"nickName"]];
        }
        if (arr.count<7) {
            [arr addObject:@"添加家庭成员"];
        }
        PickerView *myPicker = [[PickerView alloc] init];
        UILabel * name = (UILabel*)[self viewWithTag:900];
        [myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] andWithSelectString:name.text setTitle:@"选择绑定家人" isShow:NO];
        myPicker.m_row = num;
        [myPicker setPickerViewBlock:^(NSString *content) {
            NSString * chooseStr = [arr objectAtIndex:[content intValue]];
            if ([content intValue] == arr.count-1) {
                ModifyInformationViewController * modify = [[ModifyInformationViewController alloc]init];
                modify.isDeviceAdd = YES;
                [modify setModifyInformationBlock:^(NSMutableDictionary *dic) {
                    NSLog(@"%@",dic);
                    name.text = dic[@"nickName"];
//                    userIdStr = dic[@"id"];
                    [_m_infoDic setObject:dic[@"id"] forKey:@"accountId"];
                    [g_familyList replaceObjectAtIndex:g_familyList.count-1 withObject:dic];
                    if (g_familyList.count < 7) {
                        [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
                    }
                }];
                modify.log_pageID = 88;
                modify.title = @"添加家庭成员";
                modify.m_infoDic = [[NSMutableDictionary alloc]init];
                [self.superVC.navigationController pushViewController:modify animated:YES];
                [modify release];
            }else{
                name.text = chooseStr;
                [_m_infoDic setObject:[farray objectAtIndex:[content intValue]][@"id"] forKey:@"accountId"];
            }
            [arr release];
        }];
    } withView:self] ;

    
//    [[[GetFamilyList alloc] initWithBlcok:^(NSMutableArray *farray){
//        
//        NSMutableArray * arr = [NSMutableArray array];
//        for (int i =0; i<farray.count; i++) {
//            if (farray[i][@"id"]==nil) {
//                break;
//            }
//            [arr addObject:farray[i]];
//        }
//        if (arr.count<7) {
//            [arr addObject:@"添加家庭成员"];
//        }
//        
//        NewPickerView *myPicker = [[NewPickerView alloc] init];
//        myPicker.m_idKey = kIdKeyString;
//        myPicker.m_titleKey = @"nickName";
//        UILabel *name = (UILabel*)[self viewWithTag:900];
//        [myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] withDefSel:[_m_infoDic objectForKey:@"accountId"] setTitle:@"选择家人"];
//        [myPicker setPickerViewBlock:^(NSArray *array) {
//            NSDictionary *dic = [array objectAtIndex:0];
//            if ([dic isKindOfClass:[NSString class]]) {
//                ModifyInformationViewController * modify = [[ModifyInformationViewController alloc]init];
//                modify.isDeviceAdd = YES;
//                [modify setModifyInformationBlock:^(NSMutableDictionary *dic) {
//                    NSLog(@"%@",dic);
////                    name.text = dic[@"nickName"];
////                    userIdStr = dic[@"id"];
//                    [g_familyList replaceObjectAtIndex:g_familyList.count-1 withObject:dic];
//                    if (g_familyList.count < 7) {
//                        [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
//                    }
//                }];
//                modify.log_pageID = 88;
//                modify.title = @"添加家庭成员";
//                modify.m_infoDic = [[NSMutableDictionary alloc]init];
//                [self.superVC.navigationController pushViewController:modify animated:YES];
//                [modify release];
//            }
//            else {
//                name.text = [dic objectForKey:myPicker.m_titleKey];
//                [_m_infoDic setObject:dic[myPicker.m_titleKey] forKey:@"familyName"];
//                [_m_infoDic setObject:dic[myPicker.m_idKey] forKey:@"accountId"];
//                [_m_infoDic setObject:dic[myPicker.m_titleKey] forKey:myPicker.m_titleKey];
//            }
//        }];
//    } withView:self] autorelease];
}

- (void)savebtn:(UIButton*)btn
{
    [self endEditing:YES];
    
//    [self hiddleKey];
    BOOL addSection = [_m_infoDic[@"IsAddSection"] boolValue];
    DiaryEventType eventState;
    switch (btn.tag )
    {
        case 5000:
            NSLog(@"删除");
            eventState = DiaryEventDelete;
            break;
        case 5001:
            NSLog(@"保存");
            eventState = addSection? DiaryEventAdd: DiaryEventUpate;
            break;
        default:
            break;
    }
    diaryZhanshiCellBlock(eventState, self.m_infoDic);
}

- (UIView *)setUpBackViewWithCount:(int)count
{
    UIView *backView  = [[UIView alloc]initWithFrame:CGRectMake(15, 15, kDeviceWidth-30, count*44)];
    backView.layer.cornerRadius = 2.5;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [CommonImage colorWithHexString:@"cccccc"].CGColor;
    backView.layer.borderWidth = 0.5f;
    return backView;
}

@end

