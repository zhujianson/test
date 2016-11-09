//
//  DisclaimerViewController.m
//  jiuhaoHealth2.0.1
//
//  Created by wangmin on 14-6-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()
<UIWebViewDelegate>

@end

@implementation DisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"用户须知", nil);
        self.log_pageID = 44;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *name = @"userKnow";
    NSString *filePath = [[NSBundle mainBundle]pathForResource:name ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    [self.m_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
