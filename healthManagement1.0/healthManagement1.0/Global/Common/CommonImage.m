//
//  CommonImage.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonImage.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation CommonImage


//view生成图片
+ (UIImage*)imageWithView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//view生成图片
+ (UIImage*)screenshotWithView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if (IOS_7) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)imageFromView:(UIView*)theView atFrame:(CGRect)rect
{
    UIImage* image = [CommonImage screenshotWithView:theView];
    
    rect = CGRectMake(rect.origin.x * image.scale,
                      rect.origin.y * image.scale,
                      rect.size.width * image.scale,
                      rect.size.height * image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage* img = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return img;
}

//将屏幕区域截图 生成：
+ (UIImage*)imageWithView:(UIView*)view forSize:(CGSize)size
{
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, [UIScreen mainScreen].scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    //    CGContextTranslateCTM(c, 0, 20);
    [view.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

//将图片生成一个圈的图
+ (UIImage*)imageWithImage:(UIImage*)image
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat WH = width > height ? height : width;
    
    UIImage* img;
    if (abs((int)(width - height)) > 1) {
        CGRect rect = CGRectMake(MAX((width - height) / 2, 0), MAX((height - width) / 2, 0), WH, WH);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    } else {
        img = image;
    }
    
    //开始绘制图片
    UIGraphicsBeginImageContext(CGSizeMake(WH, WH));
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建一个Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, WH / 2, WH / 2, WH / 2, 0, DEGREES_TO_RADIANS(360), NO);
    CGContextAddPath(gc, path);
    
    //按照path截出context
    CGContextClip(gc);
    CGPathRelease(path);
    //    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [image CGImage]);
    [img drawInRect:CGRectMake(0, 0, WH, WH)];
    
    //结束绘画
    UIImage* destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImg;
}

//把UIColor对象转化成UIImage对象
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//把UIColor对象转化成UIImage对象
+ (UIImage*)createImageWithColor:(UIColor *)color forAlpha:(float)alpha
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, alpha);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//#009900
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert
{
    NSString* cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha
{
    NSString* cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}

/**
 *  返回截图
 */
+ (void)popToNoNavigationView
{
    float y = 0;
    UIImageView* imageViewTest = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, kDeviceHeight + 44)];
    imageViewTest.image = [CommonImage imageWithView:APP_DELEGATE];
    imageViewTest.contentMode = UIViewContentModeTop;
    [APP_DELEGATE addSubview:imageViewTest];
    [imageViewTest release];
    [UIView animateWithDuration:0.35 animations:^{
        imageViewTest.frame = [Common rectWithOrigin:imageViewTest.frame x:kDeviceWidth y:0];
    } completion:^(BOOL finished) {
        [imageViewTest removeFromSuperview];
    }];
}

//等比例缩放
+ (UIImage *)zoomImage:(UIImage *)image toScale:(CGSize)size
{
    //开始绘制图片
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建一个Path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //按照path截出context
    CGContextClip(gc);
    CGPathRelease(path);
    //    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [image CGImage]);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //结束绘画
    UIImage* destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImg;
}

+ (UIImageView*)creatRightArrowX:(CGFloat)x Y:(CGFloat)y cell:(id)cell
{
    UIImage * image =[UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
    UIView * view = cell;
    UIImageView*rightView = [[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-20-image.size.width,0, image.size.width, view.height)]autorelease];
    rightView.contentMode = UIViewContentModeCenter;
    rightView.image = image;
    //    [cell addSubview:rightView];
    return rightView;
}

+ (void)setImageFromServer:(NSString*)imgUrl View:(id)imageView Type:(int)type
{
    NSString *imagePath = imgUrl;
    CGSize imageSize;
    switch (type) {
        case 0:
            imageSize = CGSizeMake(80, 80);
            break;
        case 1:
            imageSize = ((UIView*)imageView).size;
            break;
        case 2:
            imageSize = ((UIView*)imageView).size;
            break;
        case 3:
            imageSize = ((UIView*)imageView).size;
            break;
        case 4:
            imageSize = ((UIView*)imageView).size;
            break;
    }
    NSString *dimage = [CommonImage fetchDefaultImageWithType:type];
    
    imagePath = [imgUrl stringByAppendingFormat:@"?imageView2/1/w/%d/h/%d", ((int)imageSize.width)*2 , ((int)imageSize.height)*2];
    
    UIImage *define = [UIImage imageNamed:dimage];
    
    if ([imageView isKindOfClass:[UIButton class]]) {
        [(UIButton*)imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:define];
    }
    else{
        [(UIImageView*)imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:define];
    }
}

