//
//  HomeIndexCollectionViewCell.h
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/1/18.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const itemCell = @"ItemCell";
static NSString *const itemLastCell = @"itemLastCell";
static NSString *const itemHeadView = @"itemHeadView";
static NSString *const itemFooterViewView = @"itemFooterViewView";

@interface HomeIndexCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *m_infoDict;

- (void)hidenImage;

@end

@interface HomeIndexCollectionAddViewCell : UICollectionViewCell

@end


@interface HomeIndexCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong)  UILabel *m_footerLabel;

-(void)showText:(BOOL)show;

@end


@interface HomeIndexCollectionFooterView : UICollectionReusableView

@end