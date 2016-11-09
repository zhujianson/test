//
//  ImagePicker.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-9-1.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ImagePicker.h"
#import "ShowConsultViewController.h"
#import "PickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImagePicker ()<PickerViewControllerDelegate>

@end

@implementation ImagePicker

- (id)initWithId:(UIViewController*)VC
{
    self = [super init];
    if (self) {
        _sendTitle = @"发送";
        _selectHeadPhoto = YES;
        nowVC = VC;
//        if (![VC isKindOfClass:[ShowConsultViewController class]]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从相册选择", nil),nil];
            [actionSheet showInView:VC.view];
            [actionSheet release];
//        }else{
//            [self actionSheet:nil clickedButtonAtIndex:0];
//        }
        [self getQiniuToken];

    }
    return self;
}

- (void)getQiniuToken
{
    long time = [CommonDate getLongTime];
    if (time - g_longTime > 11 * 60 * 60) {
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_QINIU_TOKEN values:[NSDictionary dictionary] requestKey:GET_QINIU_TOKEN delegate:self controller:self actiViewFlag:0 title:nil];
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
    
    if (![[dic objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        return;
    }
    if ([loader.username isEqualToString:GET_QINIU_TOKEN]) {
        g_nowUserInfo.qiniuToken = dict[@"body"][@"token"];
        g_longTime = [CommonDate getLongTime];
    }
}

- (void)setPickerViewBlock:(imagePickerBlock)back
{
    m_iamgePBlock = [back copy];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    @try {
        //创建图像选取控制器
        switch (buttonIndex) {
            case 0:
            {
                if (![CommonImage isMedia]) {
                    [Common TipDialog2:@"请在iphone的“设置－隐私－相机”选项中，允许康迅360访问你的相机。"];
                    return;
                }
                //检查摄像头是否支持摄像机模式
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [self createImgePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
                } else {
                    [Common TipDialog:NSLocalizedString(@"您没有摄像头", nil)];
                    return;
                }
                break;
            }
            case 1:
            {
                if (!_selectHeadPhoto)
                {
                    //设置图像选取控制器的来源模式为相机模式
                    PickerViewController *pickerVc = [[PickerViewController alloc] init];
                    // 默认显示相册里面的内容SavePhotos
                    pickerVc.status = PickerViewShowStatusGroup;
                    pickerVc.sendTitle = _sendTitle;
                    // 选择图片的最大数
                    pickerVc.maxCount = _maxCount;
                    pickerVc.delegate = self;
                    [nowVC presentViewController:pickerVc animated:YES completion:nil];
                    [pickerVc release];
                }
                else
                    [self createImgePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)createImgePickerControllerWithType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController* imagePickerController  = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = sourceType;
    //允许用户进行编辑
    if (_selectHeadPhoto)
    {
        imagePickerController.allowsEditing = YES;
    }
    //设置委托对象
    imagePickerController.delegate = self;
    //以模式视图控制器的形式显示
    [nowVC presentViewController:imagePickerController animated:YES completion:nil];
    [imagePickerController release];
}

//选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
//    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:editingInfo];

//    UIImage* original_image = [dict objectForKey:@"UIImagePickerControllerOriginalImage"];
//    UIImageWriteToSavedPhotosAlbum(original_image, self, nil, nil);
    
    //获得编辑过的图片
//    headerImage.image = image;
//    [delegate getSelPic:image];
    m_iamgePBlock(image);
    
    //获得编辑过的图片
    [nowVC dismissViewControllerAnimated:YES completion:nil];
}

// 代理回调方法
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    if (assets.count >0)
    {
        m_iamgePBlock(assets);
    }
    else
        return ;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [nowVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)setMaxCount:(NSInteger)maxCount{
    if (maxCount <= 0) return;
    _maxCount = maxCount;
}

-(void)setSendTitle:(NSString *)sendTitle
{
    _sendTitle = sendTitle;
}

-(void)setSelectHeadPhoto:(BOOL)selectHeadPhoto
{
    _selectHeadPhoto = selectHeadPhoto;
}

-(void)dealloc
{
    [m_iamgePBlock release];
    self.sendTitle = nil;
    [super dealloc];
}
@end
