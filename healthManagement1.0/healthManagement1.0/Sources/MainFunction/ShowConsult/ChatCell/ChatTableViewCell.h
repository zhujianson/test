//
//  ChatTableViewCell.h
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

#define cellMsgWidth kDeviceWidth - 60 - 76

@protocol chatTableCellDelegate <NSObject>

- (void)sendMsg:(NSMutableDictionary*)dic;

- (void)showPic:(NSMutableDictionary*)dic withID:(id)vc;

- (void)butEventShowConsult:(NSMutableDictionary*)dic;

//- (void)butEventShowUserInfo:(NSMutableDictionary*)dic;;

- (void)shuaxinCell:(id)cc;

@end

@interface ChatTableViewCell : UITableViewCell <UIAlertViewDelegate>
{
//    UILabel *m_labTime;
    
    UIButton *m_imageBack;
    UILabel *m_labTitle;
    
//    UIImageView *m_viewPhone;
    UIButton *m_imagePhone;
    
    UIActivityIndicatorView *m_activity;
    UIButton *m_butAgainSend;
    
    NSString *m_friendImageUrl;
    
    MLEmojiLabel *m_emojiLabel;
}
@property (nonatomic, assign) id <chatTableCellDelegate> delegate;
@property (nonatomic ,assign) NSMutableDictionary *dicInfo;
@property (nonatomic, assign) UIImageView *m_imageTitle;
@property (nonatomic, assign) UIImageView *m_bubblePlay;

//- (void)setDicInfo:(NSDictionary *)dic;

- (void)setImage:(UIImage *)image;

- (void)setFriendPhoto:(NSString*)imageUrl;

@end
