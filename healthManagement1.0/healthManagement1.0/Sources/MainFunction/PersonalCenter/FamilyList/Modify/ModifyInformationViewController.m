//
//  ModifyInformationViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ModifyInformationViewController.h"
//#import "NickNameViewController.h"
#import "MedicalHistoryViewController.h"
#import "FamilyHistoryViewController.h"
#import "ASIFormDataRequest.h"
//#import "JSON.h"
#import "CommonHttpRequest.h"
#import "PickerView.h"
#import "InputDueDatePicker.h"
#import "ImagePicker.h"
//#import "AccordingView.h"
#import "KXSwitch.h"
//#import "FamilyListView.h"
#import "GetToken.h"
#import "CommonUser.h"
#import "ModifyInformationCell.h"
#import "NSObject+KXJson.h"
#import "SDImageCache.h"

@interface ModifyInformationViewController ()<UITextFieldDelegate> {
    UITableView* myTable;
    NSArray* dataArray;
    BOOL m_isPhoto;//判断是添加自己的头像还是家人的头像
    UIImage * m_HeaderImage;
}
@end

@implementation ModifyInformationViewController
@synthesize m_infoDic;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
//    if (m_infoDic[@"id"]) {
//        [FamilyListView updateSelectFamilyInfoByUserid:m_infoDic];
//    }
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [myTable release];
    [dataArray release];
    if (m_HeaderImage) {
        [m_HeaderImage release];
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"理想体重",@"value" : [NSString stringWithFormat:@"%.1f kg", ([[m_infoDic objectForKey:@"hight"] floatValue]/100 * [[m_infoDic objectForKey:@"hight"] floatValue]/100) * 24] }],    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    if (!m_infoDic.count) {
        myTable.tableFooterView = [self createSaveBtn:0];
        [m_infoDic setObject:@"1" forKey:@"sex"];
        [m_infoDic setObject:@"1" forKey:@"is_add"];
        [m_infoDic setObject:@"0" forKey:@"complication"];
    }else {
        [m_infoDic setObject:@"0" forKey:@"is_add"];
    }

    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    myTable.backgroundColor = [UIColor clearColor];
    myTable.showsVerticalScrollIndicator = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    myTable.backgroundView = view;
    [view release];
    [self.view addSubview:myTable];
}

- (UIView*)createSaveBtn:(CGFloat)h
{
    UIView * view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 84)]autorelease];
    UIButton* btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(20, 20, kDeviceWidth-40, 44);
    [btn_save setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn_save setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    btn_save.titleLabel.font = [UIFont systemFontOfSize:20];
    btn_save.layer.cornerRadius = 4;
    btn_save.clipsToBounds = YES;
    btn_save.tag = 404;
    
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [btn_save setBackgroundImage:image forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(addFamily:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_save];
    return view;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (dataArray) {
        [dataArray release];
        dataArray = nil;
    }
    
    dataArray = [[NSArray alloc] initWithObjects:
                 [NSArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"头像",@"value" : [Common isNULLString3:[m_infoDic objectForKey:@"filePath"]] }],[NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"姓名",@"value" : [Common isNULLString3:[m_infoDic objectForKey:@"nickName"]] }],
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"性别",@"value" : [CommonUser getSex:[m_infoDic objectForKey:@"sex"]] }],
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"生日",@"value" : [Common isNULLString3:[m_infoDic objectForKey:@"birthday"]] }],
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"身高",@"value" : [Common isNULLString3:[m_infoDic objectForKey:@"hight"]] }],
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"体重",@"value" : [Common isNULLString3:[m_infoDic objectForKey:@"weight"]] }],nil],
                 [NSArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"糖尿病分类",@"value" : [Common isNULLString6:[m_infoDic objectForKey:@"diseaseType"]] }],
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"既往病史",@"value" : [Common isNULLString5:[m_infoDic objectForKey:@"history"]] }],
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"并发症", @"value" : [Common isNULLString2:[m_infoDic objectForKey:@"complication"]]}],nil],
                 [NSArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"绑定设备", @"value" : [self isAllspace:m_infoDic[@"is_bind_device"]] }],nil],nil];
    [myTable reloadData];
    [super viewWillAppear:animated];
}

