//
//  ImagePicker.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-9-1.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^imagePickerBlock)(id content);

@interface ImagePicker : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIViewController *nowVC;
    imagePickerBlock m_iamgePBlock;
}

// 每次选择图片的最大数, 默认是9
@property (nonatomic , assign) NSInteger maxCount;
//发送文字
@property(nonatomic,copy) NSString *sendTitle;
//是否是选择头像或者照片 默认选择头像
@property(nonatomic )BOOL selectHeadPhoto;

- (id)initWithId:(UIViewController*)VC;

- (void)setPickerViewBlock:(imagePickerBlock)back;

@end
