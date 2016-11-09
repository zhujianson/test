//
//  SelectedView.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-24.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SelectedView.h"

@interface SelectedView ()

@property (nonatomic,retain) UIButton *lastSelectedBtn;

@end
@implementation SelectedView
@synthesize selectedBtnBlock;
- (void)dealloc
{
    self.lastSelectedBtn = nil;
    self.selectedBtnBlock = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

//Segment风格
- (void)initSegmentStyleWithArray:(NSArray *)array
{
    int count = (int)array.count;
    
    CGFloat offsetx = 0;
    //    if(count == 2){
    //        offsetx = 65;
    //    }
    
    CGFloat width = (self.frame.size.width-offsetx*2)/count;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(offsetx, 0, self.width, self.height)];
    backView.layer.cornerRadius = backView.height/2;
    backView.backgroundColor = [UIColor clearColor];
    backView.layer.borderColor = [[CommonImage colorWithHexString:The_ThemeColor] CGColor];
    backView.layer.borderWidth = 0.5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [backView release];
    
    for(int i = 0; i < count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*width, 0, self.width/2, self.height);
        button.tag = 100 + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        [button setTitleColor:[CommonImage colorWithHexString:The_ThemeColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[CommonImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]] forState:UIControlStateSelected];
//        [button setBackgroundImage:[CommonImage createImageWithColor:[UIColor whiteColor]] forState:UIControlEventTouchDown];

        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if(i < count-1){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(button.width-0.25, 0, 0.5, self.height)];
            view.backgroundColor = [CommonImage colorWithHexString:The_ThemeColor];
            [button addSubview:view];
            [view release];
            
        }
        if(i == 0){
            [self btnClicked:button];
        }
    }
    
}


//Segment风格
- (void)initStepSegmentStyleWithArray:(NSArray *)array
{
    int count = (int)array.count;
    
    CGFloat offsetx = 15;
    //    if(count == 2){
    //        offsetx = 65;
    //    }
    
    CGFloat width = (self.frame.size.width-offsetx*2)/count;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(offsetx, (self.height-30)/2.0f, self.width-offsetx*2, 30)];
    backView.layer.cornerRadius = 4;
    backView.backgroundColor = [UIColor clearColor];
    backView.layer.borderColor = [[CommonImage colorWithHexString:COLOR_FF5351] CGColor];
    backView.layer.borderWidth = 0.5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [backView release];
    
    for(int i = 0; i < count; i++){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*width, 0, width, 30);
        button.tag = 100 + i;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnstepClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if(i < count-1){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width-0.5, 0, 0.5, 30)];
            view.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
            [button addSubview:view];
            [view release];
            
        }
        if(i == 0){
            [self btnstepClicked:button];
        }
    }
    
}


- (void)btnstepClicked:(UIButton *)btn
{
    
    if(self.lastSelectedBtn == btn){
        return;
    }
    
    if(self.lastSelectedBtn){
        self.lastSelectedBtn.backgroundColor = [UIColor whiteColor];
        if(self.theStyle == SingleStyle){
            self.lastSelectedBtn.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
            [self.lastSelectedBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        }else{
            [self.lastSelectedBtn setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
        }
    }
    btn.layer.borderColor = [CommonImage colorWithHexString:COLOR_FF5351].CGColor;
    btn.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
    [btn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.lastSelectedBtn = btn;
    int tag = (int)btn.tag -100;
    if(self.selectedBtnBlock){
        self.selectedBtnBlock(tag);
    }
}


//独立风格的布局
- (void)initSingleStyleWithArray:(NSArray *)array
{
    int count = (int)array.count;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat offsetx = 10;
    
    CGFloat offsetWidth;
    if(count == 2){
        offsetx = 65;
    }
    if(self.offsetX){
        offsetx = self.offsetX;
    }
    CGFloat width = 85/2.0f;
    
    
    
    NSLog(@"--self.width:%f",self.frame.size.width);
    offsetWidth = (self.frame.size.width - 2 * offsetx - width * count)/(count-1);
    if(self.spaceWidth){
        
        offsetWidth = _spaceWidth;
        width = (self.frame.size.width-2*offsetx-(count-1)*offsetWidth)/count;
    }
    //    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(offsetx, 15, kDeviceWidth-offsetx*2, 30)];
    //    backView.layer.cornerRadius = 4;
    //    backView.layer.borderColor = [[CommonImage colorWithHexString:VERSION_TEXT_COLOR] CGColor];
    //    backView.layer.borderWidth = 0.5;
    //    backView.layer.masksToBounds = YES;
    //    [self addSubview:backView];
    //    [backView release];
    
    for(int i = 0; i < count; i++){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offsetx + i*(width+offsetWidth), (viewHeight-25)/2.0f, width, 25);
        button.tag = 100 + i;
        button.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 2.0f;
        button.backgroundColor = [UIColor whiteColor];
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        //        if(i < count-1){
        //            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width-0.5, 0, 0.5, 30)];
        //            view.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
        //            [button addSubview:view];
        //            [view release];
        //
        //        }
        
        if(i == 0){
            [self btnClicked:button];
        }
    }
    
    
}

- (void)initwithArray:(NSArray *)array
{
    if(self.theStyle == SegmentStyle){
        if(_isSteperView){
            [self initStepSegmentStyleWithArray:array];
        }else{
            [self initSegmentStyleWithArray:array];
        }
    }else if(self.theStyle == SingleStyle){
        [self initSingleStyleWithArray:array];
    }
    
}

- (void)btnClicked:(UIButton *)btn
{
    self.lastSelectedBtn = btn;
    if(btn.selected){
        return;
    }
    btn.selected = YES;
    int tag = (int)btn.tag -100;
    if (tag) {
        tag = 100;
    }else{
        tag = 101;
    }
    UIButton * button = (UIButton*)[self viewWithTag:tag];
    button.selected = NO;
    if(self.selectedBtnBlock){
        self.selectedBtnBlock((int)btn.tag);
    }

//
//    if(self.lastSelectedBtn){
//        self.lastSelectedBtn.backgroundColor = [UIColor whiteColor];
//        if(self.theStyle == SingleStyle){
//            self.lastSelectedBtn.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
//            [self.lastSelectedBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
//        }else{
//            [self.lastSelectedBtn setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
//        }
//    }
//    btn.layer.borderColor = [CommonImage colorWithHexString:COLOR_FF5351].CGColor;
//    btn.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
//    [btn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    self.lastSelectedBtn = btn;
//    int tag = (int)btn.tag -100;
}

- (void)justShowSelectedViewAtIndex:(int)index
{
    
    UIButton *btn = (UIButton *)[self viewWithTag:100+index];
    if(self.lastSelectedBtn == btn){
        return;
    }
    
    if(self.lastSelectedBtn){
        self.lastSelectedBtn.backgroundColor = [UIColor clearColor];
        if(self.theStyle == SingleStyle){
            self.lastSelectedBtn.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
            [self.lastSelectedBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        }else{
            [self.lastSelectedBtn setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
        }
    }
    btn.layer.borderColor = [CommonImage colorWithHexString:COLOR_FF5351].CGColor;
    btn.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
    [btn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.lastSelectedBtn = btn;
    
}

- (void)setChooseView
{
    int tag = (int)self.lastSelectedBtn.tag -100;
    if (tag) {
        tag = 100;
    }else{
        tag = 101;
    }
    UIButton * button = (UIButton*)[self viewWithTag:tag];
    [self btnClicked:button];
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