- (void)addFamily:(UIButton*)add
{
    UITextField * textF1 = (UITextField*)[self.view viewWithTag:110];
    [textF1 resignFirstResponder];
    UITextField * textF2 = (UITextField*)[self.view viewWithTag:111];
    [textF2 resignFirstResponder];

    if (!m_infoDic[@"nickName"]) {
        [Common TipDialog2:@"姓名不能为空"];
        return;
    } else if (!m_infoDic[@"sex"]) {
        [Common TipDialog2:@"请选择性别"];
        return;
    } else if (!m_infoDic[@"birthday"]) {
        [Common TipDialog2:@"请选择生日"];
        return;
    } else if (!m_infoDic[@"hight"]) {
        [Common TipDialog2:@"请输入身高"];
        [textF1 becomeFirstResponder];
        return;
    } else if (!m_infoDic[@"weight"]) {
        [Common TipDialog2:@"请输入体重"];
        [textF2 becomeFirstResponder];
        return;
    } else if (!m_infoDic[@"diseaseType"]) {
        [Common TipDialog2:@"请选择糖尿病类型"];
        return;
    }
    if (!m_infoDic[@"history"]) {
        [m_infoDic setObject:@"" forKey:@"history"];
    }
    if (!m_infoDic[@"filePath"]) {
        [m_infoDic setObject:@"" forKey:@"filePath"];
    }
    if (!m_infoDic[@"complication"]) {
        [m_infoDic setObject:@"否" forKey:@"complication"];
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:m_infoDic[@"filePath"] forKey:@"filePath"];
    [dic setObject:m_infoDic[@"history"] forKey:@"history"];
    [dic setObject:m_infoDic[@"diseaseType"] forKey:@"diseaseType"];
    [dic setObject:m_infoDic[@"weight"] forKey:@"weight"];
    [dic setObject:m_infoDic[@"hight"] forKey:@"hight"];
    [dic setObject:m_infoDic[@"birthday"] forKey:@"birthday"];
    [dic setObject:m_infoDic[@"sex"] forKey:@"sex"];
    [dic setObject:m_infoDic[@"nickName"] forKey:@"nickName"];
    [dic setObject:m_infoDic[@"complication"] forKey:@"complication"];

    add.userInteractionEnabled = NO;
    
    if (!m_isPhoto) {
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:ADD_FAMILY values:dic requestKey:ADD_FAMILY delegate:self controller:self actiViewFlag:1 title:@"添加中..."];
        return;
    }
    
