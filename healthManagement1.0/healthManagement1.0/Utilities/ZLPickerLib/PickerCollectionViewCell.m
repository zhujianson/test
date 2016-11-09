//
//  PickerCollectionViewCell.m
//  相机
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "PickerCollectionViewCell.h"


@implementation PickerCollectionViewCell
@synthesize cellImgView;

//+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    PickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    
//    if ([[cell.contentView.subviews lastObject] isKindOfClass:[UIImageView class]]) {
//        [[cell.contentView.subviews lastObject] removeFromSuperview];
//    }
//    
//    return cell;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cellImgView = [[PickerImageView alloc] initWithFrame:self.bounds];
         self.cellImgView.contentMode = UIViewContentModeScaleAspectFill;
         self.cellImgView.clipsToBounds = YES;
         self.cellImgView.maskViewAlpha = 0.f;
        [self.contentView addSubview: self.cellImgView];
    }
    return self;
}

-(void)dealloc
{
    [self.cellImgView release];
    [super dealloc];
}
@end
