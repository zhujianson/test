//
//  HealthWeekCycleViewController.m
//  jiuhaoHealth2.0
//
//  Created by yangshuo on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "HealthWeekCycleViewController.h"
#import "SSCheckBoxView.h"

#define  VIEWFRONTSIZE 16
#define  VIEWCONTENTFRONTSIZE 14
#define  CELLHEIGHT 44

@interface HealthWeekCycleCell : UITableViewCell
@property(nonatomic,strong) UILabel *leftLabel;
@property(nonatomic,strong)  SSCheckBoxView *checkBox;
@end

@implementation HealthWeekCycleCell
@synthesize leftLabel,checkBox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftLabel = [Common createLabel:CGRectMake(10, 8, 150, 30) TextColor:@"333333" Font:[UIFont systemFontOfSize:VIEWFRONTSIZE] textAlignment:NSTextAlignmentLeft labTitle:NSLocalizedString(@"周期",nil)];
        [self.contentView addSubview:leftLabel];
        
        checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(kDeviceWidth-40, 7, 30, 30) style:kSSCheckBoxViewStyleDark checked:YES];
        [self.contentView addSubview:checkBox];
    }
    return self;
}
- (void)dealloc
{
//    [leftLabel release];
    [checkBox release];
    [super dealloc];
}
@end



@interface HealthWeekCycleViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HealthWeekCycleViewController
{
    UITableView *m_tablview;
    NSArray *m_leftData;
    HealthWeekCycleViewControllerBlock _inBlock;
    NSMutableDictionary *m_dict;
//    BOOL deflautState;
}

- (id)initWithUpdate:(BOOL)update withContentString:(NSString *)contentWeek
{
    self = [super init];
    if (self)
    {
        // Custom initialization
//        deflautState = YES;
        
         m_leftData = [[NSArray alloc] initWithObjects:
                       NSLocalizedString(@"周一",nil),
                       NSLocalizedString(@"周二",nil),
                       NSLocalizedString(@"周三",nil),
                       NSLocalizedString(@"周四",nil),
                       NSLocalizedString(@"周五",nil),
                       NSLocalizedString(@"周六",nil),
                       NSLocalizedString(@"周日",nil), nil];
        m_dict = [[NSMutableDictionary alloc] init];
        
        NSArray *delfaultWeekArray = nil;
        NSString *defaultWeek = @"";
        if (update)
        {
//            deflautState = NO;
        }
        
        if ([contentWeek containsString:@"每天"])
        {
            delfaultWeekArray = m_leftData;
        }
        else if (contentWeek.length >0)
        {
            delfaultWeekArray = [contentWeek componentsSeparatedByString:@"  "];
        }
        else
        {
             defaultWeek = @"周一";
//            deflautState = NO;
        }
        for (int i = 0; i < m_leftData.count ; i++)
        {
           NSString *str = m_leftData[i];
             NSNumber *num = [NSNumber numberWithInt:NO];
            if ([str isEqualToString:NSLocalizedString(defaultWeek,nil)] || [delfaultWeekArray containsObject:str])
            {
                num = [NSNumber numberWithInt:YES];
            }
            [m_dict setObject:num forKey:str];
        }
//        [self createSaveBtn];
    }
    return self;
}

-(void)setHealthWeekCycleViewControllerBlock:(HealthWeekCycleViewControllerBlock)_handler
{
    _inBlock = [_handler copy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"周期设置",nil);
    self.view.backgroundColor = [CommonImage  colorWithHexString:ANSWERBACKBACKCOLOR];
    [self createContentView];
    // Do any additional setup after loading the view.
}

- (void)createSaveBtn
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 31, 44);
    [but addTarget:self action:@selector(butEventSave) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"common.bundle/nav/data_save.png"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"common.bundle/nav/data_save_p.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithCustomView:but];
    self.navigationItem.rightBarButtonItem = saveBar;
    [saveBar release];
}

-(void)butEventSave
{
    [self changeContentWithDictionary];
      _inBlock(m_dict);
    [self.navigationController popViewControllerAnimated:YES];
}

//改为每天
-(void)changeContentWithDictionary
{
    for (NSNumber *num in m_dict.allValues)
    {
        if (!num.boolValue)
        {
            return;
        }
    }
    [m_dict removeAllObjects];
    [m_dict setObject:[NSNumber numberWithBool:YES] forKey:NSLocalizedString(@"每天",nil)];
}
-(void)createContentView
{
    m_tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kDeviceWidth, CELLHEIGHT*7) style:UITableViewStylePlain];
    m_tablview.bounces = NO;
    m_tablview.delegate = self;
    m_tablview.dataSource = self;
    if ([m_tablview respondsToSelector:@selector(setSeparatorInset:)])
    {
        [m_tablview setSeparatorInset:UIEdgeInsetsZero];
    }
    m_tablview.rowHeight = CELLHEIGHT;
    [self.view addSubview:m_tablview];
    
    UIButton * btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(20, m_tablview.bottom+20, kDeviceWidth-40, 44);
    [btnSave setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:18];
    btnSave.layer.cornerRadius = 4;
    btnSave.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [btnSave setBackgroundImage:image forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(butEventSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    HealthWeekCycleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[[HealthWeekCycleCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] autorelease];
    }
    cell.leftLabel.text = [m_leftData objectAtIndex:indexPath.row];
    cell.checkBox.checked = [[m_dict objectForKey:[m_leftData objectAtIndex:indexPath.row]] boolValue];
    [cell.checkBox  setStateChangedBlock:^(SSCheckBoxView *che) {
        che.checked = !che.checked;
        NSString  *weekName = [m_leftData objectAtIndex:indexPath.row];
        [m_dict setValue:[NSNumber numberWithBool:che.checked] forKey:weekName];

    }];
//    默认选为星期一
//    if (deflautState && indexPath.row == 0)
//    {
//        cell.checkBox.checked = YES;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_leftData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d  %d",(int)indexPath.row ,((HealthWeekCycleCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked);
    BOOL checkBoxState = ((HealthWeekCycleCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked;
    checkBoxState = !checkBoxState;
    ((HealthWeekCycleCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked = checkBoxState;
    NSString  *weekName = [m_leftData objectAtIndex:indexPath.row];
    [m_dict setValue:[NSNumber numberWithBool:checkBoxState] forKey:weekName];
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
- (void)dealloc
{
    [m_tablview release];
    [super dealloc];
    
}
@end
