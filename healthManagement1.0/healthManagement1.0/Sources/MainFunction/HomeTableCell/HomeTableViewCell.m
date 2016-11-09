//
//  HomeTableViewCell.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/1.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
{
    UILabel * titleLab;
    UILabel * readingLab;
    UIImageView * pickerImage;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLab = [Common createLabel:CGRectMake(15, 15, kDeviceWidth-90-30 - 10, 0) TextColor:@"000000" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:nil];
        titleLab.numberOfLines = 2;
        [self.contentView addSubview:titleLab];
        
        UIImage * image = [UIImage imageNamed:@"common.bundle/home/see.png"];

        UIImageView * see = [[UIImageView alloc]initWithFrame:CGRectMake(titleLab.left, 130/2-2, image.size.width, 24)];
        see.image = image;
        see.contentMode = UIViewContentModeCenter;

        [self.contentView addSubview:see];
        
        readingLab = [Common createLabel:CGRectMake(15+20, 130/2, 200, 20) TextColor:@"b8b8b8" Font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:readingLab];
        
        pickerImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-15-90, 15+2.5, 90, 60)];
        [self.contentView addSubview:pickerImage];
        
    }
    return self;
    
}

- (void)setInformationWithDic:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
    titleLab.text = dic[@"postName"];
    CGSize size = [Common sizeForAllString:titleLab.text andFont:17 andWight:titleLab.width];
    titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:size.height];
    [CommonImage setImageFromServer:dic[@"img"] View:pickerImage Type:2];
    
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dic[@"viewCount"]]];
//    UIImage *tuImage = [UIImage imageNamed:@"common.bundle/home/see_img.png"];
//    NSTextAttachment *tu = [[NSTextAttachment alloc] init];
//    tu.image = tuImage;
//    tu.bounds = CGRectMake(0, -2, tuImage.size.width, tuImage.size.height);
//    NSAttributedString *tuAttrStr = [NSAttributedString attributedStringWithAttachment:tu];
//    [titleString insertAttributedString:tuAttrStr atIndex:0];
    
    readingLab.text = [NSString stringWithFormat:@"%@",dic[@"viewCount"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end






@implementation SoundTableViewCell
{
    UILabel * titleLab;
    UILabel * nameLab;
    UILabel * dataLab;
    UILabel * readingLab;

    UIButton * soundBtn;
    UIImageView * headerImage;
    
    UILabel * soungType;
    UIView * lineView;
    NSURL * soundUrl;
//    NSMutableDictionary * m_dic;
    UIView * m_allView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLab = [Common createLabel:CGRectMake(15, 20, kDeviceWidth-30, 0) TextColor:@"000000" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:nil];
        titleLab.numberOfLines = 0;
        [self.contentView addSubview:titleLab];

        m_allView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-85, kDeviceWidth, 85)];
        [self addSubview:m_allView];
        m_allView.backgroundColor = [UIColor clearColor];
        
        nameLab = [Common createLabel:CGRectMake(titleLab.left, 0, 100, 25) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [m_allView addSubview:nameLab];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, nameLab.top+13/2, 1, 12)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"dcdcdc"];
        [m_allView addSubview:lineView];
        
        dataLab = [Common createLabel:CGRectMake(nameLab.right, nameLab.top, 200, 25) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [m_allView addSubview:dataLab];

        headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, m_allView.height-35-20, 35, 35)];
        headerImage.layer.cornerRadius = headerImage.width/2;
        headerImage.clipsToBounds = YES;
//        headerImage.backgroundColor = [UIColor redColor];
        [m_allView addSubview:headerImage];
        
        UIImage * i = [UIImage imageNamed:@"common.bundle/home/sound.png"];
        
        soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        soundBtn.tag = 10;
        soundBtn.frame = CGRectMake(headerImage.right+10, headerImage.top, i.size.width, headerImage.height);
        [soundBtn setBackgroundImage:i forState:UIControlStateNormal];
        [soundBtn addTarget:self action:@selector(sound:) forControlEvents:UIControlEventTouchUpInside];
        [m_allView addSubview:soundBtn];
        
        self.imagePlayView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 30, soundBtn.height)];
        self.imagePlayView.image = [UIImage imageNamed:@"common.bundle/home/audioPlay/04.png"];
        NSArray *array = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"common.bundle/home/audioPlay/02.png"], [UIImage imageNamed:@"common.bundle/home/audioPlay/03.png"], [UIImage imageNamed:@"common.bundle/home/audioPlay/04.png"], nil];
        self.imagePlayView.animationImages = array;
        self.imagePlayView.contentMode = UIViewContentModeCenter;
        self.imagePlayView.animationDuration = 1.0;
        self.imagePlayView.animationRepeatCount = 0;
//        [self.imagePlayView stopAnimating];
//        [self.imagePlayView startAnimating];//开始播放动画

        [soundBtn addSubview:self.imagePlayView];

        soungType = [Common createLabel:CGRectMake(21, 0, soundBtn.width-21, soundBtn.height) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:@"限时免费听"];
        [soundBtn addSubview:soungType];
        
        
        readingLab = [Common createLabel:CGRectMake(soundBtn.right, soundBtn.top, kDeviceWidth-soundBtn.right-15, soundBtn.height) TextColor:@"ff654c" Font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentRight labTitle:nil];
        [m_allView addSubview:readingLab];

    }
    return self;
}

- (void)sound:(UIButton*)btn
{
//    _soundBlock(m_dic);
    [self.delegate showPic:self.m_dic withID:self];
}

