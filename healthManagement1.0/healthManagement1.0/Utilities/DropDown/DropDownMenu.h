//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownCell.h"

typedef void(^DropDownMenuSel)(int);

@interface DropDownMenu : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) DropDownMenuSel selBlock;

- (id)initWithView:(UIView*)view withWidth:(float)width withArray:(NSArray*)array superView:(UIView*)superView;

- (void)showDropDown;
- (void)hideDropDown;

@end
