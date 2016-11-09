//
//  FoodMatchViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FoodMatchViewController.h"
#import "FoodMatchTableViewCell.h"
#import "FoodMatchListViewController.h"
#import "DBOperate.h"
#import "FristRunFMViewController.h"

@implementation FoodMatch

+ (CommonViewController*)initGet
{
    id is = [[NSUserDefaults standardUserDefaults] objectForKey:@"FristFoodMatch"];
    if (!is) {
        FristRunFMViewController *frist = [[[FristRunFMViewController alloc] init]autorelease];
        return frist;
    }
    else {
        FoodMatchViewController *match = [[[FoodMatchViewController alloc] init]autorelease];
        return match;
    }
}

@end


@implementation FoodMatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"健康配餐";
//        UIBarButtonItem *right = [self createRightNavBut:@"我" setImage:@"image"];
        UIBarButtonItem *right = [Common CreateNavBarButton:self setEvent:@selector(butEventSelFamily) setImage:@"common.bundle/common/" setTitle:nil];
        self.navigationItem.rightBarButtonItem = right;
        
    }
    return self;
}

- (void)butEventSelFamily
{
    
}

- (UIBarButtonItem*)createRightNavBut:(NSString*)title setImage:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"" forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    float textWidth = [but.titleLabel.text sizeWithFont:but.titleLabel.font].width;
    float imageWidth = image.size.width;
    [but setTitleEdgeInsets:UIEdgeInsetsMake(0, -textWidth, 0, 0)];
    [but setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imageWidth)];
    
    UIBarButtonItem *bar = [[[UIBarButtonItem alloc] initWithCustomView:but]autorelease];
    
    return bar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_nowPage = 0;
    
    m_familyArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicp;
    for (int i = 0; i < 5; i++) {
        dicp = [NSMutableDictionary dictionaryWithDictionary:@{@"name":[NSString stringWithFormat:@"家人%d",i], @"height":[NSNumber numberWithFloat:175], @"weight":[NSNumber numberWithFloat:75]}];
        [m_familyArray addObject:dicp];
    }
    m_nowSelFamily = [m_familyArray objectAtIndex:0];
    
    NSMutableDictionary *dddd = [self jisuanValue:m_nowSelFamily];
    
    [m_nowSelFamily setObject:[dddd objectForKey:@"array"] forKey:@"array"];
    [m_nowSelFamily setObject:[dddd objectForKey:@"standardWeight"] forKey:@"standardWeight"];
    
    UIScrollView *foodType = [self createFoodType:[dddd objectForKey:@"array"]];
    [self.view addSubview:foodType];
    [foodType release];
    
    NSArray *array1 = [NSArray arrayWithObjects:@"低脂奶类", @"蔬菜", @"水果", @"豆鱼肉蛋类", @"谷物", nil];
    m_array = [[NSMutableArray alloc] init];
    NSDictionary *dic;
    for (int i = 0; i < array1.count; i++) {
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":array1[i], @"icon":[NSString stringWithFormat:@"common.bundle/common/head_%d.png",i]}];
        [m_array addObject:dic];
    }
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, foodType.bottom, kDeviceWidth, kDeviceHeight- foodType.bottom)];
    m_tableView.rowHeight = 85;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.separatorColor =  [UIColor clearColor];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    
    m_butJisuan = [[UIButton alloc] initWithFrame:CGRectMake(10, kDeviceHeight - 60, 300, 40)];
    UIImage *image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [m_butJisuan setBackgroundImage:image forState:UIControlStateNormal];
    [m_butJisuan setTitle:@"科学健康计算" forState:UIControlStateNormal];
    [m_butJisuan addTarget:self action:@selector(butEventJisuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_butJisuan];
    
//    [NSThread detachNewThreadSelector:@selector(searchDBList) toTarget:self withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (m_indexPath) {
        
        [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:m_indexPath] withRowAnimation:UITableViewRowAnimationNone];
        m_indexPath = nil;
    }
    [super viewWillAppear:animated];
}


/**
 *  计算卡路里值
 *
 *  @param dic 家人
 *
 *  @return 卡路里值
 */
