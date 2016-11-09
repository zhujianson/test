//
//  SelFamilyView.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-9-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SelFamilyView.h"
#import "Global.h"
#import "GetFamilyList.h"
#import "Global_Url.h"

@implementation SelFamilyView
{
    selFamilyViewBlock _inBlock;
}
@synthesize delegate;
@synthesize selIndex = selIndex;

- (id)initWithFrame:(CGRect)frame PicHeight:(float)height
{
    self = [super initWithFrame:frame];
    if (self) {
        selIndex = 0;
        m_picHeight = height;
        if (!g_familyList) {
          [[GetFamilyList alloc] initWithBlcok:^(NSMutableArray *farray){
                if (!g_familyList.count) {
                    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
                    [dic setObject:g_nowUserInfo.userid forKey:@"id"];
                    [dic setObject:g_nowUserInfo.filePath forKey:@"filePath"];
                    [g_familyList addObject:dic];
                }
                [self createSelFamilyView:frame];
                UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, kDeviceWidth, 0.5)];
                lin.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
                lin.tag = 6666;
                [self addSubview:lin];
                [lin release];
            } withView:self];
//            [familyList release];
        }else{
            [self createSelFamilyView:frame];
            UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, kDeviceWidth, 0.5)];
            lin.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
            lin.tag = 6666;
            [self addSubview:lin];
            [lin release];
        }
    }
    return self;
}

//- (void)setSelIndex:(int)selInde
//{
////    UIButton *butLeft = (UIButton*)[self viewWithTag:1001];
////    UIButton *butRight = (UIButton*)[self viewWithTag:1002];
////
////    if (!selInde) {
////        butLeft.enabled = NO;
////    }else{
////        butLeft.enabled = YES;
////    }
////    if (selInde == g_familyList.count-1) {
////        butRight.enabled = NO;
////    }else{
////        butRight.enabled = YES;
////    }
//    [self setButEnabled];
//}

- (void)loadDataBegin
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:g_nowUserInfo.userid forKey:@"userId"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_FAMILY_LIST_BY_USERID values:dic requestKey:GET_FAMILY_LIST_BY_USERID delegate:self controller:self actiViewFlag:0 title:nil];
}

-(void)setSelFamilyViewBlock:(selFamilyViewBlock)_handler andHidenLine:(BOOL)hiden
{
    _inBlock = [_handler copy];
    UILabel *lineLable = (UILabel *)[self viewWithTag:6666];
    if (lineLable)
    {
        lineLable.hidden = hiden;
    }
}

- (void)setSelFamilyId:(NSString *)string
{
    if (!string) {
        return;
    }
    if (m_selFamilyId) {
        [m_selFamilyId release];
        m_selFamilyId = nil;
    }
    m_selFamilyId = [string retain];
//    for (NSDictionary *dic in g_familyList) {
    for (int i = 0;i<g_familyList.count;i++) {
        if ([[g_familyList[i] objectForKey:@"id"] isEqualToString:string]) {
            selIndex = i;
            break;
        }
    }
}

