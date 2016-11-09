//
//  InvitationDoctorViewController.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "Common.h"

@interface InvitationDoctorViewController : CommonViewController
- (void)setInviteView;//用户编号
- (void)setIphotoView;//手机号
- (void)getFriendData;//请求好友信息
@property (nonatomic,copy) NSString* m_invite;//扫一扫用户编号

@end
