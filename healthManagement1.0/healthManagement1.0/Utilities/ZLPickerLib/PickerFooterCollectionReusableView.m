//
//  FooterCollectionReusableView.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-13.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "PickerFooterCollectionReusableView.h"

@interface PickerFooterCollectionReusableView ()

@end

@implementation PickerFooterCollectionReusableView
{
    UILabel *_footerLabel;
}
- (void)setCount:(NSInteger)count{
    _count = count;
    
    if (count > 0) {
        _footerLabel.text = [NSString stringWithFormat:@"有 %d 张图片", (int)count];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        _footerLabel.text = @"";
        _footerLabel.backgroundColor = [UIColor clearColor];
        _footerLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_footerLabel];
    }
    return self;
}

-(void)dealloc
{
    [_footerLabel release];
    [super dealloc];
}

@end