//    ModifyInformationCell *cell = (ModifyInformationCell*)[myTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSData *data = UIImageJPEGRepresentation([m_HeaderImage retain], Define_picScale);

    [GetToken submitData:data withBlock:^(BOOL isOK,NSString*st) {
        [self stopLoadingActiView];
        if (!isOK) {
            [Common TipDialog2:@"创建家人失败，请检查网络是否正常!"];
        }else
        {
            [dic setObject:st forKey:@"filePath"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:ADD_FAMILY values:dic requestKey:ADD_FAMILY delegate:self controller:self actiViewFlag:1 title:@"添加中..."];
            
        }
    } withName:nil];

}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath.section && !indexPath.row) {
        return 80;
    }
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray[section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[[UIView alloc]init]autorelease];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* cellF = @"cell";
    ModifyInformationCell* cell = [tableView dequeueReusableCellWithIdentifier:cellF];
    if (!cell) {
        cell = [[[ModifyInformationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellF] autorelease];
        if ([m_infoDic[@"is_app_active"] intValue] && ![m_infoDic[@"is_current_user"] intValue]) {
            cell.userInteractionEnabled = NO;
        }
        __block typeof(self) weak = self;
        [cell setP_block:^(NSDictionary *dic) {
             NSMutableDictionary * dic2 = dataArray[0][4];
            if ([dic[@"title"] isEqualToString:@"请输入身高"]) {
                if ([m_infoDic[@"hight"] isEqualToString:dic[@"text"]]) {
                }else if ([dic[@"text"] length]>0) {
                    [weak setAddData:@"身高" data:dic[@"text"]];
                }else{
                    [m_infoDic removeObjectForKey:@"hight"];
                }
            }else{
                dic2 = dataArray[0][5];
                if ([m_infoDic[@"weight"] isEqualToString:dic[@"text"]]) {
                }else
                if ([dic[@"text"] length]>0) {
                    
                    [weak setAddData:@"体重" data:dic[@"text"]];
                }else{
                    [m_infoDic removeObjectForKey:@"weight"];
                }
            }
            [dic2 setObject:[Common isNULLString3:dic[@"text"]] forKey:@"value"];

            NSLog(@"%@",dic);
        }];
    }
    cell.selectedBackgroundView = [Common creatCellBackView];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (!indexPath.section && indexPath.row == 3) {
        if ([m_infoDic objectForKey:@"birthday"]) {
            [dic setObject:[m_infoDic objectForKey:@"birthday"] forKey:@"value"];
        }
        [dic setObject:@"生日" forKey:@"title"];
    }else if (indexPath.section==1 && indexPath.row == 0){
        if ([m_infoDic objectForKey:@"diseaseType"]) {
            [dic setObject:[Common isNULLString6:[m_infoDic objectForKey:@"diseaseType"]] forKey:@"value"];
        }
        [dic setObject:@"糖尿病类型" forKey:@"title"];
    }else if (indexPath.section==1 && indexPath.row == 2){
        if ([m_infoDic objectForKey:@"complication"]) {
            [dic setObject:[Common isNULLString2:[m_infoDic objectForKey:@"complication"]] forKey:@"value"];
        }
        [dic setObject:@"并发症" forKey:@"title"];
    }else {
        dic = dataArray[indexPath.section][indexPath.row];
    }
    [cell setInfoWithDic:dic object:self isHide:![m_infoDic[@"is_add"] intValue] headerImage:m_HeaderImage];
    if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self textResignFirstResponder];
    NSMutableDictionary* dic = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    ModifyInformationCell * cell = [myTable cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
    case 0: {
        switch (indexPath.row) {
            case 0:
            {
                ModifyInformationCell *cell = (ModifyInformationCell*)[myTable cellForRowAtIndexPath:indexPath];
                ImagePicker *picker = [[ImagePicker alloc] initWithId:self];
                [picker setPickerViewBlock:^(UIImage *image) {
                    [cell setHeaderImageView:image];
                    m_HeaderImage = image;
                    m_isPhoto = YES;
                    if ([m_infoDic[@"is_add"] intValue] == 0) {
                        [self showLoadingActiview];
                        
                        NSData *data = UIImageJPEGRepresentation(image, Define_picScale);
                        [GetToken submitData:data withBlock:^(BOOL isOK,NSString*st) {
                            [self stopLoadingActiView];
                            if (!isOK) {
                                [Common TipDialog2:@"图片上传失败，请检查网络是否正常!"];
                            }else
                            {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                [dic setObject:st forKey:@"filePath"];
                                if ([m_infoDic[@"is_current_user"] intValue] == 0) {
                                    [dic setObject:m_infoDic[@"id"] forKey:@"id"];
                                }
                                [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATAField_API_URL values:dic requestKey:UPDATAField_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"修改中...", nil)];
                                [picker release];
                                
                            }
                        } withName:nil];
                    }
                    
                    [picker release];
                }];

            }
                break;
                case 1:
            {
//                NickNameViewController* modify = [[NickNameViewController alloc] init];
//                modify.log_pageID = 89;
//                modify.title = @"姓名";
//                modify.m_infoDic = m_infoDic;
//                modify.m_strUrl = @"姓名";
//                [self.navigationController pushViewController:modify animated:YES];
//                [modify release];

            }
                break;
            case 3:
            {
                [self setTimePickerWithString:dic[@"value"]];
            }
                break;
            case 4:
            {
                [cell setbecomeFirstResponder];
            }
                break;
            case 5:
            {
                [cell setbecomeFirstResponder];

            }
                break;

            default:
                break;
        }
    }
            break;
    case 1: {
        switch (indexPath.row) {
        case 0:
            [self setPickerWithType:dic[@"title"]];
            break;
        case 1: {
            FamilyHistoryViewController* medical = [[FamilyHistoryViewController alloc] init];
            medical.m_infoDic = m_infoDic;
            [self.navigationController pushViewController:medical animated:YES];
            [medical release];
            
        } break;
        case 2: {
            [self setPickerWithType:dic[@"title"]];
            
        } break;

        default:
            break;
        }
    } break;
    }
}

