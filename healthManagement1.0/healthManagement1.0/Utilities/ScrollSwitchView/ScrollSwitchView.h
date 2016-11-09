

#import <UIKit/UIKit.h>

@class ScrollSwitchView;

typedef enum {
    vertical,
    horizontal,
}enum_showType;

@protocol ScrollSwitchViewDelegate <NSObject>

- (void)scrollSwitchView:(ScrollSwitchView*)cc willSelectValue:(NSString*)text;

@end

@interface ScrollSwitchView : UIView

@property (nonatomic, retain) NSString *selCellColor;
@property (nonatomic, retain) NSString *noSelCellColor;

@property (nonatomic, assign) UIColor *activeDayNameColor;

@property (nonatomic, assign) CGFloat cellLabelFontSize;

@property (nonatomic, assign) CGFloat cellLabelZoomScale;

@property (nonatomic, assign) CGSize CellSize;

@property (nonatomic, retain) NSArray *m_array;

@property (nonatomic, assign) enum_showType showType;

@property (nonatomic, assign) id<ScrollSwitchViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame withCell:(CGSize)sized withArray:(NSArray*)array withType:(enum_showType)type;

- (void)setCurrentRow:(NSInteger)row animated:(BOOL)animate;

- (void)setCurrentRow:(NSInteger)row;

//- (void)


@end


