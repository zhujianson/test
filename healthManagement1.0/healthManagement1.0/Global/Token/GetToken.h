//
//  GetToken.h
//  jiuhaohealth3.0
//
//  Created by 徐国洪 on 15-1-17.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDImageCache.h"

typedef void (^submitDataReturn)(BOOL isOK, NSString *name);
typedef void (^getTokenDataReturn)(NSString *token);

@interface GetToken : NSObject
{
    NSMutableArray *m_array;
    getTokenDataReturn m_block;
    
}
//@property (nonatomic, assign) NSMutableArray *m_array;
@property (nonatomic, assign) NSMutableArray *m_array2;
@property (nonatomic, assign) NSThread *m_thread;

- (void)addObject:(NSDictionary*)dic;

- (void)getToken:(getTokenDataReturn)bo;

+ (NSString*)getTokenStr;

+ (void)submitData:(NSData*)data withBlock:(submitDataReturn)delegate withName:(NSString*)name1;

@end
