//
//  GetFamilyList.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-12-9.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "GetFamilyList.h"

@implementation GetFamilyList

- (id)initWithBlcok:(getFamilyListBlock)block withView:(id)vc
{
	self = [super init];
	if (self) {
		[g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
        m_familyListBlock = [block copy];
        m_vc = vc;
		[self getFamilyList];
	}
	return self;
}

- (void)getFamilyList
{
	if (!g_familyList.count) {
		[g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
		g_familyList = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"familyInfo_%@", g_nowUserInfo.userid]]];
//		if (!g_familyList.count) {
//			NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
//			[dic setObject:g_nowUserInfo.userid forKey:@"id"];
//			[dic setObject:g_nowUserInfo.filePath forKey:@"filePath"];
//			[g_familyList addObject:dic];
//		}
//		else if ([g_familyList count]<7)
//		{
//			if (g_familyList.lastObject[@"id"]) {
//				[g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
//			}
//		}
		
		[self loadDataBegin];
	}
	else {
        if (m_familyListBlock) {
            m_familyListBlock(g_familyList);
        }
	}
}

- (void)loadDataBegin
{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//	[dic setObject:g_nowUserInfo.userid forKey:@"userId"];
	
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_FAMILY_LIST_BY_USERID values:dic requestKey:GET_FAMILY_LIST_BY_USERID delegate:self controller:m_vc actiViewFlag:m_vc ? 1 : 0 title:nil];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
	NSString *responseString = [loader responseString];
	NSDictionary *dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
    
    NSLog(@"%@",dict);
    if (![[dic objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        return;
    }
	if (![[dic objectForKey:@"state"] intValue])
	{
		if ([loader.username isEqualToString:GET_FAMILY_LIST_BY_USERID]){
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"body"][@"result_set"]];
            NSMutableDictionary * dicS;
            for (int i = 1; i<arr.count; i++) {
                dicS = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
                [dicS setObject:[Common dataWithString:dicS[@"history"]] forKey:@"history"];
                [arr replaceObjectAtIndex:i withObject:dicS];
            }
            
			[[NSUserDefaults standardUserDefaults] setObject:arr forKey:[NSString stringWithFormat:@"familyInfo_%@",g_nowUserInfo.userid]];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[g_familyList removeAllObjects];
			[g_familyList addObjectsFromArray:arr];
            [arr release];
			
			if (g_familyList.count < 7) {
				if (g_familyList.lastObject[@"id"]) {
					[g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
				}
            }
            if (m_familyListBlock) {
                m_familyListBlock(g_familyList);
            }
		}
    } else {
        if (m_familyListBlock) {
            m_familyListBlock(g_familyList);
        }
	}
    [self release];
    self = nil;
}

- (void)dealloc
{
	[m_familyListBlock release];
	[super dealloc];
}

@end
