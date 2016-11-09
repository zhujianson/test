//
//  HealthRecordCell.m
//  healthManagement1.0
//
//  Created by wangmin on 16/1/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HealthRecordCell.h"




@implementation BaseHealthRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){

        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = [CommonImage colorWithHexString:@"ebebeb"];
        [self.contentView addSubview:_lineView];
    }
    
    return self;
    
}


@end


@interface HealthRecordCell ()

@property (nonatomic,strong) UIImageView *logoImageView;

@property (nonatomic,strong) UILabel *logoNameLabel;


@end

@implementation HealthRecordCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    
        //图标
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 25, 25)];
//        self.logoImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_logoImageView];
        //文字
        self.logoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoImageView.right+16, 22.5, kDeviceWidth-_logoImageView.right-16-15*2, 15)];
        _logoNameLabel.textColor = [CommonImage colorWithHexString:@"999999"];
        _logoNameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_logoNameLabel];
    
    }
    
    return self;

}

- (void)setData:(HealthRecordModel *)model
{
    self.logoNameLabel.text = model.logoName;
    self.logoImageView.image = [UIImage imageNamed:model.logoImageName];
    CGRect lineFrame = self.lineView.frame;
    
    lineFrame.origin.y = model.rowHeight-0.5;
    lineFrame.origin.x = 0;
    self.lineView.frame = lineFrame;
}

@end



@interface  HealthRecordPairCell()

@property (nonatomic,strong) UILabel *keyLabel;

@property (nonatomic,strong) UILabel *valueLabel;

@end

@implementation HealthRecordPairCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //key
        self.keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5 ,(kDeviceWidth-30)/2.0f , 15)];
        _keyLabel.font = [UIFont systemFontOfSize:15.0f];
        _keyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:_keyLabel];
        
        //value
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_keyLabel.right, 17.5 ,(kDeviceWidth-30)/2.0f , 15)];
        _valueLabel.font = [UIFont systemFontOfSize:15.0f];
        _valueLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_valueLabel];
        
    }
    
    return self;
    
}

- (void)setData:(HealthRecordModel *)model
{
    self.keyLabel.text = model.keyString;
    self.valueLabel.text = model.valueString;
    
    CGRect lineFrame = self.lineView.frame;
    
    lineFrame.origin.y = model.rowHeight-0.5;
    lineFrame.origin.x = 15;
    self.lineView.frame = lineFrame;
    
}


@end


@interface  HealthRecordTextCell()

@property (nonatomic,strong) UILabel *contentLabel;


@end

@implementation HealthRecordTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //key
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5 ,(kDeviceWidth-30), 15)];
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:_contentLabel];
        
    }
    
    return self;
}

- (void)setData:(HealthRecordModel *)model
{
    
     CGRect rect = self.contentLabel.frame;
     rect.size.height = model.rowHeight - 17.5*2;
     self.contentLabel.frame = rect;
    
    self.contentLabel.text = model.contentString;
    
    CGRect lineFrame = self.lineView.frame;
    
    lineFrame.origin.y = model.rowHeight-0.5;
    lineFrame.origin.x = 0;
    self.lineView.frame = lineFrame;
}


@end

@interface HealthRecordDiseaseCell ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) NSMutableArray *diseaseArray;

@end


@implementation HealthRecordDiseaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //name
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5 ,(kDeviceWidth-30)/2.0f , 15)];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:_nameLabel];
        
        self.diseaseArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    
    return self;
}

- (void)setData:(HealthRecordModel *)model
{
    
    self.nameLabel.text = model.diseaseTitleString;
    
     [self.diseaseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         
         [obj removeFromSuperview];
     }];
    
    [self.diseaseArray removeAllObjects];
    
    CGFloat margin = 15;
    CGFloat width = (kDeviceWidth - 15*5)/4.0f;

    CGFloat lastWidth = kDeviceWidth-15*2;//可以布局的空间
    
    CGFloat originX = margin;//初始化起点
    CGFloat originY = _nameLabel.bottom + 18;
    
    for(NSString *disease in model.diseaseArray){
        
        CGFloat realWidth = width;//实际宽度
        if(disease.length > 4 || width < 15*disease.length+10){
            
            realWidth = 15*disease.length+10;
        }
        
        if(lastWidth < realWidth){
            //不够了另起一行
            originX = margin;
            originY += 30+10;//高+空
            lastWidth = kDeviceWidth-15*2;
        }
        
        lastWidth -= realWidth+margin;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(originX, originY, realWidth, 30);
        [btn setTitle:disease forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:@"333333"] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        btn.layer.borderColor = [CommonImage colorWithHexString:@"dcdcdc"].CGColor;
        btn.layer.borderWidth = 0.5;
        [self.contentView addSubview:btn];
        [self.diseaseArray addObject:btn];
        
        originX += realWidth+margin;
        
        
        
    }

    
    CGRect lineFrame = self.lineView.frame;
    
    lineFrame.origin.y = model.rowHeight-0.5;
    lineFrame.origin.x = 15;
    self.lineView.frame = lineFrame;
    
}

@end

















