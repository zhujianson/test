//
//  FriendListCell.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FriendListCell.h"
#import "Global.h"
#import "Global_Url.h"

@implementation FriendListCell
{
    UILabel *m_nameLabel;
    UILabel *m_contentTitle;
    UILabel *m_timeLabel;
    
    UILabel *m_labTypeName;//医生类型
}
@synthesize m_headerView,redImage;


- (void)dealloc
{
    [redImage release];
    [m_headerView release];
    m_nameLabel  = nil;
    m_contentTitle = nil;
    m_timeLabel = nil;
//    [redHeartImage release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_headerView = [[UIImageView alloc]init];
        m_headerView.clipsToBounds = YES;
        m_headerView.contentMode = UIViewContentModeScaleAspectFill;
        m_headerView.frame = CGRectMake(10, 10, 50, 50);
        m_headerView.layer.cornerRadius = m_headerView.width/2.0;
        [self.contentView addSubview:m_headerView];
        
        m_nameLabel = [Common createLabel:CGRectMake(m_headerView.right+10, m_headerView.top+5, kDeviceWidth-m_headerView.right-20-80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [self.contentView addSubview:m_nameLabel];
        
        m_labTypeName = [Common createLabel];
        m_labTypeName.frame = CGRectMake(200, m_nameLabel.top+1, 30, 19);
        m_labTypeName.textAlignment = NSTextAlignmentCenter;
        m_labTypeName.layer.cornerRadius = 2;
        m_labTypeName.clipsToBounds = YES;
        m_labTypeName.font = [UIFont systemFontOfSize:12];
        m_labTypeName.textColor = [UIColor whiteColor];
        m_labTypeName.layer.cornerRadius = 2;
        [self.contentView addSubview:m_labTypeName];
        [m_labTypeName release];

        
        m_contentTitle = [Common createLabel:CGRectMake(m_nameLabel.left, m_nameLabel.bottom+3, kDeviceWidth-m_nameLabel.left-10, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [self.contentView addSubview:m_contentTitle];
        
        m_timeLabel = [Common createLabel:CGRectMake(m_nameLabel.right, 0,80, 60) TextColor:@"999999" Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] textAlignment:NSTextAlignmentRight labTitle:@"123"];
        [self.contentView addSubview:m_timeLabel];
        
        UIImage *redImgeContent = [UIImage imageNamed:@"common.bundle/topic/conversation_icon_redpoint.png"];
        redImage = [[UIImageView alloc] initWithFrame:CGRectMake(m_headerView.right-14, m_headerView.top,14, 14)];
        redImage.image = redImgeContent;
        [self.contentView addSubview:redImage];
    }
    return self;
}

- (void)setInfoModel:(FriendModel*)friendModel
{
    //名称
    m_nameLabel.text = friendModel.nickName;
    
    //医师类型
    m_labTypeName.text = friendModel.typeName;
    m_labTypeName.backgroundColor = [CommonImage colorWithHexString:friendModel.typeColor];
    //设置位置
    CGRect rect = m_labTypeName.frame;
    rect.origin.x = m_nameLabel.left + [Common sizeForString:m_nameLabel.text andFont:m_nameLabel.font.pointSize].width+5;
    rect.size.width = [Common sizeForString:m_labTypeName.text andFont:m_labTypeName.font.pointSize].width +10;
    m_labTypeName.frame = rect;

    NSString *title;
    
    redImage.hidden = !friendModel.unReadCount;//未读
    if (friendModel.unReadCount > 1 && friendModel.chatContentType != 50)//大于1显示条数 同时 没有草稿
    {
        title = [NSString stringWithFormat:@"【%d条】%@", friendModel.unReadCount, @"未读消息"];
    }
    else
    {
        switch (friendModel.chatContentType) {
            case 0:
                title = friendModel.chatContent;
                break;
            case 1:
                title = @"图片消息";
                break;
            case 2:
                title = @"语音消息";
                break;
            case 3:
                title = @"图片表情";
                break;
            case 50:
                title = [NSString stringWithFormat:@"[草稿]%@", friendModel.chatContent];
                break;
            default:
                title = @"版本过低无法查看";
                break;
        }
    }
    
    m_contentTitle.attributedText = [self replaceRedColorWithNSString:title andUseKeyWord:@"[草稿]" andWithFontSize:14];
    
    if (friendModel.chatTime) {
        NSString *time = [NSString stringWithFormat:@"%ld", friendModel.chatTime];
        
        m_timeLabel.text = [self setTimeWithDate:time];
        //自定义右箭头
        self.accessoryView = nil;
    }
    else {
        //自定义右箭头
        self.accessoryView = [CommonImage creatRightArrowX:self.frame.size.width-22 Y:(self.frame.size.height-12)/2 cell:self];
    }
    m_timeLabel.hidden = !friendModel.chatTime;
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString*)str andUseKeyWord:(NSString*)keyWord andWithFontSize:(float)s
{
    if (!str.length)
    {
        return [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
    }
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:COLOR_FF5351], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

//  更改时间
//
//  @param indexDict 原数据
//
//  @return 更新后得数据
- (NSString *)setTimeWithDate:(NSString*)timeStr
{
    NSString *flagTime = nil;

    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    // 当前日期
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSString *timeString = [CommonDate getServerTime:(long)[timeStr longLongValue] type:4];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectDate = [formatter dateFromString:timeString];
    NSString *curuunet = [formatter stringFromDate: [NSDate date]]; //统一时间点
    NSDate *currentDate = [formatter dateFromString:curuunet];
    [formatter release];
    

    NSDateComponents *comps = [myCalendar components:unitFlags fromDate:currentDate toDate:selectDate options:0];
    int diff = (int)comps.day;
    
    if (diff==0) {
        flagTime = [CommonDate  getServerTime:(long)([timeStr longLongValue]) type:1];
    } else if (diff==-2) {
        flagTime = @"前天";
    } else if (diff==-1) {
        flagTime = @"昨天";
    } else {
        flagTime = timeString;
    }
    
    return flagTime;
}

@end

