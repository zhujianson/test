

#import "ScrollSwitchCell.h"


@implementation ScrollSwitchCell
{
    CGSize m_size;
}
@synthesize m_labTitle;
@synthesize m_markLeft;
@synthesize m_markRight;

- (UITableViewCell *)initWithSize:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        m_size = size;
        m_labTitle = [Common createLabel];
        m_labTitle.frame = CGRectMake(0, 0, size.width, size.height);
        m_labTitle.textAlignment = NSTextAlignmentCenter;
//        m_labTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:labTitle.font.pointSize];
        m_labTitle.center = CGPointMake(size.width/2, size.height/2);
        [self addSubview:m_labTitle];
        [m_labTitle release];
        
        m_markLeft = [[UIView alloc] initWithFrame:CGRectMake(0, (size.height-3)/2, 7, 3)];
        m_markLeft.backgroundColor = [CommonImage colorWithHexString:@"c6c6c6"];
        [self addSubview:m_markLeft];
        [m_markLeft release];
        
        m_markRight = [[UIView alloc] initWithFrame:CGRectMake(size.width-7, (size.height-3)/2, 7, 3)];
        m_markRight.backgroundColor = [CommonImage colorWithHexString:@"c6c6c6"];
        [self addSubview:m_markRight];
        [m_markRight release];
    }
    
    return self;
}

- (void)setTitleValue:(NSString*)text
{
    m_labTitle.text = text;
    
    float height = m_size.height;
    float width = m_size.width;
    
    CGRect rectL = CGRectMake(0, (height-3)/2, 7, 3);
    CGRect rectR = CGRectMake(width-7, (height-3)/2, 7, 3);
    
    if (!([text intValue]%5)) {
        rectL.size.width = 14;
        rectR.origin.x -= 7;
        rectR.size.width = 14;
    }
    m_markLeft.frame = rectL;
    m_markRight.frame = rectR;
}

- (void)setColorFont:(NSDictionary*)dic
{
    m_labTitle.font = [UIFont systemFontOfSize:[[dic objectForKey:@"size"] floatValue]];
    m_labTitle.textColor = [CommonImage colorWithHexString:[dic objectForKey:@"color"]];
    
//    m_labTitle.font = [dic objectForKey:@"size"];
//    m_labTitle.textColor = [dic objectForKey:@"color"];
//    
    m_markLeft.backgroundColor = m_labTitle.textColor;
    m_markRight.backgroundColor = m_labTitle.textColor;
}

@end
