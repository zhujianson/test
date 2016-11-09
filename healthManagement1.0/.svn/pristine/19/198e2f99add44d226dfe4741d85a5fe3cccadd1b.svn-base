//
//  ModifyInformationViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"

typedef void(^ModifyInformationBlock)(NSMutableDictionary * dic);
@interface ModifyInformationViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIImage *m_image;
    ModifyInformationBlock addBlock;
}
@property (nonatomic, assign) BOOL isDeviceAdd;
@property (nonatomic, retain) NSMutableDictionary *m_infoDic;
- (void)setModifyInformationBlock:(ModifyInformationBlock)block;

@end
