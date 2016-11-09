//
//  IconOperationQueue.m
//  bulkBuy1.0
//
//  Created by 徐国洪 on 13-10-10.
//  Copyright (c) 2013年 徐国洪. All rights reserved.
//

#import "IconOperationQueue.h"
#import "Common.h"

@implementation IconOperationQueue
@synthesize delegate;
@synthesize m_arrayList;
@synthesize m_isMoreSection;
@synthesize arrayScetion;

- (id)init
{
	self = [super init];
	if (self) {
		queue = [[NSOperationQueue alloc] init];
		[queue setMaxConcurrentOperationCount:3];
		
		m_imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
        
        if (g_imageArrayDic) {
            int retainCount = [[g_imageArrayDic objectForKey:@"retainCount"] intValue]+1;
            [g_imageArrayDic setObject:[NSNumber numberWithInt:retainCount] forKey:@"retainCount"];
        }
        else {
            g_imageArrayDic = [[NSMutableDictionary alloc] init];
        }
	}
	return self;
}

- (void)delImageNoArray:(NSArray*)visiblePaths withRow:(BOOL)is
{
    NSMutableArray *arraySection = nil, *array1;
    
    @try {
        for (id dicItem in m_arrayList) {
            
            if (is) {
                if ([dicItem isKindOfClass:[NSDictionary class]])
                {
                    arraySection = [dicItem objectForKey:arrayScetion];
                    if (!arraySection) {
                        arraySection = [NSMutableArray arrayWithObjects:dicItem, nil];
                    }
                }
            }
            else {
                
                if ([dicItem isKindOfClass:[NSArray class]]) {
                    arraySection = [NSMutableArray array];
                    for (NSDictionary *dic1 in dicItem) {
                        
                        if ([dic1 isKindOfClass:[NSDictionary class]])
                        {
                            array1 = [dic1 objectForKey:arrayScetion];
                            if (!array1) {
                                [arraySection addObject:dic1];
                            }
                            else {
                                [arraySection addObjectsFromArray:array1];
                            }
                        }
                    }
                }
                else if ([dicItem isKindOfClass:[NSDictionary class]]) {
                    arraySection = [dicItem objectForKey:arrayScetion];
                    if (!arraySection) {
                        arraySection = [NSMutableArray arrayWithObjects:dicItem, nil];
                    }
                }
            }
            
            
            for (int i = 0; i < arraySection.count; i++)
            {
                NSMutableDictionary *dic = [arraySection objectAtIndex:i];
                NSString *imagePath = [dic objectForKey:self.imageKey];
                if (!imagePath) {
                    continue;
                }
                if (self.pathSuffix) {
//                    imagePath = [imagePath stringByAppendingString:self.pathSuffix];
                    if (![imagePath rangeOfString:@"?imageView2/1/w/"].length) {
                        imagePath = [imagePath stringByAppendingString:self.pathSuffix];
                    }
                }
                [g_imageArrayDic removeObjectForKey:imagePath];
                [m_imageDownloadsInProgress removeObjectForKey:imagePath];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSMutableArray*)getArray:(BOOL)is withArray:(NSArray*)array withIndex:(NSIndexPath*)indexPath
{
    NSMutableArray *arraySection = nil;
    id dic1;
    NSDictionary *dicItem;
    if (is) {
        
        dicItem = [array objectAtIndex:indexPath.row];
        arraySection = [dicItem objectForKey:arrayScetion];
        if (!arraySection) {
            arraySection = [NSMutableArray arrayWithObjects:dicItem, nil];
        }
    }
    else {
        
        dic1 = [array objectAtIndex:indexPath.section];
        if ([dic1 isKindOfClass:[NSArray class]]) {
            dicItem = [dic1 objectAtIndex:indexPath.row];
            arraySection = [dicItem objectForKey:arrayScetion];
            if (!arraySection) {
                arraySection = [NSMutableArray arrayWithObjects:dicItem, nil];
            }
        }
        else if ([dic1 isKindOfClass:[NSDictionary class]]) {
            arraySection = [dic1 objectForKey:arrayScetion];
            if (!arraySection) {
                arraySection = [NSMutableArray arrayWithObjects:dic1, nil];
            }
        }
    }
    
    return arraySection;
}

- (UIImage*)getImageForUrl:(NSString*)url
{
    if (self.pathSuffix) {
        if (![url rangeOfString:@"?imageView2/1/w/"].length) {
            url = [url stringByAppendingString:self.pathSuffix];
        }
    }
    
	UIImage *image = [g_imageArrayDic objectForKey:url];
	if (!image) {
		
		NSString *strCon = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
		image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@",strCon]];
		if (image) {
//			[image retain];
			[g_imageArrayDic setObject:image forKey:url];
		} else {
			image = nil;
		}
	}
	
	return image;
}

#pragma mark - 下载店铺图片
#pragma mark Table cell image support
- (void)loadImagesForOnscreenRows:(NSArray*)visiblePaths isRow:(BOOL)is
{
    NSArray *array = m_arrayList;
    NSMutableArray *arraySection = nil;
//    id dic1;
//    NSDictionary *dicItem;
    for (NSIndexPath *indexPath in visiblePaths)
    {
        arraySection = [self getArray:is withArray:array withIndex:indexPath];
        
        for (int i = 0; i < arraySection.count; i++)
        {
            NSMutableDictionary *dic = [arraySection objectAtIndex:i];
            NSString *imagePath = [dic objectForKey:self.imageKey];
            if (!imagePath) {
                continue;
            }
            UIImage *image = [self getImageForUrl:imagePath];
            if (!image)
            {
                [self startIconDownload:imagePath forIndexPath:indexPath setNo:i];
            }
        }
    }
}

- (void)startIconDownload:(NSString*)imagePath forIndexPath:(NSIndexPath *)indexPath setNo:(int)i
{
    if (!imagePath) {
        return;
    }
    
    if (self.pathSuffix) {
        if (![imagePath rangeOfString:@"?imageView2/1/w/"].length) {
            imagePath = [imagePath stringByAppendingString:self.pathSuffix];
        }
    }
    
    IconDownloader *iconDownloader = [m_imageDownloadsInProgress objectForKey:imagePath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        [m_imageDownloadsInProgress setObject:iconDownloader forKey:imagePath];
        iconDownloader.delegate = self;
		[iconDownloader setArrayIndexPath:indexPath setNo:i setImageUrl:imagePath];
		[queue addOperation:iconDownloader];
    }
}

- (void)appImageDidLoad:(NSDictionary *)imageDicInfo
{
    NSString *path = [imageDicInfo objectForKey:@"imagePath"];
    if (self.pathSuffix) {
        if (![path rangeOfString:@"?imageView2/1/w/"].length) {
            path = [path stringByAppendingString:self.pathSuffix];
        }
    }
    
    UIImage *image = [imageDicInfo objectForKey:@"image"];
    [g_imageArrayDic setObject:image forKey:path];
    
	NSString *strCon = [path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    image = [self rotateUIImage:image];
	NSData *data = UIImagePNGRepresentation(image);
	[data writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
	
	[g_iconArrayLock lock];
//	id one = [m_arrayList objectAtIndex:0];
//	NSLog(@"%@", [NSString stringWithFormat:@"%@", m_arrayListForOne]);
    if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
        [delegate showImageForDownload:imageDicInfo];
    }
	[g_iconArrayLock unlock];
}

- (void)dealloc
{
	for (IconDownloader *icon in [m_imageDownloadsInProgress allValues]) {
		icon.delegate = nil;
		[icon release];
	}
	[m_imageDownloadsInProgress release];
	
    [queue release], queue = nil;
    
    self.pathSuffix = nil;
	int retainCount = [[g_imageArrayDic objectForKey:@"retainCount"] intValue]-1;
	if (retainCount > 0) {
		[g_imageArrayDic setObject:[NSNumber numberWithInt:retainCount] forKey:@"retainCount"];
	} else {
		[g_imageArrayDic release], g_imageArrayDic = nil;
        NSLog(@"------------------------------------------------------------------------------------------------------------------------");
	}
	
	[super dealloc];
}

//修正图片显示方式
-(UIImage*)rotateUIImage:(UIImage*)src {
    
    // No-op if the orientation is already correct
    if (src.imageOrientation == UIImageOrientationUp) return src ;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (src.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, src.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, src.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (src.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, src.size.width, src.size.height,
                                             CGImageGetBitsPerComponent(src.CGImage), 0,
                                             CGImageGetColorSpace(src.CGImage),
                                             CGImageGetBitmapInfo(src.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (src.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,src.size.height,src.size.width), src.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,src.size.width,src.size.height), src.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