#pragma 选择家人头像
- (void)createSelFamilyView:(CGRect)frame
{
    float picwidht =  m_picHeight + 20;
    
    float scale = m_picHeight == 100 ? 1 : 0.7;
    //左边
    UIButton *butLeft = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/2 - picwidht/2 - 60, 0, 60, frame.size.height)];
    butLeft.tag = 1001;
    UIImage *image = [UIImage imageNamed:@"common.bundle/monitor/arrow_left.png"];
    CGSize size = image.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width * scale, size.height * scale), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width * scale, size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [butLeft setImage:scaledImage forState:UIControlStateNormal];
    [butLeft addTarget:self action:@selector(butEventSelFamily:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:butLeft];
    [butLeft release];
    
    //头像
    NSDictionary *dic = [NSDictionary dictionary];
    if (g_familyList.count) {
        dic = [g_familyList objectAtIndex:selIndex];
    }
    UIView *photo = [self createPhoto:dic selfView:frame.size.height];
    photo.frame = CGRectMake(butLeft.right, (frame.size.height-m_picHeight)/2, picwidht, m_picHeight);
    [self addSubview:photo];
    [photo release];
    
    //右边
    UIButton *butRight = [[UIButton alloc] initWithFrame:CGRectMake(photo.right, 0, butLeft.width, butLeft.height)];
    butRight.tag = 1002;
    image = [UIImage imageNamed:@"common.bundle/monitor/arrow_right.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width * scale, size.height * scale), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width * scale, size.height * scale)];
    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [butRight setImage:scaledImage forState:UIControlStateNormal];
    [butRight addTarget:self action:@selector(butEventSelFamily:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:butRight];
    [butRight release];
    
    if (g_familyList.count) {
        if (!selIndex) {
            butLeft.enabled = NO;
        }
        else if (selIndex == g_familyList.count-1) {
            butRight.enabled = NO;
        }
    }
    else {
        butLeft.enabled = NO;
        butRight.enabled = NO;
    }
}

- (NSMutableDictionary*)getFamilySel
{
    return [g_familyList objectAtIndex:selIndex];
}

//创建头像
- (UIView*)createPhoto:(NSDictionary*)dic selfView:(float)height
{
    UIView *view = [[UIView alloc] init];
    view.clipsToBounds = YES;
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, (height-self.picHeight)/2, self.picHeight, self.picHeight)];
    //    view.tag = 500;
    //    [viewb addSubview:view];
    //    [view release];
    
    UIButton *imagePhoto = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, m_picHeight, m_picHeight)];
    imagePhoto.tag = 501;
    imagePhoto.contentMode = UIViewContentModeScaleAspectFill;
    imagePhoto.layer.cornerRadius = imagePhoto.width/2;
    imagePhoto.clipsToBounds = YES;
    [imagePhoto addTarget:self action:@selector(butEventShowFamily) forControlEvents:UIControlEventTouchUpInside];
    [CommonImage setImageFromServer:[dic objectForKey:@"filePath"] View:imagePhoto Type:0];

//    [CommonImage setPicImageQiniu:[dic objectForKey:@"filePath"] View:imagePhoto Type:0 Delegate:^(NSString *strCon) {
//        NSDictionary *dicc = [g_familyList objectAtIndex:selIndex];
//        if ([dic isEqual:dicc]) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//            [imagePhoto setBackgroundImage:image forState:UIControlStateNormal];
//        }
//    }];
//    [Common getServerPic:[Common getImagePath:[dic objectForKey:@"filePath"] Widht:m_picHeight*2 Height:m_picHeight*2] View:imagePhoto Delegate:^(NSString *strCon) {
//        NSDictionary *dicc = [g_familyList objectAtIndex:selIndex];
//        if ([dic isEqual:dicc]) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//            [imagePhoto setBackgroundImage:image forState:UIControlStateNormal];
//        }
//    }];
    [view addSubview:imagePhoto];
    [imagePhoto release];
    
    UILabel *labName = [Common createLabel:CGRectMake((m_picHeight-50)/2, m_picHeight-10-16, 50, 16) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter labTitle:[dic objectForKey:@"nickName"]];
    labName.tag = 502;
    labName.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    labName.layer.cornerRadius = labName.height/2;
    labName.clipsToBounds = YES;
    [imagePhoto addSubview:labName];
    
    return view;
}

- (void)butEventShowFamily
{
    if ([delegate respondsToSelector:@selector(butEventShowFamily:)]) {
        [delegate butEventShowFamily:[g_familyList objectAtIndex:selIndex]];
    }
}

- (void)butEventSelFamily:(UIButton*)but
{
    int index = selIndex;
    switch (but.tag) {
        case 1001:
            selIndex--;
            break;
        case 1002:
            selIndex++;
            break;
    }
    
    [self setButEnabled];
    
    if (index != selIndex)
    {
        [self setPhotoInfo:[g_familyList objectAtIndex:selIndex] isRight:but.tag == 1002];
        
        if ([delegate respondsToSelector:@selector(butEventShowFamily:)]) {
            [delegate showSelFamily:[g_familyList objectAtIndex:selIndex]];
        }
    }
}

- (void)setButEnabled
{
    UIButton *butl = (UIButton*)[self viewWithTag:1001];
    UIButton *butr = (UIButton*)[self viewWithTag:1002];
    butl.enabled = YES;
    butr.enabled = YES;
    
    if (g_familyList.count) {
        
        if(self.noAddingBtn){
        
            if(selIndex >=g_familyList.count-2){
                butr.enabled = NO;
                if ([[[g_familyList lastObject] allKeys] count] && selIndex == 5)
                {
                    butr.enabled = YES;
                }
            }
        }
        
        if (g_familyList.count == 1) {
            butl.enabled = NO;
            butr.enabled = NO;
        }
        else if (selIndex <= 0) {
            butl.enabled = NO;
        }
        else if (selIndex >= g_familyList.count-1) {
            butr.enabled = NO;
        }
    }
    else {
        butl.enabled = NO;
        butr.enabled = NO;
    }
}

