//
//  KXTextView.m
//  MOMO
//
//  Created by 超 曾 on 12-6-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "KXTextView.h"

@implementation KXTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
	
    [placeHolderLabel release]; 
    placeHolderLabel = nil;
    [placeholderColor release]; 
    placeholderColor = nil;
    [placeholder release]; 
    placeholder = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

//居中
- (void)setCenterOffset
{
    [self addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    // Center vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/3;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    //    // Bottom vertical alignment
    //    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    //    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    //    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,8,self.bounds.size.width - 6,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end