#import <Foundation/Foundation.h>



@interface SSBLEReadWriteData : NSObject

@property (nonatomic, assign) NSInteger maxRewriteCount;
@property (nonatomic, retain) NSDictionary *readValues;
@property (nonatomic, assign) NSInteger writeDateTime;
@property (nonatomic, assign) BOOL ifReply;

@end
