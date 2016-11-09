
//
//  VerticalLineView.m
//  Adviser
//
//  Created by wangmin on 14-4-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "VerticalLineView.h"
#import "Common.h"

@interface VerticalLineView ()


@property (nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation VerticalLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _edgeInsets = UIEdgeInsetsMake(10, 30, 30, 10);
        
    }
    return self;
}

//- (NSNumber *)maxDataPoint {
//    if (_maxDataPoint) {
//        return _maxDataPoint;
//    } else {
//        __block CGFloat max = ((NSString *)self.dataPoints[0]).floatValue;
//        [self.dataPoints enumerateObjectsUsingBlock:^(NSString *n, NSUInteger idx, BOOL *stop) {
//            if (n.floatValue > max)
//                max = n.floatValue;
//        }];
//        if(self.dataPoints2.count){
//            [self.dataPoints2 enumerateObjectsUsingBlock:^(NSString *n, NSUInteger idx, BOOL *stop) {
//                if (n.floatValue > max)
//                    max = n.floatValue;
//            }];
//        }
//
//
//        return @(max);
//    }
//}
//
//- (NSNumber *)minDataPoint {
//    if (_minDataPoint) {
//        return _minDataPoint;
//    } else {
//        __block CGFloat min = ((NSString *)self.dataPoints[0]).floatValue;
//        [self.dataPoints enumerateObjectsUsingBlock:^(NSString *n, NSUInteger idx, BOOL *stop) {
//            if (n.floatValue < min)
//                min = n.floatValue;
//        }];
//        if(self.dataPoints2.count){
//            [self.dataPoints2 enumerateObjectsUsingBlock:^(NSString *n, NSUInteger idx, BOOL *stop) {
//                if (n.floatValue < min)
//                    min = n.floatValue;
//            }];
//        }
//
//        return @(min);
//    }
//}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (self.isThin) {
        _edgeInsets = UIEdgeInsetsMake(30, 30, 50, 10);
    }
    //纵轴标注
    //相对高度
    CGFloat drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    CGFloat min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    CGFloat max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    //分成5段
    //    CGFloat oneItemHeight = drawingHeight/4.0;
    CGFloat oneItemValue = (max-min)/1.0;
    //    20 40 60 80 100
    
    //纵轴
    //        CGContextRef context = UIGraphicsGetCurrentContext();
    //        [[UIColor redColor] setStroke];
    //        CGContextSetLineWidth(context, 1);
    //        CGContextMoveToPoint(context, self.frame.size.width, rect.size.height-self.edgeInsets.bottom+1);
    //        CGContextAddLineToPoint(context, self.edgeInsets.left, self.edgeInsets.top);
    //        CGContextStrokePath(context);
    
    
    //    CGFloat offset = min/oneItemValue * (drawingHeight/5.0);//确定起点x的位置=min占一个的倍数*一个的高度
    
    NSMutableArray *numArray = [[NSMutableArray alloc] initWithCapacity:0];
    //    [numArray addObject:[NSString stringWithFormat:@"%f",min]];
    
    
    if(self.isYClipTo5){
        for(int i = 0; i < 5; i++){
            [numArray addObject:[NSString stringWithFormat:@"%.0f",min+i*oneItemValue]];
        }
        
    }
    else if (self.isThin){
        [numArray addObjectsFromArray:self.normalValueArray[0]];
    }
    else{
        
        if (self.isBloodSugarFlag || self.isThin) {
            [numArray addObject:[NSString stringWithFormat:@"%.1f",[self.maxDataPoint floatValue]]];
            [numArray addObject:[NSString stringWithFormat:@"%.1f",[self.minDataPoint floatValue]]];
        }
        else {
            [numArray addObject:[NSString stringWithFormat:@"%@",self.maxDataPoint]];
            [numArray addObject:[NSString stringWithFormat:@"%@",self.minDataPoint]];
        }
        for(NSArray *normalArray in self.normalValueArray){
            //            [numArray addObjectsFromArray:normalArray];
            
            for(NSString *value in normalArray){
                if([numArray containsObject:value]){
                    
                    continue;
                }else{
                    [numArray addObject:value];
                }
            }
        }
    }
    
    
    
    [numArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *o1 = obj1;
        NSString *o2 = obj2;
        if(o1.floatValue < o2.floatValue){
            return NSOrderedDescending;
        }else if(o1.floatValue > o2.floatValue){
            return NSOrderedAscending;
        }else{
            
            return NSOrderedSame;
        }
        
    }];
    
    NSArray *titl = @[@"初始", @"目标"];
    
    int i = 0;
    for(NSString *value in numArray){
        //从右到左到上
//        CGFloat y = rect.size.height - (self.edgeInsets.bottom + drawingHeight*(([value floatValue] - min) / (max - min)));//根据比例确定y的值
//        float item = drawingHeight/(max - min);
//        float y = self.edgeInsets.top + item*(max-[value floatValue]);
//        rect.size.height-self.edgeInsets.bottom+10
        
        CGFloat y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*(((CGFloat)([value floatValue] - min)/oneItemValue)));//根据比例确定y的值
        //纵轴小斜线
        NSLog(@"-----y:%f",y);
        
        NSString *color = [self getPointColorWithCount:numArray.count index:i];
        
        [[CommonImage colorWithHexString:color] setStroke];
        [[CommonImage colorWithHexString:color] setFill];
        if(self.currentTimeType == OneDayType){
            if([value intValue] < 0){
                value = @"0";
            }
        }
        
        if(value.intValue < 0){
            value = @"0";
        }
        
        NSString *floatyString = nil;
        if(self.isBloodSugarFlag){
            if([value rangeOfString:@"."].length){
                floatyString = [NSString stringWithFormat:@"%.1f",value.floatValue];
            }else{
                floatyString = [NSString stringWithFormat:@"%.0f",value.floatValue];
            }
        }else{
            floatyString = [NSString stringWithFormat:@"%.0f",value.floatValue];
        }
        
        if (self.isThin) {
            floatyString = [NSString stringWithFormat:@"%.1f\n%@",value.floatValue, titl[i]];
        }
        
        [floatyString drawInRect:CGRectMake(0,y-8, 30, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        
        i++;
    }
    
}

- (NSString *)getPointColorWithCount:(int)count index:(int)index
{
    
    if (self.isThin) {
        return @"333333";
    }
    
    if(self.currentTimeType == OneDayType){
        
        return @"333333";
    }
    
    NSArray *colorArray = @[@"fe6339",@"a9ce06",@"57b2ff"];
    
    if(count == 5){
        
        colorArray = @[@"ff7a22",@"2ed039",@"6c93ff",@"ff7a22",@"ffffff"];
    }else if (count == 4){
        colorArray = @[@"ff7a22",@"2ed039",@"6c93ff",@"333333"];
        
    }else{
        
        colorArray = @[@"fe6339",@"a9ce06",@"333333"];
    }
    
    return colorArray[index];
    
    
    //    if(firstN.floatValue == secondN.floatValue){
    //
    //        return @"a9ce06";
    //    }
    //
    //
    //
    //    if(value.floatValue > max){
    //        return colorArray[0];
    //
    //    }else if( value.floatValue > min){
    //        return colorArray[1];
    //    }else{
    //        return colorArray[2];
    //    }
    //    
    //    return colorArray[0];
}



@end