+(NSString *)fetchDefaultImageWithType:(int)type
{
    NSString *dimage = @"";
    switch (type) {
        case 0:
            dimage = @"common.bundle/common/center_my-family_head_icon.png";
            break;
        case 1:
            dimage = @"common.bundle/common/data_icon_plus.png";
            break;
        case 2:
            dimage = @"common.bundle/common/conversation_logo.png";
            break;
        case 3:
            dimage = @"common.bundle/common/conversation_logo.png";
            break;
        case 4:
            dimage = @"common.bundle/common/center_icon_nor.png";
            break;
        default:
            dimage = @"common.bundle/common/conversation_logo.png";
             break;
    }
    return dimage;
}

+ (void)setBackImageFromServer:(NSString*)imgUrl View:(id)imageView Type:(int)type
{
    NSString *imagePath = imgUrl;
    CGSize imageSize;
    
    switch (type) {
        case 0:
            imageSize = CGSizeMake(80, 80);
            break;
        case 1:
            imageSize = ((UIView*)imageView).size;
            break;
        case 2:
            imageSize = ((UIView*)imageView).size;
            break;
        case 3:
            imageSize = ((UIView*)imageView).size;
            break;
        case 4:
            imageSize = ((UIView*)imageView).size;
            break;
    }
    NSString *dimage = [CommonImage fetchDefaultImageWithType:type];
    UIImage *define = [UIImage imageNamed:dimage];
    if ([imageView isKindOfClass:[UIButton class]]) {
        [(UIButton*)imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:define];
        [(UIButton*)imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateHighlighted placeholderImage:define];
    }
    else{
        [(UIImageView*)imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:define];
    }
}

