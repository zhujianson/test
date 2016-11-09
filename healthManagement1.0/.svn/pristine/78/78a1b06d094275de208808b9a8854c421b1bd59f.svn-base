//
//  CommentsInput.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//评论框

@interface UIButton(EnlargeTouchArea)

@end
#import <objc/runtime.h>

@implementation UIButton(EnlargeTouchArea)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end


#import "CommentsInput.h"

@implementation CommentsInput
{
    CommentsInputViewBlock _inBlock;
    UIView* m_view;
    UIView* backView;
    UITextView* m_textView;
  

}

@synthesize titleLab;

- (void)dealloc
{
    [m_view release];
    [backView release];
    [m_textView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

        // Initialization code
        m_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        m_view.backgroundColor = [UIColor clearColor];
        [APP_DELEGATE addSubview:m_view];

//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
//        [m_view addGestureRecognizer:tap];
//        [tap release];
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight + 44, kDeviceWidth, 200)];
        backView.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
        
        [m_view addSubview:backView];

        titleLab = [Common createLabel:CGRectMake(50, 0, kDeviceWidth-100, 50) TextColor:@"333333" Font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentCenter labTitle:@"写评论"];
        
        [backView addSubview:titleLab];

        m_textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 50, kDeviceWidth-30, 80)];
        m_textView.font = [UIFont systemFontOfSize:14];
        m_textView.textAlignment = NSTextAlignmentLeft;
        m_textView.delegate = self;
        [backView addSubview:m_textView];
        [m_textView becomeFirstResponder];
        
        UIButton * clane = [UIButton buttonWithType:UIButtonTypeCustom];
        clane.frame = CGRectMake(15, 10, 30, 30);
        clane.tag = 1;
        //扩展点击范围
        [clane setEnlargeEdgeWithTop:20 right:20 bottom:20
                                         left:20];
        [clane setBackgroundImage:[UIImage imageNamed:@"common.bundle/commont/conversation_icon_close_normal.png"] forState:UIControlStateNormal];
        [clane addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:clane];
        UIButton * determine = [UIButton buttonWithType:UIButtonTypeCustom];
        //扩展点击范围
        [determine setEnlargeEdgeWithTop:20 right:20 bottom:20
                                left:20];

        determine.frame = CGRectMake(kDeviceWidth-75, 5, 60, 40);
        determine.tag = 2;
        determine.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        determine.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        [determine setImage:[UIImage imageNamed:@"common.bundle/commont/conversation_icon_save_normal.png"] forState:UIControlStateNormal];
        [determine addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:determine];
    }
    return self;
}

- (void)touch:(UIButton*)btn
{
//    NSString * strs = nil;
    if (btn.tag == 2) {
        NSString *text = [m_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(text.length == 0){
            [Common TipDialog:@"请输入您的评论内容!"];
            return;
        }
        
        if ([Common stringContainsEmoji:m_textView.text] )
        {
            [Common TipDialog:NSLocalizedString(@"暂不支持表情信息", nil)];
            return;
        }
//        if ([textView.text length] < 1) {
//            titleLab.text = @"再写几句吧";
//            titleLab.textColor = [UIColor redColor];
//            //定时器2秒后触发
//            [[NSRunLoop currentRunLoop]addTimer:[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(clear)userInfo:nil repeats:NO] forMode:NSDefaultRunLoopMode];
//            return;
//        }
//        strs = textView.text;
        _inBlock(m_textView.text);
    }
    [self removeView];
}

- (void)clear
{
    titleLab.text = @"写评论";
    titleLab.textColor = [UIColor blackColor];

}

#pragma mark -
#pragma mark UITextView Delegate Function
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length > 100)
            return NO;
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    NSLog(@"%@", textView.text);
}

- (void)setCommentsInputViewBlock:(CommentsInputViewBlock)str
{
    _inBlock = [str copy];
}

- (void)removeView
{
    [m_textView resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
    backView.frame = [Common rectWithOrigin:backView.frame x:0 y:kDeviceHeight+64];
    m_view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
    [m_view removeFromSuperview];
    [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark Responding to keyboard events
//当键盘出现时候上移坐标
- (void	)keyboardWillShow:(NSNotification *)aNotification {
	
	// 获得键盘大小
	NSDictionary *info = [aNotification userInfo];
	NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	[UIView beginAnimations:nil context:NULL];
	// 设置动画
	[UIView setAnimationDuration:0.3];
    m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    backView.frame = [Common rectWithOrigin:backView.frame x:0 y:kDeviceHeight-keyboardSize.height-80];

	// 将toolBar的位置放到键盘上方
//	CGRect frame = backView.frame;
//	frame.origin.y -= keyboardSize.height;
//	backView.frame = frame;
	[UIView commitAnimations];
}

//当键盘消失时候下移坐标
- (void)keyboardWillHide:(NSNotification *)aNotification {
	
//	NSDictionary *info = [aNotification userInfo];
//	NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//	CGSize keyboardSize = [aValue CGRectValue].size;
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//    backView.frame = [Common rectWithOrigin:backView.frame x:0 y:kDeviceHeight+64];
//	[UIView commitAnimations];
    NSString * strs = nil;
    _inBlock(strs);
    [self removeView];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
