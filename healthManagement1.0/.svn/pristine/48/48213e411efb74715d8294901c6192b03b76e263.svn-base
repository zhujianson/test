//
//  IconOperationQueue.h
//  bulkBuy1.0
//
//  Created by 徐国洪 on 13-10-10.
//  Copyright (c) 2013年 徐国洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconDownloader.h"

@protocol IconOperationQueueDelegate <NSObject>

- (void)showImageForDownload:(NSDictionary *)imageDicInfo;

@end

@interface IconOperationQueue : NSObject <IconDownloaderDelegate>
{
	NSOperationQueue *queue;
	
    NSMutableDictionary *m_imageDownloadsInProgress;//所有店铺图片URL
//	NSMutableDictionary *m_imageArrayDic;//所有店铺图片
	
//	NSArray *m_arrayList;
	
	id m_deleagte;
	
	id m_arrayListForOne;
}

@property (nonatomic, assign) id<IconOperationQueueDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *m_arrayList;
@property (nonatomic, assign) BOOL m_isMoreSection;
@property (nonatomic, assign) NSString *imageKey;
@property (nonatomic, assign) NSString *arrayScetion;
@property (nonatomic, retain) NSString *pathSuffix;

- (void)loadImagesForOnscreenRows:(NSArray*)visiblePaths isRow:(BOOL)is;

- (void)startIconDownload:(NSString*)url forIndexPath:(NSIndexPath *)indexPath setNo:(int)i;

- (UIImage*)getImageForUrl:(NSString*)url;

- (void)delImageNoArray:(NSArray*)visiblePaths withRow:(BOOL)is;

@end
