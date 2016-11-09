//
//  TimeFrameView.m
//  jiuhaohealth4.0
//
//  Created by wangmin on 15-4-30.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "TimeFrameView.h"
#import "DiaryModelView.h"

@interface TimeFrameView ()
{
    UIButton *selectedBtn;
    NSInteger buttonCountAll;
}

@end

@implementation TimeFrameView
@synthesize haveRandomButton;

- (void)dealloc
{
    self.selectedTimeBlock = nil;
    self.selectedArrayBlock = nil;
    self.selectedIndexArray = nil;

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withArray:(NSArray*)array
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tag = TimeFrameViewTag;
        
        int row, lst;
        UIButton *nameBtn = nil;
        buttonCountAll = array.count-1;
        
        CGFloat width = (CGRectGetWidth(frame)-15)/4 - 15;
        CGFloat height = 35;
        
        UIImage *imageN = [CommonImage createImageWithColor:[UIColor whiteColor]];
        UIImage *imageY = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
        for (int i = 0; i < array.count; i++) {
            row = i/4;
            lst = i%4;
            
            nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nameBtn.frame = CGRectMake(15+lst*(width+15), row*(height+15), width, height);
            nameBtn.tag = 100 + [CommonUser getBloodSugarIndexType:array[i]];
            nameBtn.layer.borderColor = [CommonImage colorWithHexString:@"cccccc"].CGColor;
            nameBtn.layer.borderWidth = 0.5f;
            nameBtn.layer.cornerRadius = 2.0f;
            nameBtn.layer.masksToBounds = YES;
            nameBtn.backgroundColor = [UIColor whiteColor];
            
            [nameBtn setTitle:array[i] forState:UIControlStateNormal];
            nameBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            
            [nameBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [nameBtn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
            
            [nameBtn setBackgroundImage:imageN forState:UIControlStateNormal];
            [nameBtn setBackgroundImage:imageY forState:UIControlStateSelected];
            [nameBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:nameBtn];
        }
        self.height = nameBtn.bottom;
    }
    return self;
}

//症状专用
- (void)setSelectedIndexArray:(NSMutableArray *)selectedIndexArray
{
    if(_selectedIndexArray != selectedIndexArray){
        [_selectedIndexArray release];
    }
    
    _selectedIndexArray = [selectedIndexArray retain];
    
    for(NSString *index in _selectedIndexArray){
        
        int tag = 100 + index.intValue;
        UIButton *selectdBtn = (UIButton *)[self viewWithTag:tag];
        selectdBtn.selected = YES;
    }
}

- (void)setSelBut:(int)i
{
    UIButton *but = (UIButton*)[self viewWithTag:100+i];
    [self btnClicked:but];
}

- (void)btnClicked:(UIButton *)btn
{
    if(self.multiSelectedFlag){
        NSString *tagString = [NSString stringWithFormat:@"%d",(int)(btn.tag-100)];
        if([_selectedIndexArray containsObject:tagString]){
            [_selectedIndexArray removeObject:tagString];
            btn.selected = NO;
        }else{
            [_selectedIndexArray addObject:tagString];
            btn.selected = YES;
        }
        
        if(self.selectedArrayBlock){
            
            self.selectedArrayBlock(_selectedIndexArray);
        }
        
        return;
    }
    
    if (selectedBtn)
    {
        selectedBtn.selected = NO;
        selectedBtn.layer.borderWidth = 0.5f;
    }
    
    btn.selected = YES;
    btn.layer.borderWidth = 0;
    
    if (self.selectedTimeBlock)
    {
        self.selectedTimeBlock(btn.tag - 100);
    }
    selectedBtn = btn;
}

//随机按钮
- (void)ishaveRandomButton:(BOOL)haveButton
{
    haveRandomButton = haveButton;
    
    UIImage *imageN = [CommonImage createImageWithColor:[UIColor whiteColor]];
    UIImage *imageY = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
    UIButton * nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.frame = CGRectMake(15, self.height +15, kDeviceWidth-30, 35);
    nameBtn.tag = 100 + TimeRandomType;
    nameBtn.layer.borderColor = [CommonImage colorWithHexString:@"cccccc"].CGColor;
    nameBtn.layer.borderWidth = 0.5f;
    nameBtn.layer.cornerRadius = 2.0f;
    nameBtn.layer.masksToBounds = YES;
    nameBtn.backgroundColor = [UIColor whiteColor];
    [nameBtn setTitle:@"随机" forState:UIControlStateNormal];
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [nameBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [nameBtn setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [nameBtn setBackgroundImage:imageN forState:UIControlStateNormal];
    [nameBtn setBackgroundImage:imageY forState:UIControlStateSelected];
    [nameBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameBtn];
    
    self.height = nameBtn.bottom;
}
@end