- (void)setPickerWithType:(NSString*)title
{
    //    NSString *title = [m_infoDic objectForKey:@"title"];
    NSMutableArray* fiisrtArray;
    NSString* defualt, *titl;
    if ([title isEqualToString:@"并发症"]) {
        titl = @"是否存在并发症";
        fiisrtArray = [NSMutableArray arrayWithObjects:@"有", @"无", nil];
        defualt = [Common isNULLString2:m_infoDic[@"complication"]];

    } else if ([title isEqualToString:@"糖尿病分类"]) {
        titl = @"糖尿病类型";
        fiisrtArray = [NSMutableArray arrayWithObjects:@"糖尿病前期(IFG+IGT)", @"Ⅱ型糖尿病", @"Ⅰ型糖尿病",@"妊娠糖尿病",@"无糖尿病",  nil];
        defualt = [Common isNULLString6:m_infoDic[@"diseaseType"]];
    }

    PickerView* myPicker = [[PickerView alloc] init];
    [myPicker createPickViewWithArray:[NSArray arrayWithObject:fiisrtArray] andWithSelectString:defualt setTitle:titl isShow:NO];
    [myPicker setPickerViewBlock:^(NSString* content) {
        if ([title isEqualToString:@"并发症"]) {
            if (![[Common isNULLString2:[m_infoDic objectForKey:@"complication"]] isEqualToString:content]) {
                [self setAddData:title data:content];
            }
        } else if ([title isEqualToString:@"糖尿病分类"]) {
            if (![m_infoDic[@"diseaseType"] isEqualToString:[CommonUser getBloodSugarDic2][@"content"]]) {
                [self setAddData:title data:content];
            }

        }
    }];
}

