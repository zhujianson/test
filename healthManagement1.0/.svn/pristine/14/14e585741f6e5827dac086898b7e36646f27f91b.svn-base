

#import "ScrollSwitchView.h"
#import "ScrollSwitchCell.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kDefaultCellLabelFontSize = 25.0f;
CGFloat const kDefaultCellLabelMaxZoomValue = 18.0f;


@interface ScrollSwitchView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *m_tableView;
    NSIndexPath *m_currentIndex;
}

@end


@implementation ScrollSwitchView
@synthesize m_array;

- (void)setCellLabelFontSize:(CGFloat)size
{
    _cellLabelFontSize = size;
    [m_tableView reloadData];
}

- (void)setCurrentRow:(NSInteger)row animated:(BOOL)animated
{
    m_currentIndex = [NSIndexPath indexPathForRow:row inSection:0];

    [m_tableView scrollToRowAtIndexPath:m_currentIndex
                       atScrollPosition:UITableViewScrollPositionMiddle
                               animated:animated];
    [self scrollViewDidFinishScrolling:m_tableView];
}

- (void)setCurrentIndex:(NSIndexPath *)currentIndex
{
    m_currentIndex = currentIndex;
    NSLog(@"%d", (int)currentIndex.row);
    
    UITableViewCell *cell = [m_tableView cellForRowAtIndexPath:currentIndex];
    
    CGFloat contentOffset = cell.center.y - (m_tableView.frame.size.height/2);
    
    [m_tableView setContentOffset:CGPointMake(m_tableView.contentOffset.x, contentOffset) animated:YES];
}

- (void)setCurrentRow:(NSInteger)currentDay
{
    [self setCurrentRow:currentDay animated:NO];
}

- (id)initWithFrame:(CGRect)frame withCell:(CGSize)size withArray:(NSArray*)array withType:(enum_showType)type
{
    if (self = [super initWithFrame:frame])
    {
        _cellLabelZoomScale = kDefaultCellLabelMaxZoomValue;
        _cellLabelFontSize = kDefaultCellLabelFontSize;
        _showType = type;
        
        m_array = [array retain];
        
        _CellSize = size;
        
        float widht = 58, height = 42;
        if (_showType == horizontal) {
            widht = 42;
            height = 60;
        }
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widht, height)];
        view1.layer.cornerRadius = 4;
        view1.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
        view1.layer.borderWidth = 0.5;
        view1.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        view1.backgroundColor = [UIColor whiteColor];
        [self addSubview:view1];
        [view1 release];

        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
//        m_tableView.layer.backgroundColor = [CommonImage colorWithHexString:@"c6c6c6"].CGColor;
//        m_tableView.layer.borderWidth = 1;
        m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        m_tableView.backgroundView = view;
        [view release];
        m_tableView.backgroundColor = [UIColor clearColor];
        m_tableView.showsVerticalScrollIndicator = NO;
        m_tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        float y = (CGRectGetHeight(frame)-size.height)/2;
        m_tableView.contentInset = UIEdgeInsetsMake(y, 0, y, 0);
        
        [self addSubview:m_tableView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [m_tableView addGestureRecognizer:tapGesture];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, m_tableView.height)];
        line.backgroundColor = [CommonImage colorWithHexString:@"c6c6c6"];
        [self addSubview:line];
        [line release];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(m_tableView.width-1, 0, 1, m_tableView.height)];
        line.backgroundColor = [CommonImage colorWithHexString:@"c6c6c6"];
        [self addSubview:line];
        [line release];
    }
    return self;
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [tapGesture locationInView:tapGesture.view];
        NSIndexPath *indexPath = [m_tableView indexPathForRowAtPoint:location];
        
        if (indexPath.row != m_currentIndex.row) {
            
            if ([self.delegate respondsToSelector:@selector(scrollSwitchView:willSelectValue:)])
                [self.delegate scrollSwitchView:self willSelectValue:m_array[m_currentIndex.row]];
            
            m_currentIndex = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
            [self setCurrentIndex:indexPath];
        }
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGPoint centerTableViewPoint = [self convertPoint:CGPointMake(self.CellSize.width/2.0, self.frame.size.height/2.0) toView:m_tableView];
    
    float y = self.frame.size.height/2.0;
    if (_showType == horizontal) {
        y = self.frame.size.width/2.0;
    }
    CGPoint centerTableViewPoint = [self convertPoint:CGPointMake(self.CellSize.width/2.0, y) toView:m_tableView];
    
    for (ScrollSwitchCell *cell in m_tableView.visibleCells) {
        
        CGFloat distance = cell.center.y - centerTableViewPoint.y;
        
        // Zoom step using cosinus
        CGFloat zoomStep = cosf(M_PI_2*distance/self.CellSize.height);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (distance < self.CellSize.height/2 && distance > -self.CellSize.height/2)
        {
            [dic setObject:@(self.cellLabelFontSize + self.cellLabelZoomScale * zoomStep) forKey:@"size"];
            [dic setObject:_selCellColor forKey:@"color"];
        }
        else
        {
            [dic setObject:@(self.cellLabelFontSize) forKey:@"size"];
            [dic setObject:_noSelCellColor forKey:@"color"];
        }
        [cell setColorFont:dic];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidFinishScrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) {
        [self scrollViewDidFinishScrolling:scrollView];
    }
}

- (void)scrollViewDidFinishScrolling:(UIScrollView*)scrollView
{
    float y = self.frame.size.height/2.0;
    if (_showType == horizontal) {
        y = self.frame.size.width/2.0;
    }
    CGPoint point = [self convertPoint:CGPointMake(self.CellSize.width/2.0, y) toView:m_tableView];
//    CGPoint point = [self convertPoint:CGPointMake(self.CellSize.width/2.0, self.frame.size.height/2.0) toView:m_tableView];
    
    NSIndexPath* centerIndexPath = [m_tableView indexPathForRowAtPoint:CGPointMake(0, point.y)];
    
    if (centerIndexPath.row != m_currentIndex.row)
    {
        self.currentIndex = centerIndexPath;
        if ([self.delegate respondsToSelector:@selector(scrollSwitchView:willSelectValue:)])
            [self.delegate scrollSwitchView:self willSelectValue:m_array[m_currentIndex.row]];
    }
    else
    {
        UITableViewCell *cell = [m_tableView cellForRowAtIndexPath:m_currentIndex];
        
        CGFloat contentOffset = cell.center.y - (m_tableView.frame.size.height/2);
        
        [m_tableView setContentOffset:CGPointMake(m_tableView.contentOffset.x, contentOffset) animated:YES];
    }
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.CellSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"MZDayPickerCell";
    
    ScrollSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[ScrollSwitchCell alloc] initWithSize:self.CellSize reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.userInteractionEnabled = NO;
        
        if (_showType == horizontal) {
            cell.m_labTitle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
        }
    }
    
    [cell setTitleValue:[m_array objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)dealloc
{
    [m_tableView release];
    [m_array release];
    
    [super dealloc];
}

@end

