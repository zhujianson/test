
#import "IconDownloader.h"
#import "ASIHTTPRequest.h"
#import "Common.h"

#define kAppIconHeight 48


@implementation IconDownloader
//@synthesize imageUrl;
@synthesize delegate;
//@synthesize activeDownload;
//@synthesize imageConnection;

#pragma mark

- (void)dealloc
{
	delegate = nil;
	if (m_itemInfo) {
		[m_itemInfo release], m_itemInfo = nil;
	}
    
    [super dealloc];
}

- (void)setArrayImgae:(NSMutableDictionary *)array
{
//	m_arrayImage = array;
}

- (void)setArrayIndexPath:(id)indexPath setNo:(int)i setImageUrl:(NSString*)url
{
	m_itemInfo = [[NSMutableDictionary alloc] init];
	[m_itemInfo setObject:indexPath forKey:@"indexPath"];
	if (url) {
		[m_itemInfo setObject:url forKey:@"imagePath"];
	}
	[m_itemInfo setObject:[NSNumber numberWithInt:i] forKey:@"NO."];
}

- (void)main
{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    
    if(![Common checkNetworkIsValid])
    {
        return;
    }
	NSString *imageUrl = [m_itemInfo objectForKey:@"imagePath"];
	if (![imageUrl length]) {
		[m_itemInfo release];
		m_itemInfo = nil;
		return;
	}
	NSString *imagePath = [m_itemInfo objectForKey:@"imagePath"];
    NSLog(@"imagePath ====================  %@", imagePath);
	ASIHTTPRequest *dRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imagePath]];
	[dRequest setTimeOutSeconds:600];
	[dRequest startSynchronous];
	NSData *data = [dRequest responseData];
	
	NSError *error = [dRequest error];
	
	[g_iconDownDelegateLock lock];
	if (error) {
		[g_iconDownDelegateLock unlock];
		return;
	}else if (delegate) {
		if ([delegate respondsToSelector:@selector(appImageDidLoad:)] && [data length]) {
//			if ([data length] > 100000) {
//				return;
//			}
			UIImage *image = [UIImage imageWithData:data];
//			UIImage *image = [[UIImage alloc] initWithData:data];
			if (image) {
				[m_itemInfo setObject:image forKey:@"image"];
				
				[delegate appImageDidLoad:m_itemInfo];
			}
		}
	}else {
		NSLog(@"123123123123123123123123aqweqewqweqw");
	}
	[g_iconDownDelegateLock unlock];
	
	[m_itemInfo release];
	m_itemInfo = nil;
    
    [autoPool release];
}

- (void)cancelDownload
{
//    [self.imageConnection cancel];
//    self.imageConnection = nil;
//    self.activeDownload = nil;
}

@end

