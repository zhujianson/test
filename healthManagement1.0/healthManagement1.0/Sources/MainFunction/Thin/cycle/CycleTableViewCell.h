//
//  CycleTableViewCell.h
//  healthManagement1.0
//
//  Created by xjs on 16/6/2.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  k_fetchImage(imageName)  ([UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/thin/%@.png",imageName]])


@interface CycleTableViewCell : UITableViewCell
- (void)setCellInfo:(NSString*)dic week:(NSString*)week;
@end