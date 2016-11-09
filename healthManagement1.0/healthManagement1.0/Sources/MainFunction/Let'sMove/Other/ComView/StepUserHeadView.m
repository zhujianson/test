//
//  StepUserHeadView.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-12-1.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "StepUserHeadView.h"

@implementation StepUserHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.photoImageView = nil;
    self.nameLabel = nil;
    self.descLabe = nil;
    self.localLabel = nil;
    self.localLabel2 = nil;
    self.resultDic = nil;
    [super dealloc];
}

/**
 *  获得头信息
 */
- (void)getHeadView
{
    
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 70, 70)];
    self.photoImageView.layer.cornerRadius = 35;
    self.photoImageView.layer.masksToBounds = YES;
    
//    [CommonImage setPicImageQiniu:self.resultDic[@"iconPath"] View:self.photoImageView Type:0 Delegate:nil];
    [CommonImage setImageFromServer:self.resultDic[@"iconPath"] View:self.photoImageView Type:0];

    [self addSubview:self.photoImageView];
    [self.photoImageView release];
    //昵称
    CGFloat nameX = self.photoImageView.frame.origin.x+self.photoImageView.width+20;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 19, kDeviceWidth-nameX-15, 19)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.nameLabel.text = self.resultDic[@"userName"];
    self.nameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [self addSubview:self.nameLabel];
    [self.nameLabel release];
    //描述
    self.descLabe = [[UILabel alloc] initWithFrame:CGRectMake(nameX, self.nameLabel.origin.y+self.nameLabel.size.height+8, kDeviceWidth-nameX-15, 14)];
    self.descLabe.font = [UIFont systemFontOfSize:14.0f];
//    self.descLabe.text = @"请求加入";
    self.descLabe.textColor = [CommonImage colorWithHexString:@"666666"];
    [self addSubview:self.descLabe];
    [self.descLabe release];
    
    
    if([self.resultDic[@"address"] isEqualToString:@"null"] ||[self.resultDic[@"address"] isEqualToString:@"(null)@(null)"] || [self.resultDic[@"address"] length] == 0){
        
        
    }else{
    
    
        NSArray *localArray = [self.resultDic[@"address"] componentsSeparatedByString:@"#"];
        
        CGSize size = [localArray[0] sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] constrainedToSize:CGSizeMake(kDeviceWidth-nameX-100-15, 16)];
        
        //位置1
        self.localLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, self.descLabe.origin.y+self.descLabe.size.height+7, size.width+5, 17)];//名字长度*15+8----但是限制一个最大值
        self.localLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.localLabel.text = localArray[0];
        self.localLabel.textColor = [UIColor whiteColor];
        self.localLabel.textAlignment = NSTextAlignmentCenter;
        self.localLabel.layer.cornerRadius = 2.0f;
        self.localLabel.layer.masksToBounds = YES;
        self.localLabel.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
        
        [self addSubview:self.localLabel];
        [self.localLabel release];
        
        CGSize size2 = [localArray[1] sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] constrainedToSize:CGSizeMake(kDeviceWidth-nameX-size.width-5-15, 16)];
        //位置2
        self.localLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.localLabel.origin.x+self.localLabel.size.width+5, self.descLabe.origin.y+self.descLabe.size.height+7, size2.width+5, 17)];//名字长度*15+5
        self.localLabel2.font = [UIFont boldSystemFontOfSize:13.0f];
        self.localLabel2.text = localArray[1];
        self.localLabel2.textColor = [UIColor whiteColor];
        self.localLabel2.textAlignment = NSTextAlignmentCenter;
        self.localLabel2.layer.cornerRadius = 2.0f;
        self.localLabel2.layer.masksToBounds = YES;
        self.localLabel2.backgroundColor = [CommonImage colorWithHexString:@"ffa34d"];
        
        [self addSubview:self.localLabel2];
        [self.localLabel2 release];
        
    }
    
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [self addSubview:lineView];
    [lineView release];
}


@end