- (NSMutableDictionary*)jisuanValue:(NSDictionary*)dic
{
    //标准体重（kg）=身高（cm）-105
    float standardWeight = [[dic objectForKey:@"height"] floatValue] - 105;
    
    //计算自己目前体重状况
    float nowWeightState = ([[dic objectForKey:@"weight"] floatValue] - standardWeight)/standardWeight;
    
    //判定自己的体型
    NSString *strBodily;
    int type = 0;
    if (nowWeightState >= 0.4) {
        strBodily = @"重度肥胖";
        type = 1;
    }
    else if (nowWeightState >= 0.2)
    {
        strBodily = @"肥胖";
        type = 1;
    }
    else if (nowWeightState >= 0.1)
    {
        strBodily = @"超重";
        type = 1;
    }
    else if (nowWeightState >= -.1)
    {
        strBodily = @"正常";
        type = 2;
    }
    else if (nowWeightState >= -.2)
    {
        strBodily = @"偏瘦";
        type = 3;
    }
    else if (nowWeightState < -.2)
    {
        strBodily = @"消瘦";
        type = 3;
    }
    
    //每日每公斤体重不同劳动强度热能需要量(千卡)
    float everydayKa = 0;
    switch ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"FristFoodMatch"] objectForKey:@"laodongli"] intValue]) {
        case 0:
            //重度体力劳动，：消瘦为45千卡，正常40千卡，肥胖35千卡产。
            switch (type) {
                case 1:
                    everydayKa = 35;
                    break;
                case 2:
                    everydayKa = 40;
                    break;
                case 3:
                    everydayKa = 45;
                    break;
            }
            break;
        case 1:
            //中等体力劳动：消瘦为40千卡，正常35千卡，肥胖30千卡。
            switch (type) {
                case 1:
                    everydayKa = 30;
                    break;
                case 2:
                    everydayKa = 35;
                    break;
                case 3:
                    everydayKa = 40;
                    break;
            }
            break;
        case 2:
            //劳动强度为轻体力劳动：消瘦 35千卡，正常30千卡，肥胖为25千卡。
            switch (type) {
                case 1:
                    everydayKa = 25;
                    break;
                case 2:
                    everydayKa = 30;
                    break;
                case 3:
                    everydayKa = 35;
                    break;
            }
            break;
        case 3:
            //劳动强度为卧床：消瘦25千卡，正常20千卡，肥胖15千卡。
            switch (type) {
                case 1:
                    everydayKa = 15;
                    break;
                case 2:
                    everydayKa = 20;
                    break;
                case 3:
                    everydayKa = 25;
                    break;
            }
            break;
    }
    
    //最后就可以计算出糖尿病所需每日总热量了。
    //每日所需要总热量（千卡产）f=每日每公斤体重所需热量（千卡）×标准体重（公斤）。
    float everyday = everydayKa * standardWeight;
    //早餐需要总热量（千卡产）=每日每公斤体重所需热量（千卡）×标准体重（公斤）×30%
    float zaocan = everyday*0.3;
    //午餐需要总热量（千卡产）=每日每公斤体重所需热量（千卡）×标准体重（公斤）×40%
    float wucan = everyday*0.4;
    //晚餐需要总热量（千卡产）=每日每公斤体重所需热量（千卡）×标准体重（公斤）×30%
    float wancan = everyday*0.3;
    //日蛋白质总量=f×20%/4 （早餐×30%）
    float protein = everyday*0.2/4;
    float zaocanProtein = protein*.3;
    float wucancanProtein = protein*.4;
    float wancancanProtein = protein*.3;
    //日碳水化合物总量=f×65%/4  （早餐×30%）
    float carbohydrate = everyday*0.65/4;
    float zaocancarbohydrate = carbohydrate*.3;
    float wucancarbohydrate = carbohydrate*.4;
    float wancancarbohydrate = carbohydrate*.3;
    //日脂肪总量=f×15%/9  （早餐×30%）
    float fat = everyday*0.15/9;
    float zaocanfat = fat*.3;
    float wucanfat = fat*.4;
    float wancanfat = fat*.3;
    
    NSArray *arary1 = [NSArray arrayWithObjects:@{@"title":@"脂肪", @"value":[NSNumber numberWithFloat:zaocanfat]}, @{@"title":@"碳水化合物", @"value":[NSNumber numberWithFloat:zaocancarbohydrate]}, @{@"title":@"蛋白质", @"value":[NSNumber numberWithFloat:zaocanProtein]}, nil];
    
    NSArray *arary2 = [NSArray arrayWithObjects:@{@"title":@"脂肪", @"value":[NSNumber numberWithFloat:wucanfat]}, @{@"title":@"碳水化合物", @"value":[NSNumber numberWithFloat:wucancarbohydrate]}, @{@"title":@"蛋白质", @"value":[NSNumber numberWithFloat:wucancanProtein]}, nil];
    
    NSArray *arary3 = [NSArray arrayWithObjects:@{@"title":@"脂肪", @"value":[NSNumber numberWithFloat:wancanfat]}, @{@"title":@"碳水化合物", @"value":[NSNumber numberWithFloat:wancancarbohydrate]}, @{@"title":@"蛋白质", @"value":[NSNumber numberWithFloat:wancancanProtein]}, nil];
    
