//
//  DrawLineView.m
//  Adviser
//
//  Created by wangmin on 14-4-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "DrawLineView.h"
#import "FDGraphScrollView.h"
#import "VerticalLineView.h"
#import "Common.h"

@interface DrawLineView ()
{
    FDGraphScrollView *scrollLineChatView;
    VerticalLineView *verticalLineView;
}

@property (nonatomic,retain) NSArray *multiDataArray;


@property (nonatomic, retain) NSNumber *maxDataPoint;
@property (nonatomic, retain) NSNumber *minDataPoint;


@property (nonatomic,retain) NSArray *normalValueArray;//正常值，一般为一个值

@end
@implementation DrawLineView

static NSArray *colorArray()
{
    
    NSArray *colorArray = [NSArray arrayWithObjects:@"fe6339",@"3cb6e9",@"666666",@"666666", nil];
    
    return colorArray;
}

- (void)dealloc
{
    self.multiDataArray = nil;
    self.maxDataPoint = nil;
    self.minDataPoint = nil;
    self.lineMeansArray = nil;
    [super dealloc];
}

- (void)reloadSubViews
{
    [verticalLineView setNeedsDisplay];
    [scrollLineChatView.graphView setNeedsDisplay];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect graphViewFrame = frame;
        graphViewFrame.origin.x = 40;
        graphViewFrame.origin.y = 30;
        graphViewFrame.size.height = graphViewFrame.size.height - 30;
        graphViewFrame.size.width = graphViewFrame.size.width - 40;//减去左边标尺的宽度
        
        
        verticalLineView = [[VerticalLineView alloc] initWithFrame:CGRectMake(10, 30, graphViewFrame.origin.x, frame.size.height-30)];
        verticalLineView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:verticalLineView];
        [verticalLineView release];
        
        scrollLineChatView = [[FDGraphScrollView alloc] initWithFrame:graphViewFrame];
        scrollLineChatView.backgroundColor = [UIColor clearColor];
        scrollLineChatView.bounces = NO;
        [self addSubview:scrollLineChatView];
        [scrollLineChatView release];
        self.clipsToBounds = YES;
        
    }
    return self;
}


- (NSNumber *)maxDataPoint {
    if (_maxDataPoint) {
        return _maxDataPoint;
    } else {
        
        NSArray *firstArray = nil;
        if(self.multiDataArray.count){
            firstArray = self.multiDataArray[0];
            
        }
        __block float max = 0.0;
        if(firstArray.count){
            max = ((NSString *)firstArray[0]).floatValue;
        }
        
        for(NSArray *dataArray in self.multiDataArray){
            //依次取出每个数组---用来获得最大数
            [dataArray enumerateObjectsUsingBlock:^(NSString *n, NSUInteger idx, BOOL *stop) {
                if (n.floatValue > max)
                    max = n.floatValue;
            }];
            
        }
        
        if(self.normalValueArray.count){
            //取出正常值，判断与最大值关系，如果正常值大，则 最大值设为正常值
            if(self.normalValueArray.count == 2){
                NSArray *bigArray = self.normalValueArray[1];
                if(bigArray.count){
                    NSString *normalValue = bigArray[1];
                    if([normalValue floatValue] >= max){
                        max = normalValue.floatValue ;
                    }
                }
            }else{
                NSArray *bigArray = self.normalValueArray[0];
                NSString *normalValue = bigArray[0];
                if([normalValue floatValue] >= max){
                    max = normalValue.floatValue ;
                                        
                }
            }
            
        }
        
        
        max += self.minAndMaxOffset;
        
        if(max < 16.7){
            
            max = 16.7;
        }
        _maxDataPoint = @(max);
        return @(max);
    }
}

- (NSNumber *)minDataPoint {
    if (_minDataPoint) {
        return _minDataPoint;
    } else {
        __block CGFloat min = 0;//((NSString *)firstArray[0]).floatValue;
        
//        if (self.isThin) {
////            if(self.normalValueArray.count > 1){
////                //取出正常值，判断与最大值关系，如果正常值大，则 最大值设为正常值
////                NSArray *smallArray = self.normalValueArray[0];
////                if(smallArray.count >= 1){
////                    NSString *normalValue = smallArray[0];
////                    if([normalValue floatValue] <= min){
////                        
////                        min = normalValue.floatValue;
////                    }
////                }
////                
////            }else{
//            NSArray *smallArray = self.normalValueArray[0];
//            min = [smallArray[1] floatValue];
////                if(smallArray.count >= 1){
////                    NSString *normalValue = smallArray[0];
////                    if([normalValue floatValue] <= min){
////                        
////                        min = normalValue.floatValue;
////                    }
////                }
////            }
//            return @(min);
//        }
        
        NSArray *firstArray = nil;
        if(self.multiDataArray.count){
            firstArray = self.multiDataArray[0];
            
        }
        if(firstArray.count){
            min = ((NSString *)firstArray[0]).floatValue;
        }
        for(NSArray *dataArray in self.multiDataArray){
            //依次取出每个数组---用来获得最小值
            [dataArray enumerateObjectsUsingBlock:^(NSString *n, NSUInteger idx, BOOL *stop) {
                if (n.floatValue < min && n.floatValue > 0)
                    min = n.floatValue;
            }];
        }
        
        if(self.normalValueArray.count > 1){
            //取出正常值，判断与最大值关系，如果正常值大，则 最大值设为正常值
            NSArray *smallArray = self.normalValueArray[0];
            if(smallArray.count >= 1){
                NSString *normalValue = smallArray[0];
                if([normalValue floatValue] <= min && [normalValue floatValue] > 0){
                    
                    min = normalValue.floatValue;
                }
            }
            
        }else{
            
            NSArray *smallArray = self.normalValueArray[0];
            if(smallArray.count >= 1){
//                NSString *normalValue = smallArray[0];
//                if([normalValue floatValue] <= min && [normalValue floatValue] > 0){
//                    
//                    min = normalValue.floatValue;
//                }
                
                for(NSString *normalValue in smallArray){
                    if([normalValue floatValue] <= min && [normalValue floatValue] > 0){
                        
                        min = normalValue.floatValue;
                    }
                }
            }
        }
        
        min -= self.minAndMaxOffset;
        if(min > 0 && !self.isThin){
            
            min = 0;
        }
        
        return @(min);
    }
}

