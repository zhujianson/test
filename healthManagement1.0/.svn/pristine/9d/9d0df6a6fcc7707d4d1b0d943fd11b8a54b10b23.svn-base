//
//  ChatTableViewCell.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "Common.h"
#import "UIView+ColorPointAndMask.h"
#import "ShowText.h"

@implementation ChatTableViewCell
@synthesize delegate;
@synthesize dicInfo;
@synthesize m_imageTitle;
@synthesize m_bubblePlay;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //状态
        m_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 5, 30, 40)];
        m_activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        m_activity.hidden = YES;
        [self.contentView addSubview:m_activity];
        
        //重发
        m_butAgainSend = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
        [m_butAgainSend setImage:[UIImage imageNamed:@"common.bundle/home/icon_warning.png"] forState:UIControlStateNormal];
        [m_butAgainSend addTarget:self action:@selector(butEventAgainSend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:m_butAgainSend];
        
        //头像
        m_imagePhone = [[UIButton alloc] initWithFrame:CGRectMake(15, 4, 40, 40)];
        [m_imagePhone addTarget:self action:@selector(butEventShowConsult) forControlEvents:UIControlEventTouchUpInside];
        m_imagePhone.layer.cornerRadius = 20;
        m_imagePhone.clipsToBounds = YES;
        [self.contentView addSubview:m_imagePhone];
        
        //起泡
        m_imageBack = [[UIButton alloc] init];
        m_imageBack.userInteractionEnabled = YES;
        [m_imageBack addTarget:self action:@selector(showPic) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:m_imageBack];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [m_imageBack addGestureRecognizer:doubleTap];
        [doubleTap release];
        
        //文字
        m_labTitle = [Common createLabel:CGRectMake(0, 0, 0, 0) TextColor:@"" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:@""];
        m_labTitle.numberOfLines = 0;
        m_labTitle.hidden = YES;
        m_labTitle.lineBreakMode = NSLineBreakByCharWrapping;
        [m_imageBack addSubview:m_labTitle];
        
        m_emojiLabel = [[MLEmojiLabel alloc] init];
        m_emojiLabel.numberOfLines = 0;
        m_emojiLabel.font = [UIFont systemFontOfSize:16.0f];
//        m_emojiLabel.emojiDelegate = self;
        m_emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        m_emojiLabel.isNeedAtAndPoundSign = YES;
        m_emojiLabel.disableThreeCommon = YES;
        m_emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        m_emojiLabel.customEmojiPlistName = @"expression.plist";
        [m_imageBack addSubview:m_emojiLabel];
        
        //图片
        m_imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 80)];
        m_imageTitle.contentMode = UIViewContentModeScaleAspectFill;
        m_imageTitle.hidden = YES;
        m_imageTitle.layer.cornerRadius = 4;
        m_imageTitle.clipsToBounds = YES;
        [m_imageBack addSubview:m_imageTitle];
        
        //
        m_bubblePlay = [[UIImageView alloc] init];
        m_bubblePlay.hidden = YES;
        m_bubblePlay.frame = CGRectMake(10, 9, 12, 19);
        m_bubblePlay.contentMode = UIViewContentModeRight;
        m_bubblePlay.animationDuration = 1.0;
        m_bubblePlay.animationRepeatCount = 0;
        [m_imageBack addSubview:m_bubblePlay];
    }
    return self;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    if (![dicInfo[@"contentType"] intValue]) {
        ShowText *show = [ShowText showText];
        show.m_title = dicInfo[@"content"];
        [show show];
    }
}

- (void)butEventShowConsult
{
//    NSLog(@"--%@",g_nowUserInfo.userid);
//    BOOL fromSelf = [[dicInfo valueForKey:@"fromSelf"] boolValue];
//    
//    int type = [[dicInfo valueForKey:@"toType"] intValue];////0会员,  1医生 2康迅医生
//    
//    if (fromSelf && (type == 1 || type == 2)) {
//        [delegate butEventShowConsult:dicInfo];
//    }else if(fromSelf && type == 0){
//        [delegate butEventShowUserInfo:dicInfo];//点击的是用户头像
//    }
    [delegate butEventShowConsult:dicInfo];
}