- (void)setPhotoInfo:(NSDictionary*)dic isRight:(BOOL)is
{
    UIView *view = [self viewWithTag:501];
    
    UIImageView *imageBefor = [[UIImageView alloc] initWithImage:[CommonImage screenshotWithView:view]];
    imageBefor.frame = view.frame;
    [view.superview addSubview:imageBefor];
    [imageBefor release];
    
    [self setUserInfo:dic];
    float picwidht =  m_picHeight + 10;
    
    view.transform = CGAffineTransformMakeTranslation(picwidht * (is ? 1 : -1), 0);
    view.alpha = 0.1;
    
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1;
        imageBefor.transform = CGAffineTransformMakeTranslation(picwidht * (is ? -1 : 1), 0);
        imageBefor.alpha = 0.1;
    } completion:^(BOOL finished){
        [imageBefor removeFromSuperview];
    }];
}

- (void)setUserInfo:(NSDictionary*)dic
{
    UIButton *imagePhoto = (UIButton*)[self viewWithTag:501];
    UILabel *labName = (UILabel*)[self viewWithTag:502];
    if (dic.allKeys.count) {
//        NSString * pickerStr =  [Common getImagePath:[dic objectForKey:@"filePath"] Widht:[imagePhoto width] * 2 Height:[imagePhoto height] * 2];
//        [Common getServerPic:pickerStr View:imagePhoto Delegate:^(NSString *strCon) {
//            NSDictionary *dicc = [g_familyList objectAtIndex:selIndex];
//            if ([dic isEqual:dicc]) {
//                UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//                [imagePhoto setBackgroundImage:image forState:UIControlStateNormal];
//            }
//        }];
//        [CommonImage setPicImageQiniu:[dic objectForKey:@"filePath"] View:imagePhoto Type:0 Delegate:^(NSString *strCon) {
//            NSDictionary *dicc = [g_familyList objectAtIndex:selIndex];
//            if ([dic isEqual:dicc]) {
//                UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//                [imagePhoto setBackgroundImage:image forState:UIControlStateNormal];
//            }
//        }];
        [CommonImage setImageFromServer:[dic objectForKey:@"filePath"] View:imagePhoto Type:0];

        labName.text = [dic objectForKey:@"nickName"];
        labName.hidden = NO;
    }
    else {
        UIImage *image = [UIImage imageNamed:@"common.bundle/personnal/center_my-family_btn_add_nor.png"];
        [imagePhoto setBackgroundImage:image forState:UIControlStateNormal];
        imagePhoto.backgroundColor = [UIColor whiteColor];
        labName.text = @"可添加";
        return;
    }
}

- (void)reloadView
{
    if (g_familyList.count) {
        NSDictionary *dic = [g_familyList objectAtIndex:selIndex];
        [self setUserInfo:dic];
//        if (![[[g_familyList objectAtIndex:g_familyList.count-1] allKeys] count]) {
        
            if (g_familyList.count < 7) {
                if (g_familyList.lastObject[@"id"]) {
                    [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
                }
            }
//        }
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if (![[dic objectForKey:@"state"] intValue])
    {
        if ([loader.username isEqualToString:GET_FAMILY_LIST_BY_USERID]){
            
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"rs"] forKey:[NSString stringWithFormat:@"familyInfo_%@",g_nowUserInfo.userid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [g_familyList removeAllObjects];
            [g_familyList addObjectsFromArray:[dic objectForKey:@"rs"]];
            
            if (_inBlock)
            {
                 _inBlock(g_familyList);
            }
           
            if (g_familyList.count < 7) {
                if (g_familyList.lastObject[@"id"]) {
                    [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
                }
            }
            [self setSelFamilyId:m_selFamilyId];
            [self setUserInfo:[g_familyList objectAtIndex:selIndex]];
            
            [self setButEnabled];
        }
    } else {
        
    }
}

- (void)dealloc
{
	[g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    if (m_selFamilyId) {
        [m_selFamilyId release];
        m_selFamilyId = nil;
    }
    
    [super dealloc];
}

@end
