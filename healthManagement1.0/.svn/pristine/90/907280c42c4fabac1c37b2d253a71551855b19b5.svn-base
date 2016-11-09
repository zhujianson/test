//
//  PickerAssetsViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-12.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//


// CellFrame
#define CELL_ROW 4
#define CELL_MARGIN 4
#define CELL_LINE_MARGIN 5

// 通知
#define PICKER_TAKE_DONE @"PICKER_TAKE_DONE"
// TOOLBAR 展示最大图片数
#define TOOLBAR_COUNT 9
// 间距
#define TOOLBAR_IMG_MARGIN 2


#import "PickerAssetsViewController.h"
#import "PickerCollectionView.h"
#import "PickerGroup.h"
#import "PickerDatas.h"
#import "PickerCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import  "PickerFooterCollectionReusableView.h"
#import "MJPhotoBrowser.h"

@interface PickerAssetsViewController () <PickerCollectionViewDelegate,MJPhotoBrowserDelegate>

@property (nonatomic , assign) PickerCollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assets;
/**
 *  标记View
 */
@property (nonatomic , assign) UILabel *makeView;
@property (nonatomic , assign) UIButton *doneBtn;
@property (nonatomic , assign) UIToolbar *toolBar;

@property (nonatomic , retain) NSMutableArray *buttons;


@end

@implementation PickerAssetsViewController
{
    NSMutableArray *_selectImges;
}

@synthesize sendTitle;

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc]init];
    }
    return _buttons;
}

-(void)dealloc
{
    [_selectImges release];
    self.buttons = nil;
    self.toolBar = nil;
    self.makeView = nil;
    [super dealloc];
}
- (PickerCollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat cellW = (kDeviceWidth- CELL_MARGIN * (CELL_ROW + 1)) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(cellW, cellW);// 定义cell的size
        layout.minimumInteritemSpacing = CELL_MARGIN;// 定义左右cell的最小间距
        layout.minimumLineSpacing = CELL_LINE_MARGIN;// 定义上下cell的最小间距
        layout.footerReferenceSize = CGSizeMake(kDeviceWidth, 50);// 定义headview的size
        layout.sectionInset = UIEdgeInsetsMake(5, 4, 5, 4);
        
        CGFloat height = 44;
//        if (!IOS_7) {
//            height = 44;
//        }
        
        PickerCollectionView *collectionView = [[PickerCollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - height) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[PickerCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [collectionView registerClass:[PickerFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.toolBar.frame.size.height, 0);
        collectionView.collectionViewDelegate = self;
        [self.view insertSubview:collectionView belowSubview:self.toolBar];
        self.collectionView = collectionView;
        [layout release];
        [collectionView release];
    }
    return _collectionView;
}

- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-5, -5, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = [UIColor redColor];
        [self.view addSubview:makeView];
        self.makeView = makeView;
        [makeView release];
    }
    return _makeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectImges = [[NSMutableArray alloc]init];
    
    [self setupButtons];
    
    // 初始化底部ToorBar
    [self setupToorBar];
}


#pragma mark - setup
- (void) setupButtons{
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    rightBtn.frame = CGRectMake(0, 0, 45, 45);
//    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
//    
//    [rightBtn addSubview:self.makeView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    rightBtn.enabled = (self.collectionView.selectAsstes.count > 0);
//    self.navigationItem.rightBarButtonItem.enabled = (self.collectionView.selectAsstes.count > 0);
//    self.rightBtn = rightBtn;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[barItem,fiexItem];
    [barItem release];
    [fiexItem release];
}


- (void) setupAssets{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }
    
    PickerDatas *datas = [PickerDatas defaultPicker];
    [datas getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
        
        self.collectionView.dataArray = assets;
        [self.collectionView reloadData];
    }];
    
}

#pragma mark -初始化底部ToorBar
- (void) setupToorBar{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    CGFloat toorBarH = 44;
    toorBar.frame = CGRectMake(0, kDeviceHeight - toorBarH, kDeviceWidth, toorBarH);
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    [toorBar release];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    rightBtn.enabled = YES;
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.frame = CGRectMake(0, 0, 45, 45);
    [rightBtn setTitle:sendTitle.length?sendTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addSubview:self.makeView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toorBar.items = @[fiexItem,rightItem];
    self.doneBtn = rightBtn;
    [rightItem release];
    [fiexItem release];
}

#pragma mark - setter
- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    
    self.collectionView.maxCount = self.maxCount;
}

- (void)setAssetsGroup:(PickerGroup *)assetsGroup{
    _assetsGroup = assetsGroup;
    
    self.title = assetsGroup.groupName;
    
    // 获取Assets
    [self setupAssets];
}


- (void)pickerCollectionViewDidSelected:(PickerCollectionView *)pickerCollectionView{
    NSInteger count = pickerCollectionView.selectAsstes.count;
    [_selectImges removeAllObjects];
    [_selectImges addObjectsFromArray:pickerCollectionView.selectAsstes];
    
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.doneBtn.enabled = (count > 0);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.9), @(1.4), @(0.9), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.6), @(1)];
    animation.duration = 1.0f;
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.makeView.layer addAnimation:animation forKey:@"handler"];
    
//    if (count < self.buttons.count) {
//        for (NSInteger i = self.buttons.count; i > count; i--) {
//            [self.buttons[i-1] removeFromSuperview];
//        }
//    }
//    // 创建btn
//    for (int i = 0; i < count; i++) {
//        ALAsset *asset = pickerCollectionView.selectAsstes[i];
//        
//        UIButton *btn = nil;
//        if (self.buttons.count <= i) {
//            btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
//            [self.toolBar addSubview:btn];
//            [self.buttons addObject:btn];
//        }else if(self.buttons.count){
//            btn = self.buttons[i];
//            btn.tag = 1000 + i;
//            if (![btn.superview isKindOfClass:[self class]]) {
//                [self.toolBar addSubview:btn];
//            }
//        }
//        
//        CGFloat btnW = (kDeviceWidth- 80 - TOOLBAR_IMG_MARGIN * 10) / TOOLBAR_COUNT;
//        CGFloat btnX = btnW * i + (i * TOOLBAR_IMG_MARGIN + TOOLBAR_IMG_MARGIN);
//        CGFloat btnY = (self.toolBar.frame.size.height - btnW) / 2.0;
//        [btn setImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnW);
//        
//    }
}

//浏览图片
-(void)selectImage:(UIButton *)btn
{
    int indexPic = (int)btn.tag -1000;
    NSMutableArray *photos = [NSMutableArray array];
	MJPhoto *photo;
    for (ALAsset *asset in _selectImges) {
        if ([asset isKindOfClass:[ALAsset class]]) {
            // 替换为中等尺寸图片
            photo = [[MJPhoto alloc] init];
            photo.image = [UIImage imageWithCGImage:[asset thumbnail]];
            photo.srcView = btn.imageView; // 来源于哪个UIImageView
            [photos addObject:photo];
            [photo release];
            
            
//            NSMutableDictionary *dicPhoto = [[NSMutableDictionary alloc] init];
////            UIImage *imgeView = [UIImage imageWithCGImage:[asset thumbnail]];
//            [dicPhoto setObject:btn.imageView forKey:@"srcImageView"];
//            [photos addObject:dicPhoto];
//            [dicPhoto release];
        }
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
	browser.delegate = self;
    browser.currentPhotoIndex = indexPic; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
	[browser release];
}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
{
    
}

#pragma mark -<Navigation Actions>
#pragma mark -开启异步通知
- (void) back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.collectionView.selectAsstes}];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
