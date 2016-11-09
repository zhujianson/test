//
//  MLEmojiLabel.h
//  MLEmojiLabel
//
//  Created by molon on 5/19/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "TTTAttributedLabel.h"

static NSString *const kRTTextCopyColor = @"c2c2c4";//特殊文字颜色
typedef NS_OPTIONS(NSUInteger, MLEmojiLabelLinkType) {
    MLEmojiLabelLinkTypeURL = 0,
    MLEmojiLabelLinkTypePhoneNumber,
    MLEmojiLabelLinkTypeEmail,
    MLEmojiLabelLinkTypeAt,
    MLEmojiLabelLinkTypePoundSign,
};


@class MLEmojiLabel;
@protocol MLEmojiLabelDelegate <NSObject>

@optional
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type;

//添加一些自定义处理
- (NSMutableArray *)customHandleNameString;

- (void)customDidSelectLink:(NSString*)link;

@end

@protocol CopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(UILabel *)copyableLabel withChangeColor:(BOOL)changeColor;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(UILabel *)copyableLabel;

@end

@interface MLEmojiLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者

@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要

@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式

@property (nonatomic, weak) id<MLEmojiLabelDelegate> emojiDelegate; //点击连接的代理方法

@property (nonatomic, copy) NSString *emojiText; //设置处理文字

@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES
@property (nonatomic, weak) id<CopyableLabelDelegate> copyableLabelDelegate;
@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault
// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, assign) BOOL isCopyIng; // Defaults to NO

///  删除表情
///
///  @param emojiText 数据
///  @param isSystem  是否系统删除
///
///  @return 处理后的结果
+ (NSString *)deleteWithOriginalString:(NSString *)emojiText;

+ (NSRange)emojiTextisContainsEmojiWithText:(NSString *)emojiText;

+ (NSString *)deleteEmojiTextWithOriginalString:(NSString *)emojiText withEmojiRange:(NSRange )mEmojiRange;

@end
