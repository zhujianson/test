//
//  HealthWeekCycleViewController.m
//  jiuhaoHealth2.0
//
//  Created by yangshuo on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "SoundListViewController.h"
#import "SSCheckBoxView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define  VIEWFRONTSIZE 16
#define  VIEWCONTENTFRONTSIZE 14
#define  CELLHEIGHT 44

@interface SoundListCell : UITableViewCell
@property(nonatomic,strong) UILabel *leftLabel;
@property(nonatomic,strong)  SSCheckBoxView *checkBox;
@end

@implementation SoundListCell
@synthesize leftLabel,checkBox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftLabel = [Common createLabel:CGRectMake(10, 8, 150, 30) TextColor:@"333333" Font:[UIFont systemFontOfSize:VIEWFRONTSIZE] textAlignment:NSTextAlignmentLeft labTitle:NSLocalizedString(@"周期",nil)];
        [self.contentView addSubview:leftLabel];
        
        checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(kDeviceWidth-40, 7, 30, 30) style:kSSCheckBoxViewStyleDark checked:YES];
        [checkBox setUpCheckImage: @"common.bundle/diary/selected_on.png" andWithNormalImage:@"common.bundle/diary/selected_off.png"];
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



@interface SoundListViewController ()<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>

@end

@implementation SoundListViewController
{
    UITableView *m_tablview;
    NSArray *m_leftData;
    SoundListViewControllerBlock _inBlock;
    NSMutableDictionary *m_dict;
    BOOL deflautState;
    AVAudioPlayer *musicPlayer;
    NSString *musicFileName;
}


- (id)initWithUpdateTitle:(NSString *)soundTile
{
    self = [super init];
    if (self)
    {
        // Custom initialization
//  不是更新为默认
//        deflautState = !update;
        if (!soundTile.length)
        {
            soundTile = @"声音1";
        }
//        m_leftData = [[NSArray alloc] initWithObjects:
//                      NSLocalizedString(@"声音1",nil),
//                      NSLocalizedString(@"声音2",nil),
//                      NSLocalizedString(@"声音3",nil),
//                      NSLocalizedString(@"声音4",nil),
//                      NSLocalizedString(@"声音5",nil),
//                      NSLocalizedString(@"声音6",nil),
//                      NSLocalizedString(@"声音7",nil), nil];
        
        m_leftData = [[NSArray alloc] initWithObjects:
                      NSLocalizedString(@"声音1",nil),
                      NSLocalizedString(@"声音2",nil),
                      NSLocalizedString(@"声音3",nil),
                      NSLocalizedString(@"声音4",nil),
                      nil];
        
        m_dict = [[NSMutableDictionary alloc] init];
        for (NSString * str in m_leftData)
        {
            NSNumber *num = [NSNumber numberWithInt:NO];
//            if (deflautState && [str isEqualToString:NSLocalizedString(@"声音1",nil)])
            if ([str isEqualToString:NSLocalizedString(soundTile,nil)])
            {
                num = [NSNumber numberWithInt:YES];
            }
            [m_dict setObject:num forKey:str];
        }
        
    }
    return self;
}


-(void)setSoundListViewControllerBlock:(SoundListViewControllerBlock)_handler
{
    _inBlock = [_handler copy];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self stopMusic];
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"提醒音",nil);
    self.view.backgroundColor = [CommonImage  colorWithHexString:ANSWERBACKBACKCOLOR];
    [self createContentView];
//    [self createSaveBtn];
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
    NSString *returnString = [self changeContentWithDictionary];
    _inBlock(returnString);
    [self.navigationController popViewControllerAnimated:YES];
}

//改为每天
-(NSString *)changeContentWithDictionary
{
    for (NSString  *str in m_dict.allKeys)
    {
        NSNumber *num = m_dict[str];
        if (num.boolValue)
        {
            return  str;
        }
    }
    return @"声音1";
}

-(void)createContentView
{
    m_tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kDeviceWidth, CELLHEIGHT*m_leftData.count) style:UITableViewStylePlain];
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
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    SoundListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[[SoundListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] autorelease];
    }
    cell.leftLabel.text = [m_leftData objectAtIndex:indexPath.row];
    cell.checkBox.checked = [[m_dict objectForKey:[m_leftData objectAtIndex:indexPath.row]] boolValue];
    [cell.checkBox  setStateChangedBlock:^(SSCheckBoxView *che) {
        che.checked = !che.checked;
        NSString  *weekName = [m_leftData objectAtIndex:indexPath.row];
        [m_dict setValue:[NSNumber numberWithBool:che.checked] forKey:weekName];
        
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_leftData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self initMusicPlayerWithIndex:((int)indexPath.row+1)];
    if (musicPlayer)
    {
        [musicPlayer play];
    }
    
    BOOL checkBoxState = ((SoundListCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked;
    if (checkBoxState)
    {
        return;
    }
    checkBoxState = !checkBoxState;
    for (NSString *key in m_leftData)
    {
        [m_dict setObject:@0 forKey:key];
    }
    ((SoundListCell *)[tableView cellForRowAtIndexPath:indexPath]).checkBox.checked = checkBoxState;
    NSString  *weekName = [m_leftData objectAtIndex:indexPath.row];
    [m_dict setValue:[NSNumber numberWithBool:checkBoxState] forKey:weekName];
    [m_tablview reloadData];
}

- (void)dealloc
{
   	if (musicPlayer) {
		[musicPlayer release];
	}
    [m_tablview release];
    [super dealloc];
}

#pragma mark 铃声
- (void)initMusicPlayerWithIndex:(int)index
{
	if (musicPlayer) {
		[musicPlayer release];
	}
    //	int length = [musicLabel.text length];
    //	musicFileName = [musicLabel.text substringToIndex:(length - 4)];
    //  musicFileType = [musicLabel.text substringFromIndex:(length - 3)];
//	musicFileName = musicLabel.text;
//    NSString * musicFileType = @"caf";
    NSString *musicName = [NSString stringWithFormat:@"alert%d.caf",index];
	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	[audioSession setActive:YES error:nil];
    
    NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
    NSString *bundlePath =[mainBundlPath stringByAppendingPathComponent:@"common.bundle/mp3"];
    NSString *filePath = [bundlePath stringByAppendingPathComponent:musicName];
    NSURL* fileURL =  [NSURL fileURLWithPath:filePath];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:musicName ofType:musicFileType];
    if (fileURL == nil)
    {
        return;
    }
    @try {
        musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        musicPlayer.delegate = self;
        musicPlayer.numberOfLoops = 0;
        //	volumnSlider.value = 0.5;
        //	processSlider.value = 0.0;
        //	musicPlayer.volume = volumnSlider.value;
        [musicPlayer prepareToPlay];
        musicPlayer.meteringEnabled = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"无视频文件");
    }
    @finally {
        
    }
}

- (void)stopMusic {
    if (musicPlayer) {
		[musicPlayer stop];
	}
}

@end
