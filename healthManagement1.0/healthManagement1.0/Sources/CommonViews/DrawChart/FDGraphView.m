//
//  FDGraphView.m
//  disegno
//
///  Created by wangmin on 14-4-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FDGraphView.h"
#import "Common.h"
#import "AppDelegate.h"

@interface FDGraphView()
{
    
    
    NSTimer *timer;
//    UILabel *detailView;
    CGFloat  spaceWidth;//间距width
    NSArray *otherDataArray;//第二组用
    UIImageView *triangleImgeView;
}


@property (nonatomic, assign) CGPoint  minLeftpoint;

@property (nonatomic, assign) CGPoint  maxRightPoint;

@property (nonatomic,assign) CGFloat currentOffsetX;//当前的间距 当该值大于等于minOffsetX时有效
@property (nonatomic,assign) CGFloat scaleNum;//缩放的比例
@property (nonatomic,assign) BOOL isLandView;//横屏
@property (nonatomic,assign) CGFloat minoffsetX;//最小的间距

@property (nonatomic,assign) CGFloat  originWidth;

@end


static NSArray *colorArray()
{
    //    3cb6e9
    NSArray *colorArray = [NSArray arrayWithObjects:[CommonImage colorWithHexString:@"6c93ff"],[CommonImage colorWithHexString:@"2ed039"],[CommonImage colorWithHexString:@"d05151"], nil];//ffa391
    
    return colorArray;
}

@implementation FDGraphView

- (void)dealloc
{
    self.dataPoints = nil;
    self.dataPoints2 = nil;
    self.timePointsString = nil;
    self.linesColor = nil;
    self.dataPoints = nil;
    self.dataPointStrokeColor = nil;
    self.multiDataArray = nil;
    self.lineMeansArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default values
        _edgeInsets = UIEdgeInsetsMake(30, 20, 30,30);
        self.dataPointColor = [CommonImage colorWithHexString:@"ff0000"];//[UIColor redColor];
        self.dataPointStrokeColor = [CommonImage colorWithHexString:@"ff0000"];//[UIColor blackColor];
        self.linesColor = [UIColor grayColor];
        _autoresizeToFitData = NO;
        _dataPointsXoffset = 10.0f;
        self.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];
        //        self.backgroundColor = [UIColor clearColor];
        
        //       timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(addData) userInfo:nil repeats:YES];


        UIImage *normalImage =[UIImage  imageNamed:@"common.bundle/diary/redbubble.png"];//非高亮
        triangleImgeView = [[UIImageView alloc]initWithImage:normalImage];
        triangleImgeView.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
        triangleImgeView.userInteractionEnabled = YES;
        [self addSubview:triangleImgeView];
//        [[UIApplication sharedApplication].keyWindow addSubview:triangleImgeView];
        triangleImgeView.alpha = 0;
        
        UILabel *detailView = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, normalImage.size.width, normalImage.size.height)]autorelease];
        detailView.textColor = [UIColor whiteColor];
        detailView.backgroundColor  = [UIColor clearColor];//[CommonImage colorWithHexString:@"fe6339"];
        detailView.font = [UIFont systemFontOfSize:13.0f];
        detailView.textAlignment = NSTextAlignmentCenter;
        detailView.tag = 299;
        [triangleImgeView addSubview:detailView];

        self.originWidth = frame.size.width;
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchCalled:)];
        [self addGestureRecognizer:pinchGesture];
        [pinchGesture release];
        
        UITapGestureRecognizer *pinchGestureTriangleImgeView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipTriangleImgeView:)];
        [self addGestureRecognizer:pinchGestureTriangleImgeView];
        [pinchGestureTriangleImgeView release];
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)pinchCalled:(UIPinchGestureRecognizer *)pinch
{
    [self tipTriangleImgeView:nil];
    
    if(self.timeType == OneDayType){
        return;
    }
    
    
    self.scaleNum = pinch.scale;
    //    [self setNeedsDisplay];
    //
    NSInteger count = self.dataPoints.count;
    
    CGFloat rectWidth = [[Common getAppDelegate] isLandView]? kDeviceHeight : kDeviceWidth ;
    
    if(count > 1){
        
        TimeType type = self.timeType;
        
        
        
        CGFloat  drawingWidth = rectWidth - self.edgeInsets.left - self.edgeInsets.right;//获得绘画的宽度
        
        self.minoffsetX = drawingWidth/(count-1);//最小间距
        
        CGFloat width = drawingWidth/(count -1);
        if(self.currentOffsetX == 0 && self.scaleNum > 0){
            //未初始化过 且 处于缩放时
            width = self.minoffsetX * self.scaleNum;
            self.currentOffsetX = width;
            self.theTimeType = ScaleType;
        }else if(self.scaleNum > 0){
            //且 处于缩放时
            width = self.currentOffsetX *self.scaleNum;//非首次在原基础上变化
            //        self.currentOffsetX = width;//结束时记录哦
            self.theTimeType = ScaleType;
            self.theTimeType = ScaleType;
        }
        
        if(width > 80 ){//最大间隔
            width = 80;
        }
        
        [self changeFrameWidthTo:self.edgeInsets.left + self.edgeInsets.right + spaceWidth*(count -1)];
        
        if(width < self.minoffsetX){//最小间隔
            width = self.minoffsetX;
            self.theTimeType = type;
            [self changeFrameWidthTo:self.originWidth];
        }
        
        spaceWidth = width;
 
    }
    
    
    if([(UIPinchGestureRecognizer*)pinch state] == UIGestureRecognizerStateEnded) {
        [self pinchEndWithScale:pinch.scale];
    }
    
    [self setNeedsDisplay];
}

- (void)pinchEndWithScale:(CGFloat)scale
{
    self.currentOffsetX = spaceWidth;
}

//test
//- (void)addData
//{
//    
//    if(self.dataPoints.count > 25){
//        [timer invalidate];
//        timer = nil;
//        return;
//    }
//    
//    NSMutableArray *datas = [self.dataPoints mutableCopy];
//    [datas addObject:[NSString stringWithFormat:@"%d",arc4random()%20]];
//    self.dataPoints = datas;
//    
//    NSMutableArray *timePointes = [self.timePointsString mutableCopy];
//    [timePointes addObject:[NSString stringWithFormat:@"%d",arc4random()%20]];
//    self.timePointsString = timePointes;
//    
//    [self setNeedsDisplay];
//    
//    
//}