+ (UIImage*)createRoundImageWithColor:(NSString *)color withRect:(CGRect )rect
{
    //    CGRect rect = CGRectMake(0.0f, 0.0f, 121.0f,121);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [color CGColor]);
    //    CGContextFillRect(context, rect);
    UIColor*aColor = [CommonImage colorWithHexString:color];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    //    CGContextSetLineWidth(context, 3.0);//线的宽度
    CGContextAddArc(context, rect.size.width/2.0, rect.size.width/2.0, rect.size.width/2.0, 0, 2*M_PI, 0); //添加一个圆
    //    CGContextDrawPath(context, kCGPathStroke);
    CGContextDrawPath(context, kCGPathFill);
    //    CGContextFillPath(context);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//设置图片
+ (void)setPicImageQiniu:(NSString*)imgURL View:(id)imageView Type:(int)type Delegate:(getServerPicBlock)block
{
    CGSize imageSize;
    NSString *dimage = @"";
    if (type == 3) {
        dimage = @"common.bundle/common/conversation_logo.png";
    }
    else {
        switch (type) {
            case 0:
                imageSize = CGSizeMake(80, 80);
                dimage = @"common.bundle/common/center_my-family_head_icon.png";
                break;
            case 1:
                imageSize = ((UIView*)imageView).size;
                dimage = @"common.bundle/common/data_icon_plus.png";
                break;
            case 2:
                imageSize = ((UIView*)imageView).size;
                dimage = @"common.bundle/common/conversation_logo.png";
                break;
            case 4:
                imageSize = ((UIView*)imageView).size;
                dimage = @"common.bundle/common/center_icon_nor.png";
                break;
        }
        
        if ([imgURL length]) {
            imgURL = [Common getImagePath:imgURL Widht:imageSize.width * 2 Height:imageSize.height * 2];
        }
    }
    
    UIImage* image;
    if (![imgURL length]) {
        image = [UIImage imageNamed:dimage];
    } else {
        NSString* strCon = [imgURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//        NSString * st = [[Common getImagePath] stringByAppendingFormat:@"/%@", strCon];
        image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon]];
        
        if (!image) {
            image = [UIImage imageNamed:dimage];
            if (strCon) {
                //网络图片 请使用ego异步图片库
                
                UIActivityIndicatorView *activi = [[UIActivityIndicatorView alloc] init];
                activi.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                activi.tag = 1201;
                UIView *view = imageView;
                activi.center = CGPointMake(view.width/2, view.height/2);
                [activi startAnimating];
                [view addSubview:activi];
                [activi release];
                
                NSString *rul = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                ASIHTTPRequest *dRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:rul]];
                [dRequest setTimeOutSeconds:600];
                [dRequest setCompletionBlock:^{

                    @try {
                        UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[imageView viewWithTag:1201];
                        [activi removeFromSuperview];


                        NSData* data = [dRequest responseData];
                        UIImage *image = [UIImage imageNamed:dimage];
                        if (data) {
                            if (data.length > 10) {
                                [data writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
                                
                                if (block) {
                                    block(strCon);
                                    return ;
                                }
                                else {
                                    image = [UIImage imageWithData:data];
                                    [CommonImage setViewImageQiniu:imageView :image];
                                }
                            }
                        }
                        [CommonImage setViewImageQiniu:imageView :image];

                    }
                    @catch (NSException *exception) {
                        NSLog(@"ENCRYPT_GET_USER_ADDRESS");
                    }
                    //        request = nil;
                }];
                [dRequest setFailedBlock:^{

                    @try {
                        UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[imageView viewWithTag:1201];
                        [activi removeFromSuperview];

                    }
                    @catch (NSException *exception) {
                        NSLog(@"ENCRYPT_GET_USER_ADDRESS");
                    }
                    //        request = nil;
                }];
//                    [dRequest startSynchronous];
                [dRequest startAsynchronous];
                    
//                    NSData *data = [dRequest responseData];
//                    
//                    NSError *error = [dRequest error];
//                    
//                    if (error) {
//                        return;
//                    }
//                    else {
//                        dispatch_async( dispatch_get_main_queue(), ^(void){
//                            UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[imageView viewWithTag:1201];
//                            [activi removeFromSuperview];
//                            @try {
//                                UIImage *image = [UIImage imageNamed:dimage];
//                                if (data) {
//                                    if (data.length > 10) {
//                                        [data writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
//                                        
//                                        if (block) {
//                                            block(strCon);
//                                            return ;
//                                        }
//                                        else {
//                                            image = [UIImage imageWithData:data];
//                                            [CommonImage setViewImageQiniu:imageView :image];
//                                        }
//                                    }
//                                }
//                                [CommonImage setViewImageQiniu:imageView :image];
//                            }
//                            @catch (NSException *exception) {
//                                NSLog(@"EScrollerViewqweqweqwe");
//                            }
//                        });
//                    }
                    
//                });

                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                    
//                    NSString *rul = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:rul]];
//                    dispatch_async( dispatch_get_main_queue(), ^(void){
//                        UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[imageView viewWithTag:1201];
//                        [activi removeFromSuperview];
//                        @try {
//                            UIImage *image = [UIImage imageNamed:dimage];
//                            if (data) {
//                                if (data.length > 10) {
//                                    //                                                   NSString *strCon = [imgURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//                                    //                                                   NSLog(@"%ld", (unsigned long)[data length]);
//                                    [data writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
//                                    
//                                    if (block) {
//                                        block(strCon);
//                                        return ;
//                                    }
//                                    else {
//                                        image = [UIImage imageWithData:data];
//                                        [CommonImage setViewImageQiniu:imageView :image];
//                                    }
//                                }
//                            }
//                            [CommonImage setViewImageQiniu:imageView :image];
//                        }
//                        @catch (NSException *exception) {
//                            NSLog(@"EScrollerViewqweqweqwe");
//                        }
//                    });
//                });
            }
        } else {
            if (block) {
                block(strCon);
            }
        }
    }
    [CommonImage setViewImageQiniu:imageView :image];
}

+ (void)setViewImageQiniu:(id)view :(UIImage*)image
{
    ((UIView*)view).clipsToBounds = YES;
    //    NSLog(@"%@", [view class]);
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton* but = (UIButton*)view;
        
        //        if (but.tag == 100 || but.tag == 101)
        //        {
        [but setImage:image forState:UIControlStateNormal];
        //        }
        //        else
        //        {
        //            [but setBackgroundImage:image forState:UIControlStateNormal];
        //        }
        
    } else if ([view isKindOfClass:[UIImageView class]]) {
        [view setImage:image];
    }
    
}

+ (BOOL)isMedia
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        return NO;
    }
    return YES;
}

@end
