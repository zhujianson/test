//
//  FDCaptionGraphView.m
//  SampleProj
//
//  Created by wangmin on 14-4-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FDGraphScrollView.h"
#import "VerticalLineView.h"

@implementation FDGraphScrollView


- (void)dealloc
{
    
    self.graphView = nil; 
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
        NSLog(@"frame:%@",NSStringFromCGRect(frame));
        CGRect graphViewFrame = frame;
        graphViewFrame.origin.x = 0;
        graphViewFrame.origin.y = 0;
        
        self.graphView = [[FDGraphView alloc] initWithFrame:graphViewFrame];
        _graphView.autoresizeToFitData = YES;
        _graphView.delegate = self;

        self.backgroundColor = self.graphView.backgroundColor;
        self.graphView.backgroundColor = [UIColor clearColor];
        [self addSubview:_graphView];
        [self.graphView release];
    }
    return self;
}

- (CGSize)contentSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, self.frame.size.height);
}

- (void)setDataPoints:(NSArray *)dataPoints dataPoints2:(NSArray *)dataPoint2 timeArray:(NSArray *)timeArray {
    self.graphView.dataPoints = dataPoints;
    self.graphView.dataPoints2 = dataPoint2;
    self.graphView.timePointsString = timeArray;
    
//    self.contentSize = [self contentSizeWithWidth:self.graphView.frame.size.width+30];
    
}

- (void)setLineDataArray:(NSArray *)multiDataArray andTimeArray:(NSArray *)timeArray normalValueArray:(NSArray *)normalValuesArray lineMeansArray:(NSArray *)lineMeansArray aboutMultiLocaInOriginalArray:(NSArray *)multiLocalArray
{

    self.graphView.maxDataPoint = self.maxDataPoint;//最大值
    self.graphView.minDataPoint = self.minDataPoint;//最小值
    if(timeArray.count != [multiDataArray[0] count]){
        //按照时间排序
        self.graphView.timeFlag = YES;
        NSMutableArray *allDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSArray *array in multiDataArray){
            [allDataArray addObjectsFromArray:array];
        }
        
        NSMutableArray *originLocationArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSArray *array in multiLocalArray){
            [originLocationArray addObjectsFromArray:array];
        }
        self.graphView.dataPoints = allDataArray;
        [allDataArray release];
        self.graphView.multiOriginalLocalArray = originLocationArray;
        [originLocationArray release];

        
    }else{
        self.graphView.timeFlag = NO;
        self.graphView.dataPoints = [multiDataArray objectAtIndex:0];//画第一条
        
    }
    self.graphView.theTimeType = self.currentTimeType;
    self.graphView.timeType = self.currentTimeType;
    self.graphView.isYClipTo5 = self.isYClipTo5;
    self.graphView.isNewSugarTrend = _isNewSugarTrend;
    self.graphView.isThin = _isThin;
    self.graphView.multiDataArray = [NSMutableArray arrayWithArray:multiDataArray];//折线数据源
    self.graphView.timePointsString = [NSMutableArray arrayWithArray:timeArray];//时间轴数据源
    self.graphView.normalValueArray = normalValuesArray;//正常值数组
    self.graphView.lineMeansArray = lineMeansArray;//颜色说明
    
//    self.contentSize = [self contentSizeWithWidth:self.graphView.frame.size.width+30];

}

- (void)reportNewFrameWithWidth:(CGFloat)width
{
    NSLog(@"----width%f",width);
    self.contentSize = [self contentSizeWithWidth:width];
}




@end