- (CGFloat)widhtToFitData {
    CGFloat res = 0;
    
    if (self.dataPoints) {
        res += (self.dataPoints.count - 1)*self.dataPointsXoffset; // space occupied by data points
        res += (self.edgeInsets.left + self.edgeInsets.right) ; // lateral margins;
    }
    
    return res;
}
//画坐标
- (void)drawCoordinate:(CGRect)rect withNormalValueArray:(NSArray *)normalValuesArray
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *color;
    float y;
    if (self.isThin) {
        color = @"dcdcdc";
        y = rect.size.height-self.edgeInsets.bottom+10;
    }
    else {
        color = @"dddddd";
        y = rect.size.height-self.edgeInsets.bottom-0.5;
    }
    [[CommonImage colorWithHexString:color] setStroke];
    CGContextSetLineWidth(context, 0.5);
    //画x时间轴
    CGContextMoveToPoint(context, rect.size.width-10 ,y);
    CGContextAddLineToPoint(context, 0, y);
    CGContextStrokePath(context);
    
    //画x轴开始结束的封闭线
    [self drawlineFrombottonToTopWithX:0];
    [self drawlineFrombottonToTopWithX:rect.size.width-10.5];
    
    //纵轴标注----画正常值的线
    //相对高度
    CGFloat drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    CGFloat min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    CGFloat max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    //画纵坐标虚线
    if (!self.isThin) {
        //分成5段
        CGFloat oneItemValue1 = (max-min)/4.0;
        NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:0];
        
        if(self.isYClipTo5){
            for(int i = 0; i < 5; i++){
                [numArray addObject:[NSString stringWithFormat:@"%.0f",min+i*oneItemValue1]];
            }
            
        }else{
            [numArray addObject:[NSString stringWithFormat:@"%@",self.maxDataPoint]];
            [numArray addObject:[NSString stringWithFormat:@"%@",self.minDataPoint]];
            //不显示正常值线
            //        for(NSArray *normalArray in normalValuesArray){
            //            [numArray addObjectsFromArray:normalArray];
            //        }
        }
        //最高最低值画线
        for(NSString *value in numArray){
            //从右到左到上
            int y = rect.size.height - (self.edgeInsets.bottom + drawingHeight*(([value floatValue] - min) / (max - min)));//根据比例确定y的值
            if(y == rect.size.height - (self.edgeInsets.bottom + drawingHeight)){
                [self drawNormalDashLineWithY:y color:@"ff7a22"];
            }else{
                CGContextRef context = UIGraphicsGetCurrentContext();
                [[CommonImage colorWithHexString:@"e5e5e5"] setStroke];
                CGContextSetLineWidth(context, 0.5);
                CGContextMoveToPoint(context, 0, y-0.5);
                CGFloat maxRightX = rect.size.width-10;
                CGContextAddLineToPoint(context,maxRightX, y-0.5);
                CGContextStrokePath(context);
            }
        }
    }
    
    //分成5段
    CGFloat oneItemValue = (max-min)/1.0;
    //    20 40 60 80 100
    int i = 0;
    
    //画横向分割线
    CGFloat shadowLow = 0;
    for( NSArray *normalArray in normalValuesArray){
        //依次取出正常值
        NSString *normalBigValueString = normalArray[0];
        NSString *normalSmallValueString = normalArray[1];
        CGFloat normalBigValue = [normalBigValueString floatValue];
        CGFloat normalSmallValue = [normalSmallValueString floatValue];
        CGFloat bigy = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*(((CGFloat)(normalBigValue - min)/oneItemValue)));//根据比例确定y的值
        CGFloat smally = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*(((CGFloat)(normalSmallValue - min)/oneItemValue)));//根据比例确定y的值
        if(normalValuesArray.count == 1){
            [self drawNormalDashLineWithY:smally color:@"2ed039"];
            [self drawNormalDashLineWithY:bigy color:@"6c93ff"];
            [self drawShadowView:smally second:bigy];
        }else{//两组正常值时进入该逻辑
            if(i == 0){
                [self drawNormalDashLineWithY:bigy color:@"ff7a22"];//下
                shadowLow = bigy;
            }else{
                [self drawNormalDashLineWithY:smally color:@"2ed039"];//上
                [self drawNormalDashLineWithY:bigy color:@"6c93ff"];//中
                [self drawShadowView:shadowLow second:smally];
            }
        }
        i++;
    }
}

- (void)drawNormalDashLineWithY:(CGFloat)y color:(NSString *)color
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
     CGContextSaveGState(context);//保存一份状态
    
    [[CommonImage colorWithHexString:color] setStroke];
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, y);
    //绘制8空5个如此循环
    CGFloat lengths[] = {2,1};
    //phase,为第一次绘制5-phase个点
    CGContextSetLineDash(context, 0, lengths, 2);//暂时屏蔽了
    CGContextAddLineToPoint(context,self.size.width-10, y);
    
    CGContextStrokePath(context);
    
//    CGContextClosePath(context);
    
    CGContextRestoreGState(context);//恢复之前的
    
    
}

//画阴影
- (void)drawShadowView:(CGFloat) firstY  second:(CGFloat)secondY
{

    
     CGContextRef context = UIGraphicsGetCurrentContext();

     CGMutablePathRef path = CGPathCreateMutable();
     CGPathMoveToPoint(path, NULL, 0, firstY-0.1);
     CGPathAddLineToPoint(path, NULL, self.size.width-10, firstY);
     CGPathAddLineToPoint(path, NULL, self.size.width-10, secondY);
     CGPathAddLineToPoint(path, NULL, 0, secondY);
     CGPathAddLineToPoint(path, NULL, 0, firstY);
     CGPathCloseSubpath(path);
    
    [self drawLinearGradient:context path:path startColor:[CommonImage colorWithHexString:@"3fd0ff" alpha:0.12].CGColor endColor:[CommonImage colorWithHexString:@"3fd0ff" alpha:0.02].CGColor];
    
}


- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //构建
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}



//画坐标
- (void)drawStepCoordinate:(CGRect)rect withNormalValueArray:(NSArray *)normalValuesArray
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[CommonImage colorWithHexString:@"e5e5e5"] setStroke];
    CGContextSetLineWidth(context, 0.5);
    //画x时间轴
    //    CGContextMoveToPoint(context, self.maxRightPoint.x+3, rect.size.height-self.edgeInsets.bottom);
    CGContextMoveToPoint(context, rect.size.width-10 , rect.size.height-self.edgeInsets.bottom-0.5);
    CGContextAddLineToPoint(context, 0, rect.size.height-self.edgeInsets.bottom-0.5);
    //    CGContextAddLineToPoint(context, self.edgeInsets.left, self.edgeInsets.top);
    CGContextStrokePath(context);
    
    //画x轴开始结束的封闭线
    [self drawlineFrombottonToTopWithX:0];
    [self drawlineFrombottonToTopWithX:rect.size.width-10.5];
    
    
    //纵轴标注----画正常值的线
    //相对高度
    CGFloat drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    CGFloat min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    CGFloat max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    //画纵坐标虚线
    
    
    //分成5段
    CGFloat oneItemValue1 = (max-min)/4.0;
    NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:0];
    
    if(self.isYClipTo5){
        for(int i = 0; i < 5; i++){
            [numArray addObject:[NSString stringWithFormat:@"%.0f",min+i*oneItemValue1]];
            
        }
        
    }else{
        [numArray addObject:[NSString stringWithFormat:@"%@",self.maxDataPoint]];
        [numArray addObject:[NSString stringWithFormat:@"%@",self.minDataPoint]];
        //不显示正常值线
        //        for(NSArray *normalArray in normalValuesArray){
        //            [numArray addObjectsFromArray:normalArray];
        //        }
    }
    for(NSString *value in numArray){
        //从右到左到上
        int y = rect.size.height - (self.edgeInsets.bottom + drawingHeight*(([value floatValue] - min) / (max - min)));//根据比例确定y的值
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[CommonImage colorWithHexString:@"e5e5e5"] setStroke];
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, 0, y-0.5);
        CGFloat maxRightX = rect.size.width-10;
        CGContextAddLineToPoint(context,maxRightX, y-0.5);
        CGContextStrokePath(context);
        
    }
    
    //分成5段
    CGFloat oneItemValue = (max-min)/1.0;
    //    20 40 60 80 100
    int i = 0;
    for( NSArray *normalArray in normalValuesArray){
        //依次取出正常值
        //        break;
        NSString *normalBigValueString = normalArray[0];
        NSString *normalSmallValueString = normalArray[1];
        CGFloat normalBigValue = [normalBigValueString floatValue];
        CGFloat normalSmallValue = [normalSmallValueString floatValue];
        CGFloat bigy = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*(((CGFloat)(normalBigValue - min)/oneItemValue)));//根据比例确定y的值
        CGFloat smally = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*(((CGFloat)(normalSmallValue - min)/oneItemValue)));//根据比例确定y的值
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        if(i == 0){
            //            [[UIColor blueColor] setStroke];
            [[UIColor clearColor] setFill];
        }else{
            //            [colorArray()[i-1] setFill];
            [[UIColor clearColor] setFill];
        }
        //        [[CommonImage colorWithHexString:@"3599d4" ] setFill];
        //        [[UIColor colorWithRed:53/255.0f green:153/255.0f blue:212/255.0f alpha:0.1 ] setFill];
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, 0, bigy);
        
        CGFloat maxRightX = rect.size.width-10;
        CGContextAddLineToPoint(context,maxRightX, bigy);
        CGContextAddLineToPoint(context, maxRightX, smally);
        CGContextAddLineToPoint(context, 0, smally);
        
        //        CGContextStrokePath(context);
        CGContextFillPath(context);
        i++;
        //        break;
    }
}

