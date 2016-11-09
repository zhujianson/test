//
//  SettingViewController.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-3-17.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "SettingViewController.h"
#import "EditPwdViewController.h"
#import "FeedbackViewController.h"
#import "FirstLogingViewController.h"
#import "CommonHttpRequest.h"
#import "ClearBufferViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "DisclaimerViewController.h"
#import "ASIFormDataRequest.h"
#import "SDImageCache.h"
#import "CommonImage.h"
#import "SFHFKeychainUtils.h"


@interface SettingViewController () {
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        self.log_pageID = 29;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_array = [[NSArray alloc] initWithObjects:
               [NSArray arrayWithObjects:
//                NSLocalizedString(@"意见反馈", nil),
                NSLocalizedString(@"清理缓存", nil),
                nil],
               [NSArray arrayWithObjects:
                NSLocalizedString(@"用户须知", nil),
                NSLocalizedString(@"关于我们", nil),
                NSLocalizedString(@"给个好评", nil),
                NSLocalizedString(@"康迅学糖", nil),
                nil],
//               [NSArray arrayWithObjects:
//                //                NSLocalizedString(@"意见反馈", nil),
//                NSLocalizedString(@"计步语音播报", nil),
//                nil],

               nil];
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.rowHeight = 55;
    m_tableView.backgroundColor = [UIColor clearColor];
    //分割线颜色
    if (IOS_7) {
        m_tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }

    m_tableView.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:m_tableView];
    [Common setExtraCellLineHidden:m_tableView];
    //    [self loadDataBegin];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = view;
    [view release];
    
    [m_tableView setTableFooterView:[self withdrawFromAccount]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [m_array count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_array[section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"cell11";;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"000000"];
        
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
            //自定义右箭头
//        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-30 Y:(cell.frame.size.height-12)/2 cell:cell];
        UIImage * image =[UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
        UIImageView*rightView = [[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-20-image.size.width,0, image.size.width, 55)]autorelease];
        rightView.contentMode = UIViewContentModeCenter;
        rightView.image = image;
        [cell addSubview:rightView];
        
        
         UISwitch  *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth -(IOS_7? 65:90),5, 50, 30)];
        switchView.tag = 188;
        switchView.onTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
        switchView.on = YES;//[self.dataDic[@"bsFlag"] intValue];
        [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchView];
        
        
    }
    
    
    cell.textLabel.text =
    [m_array[indexPath.section] objectAtIndex:indexPath.row];
    
    UISwitch *theSwitch = (UISwitch *)[cell.contentView viewWithTag:188];
    
    if(indexPath.section != 2){
        cell.accessoryView.hidden = NO;
        theSwitch.hidden = YES;
    }else{
        
         BOOL closeVoiceFlag = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"closeVoiceFlag_%@",g_nowUserInfo.userid]];
        
        cell.accessoryView.hidden = YES;
        theSwitch.hidden = NO;
        theSwitch.on = !closeVoiceFlag;
    }
    
    
    return cell;
}


- (void)switchValueChanged:(UISwitch*)switchView
{
    if(switchView.tag == 188){
        
        BOOL closeVoiceFlag = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"closeVoiceFlag_%@",g_nowUserInfo.userid]];
        
//        [Common getAppDelegate].stepCounterObj.disableVoiceFlage = !closeVoiceFlag;
        
        [[NSUserDefaults standardUserDefaults] setBool:!closeVoiceFlag forKey:[NSString stringWithFormat:@"closeVoiceFlag_%@",g_nowUserInfo.userid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc] init];
                [self.navigationController pushViewController:disclaimerVC animated:YES];
                [disclaimerVC release];
            }
                break;
            case 1: {
                AboutViewController* about = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:about animated:YES];
                [about release];
            }
                break;
            case 2:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
                self.log_pageID = 30;

            }
                break;
            case 3:
            {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.9haohealth.kangxun360://"]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.9haohealth.kangxun360://"]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", @"896176289"]]];
                }
                self.log_pageID = 45;
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
//            case 0:
//            {
//                {//意见反馈
//                    FeedbackViewController* feedBack = [[FeedbackViewController alloc] init];
//                    feedBack.log_pageID = 104;
//                    [self.navigationController pushViewController:feedBack animated:YES];
//                    [feedBack release];
//                }
//
//            }
//                break;
            case 0:
            {
                NSLog(@"清理缓存");
                UIAlertView* curr2=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要清理缓存吗？" delegate:self cancelButtonTitle:@"不清理" otherButtonTitles:@"清理", nil];
                curr2.tag = 119;
                [curr2 show];
            }
                break;
   
            default:
                break;
        }

    }
}

- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 119 && buttonIndex == 1){
        [self showLoadingActiview];
        [self clearnLocalImageCache];
    }else if(alertView.tag == 999){
        if (buttonIndex) {
            g_longTime = 0;
            //切换用户，重新上传push信息
            [self cancelload];
            AppDelegate* myDelegate = [Common getAppDelegate];
//            myDelegate.stepCounterObj.notShowFailView = YES;//上传失败关闭提示
//            [myDelegate.stepCounterObj uploadDataRequest];//上传数据
//            g_nowUserInfo.userid = nil;
//            myDelegate.stepCounterObj.isLoginFlag = NO;//退出登录了
            myDelegate.isUploadPushInfo = NO;
            //默认关闭计步器
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];//默认关闭
//            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSelector:@selector(qweqwe) withObject:nil afterDelay:0.35];
            //        [self qweqwe];
            if (g_nowUserInfo.thirdLogin)
            {
                //            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
                //            [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
                //            [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"thirdUserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                g_nowUserInfo.thirdLogin = NO;
            }
            //        g_nowUserInfo = nil;
//            [g_nowUserInfo removeAllKeyValue];
            g_nowUserInfo = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setRemoveFloatView" object:self];
        }
    }
    
}

//清理本地缓存
- (void)clearnLocalImageCache
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *imagePath = [Common getImagePath];
        NSString *path ;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *fileEnumerator =[fileManager enumeratorAtPath:imagePath];
        while ((path = [fileEnumerator nextObject]) != nil) {
            BOOL directory;
            NSError *error = nil;
            [fileManager  fileExistsAtPath:path isDirectory:&directory];
            if(!directory){
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[Common getImagePath],path] error:&error];
                if(error){
                    NSLog(@"清理缓存,%@",error);
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                
                MBProgressHUD* progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
                progress_.labelText = @"清理成功";
                progress_.mode = MBProgressHUDModeText;
                progress_.userInteractionEnabled = NO;
                [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
                [progress_ show:YES];
                [progress_ showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [progress_ release];
                    [progress_ removeFromSuperview];
                }];

                [self stopLoadingActiView];
            }];
        });
    });
    
}


- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    return cleanView;
}


/**
 *  退出按钮
 *
 *  @return 退出按钮
 */
- (UIView*)withdrawFromAccount
{
    UIView* cleanView =
    [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 55)] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    UIButton* withBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withBtn.frame = CGRectMake(0, 0, kDeviceWidth, 55);
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
    [withBtn setBackgroundImage:image forState:UIControlStateNormal];
    [withBtn setTitleColor:[CommonImage colorWithHexString:@"000000"] forState:UIControlStateNormal];
    withBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [withBtn setTitle:NSLocalizedString(@"退出登录", nil)
             forState:UIControlStateNormal];
    [withBtn addTarget:self
                action:@selector(withdraw)
      forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:withBtn];
    return cleanView;
}

- (void)withdraw
{
    UIAlertView* av = [[UIAlertView alloc]
                       initWithTitle:NSLocalizedString(@"提示", nil)
                       message:NSLocalizedString(@"您确定要退出应用吗？",
                                                 nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"取消", nil)
                       otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    av.tag = 999;
    [av show];
    [av release];
}

//退出登录取消自动登录和秘密保存
- (void)cancelload
{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"checkstatus"];
    NSString* name = [CommonUser getUserName];
    [SFHFKeychainUtils deleteItemForUsername:name andServiceName:BUNDLE_IDENTIFIER error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/**
 *  返回登录界面
 */
- (void)qweqwe
{
    FirstLogingViewController* LoginViewCon = [[FirstLogingViewController alloc] init];
    UIImage* loginViewImage = [CommonImage imageWithView:LoginViewCon.view];
    UIImageView* loginView = [[UIImageView alloc] initWithImage:loginViewImage];
    loginView.frame = CGRectMake(0, kDeviceHeight + 64, kDeviceWidth, kDeviceHeight + 64);
    [self.navigationController.view addSubview:loginView];
    [loginView release];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect rect = loginView.frame;
                         rect.origin.y = 0;
                         loginView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         [loginView removeFromSuperview];
                         //      LoginViewController *view1 = [[LoginViewController alloc]
                         //      init];
                         CommonNavViewController* view1 = [[CommonNavViewController alloc]
                                                           initWithRootViewController:LoginViewCon];
                         [LoginViewCon release];
                         APP_DELEGATE.rootViewController = view1;
                         [view1 release];
                     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_tableView release];
    m_tableView = nil;
    [m_userPhone release];
    [super dealloc];
}

@end
