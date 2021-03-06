//
//  HomeTableViewCell.h
//  healthManagement1.0
//
//  Created by xjs on 16/7/1.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableCellDelegate <NSObject>

- (void)sendMsg:(NSMutableDictionary*)dic;

- (void)showPic:(NSMutableDictionary*)dic withID:(id)vc;

- (void)butEventShowConsult:(NSMutableDictionary*)dic;

- (void)shuaxinCell:(id)cc;

@end





@interface HomeTableViewCell : UITableViewCell

- (void)setInformationWithDic:(NSDictionary*)dic;

@end


typedef void(^ChooseSoundBlock)(NSDictionary* dic);

@interface SoundTableViewCell : UITableViewCell//声音cell
{
    ;
}

@property (nonatomic, strong) ChooseSoundBlock soundBlock;
@property (nonatomic, strong) UIImageView *imagePlayView;
@property (nonatomic, strong) NSMutableDictionary *m_dic;
@property (nonatomic, assign) id <TableCellDelegate> delegate;

- (void)setSoundInfoWithDic:(NSMutableDictionary*)dic;

@end








typedef void(^ChooseVideoBlock)(NSDictionary *dic, NSString *index);

@interface VideoTableViewCell : UITableViewCell//视频cell
{
    NSMutableDictionary *m_dic;
}

@property (nonatomic,strong) ChooseVideoBlock videoBlock;

- (void)setVideoInfoWithDic:(NSDictionary*)dic;
@end
