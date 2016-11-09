//
//  PickerCollectionView.m
//  相机
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#define MAX_COUNT 9 // 选择图片最大数默认是9

#import "PickerCollectionView.h"
#import "PickerCollectionViewCell.h"
#import "PickerImageView.h"
#import "PickerFooterCollectionReusableView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PickerCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>

//@property (nonatomic , strong) ALAssetsLibrary *assetsLibrary;
/**
 *  选中的索引值，为了防止重用
 */
@property (nonatomic , retain) NSMutableArray *selectsIndexPath;
@property (nonatomic , retain) PickerFooterCollectionReusableView *footerView;


@end

@implementation PickerCollectionView

#pragma mark -getter
//- (ALAssetsLibrary *)assetsLibrary{
//    if (!_assetsLibrary) {
//        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
//    }
//    return _assetsLibrary;
//}

- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [[NSMutableArray alloc]init];
    }
    return _selectsIndexPath;
}
- (void)dealloc
{
    self.selectsIndexPath = nil;
    self.footerView = nil;
    self.dataArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
#pragma mark -setter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = [dataArray retain];
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        _selectAsstes = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    PickerCollectionViewCell *cell = [PickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
//    PickerImageView *cellImgView = [[PickerImageView alloc] initWithFrame:cell.bounds];
//    cellImgView.contentMode = UIViewContentModeScaleAspectFill;
//    cellImgView.clipsToBounds = YES;
//    cellImgView.maskViewAlpha = 0.f;
//    [cell.contentView addSubview:cellImgView];
//    [cellImgView release];
    
    PickerCollectionViewCell *cell = (PickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.cellImgView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
    ALAsset *asset = self.dataArray[indexPath.item];
    if ([asset isKindOfClass:[ALAsset class]]) {
         cell.cellImgView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    }
    return cell;
}

#pragma mark 根据URL来获取图片
//- (void) getAssetURLWithImage:(NSString *) assetUrl{
//    [self.assetsLibrary assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset)
//     {
//         //在这里使用asset来获取图片
//         [self getAssetWithImage:asset];
//     } failureBlock:nil];
//}

#pragma mark 根据ALAsset来获取
//- (void) getAssetWithImage:(ALAsset *) asset{
//    //在这里使用asset来获取图片
//    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//    CGImageRef imgRef = [asset thumbnail];
//    UIImage *img = [UIImage imageWithCGImage:imgRef
//                                       scale:assetRep.scale
//                                 orientation:UIImageOrientationUp];
//    [self.images addObject:img];
//    
//    @autoreleasepool {
//        [self.fullscrenImages addObject:[UIImage imageWithCGImage:[assetRep fullScreenImage] scale:assetRep.scale
//                                                      orientation:UIImageOrientationUp]];
//    }
//                                         
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PickerCollectionViewCell *cell = (PickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    ALAsset *asset = self.dataArray[indexPath.row];
    
    PickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag) {
        [self.selectsIndexPath removeObject:@(indexPath.row)];
        [self.selectAsstes removeObject:asset];
    }else{
        // 1 先判断是否超过选择图片的最大
        NSInteger maxCount = self.maxCount ? self.maxCount : MAX_COUNT;
        
        if (self.selectsIndexPath.count >= maxCount) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"最多能选择%ld张图片",(long)maxCount] delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertView show];
            return ;
        }
        
        [self.selectsIndexPath addObject:@(indexPath.row)];
        [self.selectAsstes addObject:asset];
    }
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[PickerImageView class]]) && !pickerImageView.isMaskViewFlag;
    
    // 告诉代理现在被点击了!
    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected:)]) {
        [self.collectionViewDelegate pickerCollectionViewDidSelected:self];
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        PickerFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
        self.footerView = footerView;
    }else{
        
    }
    return reusableView;
}


@end