- (void)setDataPoints:(NSArray *)dataPoints dataPoints2:(NSArray *)dataPoint2 timeArray:(NSArray *)timeArray{
    
    verticalLineView.dataPoints = dataPoints;
    verticalLineView.dataPoints2 = dataPoint2;
    [scrollLineChatView setDataPoints:dataPoints dataPoints2:dataPoint2 timeArray:timeArray];
}

- (void)setLineDataArray:(NSArray *)multiDataArray andTimeArray:(NSArray *)timeArray normalValueArray:(NSArray *)normalValueArray lineMeansArray:(NSArray *)lineMeansArray aboutMultiLocaInOriginalArray:(NSArray *)multiLocalArray{
    
    
    _maxDataPoint = 0;
    _minDataPoint = 0;
    self.lineMeansArray = [NSMutableArray arrayWithArray:lineMeansArray];
    if(multiDataArray.count == 0){
        //提示数据太少
        return;
    }
    
    if(self.minAndMaxOffset == 0){
        self.minAndMaxOffset = 0;
    }
    if(self.currentTimeType == OneDayType){
        self.minAndMaxOffset = 0;
    }
    
    self.multiDataArray = multiDataArray;
    self.normalValueArray = normalValueArray;
    verticalLineView.normalValueArray = normalValueArray;
    
    
    NSLog(@"---maxDataPoint:%@",self.maxDataPoint);
    
    if(self.currentTimeType == OneDayType){
        if([self.maxDataPoint integerValue] > 1000){//最大值大于1000并且来自数据源
            self.maxDataPoint = [NSNumber numberWithInt:(int)([self.maxDataPoint integerValue]/1000+1)*1000];
        }
    }
    
    if ([self.m_strType isEqualToString:@"血糖趋势"]||[self.m_strType isEqualToString:@"血糖曲线"]||[self.m_strType isEqualToString:@"享瘦派"]){
        
        verticalLineView.isBloodSugarFlag = YES;
    }else{
    
        verticalLineView.isBloodSugarFlag = NO;
    }
    

    verticalLineView.maxDataPoint = self.maxDataPoint;
    verticalLineView.minDataPoint = self.minDataPoint;
    
    
    verticalLineView.isYClipTo5 = self.isYClipTo5;
    verticalLineView.currentTimeType = self.currentTimeType;
    verticalLineView.isThin = self.isThin;
    
    scrollLineChatView.maxDataPoint = self.maxDataPoint;
    scrollLineChatView.minDataPoint = self.minDataPoint;
    scrollLineChatView.isThin = self.isThin;
    
    
    
    scrollLineChatView.currentTimeType = self.currentTimeType;//设置类型
    scrollLineChatView.isYClipTo5 = self.isYClipTo5;
    scrollLineChatView.isNewSugarTrend = _isNewSugarTrend;
    
    [scrollLineChatView  setLineDataArray:multiDataArray andTimeArray:timeArray normalValueArray:normalValueArray lineMeansArray:lineMeansArray aboutMultiLocaInOriginalArray:multiLocalArray];
    
    
}

