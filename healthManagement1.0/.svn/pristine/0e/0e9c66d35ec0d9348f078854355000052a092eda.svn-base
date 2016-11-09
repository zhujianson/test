/*
 *  UIInputToolbar.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIInputToolbar.h"
#import "Common.h"
#import "MLEmojiLabel.h"

@implementation UIInputToolbar
@synthesize m_inputView;
@synthesize textView;
@synthesize inputButton;
@synthesize mydelegate;
//@synthesize button2;

-(void)inputButtonPressed
{
    BOOL isOK = NO;
    if ([mydelegate respondsToSelector:@selector(inputButtonPressed:isLishi:)])
    {
        isOK = [mydelegate inputButtonPressed:self.textView.text isLishi:NO];
    }
    
    /* Remove the keyboard and clear the text */
//    [self.textView resignFirstResponder];
    if (isOK) {
        [self.textView clearText];
    }
}

- (void)setTextView:(UIExpandingTextView *)textVie
{
    textView = [textVie retain];
    textView.delegate = self;
}

- (void)setM_inputView:(UIView *)view
{
    m_inputView = view;
    [self addSubview:view];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [self addSubview:line];
    [line release];
}

- (void)expandingTextViewDidBeginEditing:(UIExpandingTextView *)expandingTextView;
{
    if ([mydelegate respondsToSelector:@selector(inputTextBegin)])
    {
        [mydelegate inputTextBegin];
    }
}

#pragma mark -custom Method
-(BOOL)expandingTextView:(UIExpandingTextView *)expandingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])//删除按钮
    {
        NSMutableString *changeString = [NSMutableString stringWithString:textView.text];
//        [changeString replaceCharactersInRange:range withString:text];
        
        if (changeString.length )
        {
            //光标在中间的时候
            if (range.location+range.length !=textView.text.length)
            {
                return YES;
            }
            NSRange deleteRange = [MLEmojiLabel emojiTextisContainsEmojiWithText:changeString];
            //表情删除
            if (deleteRange.length != 1)
            {
                NSString *newString = [MLEmojiLabel deleteEmojiTextWithOriginalString:changeString withEmojiRange:deleteRange];
                textView.text = newString;
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView;
{
    [self inputButtonPressed];
    return YES;
}

- (void)dealloc
{
    [textView release];
    [inputButton release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
    
    r = m_inputView.frame;
    r.size.height = height;
    m_inputView.frame = r;
    
    for (UIView *item in [m_inputView subviews]) {
        if ([item class] != [UIExpandingTextView class]) {
            r = item.frame;
            r.origin.y -= diff;
            item.frame = r;
        }
    }
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    if (!inputButton)
    {
        return;
    }
    if ([expandingTextView.text length] > 0)
        self.inputButton.enabled = YES;//当有内容时才允许发送
    else
        self.inputButton.enabled = NO;
}

@end
