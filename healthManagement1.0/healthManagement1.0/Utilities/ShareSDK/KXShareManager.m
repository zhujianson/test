//
//  KXShareManager.m
//  jiuhaohealth4.0
//
//  Created by wangmin on 15/9/11.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "AppDelegate.h"
#import "KXShareManager.h"
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation KXShareManager
{
    __block MBProgressHUD *_m_Progress;
}

+ (KXShareManager *)sharedManager
{
    static KXShareManager *class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        class = [[KXShareManager alloc] init];
        [ShareSDK registerApp:@"baddd3f33600"
              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformTypeWechat),
                                @(SSDKPlatformTypeQQ)
                                ]
                     onImport:^(SSDKPlatformType platformType) {
                         
                         switch (platformType)
                         {
                             case SSDKPlatformTypeWechat:
                                 //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                 break;
                             case SSDKPlatformTypeQQ:
                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                 break;
                             case SSDKPlatformTypeSinaWeibo:
                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                 break;
                             default:
                                 break;
                         }
                         
                     }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                  
                  switch (platformType)
                  {
                      case SSDKPlatformTypeSinaWeibo:
                          //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                          [appInfo SSDKSetupSinaWeiboByAppKey:@"2840519896"
                                                    appSecret:@"97bf54ec37c39de80c50ad7181896fd6"
                                                  redirectUri:@"http://www.kangxun360.com"
                                                     authType:SSDKAuthTypeBoth];
                          break;
                      case SSDKPlatformTypeWechat:
                          //微信
                          [appInfo SSDKSetupWeChatByAppId:@"wx14c1a87b93899c58"
                                                appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                          break;
                      case SSDKPlatformTypeQQ:
                          //QQ
                          [appInfo SSDKSetupQQByAppId:@"1104845447"
                                               appKey:@"gXzvkwTCr4Oa9Gtm"
                                             authType:SSDKAuthTypeBoth];
                          break;
                        
                      default:
                          break;
                  }
              }];
    });
    
    return class;
}


- (void)noneUIShareAllButtonClickHandler:(id)sender
                                 Content:(NSString *)contentStrings
                               ImagePath:(id)imagePath
                                AndTitle:(NSString *)titleString
                                     Url:(NSString *)url
                          haveCustomItem:(BOOL)haveCutomItem
{

    if(!url){
        url = @"http://www.kangxun360.com";
    }
    if (contentStrings.length > 80)
    {
        contentStrings = [contentStrings substringToIndex:80];
    }
    
    NSString *defaultContent = contentStrings;
    NSString *sinaTitle = titleString;
    NSString *WXFirendCircleTitle = titleString;
    
    id imageIcon = [UIImage imageNamed:@"common.bundle/common/news_logo.png"];
    id sinaImage = imageIcon;//[ShareSDK imageWithUrl:((NSString*)imagePath)];
    
    NSString *sinaShareUrl = [NSString stringWithFormat:@"%@operation/activity/share",NOTICE_DETAIL_URL];
    if([url  rangeOfString:@"&step" options:NSCaseInsensitiveSearch].length || ([url hasPrefix:sinaShareUrl])){
        sinaImage = imageIcon;
        defaultContent = contentStrings;
        sinaTitle = contentStrings;
        WXFirendCircleTitle = contentStrings;
    }
    if (imagePath)
    {
        //        微信要求缩略图大小不能超过32K的
        imageIcon = [imagePath stringByAppendingFormat:@"?imageView2/1/w/%d/h/%d",100,100];
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[imageIcon];
    [shareParams SSDKSetupShareParamsByText:defaultContent
                                     images:imageArray
                                        url:[NSURL URLWithString:url]
                                      title:titleString
                                       type:SSDKContentTypeAuto];
    //新浪定制
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[defaultContent stringByAppendingFormat:@"[详情]:%@",[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                               title:titleString
                                               image:imageArray
                                                 url:[NSURL URLWithString:url]
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
    //朋友圈定制
    [shareParams SSDKSetupWeChatParamsByText:defaultContent
                                       title:defaultContent
                                         url:[NSURL URLWithString:url]
                                  thumbImage:imageArray
                                       image:imageArray
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:@[@(SSDKPlatformTypeSinaWeibo),
                                                                       @(SSDKPlatformSubTypeWechatTimeline),
                                                                       @(SSDKPlatformSubTypeWechatSession),
                                                                       @(SSDKPlatformSubTypeQZone),
                                                                       @(SSDKPlatformSubTypeQQFriend)]];
    
    
    
    
//    [ShareSDK showShareActionSheet:nil
//                                                                     items:nil
//                                                               shareParams:shareParams
//                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                                                       }];
    //2、分享
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                             items:activePlatforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           [Common MBProgressTishi:@"分享成功" forHeight:kDeviceHeight];
                           [self sendShare];
                       }
                           break;
                       case SSDKResponseStateFail:
                       {
                             [Common MBProgressTishi:@"分享失败" forHeight:kDeviceHeight];
                       }
                           break;
                       case SSDKResponseStateCancel:
                       {
//                           [Common MBProgressTishi:@"分享结束" forHeight:kDeviceHeight];
                       }
                           break;
                       default:
                           break;
                   }
               }];
    //删除和添加平台示例
//    [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeWechat)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeQQ)];
}

- (void)sendWXFriendList:(NSDictionary*)dic withBlock:(ShareCallBlock)callb
{
    NSString *imagePath = dic[@"share_img"];
    if (imagePath)//微信要求缩略图大小不能超过32K的
    {
        imagePath = [imagePath stringByAppendingFormat:@"?imageView2/1/w/%d/h/%d",100,100];
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:dic[@"share_content"]
                                     images:imagePath
                                        url:dic[@"share_url"]
                                      title:dic[@"share_title"]
                                       type:SSDKContentTypeWebPage];
//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:dic[@"share_content"]
//                                     images:dic[@"share_img"]
//                                        url:dic[@"share_url"]
//                                      title:dic[@"share_title"]
//                                       type:SSDKContentTypeWebPage];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
                 
             case SSDKResponseStateSuccess:
             {
                 callb(YES);
             }
                 break;
             case SSDKResponseStateFail:
             {
             }
                 break;
             case SSDKResponseStateCancel:
             {
             }
                 break;
             default:
                 break;
         }
    }];
}

- (void)sendShare
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_grouppointForForwardPost values:dic requestKey:URL_grouppointForForwardPost delegate:self controller:nil actiViewFlag:0 title:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shearOK" object:nil];
}



- (void)hiddenProgressView
{
    if (_m_Progress)
    {
        [_m_Progress removeFromSuperview];
        _m_Progress  = nil;
    }
}

@end
