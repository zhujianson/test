//
//  TopicDetailsViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//


@interface WebViewController : CommonViewController<UIWebViewDelegate,UIActionSheetDelegate>
//@property (nonatomic, retain) NSDictionary * m_dic;
@property (nonatomic, retain) NSString *m_url;
@property (nonatomic, assign) UIWebView* m_webView;

- (void)setKXBlock:(KXBasicBlock)block;

@end
