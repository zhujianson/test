//
//  SOSDetailViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SOSDetailViewController.h"
#import "AppDelegate.h"
#import "SOSTableViewCell.h"

@interface SOSDetailViewController ()<UITableViewDataSource,
                                      UITableViewDelegate>

@end

@implementation SOSDetailViewController

- (void)dealloc {
  self.dataArray = nil;
  self.titleName = nil;
  [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.title = @"头痛";
    self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    //        NSDictionary *methodDic = @{@"title":
    //        @"急救方法",@"content":@"1.下肢受伤者帮助其平躺。\n2.在伤腿两侧用足够的垫料或衣物夹紧以防止活动，尽快叫救护车。"};
    //        NSDictionary *decideDic = @{@"title":
    //        @"更多",@"content":@"1.大腿骨折\n大腿骨折(单纯骨折)固选用三合板、五合板或木板两块，从伤者患侧腋下至足的外侧长度者一块，从大腿根内侧至脚的内侧长度者一块，并将两块夹板用棉衣或布片包裹紧贴皮肤的一面，用绳索、布带将两块分别固定在伤肢内外两侧，再加两块木板分别放在伤肢的前后面也可。\n2.小腿骨折\n取等长的两块木板，内侧一块应从大腿根部至足内侧，另一块应包括大小腿等长的一块，同样用棉花、布条包裹，然后用绷带、绳索、布条固定。无木板时可临时将健下肢当木板与伤下肢捆在一起达到固定的目的。\n3.固定注意事项\n固定应包括上下两关节，以达到制动的目的。有骨突起部分应用棉花、软布垫起，不要使木板与骨突出部直接接触，防止压迫成伤。闭合性骨折有畸形时，应将其拉直，同时固定。\n开放性骨折时只用净水冲洗伤口，不要把外露骨头复位，只止血包扎固定即可。固定肢体的指(趾)头应暴露在外，以便观察血液循环情况。固定后如伤者肢体出现剧痛、麻木、发白、紫色时应速松绳索，再行适度固定。"};
    //        [self.dataArray addObject:methodDic];
    //        [self.dataArray addObject:decideDic];

//      UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(goToShare) withNormalImge:@"common.bundle/nav/top_share_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_share_icon_pre.png"];
//      self.navigationItem.rightBarButtonItem = rightButtonItem;
  }
  return self;
}

/**
 *  分享功能
 */
- (void)goToShare:(id)sender {
//    UIImage *screenShotImage = [Common  screenshotWithView:self.view];
//    AppDelegate *myDelegate = [Common getAppDelegate];
//    [myDelegate noneUIShareAllButtonClickHandler:self.view Content:@"来自康迅的分享@康迅360" ImagePath:screenShotImage];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  UITableView *allTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT - 44)
              style:UITableViewStyleGrouped];
  allTableView.delegate = self;
  allTableView.dataSource = self;
  allTableView.backgroundColor = [UIColor clearColor];
    allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    allTableView.backgroundView = view;
    [view release];

  [self.view addSubview:allTableView];
  [allTableView release];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 10;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  if (section == self.dataArray.count - 1) {
    return 10;
  } else {
    return .1f;
  }
}

//- (UIView *)tableView:(UITableView *)tableView
//viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
//    kDeviceWidth, 10)];
//    view.backgroundColor = [UIColor clearColor];
//    return [view autorelease];
//
//}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *oneDic = self.dataArray[indexPath.section];
  NSString *contentString = oneDic[@"content"];
  CGFloat contentHeight =
      [Common heightForString:contentString
                        Width:kDeviceWidth - 30 - 2 * 11
                         Font:[UIFont systemFontOfSize:15.0f]].height + 3;

  return contentHeight + 60 + 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *detailCell = @"sosDetailCell";

  SOSTableViewCell *sosCell =
      [tableView dequeueReusableCellWithIdentifier:detailCell];
  if (!sosCell) {
    sosCell =
        [[[SOSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:detailCell] autorelease];
    sosCell.selectionStyle = UITableViewCellSelectionStyleNone;
    sosCell.backgroundColor = [UIColor clearColor];
    UIView *tempView = [[[UIView alloc] init] autorelease];
    sosCell.backgroundView = tempView;
    sosCell.contentView.backgroundColor = [UIColor clearColor];
  }

  [sosCell setDetaiDic:self.dataArray[indexPath.section]];

  return sosCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
