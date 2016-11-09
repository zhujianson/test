//
//  PickerCollectionViewCell.h
//  相机
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerImageView.h"

@class UICollectionView;

@interface PickerCollectionViewCell : UICollectionViewCell
//+ (instancetype) cellWithCollectionView : (UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath;

@property (nonatomic , retain) PickerImageView *cellImgView;

@end
