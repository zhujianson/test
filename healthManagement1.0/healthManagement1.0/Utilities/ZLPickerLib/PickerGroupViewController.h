//
//  PickerGroupViewController.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"

@interface PickerGroupViewController : CommonViewController

@property (nonatomic , assign) id<PickerViewControllerDelegate> delegate;
@property (nonatomic , assign) PickerViewShowStatus status;
@property (nonatomic , assign) NSInteger maxCount;

@property(nonatomic,copy) NSString *sendTitle;

@end
