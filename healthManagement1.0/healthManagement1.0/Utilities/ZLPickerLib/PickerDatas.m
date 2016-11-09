//
//  PickerDatas.m
//  相册Demo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "PickerDatas.h"
#import "PickerGroup.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef ALAssetsLibraryAccessFailureBlock failureBlock;

@interface PickerDatas ()

/**
 *  是否是URLs，默认传图片
 */
@property (nonatomic , assign , getter=isResourceURLs) BOOL resourceURLs;
@property (nonatomic , retain) NSMutableArray *groups;

@property (nonatomic , retain) PickerGroup *currentGroupModel;
@property (nonatomic , retain) PickerGroup *backGroup;

@property (nonatomic , copy) failureBlock failureBlock;
@property (nonatomic , retain) ALAssetsLibrary *library;

@end

@implementation PickerDatas

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

-(void)dealloc
{
    self.backGroup = nil;
    self.library = nil;
    self.currentGroupModel = nil;
    self.groups = nil;
    [super dealloc];
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    
    return _library;
}

#pragma mark -getter
- (PickerGroup *)backGroup{
    if (!_backGroup) {
        _backGroup = [[PickerGroup alloc] init];
    }
    return _backGroup;
}

- (failureBlock)failureBlock{
    if (!_failureBlock) {
        _failureBlock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
    }
    return _failureBlock;
}

+ (instancetype) defaultPicker{
    return [[self alloc] init];
}

#pragma mark -获取所有组
- (void) getAllGroupWithPhotos : (callBackBlock ) callBack{
    
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            // 包装一个模型来赋值
            PickerGroup *pickerGroup = [[PickerGroup alloc] init];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
            [pickerGroup release];
        }else{
            callBack(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:^(NSError *error) {
        NSLog(@"Group not found!\n");
    }];
    
    
    
//    ALAssetsLibrary *assetsLibrary;
//    NSMutableArray *groupArray;
//    assetsLibrary = [[ALAssetsLibrary alloc] init];
//    groupArray=[[NSMutableArray alloc] initWithCapacity:1];
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        if (group) {
//            [groupArray addObject:group];
//            
//            //            通过这个可以知道相册的名字，从而也可以知道安装的部分应用
//            //例如 Name:柚子相机, Type:Album, Assets count:1
//            NSLog(@"%@",group);
//        }
//    } failureBlock:^(NSError *error) {
//        NSLog(@"Group not found!\n");
//    }];
}

#pragma mark -传入一个组获取组里面的Asset
- (void) getGroupPhotosWithGroup : (PickerGroup *) pickerGroup finished : (callBackBlock ) callBack{
    
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset) {
            [assets addObject:asset];
        }else{
            callBack(assets);
        }
    };
    [pickerGroup.group enumerateAssetsUsingBlock:result];
    
}

#pragma mark -传入一个AssetsURL来获取UIImage
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(callBackBlock ) callBack{
    [self.library assetForURL:url resultBlock:^(ALAsset *asset) {
        callBack([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
    } failureBlock:nil];
}

@end