- (void)setTimePickerWithString:(NSString *)timeString
{
    if (!timeString.length)
    {
        timeString = @"1975-06-15";
    }
    //时间日期选择器
    InputDueDatePicker* inputDueDateView = [[InputDueDatePicker alloc] initWithTitle:@"请选择出生年月日"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateTime = [dateFormatter dateFromString:timeString];
    inputDueDateView.inputDueDatePicker.date = dateTime;
    [dateFormatter release];
    
    [self.view addSubview:inputDueDateView];
    [inputDueDateView setInputDueDatePickerBlock:^(NSDate* date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * datestr = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        if (![m_infoDic[@"birthday"] isEqualToString:datestr]) {
            [self setAddData:@"生日" data:datestr];
        }
    }];
    [inputDueDateView release];
}

- (void)setAddData:(NSString*)title data:(NSString*)data
{
    //    [m_infoDic setObject:data forKey:@"value"];
    [self setReloadData:title data:data];
    if ([m_infoDic[@"is_add"] intValue] == 1) {
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([title isEqualToString:@"生日"]) {
            [dic setObject:data forKey:@"birthday"];
            if ([m_infoDic[@"is_current_user"] intValue] == 1) {
                g_nowUserInfo.birthday = data;
            }
    } else if ([title isEqualToString:@"身高"]) {
            [dic setObject:data forKey:@"height"];
            if ([m_infoDic[@"is_current_user"] intValue] == 1) {
                g_nowUserInfo.height = [data intValue];
            }
    } else if ([title isEqualToString:@"体重"]) {
            [dic setObject:data forKey:@"weight"];
            if ([m_infoDic[@"is_current_user"] intValue] == 1) {
                g_nowUserInfo.weight = [data intValue];
            }
    } else if ([title isEqualToString:@"并发症"]) {
            [dic setObject:[self setComplication:data] forKey:@"is_complication"];
    } else if ([title isEqualToString:@"糖尿病分类"]) {
            [dic setObject:[CommonUser getBloodSugarDic2][data] forKey:@"diabetic_type"];
            if ([m_infoDic[@"is_current_user"] intValue] == 1) {
                g_nowUserInfo.diabetesType = data;
            }
    } else if ([title isEqualToString:@"性别"]) {
            [dic setObject:[data isEqualToString:@"男"] ? @"1" : @"2" forKey:@"sex"];
            if ([m_infoDic[@"is_current_user"] intValue] == 1) {
                g_nowUserInfo.sex = dic[@"sex"];
            }
        }
    if ([m_infoDic[@"is_current_user"] intValue] == 0) {
        [dic setObject:m_infoDic[@"id"] forKey:@"id"];
    }
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATAField_API_URL values:dic requestKey:UPDATAField_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"修改中...", nil)];
}