- (void)setSoundInfoWithDic:(NSMutableDictionary*)dic
{
//    NSMutableDictionary *d;
//    if (dic[@"key"]) {
//        d =[dic[@"key"] objectAtIndex:0];
//    }else{
//        d = dic;
//    }
    self.m_dic = dic;
    
    titleLab.text = dic[@"courseTitle"];
    nameLab.text = dic[@"doctorName"];
    dataLab.text = dic[@"doctorTitle"];
    if (dic[@"browseNum"]) {
        readingLab.text = [NSString stringWithFormat:@"%@人已听",dic[@"browseNum"]];
    }
    [CommonImage setImageFromServer:dic[@"doctorIcon"] View:headerImage Type:0];
    soungType.text = [self setReadingType:dic[@"isFree"] coursePrice:dic[@"coursePrice"]];
    
    CGSize size = [Common sizeForString:nameLab.text andFont:12];
    nameLab.frame= [Common rectWithSize:nameLab.frame width:size.width height:0];
    lineView.frame = [Common rectWithOrigin:lineView.frame x:nameLab.left+size.width+6 y:0];
    dataLab.frame = [Common rectWithOrigin:dataLab.frame x:lineView.right+6 y:0];
    
    BOOL is = [[dic objectForKey:@"isPlay"] boolValue];
    if (is) {
        [self.imagePlayView startAnimating];
    }
    else {
        [self.imagePlayView stopAnimating];
    }
    size = [Common sizeForAllString:dic[@"courseTitle"] andFont:17 andWight:kDeviceWidth-30];
    titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:size.height];
//    titleLab.frame = [Common rectWithOrigin:titleLab.frame x:0 y:15];
    float h = 170/2+size.height+20;
    m_allView.frame = [Common rectWithOrigin:m_allView.frame x:0 y:h-85];
    
}

- (NSString*)setReadingType:(NSString*)str coursePrice:(NSString*)coursePrice
{
    NSString * type = @"限时免费听";
    switch ([str intValue]) {
        case 0:
            type = @"限时免费听";
            break;
        case 3:
            type = [NSString stringWithFormat:@"%.2f元偷偷听",[coursePrice intValue]/100.f];
            break;
        case 5:
            type = @"已支付";
            break;
        default:
            break;
    }
    
    return type;
}

@end






@implementation VideoTableViewCell

@synthesize videoBlock;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIImageView * pickerImage,*typeImage;
        UIView * view;
        UILabel *titleLab,*readingLab;
        UIImageView * sparkImage;
        UIImage * image = [UIImage imageNamed:@"common.bundle/home/spark"];
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap;
        for (int i = 0; i<2; i++) {
            view = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2*i, 0, kDeviceWidth/2, 326/2)];
            view.tag = 10+i;
            [self.contentView addSubview:view];
            
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(video:)];
            [view addGestureRecognizer:tap];
            
            pickerImage = [[UIImageView alloc]initWithFrame:CGRectMake(!i?15:5, 15, (kDeviceWidth-40)/2, 190/2)];
//            pickerImage.backgroundColor = [UIColor clearColor];
            pickerImage.clipsToBounds = YES;
            pickerImage.contentMode = UIViewContentModeScaleAspectFill;
            pickerImage.tag = 20+i;
            [view addSubview:pickerImage];
            
            typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(pickerImage.width-65/2, 0, 65/2, 65/2)];
            typeImage.tag = 25+i;
            [pickerImage addSubview:typeImage];

            titleLab = [Common createLabel:CGRectMake(pickerImage.left, pickerImage.bottom+11, pickerImage.width, 15) TextColor:@"000000" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:nil];
            titleLab.tag = 30+i;
            [view addSubview:titleLab];
            
            sparkImage = [[UIImageView alloc]initWithFrame:CGRectMake(pickerImage.left, titleLab.bottom+5, image.size.width, image.size.height)];
            sparkImage.image = image;
            sparkImage.contentMode = UIViewContentModeCenter;
            [view addSubview:sparkImage];

            readingLab = [Common createLabel:CGRectMake(sparkImage.right+5, titleLab.bottom+5, 200, 12) TextColor:@"ff654c" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
            readingLab.tag = 40+i;
            [view addSubview:readingLab];

        }
    }
    return self;
    
}

- (void)video:(UITapGestureRecognizer*)tap
{
    NSMutableArray *arr = m_dic[@"key"];
    NSMutableDictionary *dic = arr[(int)tap.view.tag-10];
    videoBlock(dic, tap.view.tag-10 ? @"B": @"A");
}

- (void)setVideoInfoWithDic:(NSDictionary*)dic
{
    m_dic = (NSMutableDictionary*)dic;
    NSMutableArray * arr = dic[@"key"];
    UIImageView * pickerImage,*typeImage;
    UILabel *titleLab,*readingLab;
    for (int i = 0; i<2; i++) {
        pickerImage = (UIImageView*)[self viewWithTag:20+i];
        typeImage = (UIImageView*)[self viewWithTag:25+i];
        titleLab = (UILabel*)[self viewWithTag:30+i];
        readingLab = (UILabel*)[self viewWithTag:40+i];
        titleLab.text = arr[i][@"courseTitle"];
        readingLab.text = [NSString stringWithFormat:@"%@",arr[i][@"browseNum"]];
        typeImage.image = [Common setImageTypeWithStr:arr[i][@"isFree"]];
        [CommonImage setImageFromServer:arr[i][@"iconUrl"] View:pickerImage Type:2];
    }
}

@end