- (void)getVerticalLineView:(CGFloat) originX withColor:(NSString*)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);//保存一份状态
    
    float height = 0, y = 8;
//    NSString *color = @"ebebeb";
    if (self.isThin) {
        height = 10;
        y = 12;
//        color = @"dcdcdc";
//        color = @"cccccc";
    }
    [[CommonImage colorWithHexString:color] setStroke];
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, originX, self.size.height  - self.edgeInsets.bottom + height);
    //绘制8空5个如此循环
    CGFloat lengths[] = {2,1};
    //phase,为第一次绘制5-phase个点
    CGContextSetLineDash(context, 0, lengths, 2);//暂时屏蔽了
    CGFloat topY = self.edgeInsets.top;
    CGContextAddLineToPoint(context,originX, topY-y);
    
    CGContextStrokePath(context);
    
//    CGContextClosePath(context);
    
    CGContextRestoreGState(context);//恢复之前的

}


//画血糖整体趋势图
- (void)drawLineTrend:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    [[CommonImage colorWithHexString:@"fe6339"] setStroke];
    [[CommonImage colorWithHexString:@"fe6339"] setFill];
    // lines width
    CGContextSetLineWidth(context, 0.5);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    CGPoint graphPoints[count];//各个点的坐标
    CGPoint graphDrawPoints[count];//需要画的各个点的坐标
    CGFloat drawingWidth, drawingHeight, min, max;
    
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;//获得绘画的宽度
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    CGFloat width = 0.0;
    
    int drawIndex = 0;
    if (count > 1) {
        
        width = drawingWidth/(count -1);
        
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSString *)self.dataPoints[i]).floatValue;//取出数组中的值
            
            x = self.edgeInsets.left + (width)*i;//确定起始点x的值
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );//根据比例确定y的值
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
            if(dataPointValue != 0){
                graphDrawPoints[drawIndex] = CGPointMake(x, y);
                drawIndex++;
            }
            
            if(i == count-1){
                //最右点
                self.maxRightPoint = CGPointMake(x, y);
            }else if(i == 0){
                
                self.minLeftpoint = CGPointMake(x, y);
            }
        }
    } else if (count == 1) {//只有一个时放在中间
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (((NSString *)self.dataPoints[0]).floatValue - min) / (max - min) ) );//drawingHeight/2;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO//画线
    //CGContextAddLines(context, graphPoints, count);
    
    for(UIView *view in self.subviews){
        
        if([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    
    NSString *prevTitle = @"";
    // DISEGNO I CERCHI NEL GRANO//在画上点
    for (int i = 0; i < count; ++i) {
        
        //时间
        [[CommonImage colorWithHexString:@"666666"] setStroke];
        [[CommonImage colorWithHexString:@"666666"] setFill];
        NSString *time = self.timePointsString[i];
        
        
        CGFloat firstX = graphPoints[i].x - 6 ;
        if(graphPoints[i].x  > (self.edgeInsets.left + 25)){
            
            firstX = graphPoints[i].x -27;
        }
        
        if(i == 0){
            firstX  -= 22;
        }
        if(i == 0 && count == 1){
            firstX += 22;
        }
        int count = (int)self.timePointsString.count;
        
        
        //x为firstX y从0轴到最上面画线
        
        NSString *color = @"ebebeb";
        if (self.isThin) {
            color = @"cccccc";
            if ([time isEqualToString:prevTitle]) {
                color = @"ebebeb";
            }
            [[CommonImage colorWithHexString:@"333333"] setStroke];
            [[CommonImage colorWithHexString:@"333333"] setFill];
        }
        [self getVerticalLineView:graphPoints[i].x withColor:color];
        
        if (self.isThin){
            
            if (![time isEqualToString:prevTitle]) {
                [time drawInRect:CGRectMake(firstX+20,rect.size.height-30, 55, 30) withFont:[UIFont systemFontOfSize:13.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            }
            prevTitle = time;
//            [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            
        }
        else if(self.theTimeType == SevenDaysType){
            if(count <= 8){
                [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 40) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }else{
                int one = (8 + count - 1)/8;//七天情况下多个点分七份
                if( i%one == 0){
                    //个数小于等于7个时均显示
                    [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                    [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                }
            }
            
        }else if(self.theTimeType == ThirtyDaysType){
            
            //30天按照周分--7天一分隔，最后一个也显示
            //  if(i%7 == 0 || i == self.timePoints.count-1){
            int one = count/4;//30时均等为4份
            if(count <= 8 || i%one == 0){
                //个数小于等于7个时均显示
                [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 40) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                //画竖线
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                
            }
            
        }else if(self.theTimeType == NinetyDaysType){
            int one = count/3;//90时均等为3份
            if(count <= 8 || i%one == 0){
                [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 40) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }else if(self.theTimeType == OneDayType){
            int one = count/4;//90时均等为3份
            if(count <= 8 || i%one == 0 || (count == 24 && i == count-1)){
                [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 40) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                //画竖线
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                
            }
            
        }else if(self.theTimeType == ScaleType){
            
            if(width > 30){
                NSLog(@"----currentWidth:%f",width);
                [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 40) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                //画竖线
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }else{
                int one = count/4;//90时均等为3份
                if( i%one == 0 ){
                    [time drawInRect:CGRectMake(firstX,rect.size.height-38, 55, 40) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                }
            }
        }
        
        prevTitle = time;
        //小于七个画点，七天模式下也可能有多个测量点
        if(count <= 8 || self.theTimeType == OneDayType || self.theTimeType == ScaleType){
            //七天内可以显示-点上的圆点
            //CGRect ellipseRect = CGRectMake(graphPoints[i].x-2, graphPoints[i].y-2, 4, 4);
//            CGRect ellipseRect = CGRectMake(graphDrawPoints[i].x-2, graphDrawPoints[i].y-2, 4, 4);
//            CGContextAddEllipseInRect(context, ellipseRect);
//            CGContextSetLineWidth(context, 2);
//            [[CommonImage colorWithHexString:@"fe6339"] setStroke];
//            [[CommonImage colorWithHexString:@"fe6339"] setFill];
//            
//            
//            NSString *color = [self getPointColorWithValue:self.dataPoints[i]];
//            [[CommonImage colorWithHexString:color] setStroke];
//            [[CommonImage colorWithHexString:color] setFill];
//            
//            CGContextFillEllipseInRect(context, ellipseRect);
//            CGContextStrokeEllipseInRect(context, ellipseRect);
            
            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.backgroundColor = [UIColor clearColor];
//            btn.layer.cornerRadius = 4;
//            btn.tag = i;
//            [btn addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
//            btn.frame = CGRectMake(graphPoints[i].x-8, graphPoints[i].y-8, 16, 16);
//            [self addSubview:btn];
            
        }
        
    }
    
    //画线
    int drawCout = 0;
//    NSString *color = @"fe6339";
//    if (self.isThin) {
//        color = @"ff7a22";
//    }
    NSString *color = @"fe6339";
    if (self.isThin) {
        color = @"d1d1d1";
    }
    [[CommonImage colorWithHexString:color] setStroke];
    [[CommonImage colorWithHexString:color] setFill];
    for(int i = 0; i < count && self.timeType == SevenDaysType ;i++){
        
        CGFloat dataPointValue = ((NSString *)self.dataPoints[i]).floatValue;//取出数组中的值
        
        if(dataPointValue != 0){
            
            drawCout++;
        }else{
            continue;
        }
        
        if(drawCout == 1){
            
            CGContextMoveToPoint(context, graphPoints[i].x, graphPoints[i].y);
            
        }else{
            CGContextAddLineToPoint(context, graphPoints[i].x, graphPoints[i].y);
        }
    }
    
    CGContextStrokePath(context);
    
    //画点
    drawCout = 0;
    for(int i = 0; i < count;i++){
        
        CGFloat dataPointValue = ((NSString *)self.dataPoints[i]).floatValue;//取出数组中的值
        
        if (self.isThin) {
            if (dataPointValue<0.01) {
                
                return;
            }
        }
        
        
        if(dataPointValue != 0){
            
            drawCout++;
        }else{
            continue;
        }
        
        color = [self getPointColorWithValue:self.dataPoints[i]];
        if (self.isThin) {
            color = @"d1d1d1";
        }
        
        CGRect ellipseRect = CGRectMake(graphPoints[i].x-1.5, graphPoints[i].y-1.5, 3, 3);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 1.5);

        [[CommonImage colorWithHexString:color] setStroke];
        [[CommonImage colorWithHexString:color] setFill];
        
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
    }

}


- (void)drawLine1:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    [[CommonImage colorWithHexString:@"fe6339"] setStroke];
    [[CommonImage colorWithHexString:@"fe6339"] setFill];
    // lines width
    CGContextSetLineWidth(context, 0.5);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    CGPoint graphPoints[count];//各个点的坐标
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;//获得绘画的宽度
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    CGFloat width = 0.0;
    
    if (count > 1) {
        
        width = drawingWidth/(count -1);
        
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSString *)self.dataPoints[i]).floatValue;//取出数组中的值
            
            x = self.edgeInsets.left + (width)*i;//确定起始点x的值
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );//根据比例确定y的值
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
            
            NSLog(@"----index:%d,x:%f",i,x);
            
            if(i == count-1){
                //最右点
                self.maxRightPoint = CGPointMake(x, y);
            }else if(i == 0){
                
                self.minLeftpoint = CGPointMake(x, y);
            }
        }
    } else if (count == 1) {//只有一个时放在中间
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (((NSString *)self.dataPoints[0]).floatValue - min) / (max - min) ) );//drawingHeight/2;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO//画线
    CGContextAddLines(context, graphPoints, count);
    CGContextStrokePath(context);
    
    for(UIView *view in self.subviews){
        
        if([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    
    // DISEGNO I CERCHI NEL GRANO//在画上点
    for (int i = 0; i < count; ++i) {
        
        //        //小于七个画点，七天模式下也可能有多个测量点
        //        if(count <= 7 || self.theTimeType == OneDayType){
        //            //七天内可以显示-点上的圆点
        //            CGRect ellipseRect = CGRectMake(graphPoints[i].x-4, graphPoints[i].y-4, 8, 8);
        //
        //            CGContextAddEllipseInRect(context, ellipseRect);
        //            CGContextSetLineWidth(context, 2);
        //            //        [self.dataPointStrokeColor setStroke];
        //            //        [self.dataPointColor setFill];
        //
        //            [[CommonImage colorWithHexString:@"fe6339"] setStroke];
        //            [[CommonImage colorWithHexString:@"ffffff"] setFill];
        //            CGContextFillEllipseInRect(context, ellipseRect);
        //            CGContextStrokeEllipseInRect(context, ellipseRect);
        //        }
        //时间
        [[CommonImage colorWithHexString:@"666666"] setStroke];
        [[CommonImage colorWithHexString:@"666666"] setFill];
        NSString *time = self.timePointsString[i];
        
        
        CGFloat firstX = graphPoints[i].x - 6 ;
        if(graphPoints[i].x  > (self.edgeInsets.left + 25)){
            
            firstX = graphPoints[i].x -27;
        }
        
        if(i == 0){
            firstX  -= 22;
        }
        if(i == 0 && count == 1){
            firstX += 22;
        }
        int count = (int)self.timePointsString.count;
        
        
        if(self.theTimeType == SevenDaysType){
            if(count <= 7){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }else{
                int one = (7 + count - 1)/7;//七天情况下多个点分七份
                if( i%one == 0){
                    //个数小于等于7个时均显示
                    [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                    [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                }
            }
            
        }else if(self.theTimeType == ThirtyDaysType){
            
            //30天按照周分--7天一分隔，最后一个也显示
            //  if(i%7 == 0 || i == self.timePoints.count-1){
            int one = count/4;//30时均等为4份
            if(count <= 7 || i%one == 0){
                //个数小于等于7个时均显示
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                //画竖线
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                
            }
            
        }else if(self.theTimeType == NinetyDaysType){
            int one = count/3;//90时均等为3份
            if(count <= 7 || i%one == 0){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }else if(self.theTimeType == OneDayType){
            int one = count/4;//90时均等为3份
            if(count <= 7 || i%one == 0 || (count == 24 && i == count-1)){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                //画竖线
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                
            }
            
        }else if(self.theTimeType == ScaleType){
            
            if(width > 30){
                NSLog(@"----currentWidth:%f",width);
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                //画竖线
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }else{
                int one = count/4;//90时均等为3份
                if( i%one == 0 ){
                    [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                }
            }
        }
        
        //小于七个画点，七天模式下也可能有多个测量点
        if(count <= 7 || self.theTimeType == OneDayType || self.theTimeType == ScaleType){
            //七天内可以显示-点上的圆点
            CGRect ellipseRect = CGRectMake(graphPoints[i].x-2, graphPoints[i].y-2, 4, 4);
            
            CGContextAddEllipseInRect(context, ellipseRect);
            CGContextSetLineWidth(context, 2);
            [[CommonImage colorWithHexString:@"fe6339"] setStroke];
            [[CommonImage colorWithHexString:@"fe6339"] setFill];
            
            
            NSString *color = [self getPointColorWithValue:self.dataPoints[i]];
            [[CommonImage colorWithHexString:color] setStroke];
            [[CommonImage colorWithHexString:color] setFill];
            
            CGContextFillEllipseInRect(context, ellipseRect);
            CGContextStrokeEllipseInRect(context, ellipseRect);
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.cornerRadius = 4;
            btn.tag = i;
            [btn addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(graphPoints[i].x-8, graphPoints[i].y-8, 16, 16);
            [self addSubview:btn];
            
        }
        
    }
    
}

- (NSString *)getPointColorWithValue:(NSString *)value
{
    
    
    NSString *firstN = nil;
    NSString *secondN = nil;
    

    firstN = self.normalValueArray[0][0];
    secondN = self.normalValueArray[0][1];
    
 
    
    CGFloat max = firstN.floatValue;
    CGFloat min = secondN.floatValue;
    if(secondN.floatValue > max){
        
        max = secondN.floatValue;
        min = firstN.floatValue;
    }
    if(firstN.floatValue == secondN.floatValue){
        
        return @"a9ce06";
    }
    
    NSArray *colorArray = @[@"ff7a22",@"44b813",@"6c93ff"];
    
    if(value.floatValue > max){
        return colorArray[0];
    
    }else if( value.floatValue > min){
        return colorArray[1];
    }else{
        return colorArray[2];
    }
  
    return colorArray[0];
}


- (void)showSecDetailView:(UIButton *)btn
{
    int tag = (int)btn.tag;
    
    NSString *value = otherDataArray[tag];//取出数组中的值
    
    UILabel *detailView = (UILabel *)[triangleImgeView viewWithTag:299];
    detailView.text = value;
    
    CGPoint point = CGPointMake(btn.origin.x+8, btn.origin.y+8);
    UIImage *normalImage =[UIImage  imageNamed:@"common.bundle/diary/redbubble.png"];//非高亮

    triangleImgeView.transform = CGAffineTransformIdentity;
    triangleImgeView.alpha = 0.1f;
    triangleImgeView.frameX = point.x-normalImage.size.width/2.0f;
    triangleImgeView.frameY = point.y-normalImage.size.height;
//    triangleImgeView.frame = CGRectMake(point.x-normalImage.size.width/2.0f, point.y, normalImage.size.width, normalImage.size.height);
    triangleImgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        triangleImgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);;
        triangleImgeView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            triangleImgeView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
}

- (void)showDetailView:(UIButton *)btn
{
    int tag = (int)btn.tag;
    
    NSString *value = self.dataPoints[tag];//取出数组中的值
    
    UILabel *detailView = (UILabel *)[triangleImgeView viewWithTag:299];
    detailView.adjustsFontSizeToFitWidth = YES;
    detailView.text = value;
    
    CGPoint point = CGPointMake(btn.frame.origin.x+8, btn.frame.origin.y+8);
    UIImage *normalImage =[UIImage  imageNamed:@"common.bundle/diary/redbubble.png"];//非高亮

    triangleImgeView.alpha = 0.1f;
//    triangleImgeView.frame = CGRectMake(point.x-normalImage.size.width/2.0f, point.y, normalImage.size.width, normalImage.size.width);
    
    triangleImgeView.frameX = point.x-normalImage.size.width/2.0f;
    triangleImgeView.frameY = point.y-normalImage.size.height;
    NSLog(@"----%f,%f",point.x-normalImage.size.width/2.0f,triangleImgeView.frameX);
    CGRect origeleFrme = triangleImgeView.frame;
    
    CGPoint arrowPoint = [triangleImgeView convertPoint:point fromView:self];
    triangleImgeView.layer.anchorPoint = CGPointMake(arrowPoint.x / triangleImgeView.width, arrowPoint.y / triangleImgeView.height);
//    triangleImgeView.layer.anchorPoint = CGPointMake(0.5,1);
    triangleImgeView.frame = origeleFrme;

    triangleImgeView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        triangleImgeView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        triangleImgeView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            triangleImgeView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];

}

- (void)drawlineFrombottonToTopWithX:(CGFloat)fromx
{
    
    return;
    CGFloat drawingHeight = self.size.height - self.edgeInsets.bottom;//获得绘画的高度NEw
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetAllowsAntialiasing(context,NO);
    
    [[CommonImage colorWithHexString:@"e5e5e5"] setStroke];
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, fromx, drawingHeight-0.5);
    CGContextAddLineToPoint(context,fromx, self.edgeInsets.top);
    CGContextStrokePath(context);
}

- (void)drawLine2:(CGRect)rect
{
    
    //    self.dataPoints = @[@5, @12, @53, @122, @320, @230, @13, @24];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    self.linesColor = [UIColor redColor];
    [self.linesColor setStroke];
    // lines width
    CGContextSetLineWidth(context, 1);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints2.count;
    CGPoint graphPoints[count];
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSString *)self.dataPoints2[i]).floatValue;
            
            x = self.edgeInsets.left + (drawingWidth/(count-1))*i;
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = drawingHeight/2;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO
    CGContextAddLines(context, graphPoints, count);
    CGContextStrokePath(context);
    
    // DISEGNO I CERCHI NEL GRANO
    for (int i = 0; i < count; ++i) {
        CGRect ellipseRect = CGRectMake(graphPoints[i].x-3, graphPoints[i].y-3, 6, 6);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 2);
        [self.dataPointStrokeColor setStroke];
        [self.dataPointColor setFill];
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
    }
    
}

//描述各颜色曲线的意思
- (void)drawLineMeans:(CGRect)rect
{
    CGFloat offsetY = self.edgeInsets.top + 5;
    
    CGFloat span = 30;
    
    for (int i = 0; i < self.lineMeansArray.count; i++) {
        
        CGFloat y = offsetY + i*span;
        CGContextRef context = UIGraphicsGetCurrentContext();
        if(i == 0){
            //            [[UIColor blueColor] setStroke];
            [[CommonImage colorWithHexString:@"fe6339"] setStroke];
        }else{
            [colorArray()[i-1] setStroke];
        }
        if([self.lineMeansArray[i] isEqualToString:@"标准值"]){
            
            if(self.lineMeansArray.count > 2)
                
                [[UIColor greenColor] setStroke];
        }
        
        CGContextSetLineWidth(context, 1);
        CGContextMoveToPoint(context, rect.size.width-46, y);
        CGContextAddLineToPoint(context, rect.size.width-20, y);
        CGContextStrokePath(context);
        
        [[CommonImage colorWithHexString:@"333333"] setStroke];
        [[CommonImage colorWithHexString:@"333333"] setFill];
        NSString *floatyString = [NSString stringWithFormat:@"%@",self.lineMeansArray[i]];
        [floatyString drawInRect:CGRectMake(rect.size.width-20,y-8, 20, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        
    }
    
    
}


- (void)drawLineByTime:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    CGPoint graphPoints[count];//各个点的坐标
    
    CGPoint timePoints[count];//依次存放时间点数组
    
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;//获得绘画的宽度
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array3 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array4 = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            CGFloat timeX,timeY;
            dataPointValue = ((NSString *)self.dataPoints[i]).floatValue;//取出数组中的值
            
            timeX = self.edgeInsets.left + (drawingWidth/(count-1))*i;//确定起始点x的值
            timeY = 0;
            timePoints[i] = CGPointMake(timeX, timeY);
            
            if(self.multiOriginalLocalArray.count){
                x = self.edgeInsets.left + (drawingWidth/(count-1))*[self.multiOriginalLocalArray[i] integerValue];//确定起始点x的值
            }else{
                x = self.edgeInsets.left + (drawingWidth/(count-1))*i;//确定起始点x的值
                
            }
            
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );//根据比例确定y的值
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
            
            if(i < [self.multiDataArray[0] count]){
                [array1 addObject:NSStringFromCGPoint(graphPoints[i])];
            }else if(i < (([self.multiDataArray[0] count])+([self.multiDataArray[1] count]))){
                [array2 addObject:NSStringFromCGPoint(graphPoints[i])];
            }else if(i < (([self.multiDataArray[0] count])+([self.multiDataArray[1] count])+([self.multiDataArray[2] count]))){
                [array3 addObject:NSStringFromCGPoint(graphPoints[i])];
            }else if(i < (([self.multiDataArray[0] count])+([self.multiDataArray[1] count])+([self.multiDataArray[2] count])+([self.multiDataArray[3] count]))){
                [array4 addObject:NSStringFromCGPoint(graphPoints[i])];
            }
            
            if(i == count-1){
                //最右点
                self.maxRightPoint = CGPointMake(x, y);
            }else if(i == 0){
                
                self.minLeftpoint = CGPointMake(x, y);
            }
            
            
        }
    } else if (count == 1) {//只有一个时放在中间
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = drawingHeight/2;
        [array1 addObject:NSStringFromCGPoint(graphPoints[0])];
        timePoints[0] = CGPointMake(self.edgeInsets.left + graphPoints[0].x, 0);
    } else {
        return;
    }
    
    NSArray *allPonitsArray = [NSArray arrayWithObjects:array1,array2,array3,array4, nil];
    [array1 release];
    [array2 release];
    [array3 release];
    [array4 release];
    
    if(count >= 1){
        for (int i = 0; i < allPonitsArray.count; i++) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            // lines width
            CGContextSetLineWidth(context, 2);
            NSArray *array = allPonitsArray[i];
            CGPoint currentGraphPoints[array.count];//各个点的坐标
            int j = 0;
            for(NSString *point in array){
                currentGraphPoints[j] = CGPointFromString(point);
                j++;
            }
            //设置颜色
            if(i == 0){
                
                //             [[UIColor blueColor] setStroke];
                [[CommonImage colorWithHexString:@"fe6339"] setStroke];
                [[CommonImage colorWithHexString:@"ffffff"] setFill];
            }else{
                [colorArray()[i-1] setStroke];
                //                [colorArray()[i-1] setFill];
                [[CommonImage colorWithHexString:@"ffffff"] setFill];
            }
            CGContextAddLines(context, currentGraphPoints, array.count);
            CGContextStrokePath(context);
            
            //画点
            for(int m = 0;m < array.count; m++){
                if(array.count <= 7 ){
                    //只要个数小于7个就添加圆点
                    CGRect ellipseRect = CGRectMake(currentGraphPoints[m].x-4, currentGraphPoints[m].y-4, 8, 8);
                    CGContextAddEllipseInRect(context, ellipseRect);
                    CGContextSetLineWidth(context, 2);
                    //                [self.dataPointStrokeColor setStroke];
                    //                [self.dataPointColor setFill];
                    CGContextFillEllipseInRect(context, ellipseRect);
                    CGContextStrokeEllipseInRect(context, ellipseRect);
                }
            }
        }
    }else{
        // lines width
        CGContextSetLineWidth(context, 1);
        // STYLE
        // lines color
        [[UIColor blueColor] setStroke];
        
        // DISEGNO IL GRAFICO//画线
        CGContextAddLines(context, graphPoints, count);
        CGContextStrokePath(context);
    }
    
    // DISEGNO I CERCHI NEL GRANO//在画上点
    for (int i = 0; i < count; ++i) {
        //时间
        [[CommonImage colorWithHexString:@"333333"] setStroke];
        [[CommonImage colorWithHexString:@"333333"] setFill];
        NSString *time = self.timePointsString[i];
        
        
        
        CGFloat firstX =  timePoints[i].x-6;
        if(timePoints[i].x > (self.edgeInsets.left + 25)){
            firstX = timePoints[i].x -27;
        }
        if(i == 0){
            firstX  -= 22;
        }
        
        
        int count = (int)self.timePointsString.count;
        
        if(self.theTimeType == SevenDaysType){
            if(count <= 7){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }else{
                int one = (7 + count - 1)/7;//七天情况下多个点分七份
                if( i%one == 0){
                    //个数小于等于7个时均显示
                    [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                    [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                }
            }
        }else if(self.theTimeType == ThirtyDaysType){
            //30天按照周分--7天一分隔，最后一个也显示
            //  if(i%7 == 0 || i == self.timePoints.count-1){
            int one = count/4;//30时均等为4份
            if(count <= 7 || i%one == 0){
                //个数小于等于7个时均显示
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }else if(self.theTimeType == NinetyDaysType){
            int one = count/3;//90时均等为3份
            if(count <= 7 || i%one == 0){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }
    }
}

/**
 *  画动起来曲线
 *
 *  @param rect 
 */
- (void)drawStepLine:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    //    [[UIColor blueColor] setStroke];
    [[CommonImage colorWithHexString:@"ffedea" alpha:1] setStroke];
    [[CommonImage colorWithHexString:@"ffedea" alpha:1] setFill];
    // lines width
    CGContextSetLineWidth(context, 1);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    CGPoint graphPoints[count];//各个点的坐标
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;//获得绘画的宽度
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;//获得绘画的高度
    min = ((NSNumber *)[self minDataPoint]).floatValue;//取得最小值
    max = ((NSNumber *)[self maxDataPoint]).floatValue;//取得最大值
    
    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSString *)self.dataPoints[i]).floatValue;//取出数组中的值
            
            x = self.edgeInsets.left + (drawingWidth/(count-1))*i;//确定起始点x的值
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );//根据比例确定y的值
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
            if(i == count-1){
                //最右点
                self.maxRightPoint = CGPointMake(x, y);
            }else if(i == 0){
                
                self.minLeftpoint = CGPointMake(x, y);
            }
        }
    } else if (count == 1) {//只有一个时放在中间
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (((NSString *)self.dataPoints[0]).floatValue - min) / (max - min) ) );//drawingHeight/2;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO//画线
    CGContextMoveToPoint(context, graphPoints[0].x, rect.size.height - self.edgeInsets.bottom-2);
    //    CGContextAddLines(context, graphPoints, count);
    
    for(int i = 0; i < count; i++){
        CGContextAddLineToPoint(context, graphPoints[i].x, graphPoints[i].y);
    }
    
    CGContextAddLineToPoint(context, graphPoints[count-1].x, rect.size.height - self.edgeInsets.bottom-2);
    
    CGContextClosePath(context);
    
    
    //    CGContextStrokePath(context);
    //    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    //    CGContextDrawPath(context, kCGPathFill);
    
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    // STYLE
    // lines color
    // [[UIColor blueColor] setStroke];
    [[CommonImage colorWithHexString:@"ffa190" alpha:1] setStroke];
    [[CommonImage colorWithHexString:@"ffa190" alpha:1] setFill];
    // lines width
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, graphPoints[0].x, graphPoints[0].y);
    
    for(int i = 1; i < count; i++){
        CGContextAddLineToPoint(context, graphPoints[i].x, graphPoints[i].y);
    }
    
    CGContextStrokePath(context);
    
    
    
    
    
    // DISEGNO I CERCHI NEL GRANO//在画上点
    for (int i = 0; i < count; ++i) {
        
        //        //小于七个画点，七天模式下也可能有多个测量点
        //        if( count <= 7 || self.theTimeType == OneDayType){
        //
        //            //七天内可以显示-点上的圆点
        //            CGRect ellipseRect = CGRectMake(graphPoints[i].x-2, graphPoints[i].y-2, 4, 4);
        //
        //            CGContextAddEllipseInRect(context, ellipseRect);
        //            CGContextSetLineWidth(context, 1);
        //            //        [self.dataPointStrokeColor setStroke];
        //            //        [self.dataPointColor setFill];
        //
        //            [[CommonImage colorWithHexString:@"3599d4"] setStroke];
        //            [[CommonImage colorWithHexString:@"ffffff"] setFill];
        //            CGContextFillEllipseInRect(context, ellipseRect);
        //            CGContextStrokeEllipseInRect(context, ellipseRect);
        //        }
        //时间
        [[CommonImage colorWithHexString:@"666666"] setStroke];
        [[CommonImage colorWithHexString:@"666666"] setFill];
        NSString *time = self.timePointsString[i];
        
        
        CGFloat firstX = graphPoints[i].x - 6 ;
        if(graphPoints[i].x  > (self.edgeInsets.left + 25)){
            
            firstX = graphPoints[i].x -27;
        }
        
        if(i == 0){
            firstX  -= 22;
        }
        if(i == 0 && count == 1){
            firstX += 22;
        }
        int count = self.timePointsString.count;
        
        if(self.theTimeType == SevenDaysType){
            if(count <= 7){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }else{
                int one = (7 + count - 1)/7;//七天情况下多个点分七份
                if( i%one == 0){
                    //个数小于等于7个时均显示
                    [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                    [self drawlineFrombottonToTopWithX:graphPoints[i].x];
                }
            }
            
        }else if(self.theTimeType == ThirtyDaysType){
            //30天按照周分--7天一分隔，最后一个也显示
            //  if(i%7 == 0 || i == self.timePoints.count-1){
            int one = count/4;//30时均等为4份
            if(count <= 7 || i%one == 0){
                //个数小于等于7个时均显示
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }else if(self.theTimeType == NinetyDaysType){
            int one = count/3;//90时均等为3份
            if(count <= 7 || i%one == 0){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }else if(self.theTimeType == OneDayType){
            int one = count/4;//90时均等为3份
            //            if(count <= 7 || i%one == 0 || (count == 24 && i == count-1)){
            if(count <= 7 || i%one == 0){
                [time drawInRect:CGRectMake(firstX,rect.size.height-25, 55, 30) withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                [self drawlineFrombottonToTopWithX:graphPoints[i].x];
            }
            
        }
        
    }
    
    CGRect ellipseRect = CGRectMake(graphPoints[0].x-3, graphPoints[0].y-3, 6, 6);
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextSetLineWidth(context, 2);
    [[CommonImage colorWithHexString:@"fe6339" alpha:1] setStroke];
    [[CommonImage colorWithHexString:@"fe6339" alpha:1] setFill];
    CGContextFillEllipseInRect(context, ellipseRect);
    CGContextStrokeEllipseInRect(context, ellipseRect);
    
}

/**
 *  血糖趋势作图
 *
 *  @param rect
 */
- (void)drawNewSugarTrendView:(CGRect)rect
{
    [self drawCoordinate:rect withNormalValueArray:self.normalValueArray];

    if(self.timePointsString.count){
        NSString *firstDateString = self.timePointsString[0];
        if(![firstDateString isEqualToString:@""]){
             [self drawLineTrend:rect];
            }
        }
        
        //移除第一组数据后画其他折线
        
        NSMutableArray *multiDatasArray = nil;
        if(self.multiDataArray.count){
            multiDatasArray = [NSMutableArray arrayWithArray:self.multiDataArray];
            [multiDatasArray removeObjectAtIndex:0];
        }
    int i = 0;
        for(NSArray *lineDataArray in multiDatasArray){
            
            [self drawTrendLineRect:rect  withDataArray:lineDataArray Color:[CommonImage colorWithHexString:@"fe6339"]];
            i++;
        }
    
}

/**
 *  享瘦派
 *
 *  @param rect
 */
- (void)drawThinChatView:(CGRect)rect
{
    [self drawCoordinate:rect withNormalValueArray:self.normalValueArray];
    
    if(self.timePointsString.count){
        NSString *firstDateString = self.timePointsString[0];
        if(![firstDateString isEqualToString:@""]){
            [self drawLineTrend:rect];
        }
    }
    
    //移除第一组数据后画其他折线
    
    NSMutableArray *multiDatasArray = nil;
    if(self.multiDataArray.count){
        multiDatasArray = [NSMutableArray arrayWithArray:self.multiDataArray];
        [multiDatasArray removeObjectAtIndex:0];
    }
    int i = 0;
    NSString *color = @"fe6339";
    if (self.isThin) {
        color = @"d1d1d1";
    }
    for(NSArray *lineDataArray in multiDatasArray){
        [self drawTrendLineRect:rect  withDataArray:lineDataArray Color:[CommonImage colorWithHexString:color]];
        i++;
    }
    
    [[CommonImage colorWithHexString:@"cccccc"] setStroke];
    [[CommonImage colorWithHexString:@"cccccc"] setFill];
    [@"单位：kg" drawInRect:CGRectMake(CGRectGetWidth(rect)-100, 45, 80, 30) withFont:[UIFont fontWithName:@"Arial-BoldMT" size:11] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
}

- (void)drawRect:(CGRect)rect
{
    //血糖趋势作图
    if(self.isNewSugarTrend){
        
        _edgeInsets = UIEdgeInsetsMake(30, 20, 40,30);
        self.userInteractionEnabled = NO;
        [self drawNewSugarTrendView:rect];
        return;
    }
    
    if (self.isThin) {
        _edgeInsets = UIEdgeInsetsMake(30, 20, 50, 30);
        
        [self drawThinChatView:rect];
        return;
    }
    
    //画x轴线
    if(self.theTimeType == OneDayType){
        //计步曲线绘制
        [self drawStepCoordinate:rect withNormalValueArray:self.normalValueArray];
    }else{
        [self drawCoordinate:rect withNormalValueArray:self.normalValueArray];
    }
    

    if(self.timeFlag){
        //如果时间多，则依次取multiDataArray中的数据
        [self drawLineByTime:rect];
    }else{
        //取出第一组数据
        if(self.theTimeType == OneDayType){
            [self drawStepLine:rect];
        }else{
            if(self.timePointsString.count){
                NSString *firstDateString = self.timePointsString[0];
                if(![firstDateString isEqualToString:@""]){
                    [self drawLine1:rect];
                }
            }
        }
        
        //移除第一组数据后画其他折线
        
        NSMutableArray *multiDatasArray = nil;
        if(self.multiDataArray.count){
            multiDatasArray = [NSMutableArray arrayWithArray:self.multiDataArray];
            [multiDatasArray removeObjectAtIndex:0];
        }
        int i = 0;
        for(NSArray *lineDataArray in multiDatasArray){
            [self drawLineRect:rect  withDataArray:lineDataArray Color:colorArray()[i]];
            i++;
        }
    }
    
    //画线条说明
    //    [self drawLineMeans:rect];
    
}


/**
 *  画除第一组之后的各条曲线
 *
 *  @param rect      区域
 *  @param dataArray 数据
 *  @param drawColor 指定颜色
 */
- (void)drawTrendLineRect:(CGRect)rect withDataArray:(NSArray *)dataArray Color:(UIColor *)drawColor
{
    if(otherDataArray){
        [otherDataArray release];
        otherDataArray = nil;
    }
    
    otherDataArray = [dataArray copy];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    self.linesColor = drawColor;
    [self.linesColor setStroke];
    [self.linesColor setFill];
    // lines width
    CGContextSetLineWidth(context, 0.5);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = dataArray.count;//数据源个数
    CGPoint graphPoints[count];
    CGPoint graphDrawPoints[count];//需要画的各个点的坐标

    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    CGFloat width = 0.0;
    int drawIndex = 0;
    if (count > 1) {
        
        width = drawingWidth/(count -1);
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSString *)dataArray[i]).floatValue;//取出该数据源的数据
            
            x = self.edgeInsets.left + width*i;
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
            if(dataPointValue != 0){
                graphDrawPoints[drawIndex] = CGPointMake(x, y);
                drawIndex++;
            }
            NSLog(@"%f", y);
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (((NSString *)dataArray[0]).floatValue - min) / (max - min) ) );//drawingHeight/2;
        
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO
//    CGContextAddLines(context, graphPoints, count);
//    CGContextStrokePath(context);
    
    //画线
    int drawCout = 0;
    NSString *color = @"fe6339";
    if (self.isThin) {
        color = @"ff7a22";
    }
    [[CommonImage colorWithHexString:color] setStroke];
    [[CommonImage colorWithHexString:color] setFill];
    for(int i = 0; i < count && self.timeType == SevenDaysType;i++){
        
        CGFloat dataPointValue = ((NSString *)dataArray[i]).floatValue;//取出数组中的值
        
        if(dataPointValue != 0){
            
            drawCout++;
        }else{
            continue;
        }
        
        if(drawCout == 1){
            
            CGContextMoveToPoint(context, graphPoints[i].x, graphPoints[i].y);
            
        }else{
            CGContextAddLineToPoint(context, graphPoints[i].x, graphPoints[i].y);
        }
    }
    
    CGContextStrokePath(context);

    // DISEGNO I CERCHI NEL GRANO
    BOOL islast = NO;
    drawCout = 0;
    for (int i = 0; i < count; ++i) {
        if (self.isThin) {
            
//            CGFloat dataPointValue = ((NSString *)dataArray[i+1]).floatValue;//取出该数据源的数据
            if (!islast && (i == count-1 || ((NSString *)dataArray[i+1]).floatValue<0.01)) {
                islast = YES;
                
                CGRect ellipseRect = CGRectMake(graphPoints[i].x-2.5, graphPoints[i].y-2.5, 5, 5);
                CGContextAddEllipseInRect(context, ellipseRect);
                CGContextSetLineWidth(context, 2.5);
                
                //        ffc8a3
                [[CommonImage colorWithHexString:@"ffc8a3"] setStroke];
                [[CommonImage colorWithHexString:@"ffc8a3"] setFill];
                
                CGContextFillEllipseInRect(context, ellipseRect);
                CGContextStrokeEllipseInRect(context, ellipseRect);
                
                return;
            }
            
            CGRect ellipseRect = CGRectMake(graphPoints[i].x-1.5, graphPoints[i].y-1.5, 3, 3);
            CGContextAddEllipseInRect(context, ellipseRect);
            CGContextSetLineWidth(context, 1.5);
//            color = @"d1d1d1";
            [[CommonImage colorWithHexString:color] setStroke];
            [[CommonImage colorWithHexString:color] setFill];
            CGContextFillEllipseInRect(context, ellipseRect);
            CGContextStrokeEllipseInRect(context, ellipseRect);
        }
        else {
            
            if(count <= 8 || self.theTimeType == ScaleType){
                //七天内可以显示-点上的圆点
                
                CGFloat dataPointValue = ((NSString *)dataArray[i]).floatValue;//取出数组中的值
                
                if(dataPointValue != 0){
                    
                    drawCout++;
                }else{
                    continue;
                }
                
                CGRect ellipseRect = CGRectMake(graphPoints[i].x-1.5, graphPoints[i].y-1.5, 3, 3);
                CGContextAddEllipseInRect(context, ellipseRect);
                CGContextSetLineWidth(context, 1.5);
                NSString *color = [self getPointColorWithValue:dataArray[i]];
                [[CommonImage colorWithHexString:color] setStroke];
                [[CommonImage colorWithHexString:color] setFill];
                CGContextFillEllipseInRect(context, ellipseRect);
                CGContextStrokeEllipseInRect(context, ellipseRect);
                
                //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //            btn.backgroundColor = [UIColor clearColor];
                //            btn.layer.cornerRadius = 4;
                //            btn.tag = i;
                //            [btn addTarget:self action:@selector(showSecDetailView:) forControlEvents:UIControlEventTouchUpInside];
                //            btn.frame = CGRectMake(graphPoints[i].x-8, graphPoints[i].y-8, 16, 16);
                //            [self addSubview:btn];
            }
        }
    }
}


- (void)drawLineRect:(CGRect)rect withDataArray:(NSArray *)dataArray Color:(UIColor *)drawColor
{
    if(otherDataArray){
        [otherDataArray release];
        otherDataArray = nil;
    }
    
    otherDataArray = [dataArray copy];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    self.linesColor = drawColor;
    [self.linesColor setStroke];
    [self.linesColor setFill];
    // lines width
    CGContextSetLineWidth(context, 1);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = dataArray.count;//数据源个数
    CGPoint graphPoints[count];
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    CGFloat width = 0.0;
    
    if (count > 1) {
        
        width = drawingWidth/(count -1);
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSString *)dataArray[i]).floatValue;//取出该数据源的数据
            
            x = self.edgeInsets.left + width*i;
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (((NSString *)dataArray[0]).floatValue - min) / (max - min) ) );//drawingHeight/2;
        
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO
    CGContextAddLines(context, graphPoints, count);
    CGContextStrokePath(context);
    
    // DISEGNO I CERCHI NEL GRANO
    for (int i = 0; i < count; ++i) {
        
        if(count <= 7 || self.theTimeType == ScaleType){
            //七天内可以显示-点上的圆点
            CGRect ellipseRect = CGRectMake(graphPoints[i].x-2, graphPoints[i].y-2, 4, 4);
            CGContextAddEllipseInRect(context, ellipseRect);
            CGContextSetLineWidth(context, 2);
            //        [self.dataPointStrokeColor setStroke];
            //        [self.dataPointColor setFill];
            //            [[UIColor whiteColor]setFill];
            CGContextFillEllipseInRect(context, ellipseRect);
            CGContextStrokeEllipseInRect(context, ellipseRect);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.cornerRadius = 4;
            btn.tag = i;
            [btn addTarget:self action:@selector(showSecDetailView:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(graphPoints[i].x-8, graphPoints[i].y-8, 16, 16);
            [self addSubview:btn];
            
        }
    }
}


#pragma mark - Custom setters

- (void)changeFrameWidthTo:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    if(self.delegate){
        [self.delegate reportNewFrameWithWidth:width];
    }
    
}

- (void)setDataPointsXoffset:(CGFloat)dataPointsXoffset {
    _dataPointsXoffset = dataPointsXoffset;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            //            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)setAutoresizeToFitData:(BOOL)autoresizeToFitData {
    _autoresizeToFitData = autoresizeToFitData;
    
    CGFloat widthToFitData = [self widhtToFitData];
    if (widthToFitData > self.frame.size.width) {
        //        [self changeFrameWidthTo:widthToFitData];
    }
}

- (void)setDataPoints:(NSArray *)dataPoints {

    if(_dataPoints != dataPoints){
        
        [_dataPoints release];
        _dataPoints = [dataPoints retain];
    }
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            //            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //    detailView.alpha = 0.f;
    
    //    detailView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//    
//        triangleImgeView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//        triangleImgeView.alpha = 0.f;
//    } completion:nil];
    
}

-(void)tipTriangleImgeView:(id)sender
{
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        triangleImgeView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        triangleImgeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        triangleImgeView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }];
}

@end