- (void)setReloadData:(NSString*)title data:(NSString*)data
{
    int row,section;
    if ([title isEqualToString:@"生日"]) {
        [m_infoDic setObject:data forKey:@"birthday"];
        row = 3;
        section = 0;
    } else if ([title isEqualToString:@"身高"]) {
        [m_infoDic setObject:data forKey:@"hight"];
        return;
    } else if ([title isEqualToString:@"体重"]) {
        [m_infoDic setObject:data forKey:@"weight"];
        return;
    } else if ([title isEqualToString:@"性别"]) {
        [m_infoDic setObject:[data isEqualToString:@"男"] ? @"1" : @"2" forKey:@"sex"];
        return;
    } else if ([title isEqualToString:@"糖尿病分类"]) {
        [m_infoDic setObject:[CommonUser getBloodSugarDic2][data] forKey:@"diseaseType"];
        row = 0;
        section = 1;
    } else if ([title isEqualToString:@"并发症"]) {
        [m_infoDic setObject:[self setComplication:data] forKey:@"complication"];
        row = 2;
        section = 1;
    }
    [myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
}
/**
 *  section背景
 *
 *  @param tableView mytable
 *  @param section   section
 *
 *  @return section背景
 */
- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section
{
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    return cleanView;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self textResignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_isDeviceAdd) {
        addBlock(m_infoDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    UIButton * btn = (UIButton*)[self.view viewWithTag:404];
    btn.userInteractionEnabled = YES;
    
}

#pragma mark - NetWork Function

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    
    NSDictionary * dic = dict[@"head"];
    
    NSLog(@"%@",dict);
    if (![[dic objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        UIButton * btn = (UIButton*)[self.view viewWithTag:404];
        btn.userInteractionEnabled = YES;
        return;
    }
    ModifyInformationCell *cell = (ModifyInformationCell*)[myTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if (![[dic objectForKey:@"state"] intValue]) {
        if ([loader.username isEqualToString:ADD_FAMILY]) {
            [m_infoDic setObject:[NSString stringWithFormat:@"%@",dict[@"body"][@"id"]] forKey:@"id"];
            [m_infoDic setObject:[NSString stringWithFormat:@"%@",dict[@"body"][@"user_no"]] forKey:@"user_no"];

            if (m_isPhoto && [dict objectForKey:@"body"][@"img_url"]) {
                m_isPhoto = NO;
                NSString *imgURL1 = [dict objectForKey:@"body"][@"img_url"];
                NSString *imgURL = [Common getImagePath:imgURL1 Widht:80 * 2 Height:80 * 2];
                NSString *strPath = [SDImageCache cachedFileNameForKey:imgURL];
//                NSString *str = [imgURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                
                [UIImageJPEGRepresentation(cell.headerImage.image, Define_picScale) writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strPath] atomically:YES];
                [m_infoDic setObject:imgURL1 forKey:@"filePath"];
            }

            UIAlertView* av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"添加成功", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [av show];
            [av release];
            
        }
        else if ([loader.username isEqualToString:UPDATAField_API_URL] | [loader.username isEqualToString:UPDATE_USER_INFO]) {

            MBProgressHUD* progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"修改成功";
            progress_.mode = MBProgressHUDModeText;
            progress_.userInteractionEnabled = NO;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
            [progress_ show:YES];
            [progress_ showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [progress_ release];
                [progress_ removeFromSuperview];
            }];
            if (m_isPhoto && [dict objectForKey:@"body"][@"data"]) {
                m_isPhoto = NO;
                NSString *imgURL1 = [dict objectForKey:@"body"][@"data"];
                NSString *imgURL = [Common getImagePath:imgURL1 Widht:80 * 2 Height:80 * 2];
                
                NSString *strPath = [SDImageCache cachedFileNameForKey:imgURL];
//                NSString *str = [imgURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                [UIImageJPEGRepresentation(cell.headerImage.image, Define_picScale) writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strPath] atomically:YES];
                [m_infoDic setObject:imgURL1 forKey:@"filePath"];
                if ([m_infoDic[@"is_current_user"] intValue] == 1) {
                    g_nowUserInfo.filePath = imgURL1;
                    [[NSUserDefaults standardUserDefaults] setObject:g_nowUserInfo.filePath forKey:[NSString stringWithFormat:@"%@_loadingImage",g_nowUserInfo.mobilePhone]];//头像缓存
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    } else {
        [Common TipDialog:[dic objectForKey:@"msg"]];
    }
}

- (NSString*)isAllspace:(NSString*)ling
{
    int temp = [ling intValue];
    if (temp) {
        return @"已绑定设备";
    }
    return @"未绑定设备";
}


- (void)textResignFirstResponder
{
    ModifyInformationCell *cell;
    for (int i = 4; i<6; i++) {
        cell = (ModifyInformationCell*)[myTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell setResignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==110) {
        if ([m_infoDic[@"hight"] isEqualToString:textField.text]) {
            return;
        }
        if ([textField.text length]>0 && [textField.text floatValue]>0) {
            [self setAddData:@"身高" data:textField.text];
        }else{
            [m_infoDic removeObjectForKey:@"hight"];
        }
    }else{
        if ([m_infoDic[@"weight"] isEqualToString:textField.text]) {
            return;
        }
        if ([textField.text length]>0 && [textField.text floatValue]>0) {
        [self setAddData:@"体重" data:textField.text];
        }else{
            [m_infoDic removeObjectForKey:@"weight"];

        }
    }
}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[[UITextField alloc] init]autorelease];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeRight;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.backgroundColor = [UIColor clearColor];
    text.frame = CGRectMake(kDeviceWidth-60-100, 0, 100, 46);
    text.textAlignment = NSTextAlignmentRight;
    //    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"999999"]];
    [text setFont:[UIFont systemFontOfSize:15]];
    return text;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];
    
    if ([changeString length]>3) {
        return NO;
    }
    return YES;
}


- (void)switchValueChanged:(UISwitch*)s
{
    NSString * sex = nil;
    if (s.on) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    [self setAddData:@"性别" data:sex];
}

- (NSString*)setComplication:(NSString*)complication
{
    if ([complication isEqualToString:@"有"]) {
        return @"1";
    }else{
        return @"0";
    }
}


- (void)setModifyInformationBlock:(ModifyInformationBlock)block
{
    addBlock = [block copy];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end