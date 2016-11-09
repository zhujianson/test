//
//  UserPhotoView.m
//  jiuhaohealth3.0
//
//  Created by wangmin on 15-1-27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "UserPhotoView.h"

@interface UserPhotoView ()

{
    UIImageView *photoView;
    UIImageView *sexImageView;
    UIImageView *vImageView;
}


@end

@implementation UserPhotoView


- (void)dealloc
{
    [photoView release];
    [sexImageView release];
    [vImageView release];
    self.onClickViewEvent = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame withSexImageBounds:(CGRect)sexBounds andVImageBounds:(CGRect)vBounds
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        //头像
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        photoView.layer.cornerRadius = frame.size.width/2.0f;
        photoView.layer.masksToBounds = YES;
//        [CommonImage setPicImageQiniu:nil View:photoView Type:0 Delegate:nil];
        [CommonImage setImageFromServer:nil View:photoView Type:0];

        [self addSubview:photoView];
        photoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnPhotoView)];
        [photoView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        //性别
        if(sexBounds.size.width != 0 || sexBounds.size.height != 0 ){
            sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - sexBounds.size.width, -sexBounds.size.height/2.0f+5, sexBounds.size.width, sexBounds.size.height)];
//            sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_female.png"];//修改为占位图
            sexImageView.backgroundColor = [UIColor clearColor];
            [self addSubview:sexImageView];
        }
        //加v
        if(vBounds.size.width != 0 || vBounds.size.height != 0 ){
            vImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - vBounds.size.width, frame.size.height-vBounds.size.height/2.0f-5, vBounds.size.width, vBounds.size.height)];
//            vImageView.image = [UIImage imageNamed:@"common.bundle/move/v_03.png"];//修改为占位图
            vImageView.backgroundColor = [UIColor clearColor];
            [self addSubview:vImageView];
        }

    }
    
    return self;

}

- (void)setImageURLString:(NSString *)urlString sexImageName:(NSString *)sexString andVImageName:(NSString *)vString
{
    if(photoView){
//        [CommonImage setPicImageQiniu:urlString View:photoView Type:0 Delegate:nil];
        [CommonImage setImageFromServer:urlString View:photoView Type:0];

    }
    if(sexImageView && sexString.length){
        sexImageView.image = [UIImage imageNamed:sexString];
    }
    if(vImageView && vString.length){
        vImageView.image = [UIImage imageNamed:vString];
    }

}

- (void)clickOnPhotoView
{
    
    self.onClickViewEvent();

}

@end
