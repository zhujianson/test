//
//  PickerCollectionView.h
//  相机
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerCollectionView;

@protocol PickerCollectionViewDelegate <NSObject>

// 选择相片就会调用
- (void) pickerCollectionViewDidSelected:(PickerCollectionView *) pickerCollectionView;

@end

@interface PickerCollectionView : UICollectionView
/**
 *  保存所有的数据
 */
@property (nonatomic , retain) NSArray *dataArray;

// 保存选中的图片
@property (nonatomic , retain) NSMutableArray *selectAsstes;

@property (nonatomic , assign) id <PickerCollectionViewDelegate> collectionViewDelegate;


// 限制最大数
@property (nonatomic , assign) NSInteger maxCount;

@end