- (void)drawMeansOfLine:(CGRect)rect
{
    
    if(self.lineMeansArray.count == 0){
        return;
    }

	
    [[CommonImage colorWithHexString:@"666666"] setStroke];
    [[CommonImage colorWithHexString:@"666666"] setFill];
    [self.m_strType drawInRect:CGRectMake(30, 8, 90, 30) withFont:[UIFont systemFontOfSize:15]];//类别说明
    
    return;
    
    //画标题
    NSString *titleString = self.lineMeansArray[0];
	if ([self.m_strType isEqualToString:@"血糖"] || [self.m_strType isEqualToString:@"体重"]) {
		
		//画矩形区域
		CGContextRef context = UIGraphicsGetCurrentContext();
//		CGContextSetLineWidth(context, 10);
//		
//		NSString *titleString = self.lineMeansArray[1];
//		[[CommonImage colorWithHexString:@"e2e0e1"] setStroke];
//		
//		CGContextMoveToPoint(context, 100, 10+6);
//		CGContextAddLineToPoint(context, 100+ 15, 10+6);
//		CGContextStrokePath(context);
		
		
		CGRect rectangle = CGRectMake(30, 15, 14, 12);
		CGContextAddRect(context, rectangle);
		CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:@"fe6339" alpha:0.1].CGColor);
		CGContextFillPath(context);
		
		[[CommonImage colorWithHexString:@"fe6339"] setFill];
		[self.lineMeansArray[1] drawInRect:CGRectMake(50, 14, 60, 15) withFont:[UIFont systemFontOfSize:12]];
		
		
		[[CommonImage colorWithHexString:@"666666"] setFill];
		[titleString drawInRect:CGRectMake(115, 14, 90, 15) withFont:[UIFont systemFontOfSize:12]];
		
//		CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:hex].CGColor);
//		[date drawInRect:CGRectMake(targetX+5, targetY, 25, 16) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
		
		return;
	}
	
    [[CommonImage colorWithHexString:@"666666"] setStroke];
    [[CommonImage colorWithHexString:@"666666"] setFill];
    [titleString drawInRect:CGRectMake(145, 8, 90, 30) withFont:[UIFont systemFontOfSize:12]];//存放的是单位说明
    
     
    [self.lineMeansArray removeObjectAtIndex:0];
    
    CGFloat marginx = 30;
    CGFloat marginy = 10;
    CGFloat x;
    CGFloat y;
    CGFloat width = 80;
    for(int i = 0; i < self.lineMeansArray.count; i++){
        int fontSize = 9;
        x = (i%2 == 0)?  marginx :(marginx + 82);
        if(i == 1){//针对血压特殊处理
            x -= 30;
        }else if (i == 3){
            x += 20;
        }
        y = (i < 2) ?    marginy : (marginy + 20);
        
        width = (i%2 == 0)?  80 :95;
        //设计为2条线，前两个画线说明 后两个说明正常区域
        if(i < 2){
            CGFloat offset = 0;
            if (self.lineMeansArray.count == 2) {
                offset = 0;
                y += offset;
                fontSize = 14;
            }
            
            if(self.oneValueAndRange){
                offset = 0;
                y += offset;
                fontSize = 9;
                if(i == 0){
                    //画线
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSetLineWidth(context, 1);
                    
                    [[CommonImage colorWithHexString:colorArray()[i]] setStroke];
                    CGContextMoveToPoint(context, x, y+6);
                    CGContextAddLineToPoint(context, x+ 15, y+6);
                    CGContextStrokePath(context);

                }else{
                    
                    //画矩形区域
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSetLineWidth(context, 10);
                    
                    [[CommonImage colorWithHexString:colorArray()[0] alpha:0.1] setStroke];
                    CGContextMoveToPoint(context, x, y+6);
                    CGContextAddLineToPoint(context, x+ 15, y+6);
                    CGContextStrokePath(context);

                }
            }else{
            
                //画线
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, 1);
                
                [[CommonImage colorWithHexString:colorArray()[i]] setStroke];
                CGContextMoveToPoint(context, x, y+6);
                CGContextAddLineToPoint(context, x+ 15, y+6);
                CGContextStrokePath(context);
            }
			
        }else{
            //画矩形区域
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 10);
            
            NSString *titleString = self.lineMeansArray[i];
            if([titleString isEqualToString:@"餐前正常区域"]){
                [[CommonImage colorWithHexString:@"e2e0e1"] setStroke];
            }else{
                 [[CommonImage colorWithHexString:colorArray()[i-2] alpha:0.1] setStroke];

            }
            CGContextMoveToPoint(context, x, y+6);
            CGContextAddLineToPoint(context, x+ 15, y+6);
            CGContextStrokePath(context);
        }
        
        NSString *titleString = self.lineMeansArray[i];
        if(self.oneValueAndRange){
            [[CommonImage colorWithHexString:colorArray()[0]]  setStroke];
            [[CommonImage colorWithHexString:colorArray()[0]]  setFill];
        }else{
            [[CommonImage colorWithHexString:colorArray()[i]]  setStroke];
            [[CommonImage colorWithHexString:colorArray()[i]]  setFill];
        }

        [titleString drawInRect:CGRectMake(x+18, y, width, 20) withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:NSLineBreakByWordWrapping];
        
        
        //        CGPoint point = CGPointMake(x+15/2.0, y+6);
        //
        //        CGRect ellipseRect = CGRectMake(point.x-1.5, point.y-1.5, 10, 3);
        //
        ////        CGContextAddEllipseInRect(context, ellipseRect);
        //        CGContextAddRect(context, ellipseRect);
        //        CGContextSetLineWidth(context, 0.5);
        ////        [self.dataPointStrokeColor setStroke];
        ////        [self.dataPointColor setFill];
        //        CGContextFillEllipseInRect(context, ellipseRect);
        //        CGContextStrokeEllipseInRect(context, ellipseRect);

    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawMeansOfLine:CGRectMake(0, 0, rect.size.width, 50)];
	
    
}


@end