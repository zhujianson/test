//
//  AlignLabel.h
//  jiuhaohealth4.5
//
//  Created by 徐国洪 on 16/4/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface AlignLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end