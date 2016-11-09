

#import <UIKit/UIKit.h>

@interface ScrollSwitchCell : UITableViewCell
//{
//    UILabel *m_labTitle;
//}

- (UITableViewCell *)initWithSize:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly) UILabel *m_labTitle;
@property (nonatomic, readonly) UIView *m_markLeft;
@property (nonatomic, readonly) UIView *m_markRight;


//@property (nonatomic, assign) NSDictionary *m_infoDic;

- (void)setColorFont:(NSDictionary *)dic;

- (void)setTitleValue:(NSString*)text;

@end
