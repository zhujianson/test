//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "DropDownMenu.h"
#import "QuartzCore/QuartzCore.h"
#import "DefauleViewController.h"
#import "AppDelegate.h"

@interface DropDownMenu ()
{
	UITableView *table;
	NSArray *m_array;
	
    UIView *m_superView;
    UIView *m_backView;
    UIView *m_view;
    UIImageView *m_triangleImgeView;
    
    int m_selInt;
}
@end

@implementation DropDownMenu

- (void)dealloc
{
    [m_backView release];
    [m_view release];
    [m_triangleImgeView release];
    [table release];
    [m_array release];
    
    [super dealloc];
}

- (id)initWithView:(UIView*)view withWidth:(float)width withArray:(NSArray*)array superView:(UIView*)superView
{
    self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    if (self)
    {
        m_selInt = -1;
        m_array = [array retain];
        m_superView = superView;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDown)];
//        [self addGestureRecognizer:tap];
//        [tap release];
        
        CGRect rect;
        if (![view isKindOfClass:[UIBarButtonItem class]]) {
            
            rect = [view convertRect:view.bounds toView:nil];
        }
        else {
            rect = CGRectMake(kDeviceWidth-40, 0, 30, 40);
        }
        float x = rect.origin.x + rect.size.width/2.f;
        
        m_backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        m_backView.backgroundColor = [UIColor blackColor];
        m_backView.alpha = 0.f;
        [self addSubview:m_backView];
        
        //背景
        m_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        m_view.backgroundColor = [UIColor clearColor];
        [self addSubview:m_view];
        
        //剪头
        UIImage *normalImage = [self createHeaderViewWithBackColor:[UIColor whiteColor]];//非高亮
        UIImage *hilightImage = [self createHeaderViewWithBackColor:[CommonImage colorWithHexString:@"ebebeb"]];//高亮
        m_triangleImgeView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:hilightImage];
        m_triangleImgeView.frameX = x;
        [m_view addSubview:m_triangleImgeView];
        
        float itemWidth = kDeviceWidth/3.f;
        
        DefauleViewController *myDefautVC = (DefauleViewController *)(APP_DELEGATE2.window.rootViewController);
        CommonNavViewController *nav = ((CommonNavViewController *)myDefautVC.m_selectedViewController);
        float y = ((DefauleViewController*)nav.m_DefalutViewCon).customBarView.hidden ? 0 : 49;
        float tableHeight = MIN(array.count * 45, m_superView.height-y - m_triangleImgeView.bottom - 10);
        
        //内容
        int tableX = (int)(x/itemWidth) * itemWidth;
        tableX = tableX > itemWidth ? tableX + itemWidth-width-8 : tableX+8;
        table = [[UITableView alloc]initWithFrame:CGRectMake(tableX, m_triangleImgeView.bottom, width, tableHeight) style:UITableViewStylePlain];
        table.backgroundColor = [UIColor whiteColor];
        table.delegate = self;
        table.dataSource = self;
        table.bounces = NO;
        table.layer.cornerRadius = 2.5f;
        table.rowHeight = 45;
        table.showsVerticalScrollIndicator = NO;
        table.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
            [table setSeparatorInset:UIEdgeInsetsZero];//ios7
        }
        table.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        table.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        table.layer.shadowOpacity = 0.75;//阴影透明度，默认0
        table.layer.shadowRadius = 3;//阴影半径，默认3
        table.layer.masksToBounds = YES;//tableview 默认是开启的
        table.layer.cornerRadius = 2.5;
        table.clipsToBounds = YES;
        [m_view addSubview:table];
        
        [self bringSubviewToFront:m_triangleImgeView];
    }
    return self;
}

- (UIImage *)createHeaderViewWithBackColor:(UIColor *)backColor
{
    if (!backColor)
    {
        backColor = [UIColor whiteColor];
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, 12.0f, 6.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [backColor CGColor]);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0,(rect.size.height-6)/2.0 +6.0);
    CGContextAddLineToPoint(context, rect.size.width,(rect.size.height-6)/2.0+6.0);
    CGContextAddLineToPoint(context, rect.size.width/2.0, (rect.size.height-6)/2.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)showDropDown
{
    [m_superView addSubview:self];
    [self release];
    
    m_view.frameY = -m_view.height;
    [UIView animateWithDuration:0.3 animations:^{
        m_backView.alpha = 0.6;
//        m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        m_view.frameY = 0;
    } completion:^(BOOL finished){
    }];
}

- (void)hideDropDown
{
    if (self.selBlock) {
        self.selBlock(m_selInt);
    }
	[UIView animateWithDuration:0.3 animations:^{
        m_backView.alpha = 0;
        m_view.frameY  = -m_view.height;
    } completion:^(BOOL finished){
		[self removeFromSuperview];
	}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideDropDown];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_array count];
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DropDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.m_dict = [m_array objectAtIndex:indexPath.row];
//    cell.textLabel.text = [m_array objectAtIndex:indexPath.row];
//    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_selInt = (int)indexPath.row;
    m_triangleImgeView.highlighted = !indexPath.row;
    [self hideDropDown];
}

@end
