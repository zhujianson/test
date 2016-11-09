//
//  MyPageViewController.m
//  jiuhaohealth4.5
//
//  Created by xuguohong on 16/7/1.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "MyPageViewController.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setNumberOfPages:(int)numberOfPages
{
    int width = 15, height = 3.5, sp = 3;
    int awidth = numberOfPages * width + (numberOfPages-1)*sp;
    
    UIView *page;
    for (int i = 0; i < MAX(numberOfPages, _numberOfPages); i++) {
        if (i >= _numberOfPages) {
            page = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            page.tag = PageViewTag+i;
            page.layer.borderWidth = 0.5;
            page.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
            [self addSubview:page];
//            [page release];
        }
        else {
            page = [self viewWithTag:PageViewTag+i];
            
            if (i >= numberOfPages) {
                [page removeFromSuperview];
                continue;
            }
        }
        
//        page.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        if (i == _currentPage) {
            page.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
            page.layer.borderWidth = 0;
        }
        page.left = (self.width-awidth)/2.f + i*(width+sp);
    }
    
    _numberOfPages = numberOfPages;
}

- (void)setCurrentPage:(int)currentPage
{
    UIView *view = [self viewWithTag:PageViewTag+_currentPage];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderWidth = 0.5;
    
    view = [self viewWithTag:PageViewTag+currentPage];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    view.layer.borderWidth = 0;
    
    _currentPage = currentPage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