//    NSDictionary *dic1 = @{@"title":@"早餐", @"reliang":[NSNumber numberWithFloat:zaocan], @"Protein":[NSNumber numberWithFloat:zaocanProtein], @"carbohydrate":[NSNumber numberWithFloat:zaocancarbohydrate], @"fat":[NSNumber numberWithFloat:zaocanfat]};
    NSDictionary *dic1 = @{@"title":@"早餐", @"reliang":[NSNumber numberWithFloat:zaocan], @"array":arary1};
    
    NSDictionary *dic2 = @{@"title":@"午餐", @"reliang":[NSNumber numberWithFloat:wucan], @"array":arary2};
    
    NSDictionary *dic3 = @{@"title":@"晚餐", @"reliang":[NSNumber numberWithFloat:wancan], @"array":arary3};
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithFloat:standardWeight] forKey:@"standardWeight"];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, nil];
    [dict setObject:array forKey:@"array"];
    
    return dict;
}

- (void)searchDBList
{
//    m_array = [[DBOperate shareInstance] getFoodGroup:m_nowPage];
    m_array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic;
    for (int i = 0; i < 50; i++) {
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"食物1", @"icon":@"common.bundle/common/center_my-family_head_icon.png"}];
        [m_array addObject:dic];
    }
    [m_tableView reloadData];
}

- (void)jisuanResult:(NSDictionary*)dic
{
    int standardWeight = [[m_nowSelFamily objectForKey:@"standardWeight"] floatValue];
    int weight = [[m_nowSelFamily objectForKey:@"weight"] floatValue];
//    低脂奶类 总量 g1=标准体重/实际体重×100g
    float milk = standardWeight/weight*100;
    //    蔬菜 总量 g2=标准体重/实际体重×400g
    float greens = standardWeight/weight*400;
    //    水果 总量 g3=标准体重/实际体重×300g
    float fruit = standardWeight/weight*300;
    //    豆鱼肉蛋类 g4=总量 标准体重/实际体重×300g
    float meat = standardWeight/weight*300;
    //    谷物 g5=总量 标准体重/实际体重×400g
    float grain = standardWeight/weight*400;
//    低脂奶类  a=g1×a(蛋白质)/ a{(蛋白质)+ b(蛋白质)+ c(蛋白质) +d(蛋白质) + e(蛋白质)}
//    蔬菜 a=g2×a(碳水化合物)/a {碳水化合物)+ b(碳水化合物)+ c(碳水化合物) +d(碳水化合物) + e(碳水化合物)}
//    水果 a=g3×a(碳水化合物)/ a{碳水化合物)+ b(碳水化合物)+ c(碳水化合物) +d(碳水化合物) + e(碳水化合物)}
//    豆鱼肉蛋类 a=g4×a(蛋白质+脂肪)/ a{蛋白质+脂肪)+ b(蛋白质+脂肪)+ c(蛋白质+脂肪) +d(蛋白质+脂肪) + e(蛋白质+脂肪)}
//    谷物 a=g5×a(蛋白质+碳水化合物)/ a{蛋白质+碳水化合物)+ b(蛋白质+碳水化合物)+ c(蛋白质+碳水化合物) +d(蛋白质+碳水化合物) + e(蛋白质+碳水化合物)}
}

- (void)butEventJisuan
{
    
}