- (void)butEventAgainSend
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"消息发送失败,需要重新发送吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av show];
    [av release];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [delegate sendMsg:dicInfo];
    }
}

- (void)showPic
{
    [delegate showPic:dicInfo withID:self];
}

- (void)setDicInfo:(NSMutableDictionary *)dic
{
    dicInfo = dic;
    
    m_emojiLabel.hidden = YES;
    
//    [m_emojiLabel removeFromSuperview];
    //初始化
    [m_activity stopAnimating];
    m_activity.hidden = YES;
    m_butAgainSend.hidden = YES;
    m_imageTitle.hidden = YES;
    m_labTitle.hidden = NO;
    m_bubblePlay.hidden = YES;

    //是否为自己
    BOOL forSelf = ![[dicInfo valueForKey:@"forSelf"] boolValue];
    
    CGSize size, backgrounSize;
    
    switch ([[dicInfo objectForKey:@"contentType"] intValue]) {
        case 0://文字
        {
            NSString *text = [dicInfo valueForKey:@"content"];
            
//            size = [Common heightForString:text Width:cellMsgWidth Font:m_labTitle.font];
            size.height = [[dic objectForKey:@"height"] floatValue];
            size.width = [[dic objectForKey:@"width"] floatValue];
            size.width = size.height > 24 ? cellMsgWidth : size.width;
            
            NSString *titleColor = @"000000";
            CGRect rectText = CGRectMake(10 ,8, size.width, size.height);
            
            backgrounSize = CGSizeMake(size.width+20+9, size.height+16);
            
            if (!forSelf) {
//                backgrounSize = CGSizeMake(size.width+20+5, size.height+16);
                rectText = CGRectMake(16, 8, size.width, size.height);
                titleColor = @"333333";
            }
            
            if ([[dicInfo objectForKey:@"isEmo"] boolValue]) {
                m_labTitle.hidden = YES;
                m_emojiLabel.hidden = NO;
                m_emojiLabel.frame = rectText;
//                m_emojiLabel.backgroundColor = [UIColor redColor];
                [m_emojiLabel setEmojiText:text];
                m_emojiLabel.textColor = [CommonImage colorWithHexString:titleColor];
            }
            else {
                m_labTitle.hidden = NO;
                m_emojiLabel.hidden = YES;
                m_labTitle.text = text;
                m_labTitle.frame = rectText;
                m_labTitle.textColor = [CommonImage colorWithHexString:titleColor];
            }
        }
            break;
        case 1://图片
        {
            m_imageTitle.contentMode = UIViewContentModeScaleAspectFill;
            float widht = [[dic objectForKey:@"width"] floatValue];
            float height = [[dic objectForKey:@"height"] floatValue];
            size = CGSizeMake(widht ? widht : 80, height ? height : 80);
//            size = CGSizeMake(80, 80);
            backgrounSize = size;
            
            m_imageTitle.hidden = NO;
            m_labTitle.hidden = YES;
            
            UIImage *image = [UIImage imageNamed:@"common.bundle/msg/Consultation_Dialog-box_black_right.png"];
            
            if (!forSelf) {
                image = [UIImage imageNamed:@"common.bundle/msg/Consultation_Dialog-box_black_left.png"];
            }
            m_imageTitle.frame = CGRectMake(0, 0, size.width, size.height);
            [m_imageTitle setImage:image];
            [m_imageTitle setMaskWithImage:[image stretchableImageWithLeftCapWidth:12 topCapHeight:20]];//resizableImageWithCapInsets:UIEdgeInsetsMake(20, 12, 20, 10)]
        }
            break;
        case 2://音频
        {
            m_bubblePlay.hidden = NO;
            m_labTitle.hidden = NO;
            CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
            
            size = CGSizeMake([[dicInfo objectForKey:@"width"] floatValue], 20);
            backgrounSize = CGSizeMake(size.width+20+9, size.height+16);
            
            NSString *image = @"common.bundle/msg/play.png";
            NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"common.bundle/msg/play1.png"], [UIImage imageNamed:@"common.bundle/msg/play2.png"], [UIImage imageNamed:@"common.bundle/msg/play3.png"], nil];
            
            m_bubblePlay.frame = CGRectMake(backgrounSize.width - 20 -12, 8, 12, 19);
            CGRect rectText = CGRectMake(20 , 0, 35, 36);
            
            if (!forSelf) {
                m_bubblePlay.frame = CGRectMake(20, 8, 12, 19);
                transform = CGAffineTransformIdentity;
                rectText = CGRectMake(backgrounSize.width - 20 -12 , 0, 35, 36);
            }
            m_bubblePlay.animationImages = array;
            m_bubblePlay.image = [UIImage imageNamed:image];
            m_bubblePlay.transform = transform;
            
            m_labTitle.text = [NSString stringWithFormat:@"%@\"", [dicInfo objectForKey:@"audioTime"]];
            
            //音频
            NSString *titleColor = @"333333";
            BOOL is = [[dicInfo objectForKey:@"isPlay"] boolValue];
            if (is) {
                [m_bubblePlay startAnimating];
            }
            else {
                [m_bubblePlay stopAnimating];
            }
            m_labTitle.frame = rectText;
            m_labTitle.textColor = [CommonImage colorWithHexString:titleColor];
        }
            break;
        case 3:
        {
            m_imageTitle.contentMode = UIViewContentModeScaleAspectFit;
            [m_imageTitle setMaskWithImage:nil];//
            
            float height = [[dic objectForKey:@"height"] floatValue];
            size = CGSizeMake(height, height);
            backgrounSize = size;
            
            m_imageTitle.hidden = NO;
            m_labTitle.hidden = YES;
            
            UIImage *image = [UIImage imageNamed:@"common.bundle/msg/Consultation_Dialog-box_black_right.png"];
            
            if (!forSelf) {
                image = [UIImage imageNamed:@"common.bundle/msg/Consultation_Dialog-box_black_left.png"];
            }
            m_imageTitle.frame = CGRectMake(0, 0, size.width, size.height);
            NSString *text = [dicInfo valueForKey:@"content"];
            m_imageTitle.image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/msg/emo/big/%@.png", text]];
            [m_imageTitle setMaskWithImage:m_imageTitle.image];//
        }
            break;
        default:
        {
            NSString *text = @"此版本过底,无法查看,请尽快升级查看.";
            
            m_labTitle.text = text;
            size = [Common heightForString:text Width:cellMsgWidth Font:m_labTitle.font];
            size.height = [[dic objectForKey:@"height"] floatValue];
            size.width = size.height > 24 ? cellMsgWidth : size.width;
            backgrounSize = CGSizeMake(size.width+20+9, size.height+16);
            
            NSString *titleColor = @"000000";
            CGRect rectText = CGRectMake(10 , 8, size.width, size.height);
            
            if (!forSelf) {
                rectText = CGRectMake(16, 8, size.width, size.height);
                titleColor = @"333333";
            }
            
            m_labTitle.frame = rectText;
            m_labTitle.textColor = [CommonImage colorWithHexString:titleColor];
        }
            break;
    }
    
    
    CGRect rectbackground;
    CGAffineTransform tranPhoto;
    UIImage *backImage;
    if (forSelf) {
        backImage = [[UIImage imageNamed:@"common.bundle/msg/Consultation_Dialog-box_user.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:20];
        
        tranPhoto = CGAffineTransformMakeTranslation(kDeviceWidth - m_imagePhone.width - 30, 0);
        rectbackground = CGRectMake(kDeviceWidth - backgrounSize.width - m_imagePhone.width-15 - 5, 5, backgrounSize.width, backgrounSize.height);
        
//        [CommonImage setPicImageQiniu:g_nowUserInfo.filePath View:m_imagePhone Type:0 Delegate:^(NSString *strCon) {
//            NSString *filePath1 = [m_friendImageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//            if ([strCon rangeOfString:filePath1].length != NSNotFound) {
//                UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//                [m_imagePhone setBackgroundImage:image forState:UIControlStateNormal];
//            }
//        }];
        [CommonImage setImageFromServer:g_nowUserInfo.filePath View:m_imagePhone Type:0];

        
        //发送状态
        int isSendOK = [[dic objectForKey:@"isSendOK"] intValue];
        switch (isSendOK) {
            case 1:
            {
                m_activity.hidden = NO;
                [m_activity startAnimating];
                
                CGRect recta = m_activity.frame;
                recta.origin.x = rectbackground.origin.x-30;
                m_activity.frame = recta;
            }
                break;
            case 2:
            case 3:
            {
                m_butAgainSend.hidden = NO;
                
                CGRect recta = m_butAgainSend.frame;
                recta.origin.x = rectbackground.origin.x-30;
                m_butAgainSend.frame = recta;
            }
                break;
                
            default:
                break;
        }
    }
    else {
        backImage = [[UIImage imageNamed:@"common.bundle/msg/Consultation_Dialog-box_doctor.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        
        tranPhoto = CGAffineTransformIdentity;
        rectbackground = CGRectMake(15+5 + m_imagePhone.width, 5, backgrounSize.width, backgrounSize.height);
        
//        NSString *imagePath = [m_friendImageUrl stringByAppendingString:@"?imageView2/1/w/160/h/160"];
//        NSString *strCon = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//        UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon]];
//        
//        if (!image) {
//            image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
//        }
//        
//        [m_imagePhone setBackgroundImage:image forState:UIControlStateNormal];
        
//        [CommonImage setPicImageQiniu:m_friendImageUrl View:m_imagePhone Type:0 Delegate:^(NSString *strCon) {
//            NSString *filePath1 = [m_friendImageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//            if ([strCon rangeOfString:filePath1].length != NSNotFound) {
//                UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
//                [m_imagePhone setBackgroundImage:image forState:UIControlStateNormal];
//            }
//        }];
        [CommonImage setImageFromServer:m_friendImageUrl View:m_imagePhone Type:0];

    }
    
    m_imagePhone.transform = tranPhoto;
    if ([[dicInfo objectForKey:@"contentType"] intValue] != 3) {
        [m_imageBack setBackgroundImage:backImage forState:UIControlStateNormal];
    }
    else {
        [m_imageBack setBackgroundImage:nil forState:UIControlStateNormal];
    }
    m_imageBack.frame = rectbackground;
}

- (void)setFriendPhoto:(NSString *)imageUrl
{
    m_friendImageUrl = imageUrl;
}

- (void)setImage:(UIImage *)image
{
    m_imageTitle.image = image;
//    [self setImageHeight:image withDic:dicInfo];
//    [m_imageTitle setImage:image forState:UIControlStateNormal];
}

- (void)setImageHeight:(UIImage*)image withDic:(NSMutableDictionary*)dic
{
    if ([dicInfo objectForKey:@"height"]) {
        return;
    }
    CGSize size = image.size;
    
    if (size.width > size.height) {
        float x = size.width / 100.f;
        float height = size.height / x;
        [dic setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
        [dic setObject:[NSNumber numberWithFloat:100] forKey:@"width"];
    }
    else {
        float x = size.height / 100.f;
        float height = size.width / x;
        [dic setObject:[NSNumber numberWithFloat:height] forKey:@"width"];
        [dic setObject:[NSNumber numberWithFloat:100] forKey:@"height"];
    }
    
    [delegate shuaxinCell:self];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [m_imageTitle release];
    [m_imageBack release];
    [m_imagePhone release];
    [m_butAgainSend release];
    [m_activity release];
    [m_bubblePlay release];
    [m_emojiLabel release];
    
    [super dealloc];
}

@end
