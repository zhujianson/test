//
//  ScoreRewardsCell.m
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-12-3.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ScoreRewardsCell.h"

@implementation ScoreRewardsCell
@synthesize taskFinish,taskName,taskScore;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        taskName = [Common createLabel:CGRectMake(15, 0, kDeviceWidth - 170, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:taskName];
        
        taskFinish = [Common createLabel:CGRectMake(taskName.right+5, 0, 40, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentCenter labTitle:nil];
        [self.contentView addSubview:taskFinish];
        

        taskScore = [Common createLabel:CGRectMake(kDeviceWidth-15-100, 0, 100, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentRight labTitle:nil];

        [self.contentView addSubview:taskScore];
    }
    return self;
}

-(void)setFillContentWithDict:(NSDictionary *)infoDict
{
    taskName.text = infoDict[@"taskName"];
    NSString *taskFinisString = nil;
    int num = [infoDict[@"unfinished"] intValue];
    if ([infoDict[@"completeNum"] intValue] == 0)
    {
        taskFinisString = [NSString stringWithFormat:@" %@/%d", infoDict[@"completion"], num];
        taskFinish.attributedText = [self replaceRedColorWithNSString:taskFinisString andUseKeyWord:[NSString stringWithFormat:@" %@",infoDict[@"completion"]] andWithFontSize:14.0];
    }
    else
    {
        taskFinisString = [NSString stringWithFormat:@"%@/%d",infoDict[@"completion"], num];
        taskFinish.text = taskFinisString;
    }
    NSString *taskScoreString = [NSString stringWithFormat:@"%@ 积分/次",infoDict[@"scores"]];
    taskScore.attributedText = [self replaceRedColorWithNSString:taskScoreString andUseKeyWord:[NSString stringWithFormat:@"%@",infoDict[@"scores"]] andWithFontSize:14.0];
}

- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"fe6339"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

-(void)dealloc
{
//    [taskScore release];
//    [taskName release];
//    [taskScore release];
    [super dealloc];
}
@end