- (UIScrollView*)createFoodType:(NSArray*)array
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 124)];
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    
    UIView *view;
    CGRect rect;
    for (int i = 0; i < array.count; i++) {
        view = [self createViewItem:[array objectAtIndex:i]];
        view.tag = 500+i;
        rect = view.frame;
        rect.origin.x += i * kDeviceWidth;
        view.frame = rect;
        
        [scroll addSubview:view];
        [view release];
    }
    
    scroll.contentSize = CGSizeMake(kDeviceWidth*3, 124);
    
    m_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((320-138)/2, 124, 138, 20)];
    m_pageControl.numberOfPages = 3;
    m_pageControl.enabled = NO;
    m_pageControl.currentPage = 0;
    [self.view addSubview:m_pageControl];
    
    return scroll;
}

- (UIView*)createViewItem:(NSDictionary*)dic
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 124)];
    
    //标题
    NSString *str = [NSString stringWithFormat:@"%@           千卡", [dic objectForKey:@"title"]];
//    NSMutableAttributedString *attritute = [self replaceRedColorWithNSString:str andUseKeyWord:[NSString stringWithFormat:@"%@", [dic objectForKey:@"reliang"]] andWithFontSize:18];
    UILabel *labTitle = [Common createLabel:CGRectMake(10, 10, 300, 30) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:str];
//    labTitle.attributedText = attritute;
    [view addSubview:labTitle];
    
    UILabel *labValue = [Common createLabel:CGRectMake(10, 10, 300, 30) TextColor:@"d05151" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"reliang"]]];
    labValue.tag = 100;
    [view addSubview:labValue];
    
    UIImageView *imageXian = [[UIImageView alloc] initWithFrame:CGRectMake(0, labTitle.bottom+10, kDeviceWidth, 2)];
    [view addSubview:imageXian];
    [imageXian release];

    UIView *viewItem;
    CGRect rect;
    NSArray *array = [dic objectForKey:@"array"];
    for (int i = 0; i < 3; i++) {
        viewItem = [self createViewItemValue:[array objectAtIndex:i]];
        rect = viewItem.frame;
        rect.origin.x = 20 + i * 100;
        viewItem.frame = rect;
        [view addSubview:viewItem];
        [viewItem release];
    }
    
    return view;
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString*)str andUseKeyWord:(NSString*)keyWord andWithFontSize:(float)s
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"d05151"], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

- (UIView*)createViewItemValue:(NSDictionary*)dic
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 87, 40)];
    
    //标题
    UILabel *labTitle = [Common createLabel:CGRectMake(0, 0, 87, 20) TextColor:@"" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:[dic objectForKey:@"title"]];
    [view addSubview:labTitle];
    
    //
    UILabel *labValue = [Common createLabel:CGRectMake(0, 20, 87, 20) TextColor:@"ff0000" Font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentCenter labTitle:[NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"value"] floatValue]]];
    labValue.tag = 101;
    labValue.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    labValue.layer.cornerRadius = 4;
    labValue.clipsToBounds = YES;
    [view addSubview:labValue];
    
    return view;
}

//填充数据
- (void)setViewItemValue:(NSArray*)array
{
    UIView *view;
    UILabel *labValue;
    NSDictionary *dic, *dic2;
    NSArray *sarray;
    for (int i = 0; i < array.count; i++) {
        dic = [array objectAtIndex:i];
        
        view = [self.view viewWithTag:500+i];
        labValue = (UILabel*)[view viewWithTag:100];
        labValue.text = [dic objectForKey:@"reliang"];
        
        sarray = [dic objectForKey:@"array"];
        for (int j = 0; j < sarray.count; j++) {
            dic2 = [array objectAtIndex:i];
            
            labValue = (UILabel*)[view viewWithTag:101];
            labValue.text = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"value"] floatValue]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:m_tableView]) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        m_pageControl.currentPage = page;
    }
}

#pragma mark - tableViewDataDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [m_array objectAtIndex:indexPath.row];
    float height = [[dic objectForKey:@"height"] floatValue];
    height = MAX(height += 50, 85);//加上上下的边格
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FoodMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[FoodMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = [m_array objectAtIndex:indexPath.row];
    [cell setM_dicInfo:dic];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_indexPath = indexPath;
    
    FoodMatchListViewController *list = [[FoodMatchListViewController alloc] init];
    [list setM_dicInfo:[m_array objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:list animated:YES];
    [list release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_tableView release];
    [m_array release];
    [m_butJisuan release];
    
    [super dealloc];
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

