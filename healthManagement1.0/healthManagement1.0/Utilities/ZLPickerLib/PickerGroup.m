//
//  PickerGroup.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "PickerGroup.h"

@implementation PickerGroup

-(void)dealloc
{
    self.groupName = nil;
    self.realGroupName = nil;
    self.thumbImage = nil;
    self.type = nil;
    self.group = nil;
    [super dealloc];
}

@end
