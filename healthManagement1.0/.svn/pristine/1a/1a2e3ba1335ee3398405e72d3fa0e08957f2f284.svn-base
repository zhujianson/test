
@class MyImageInfo;


@protocol IconDownloaderDelegate<NSObject>;
- (void)appImageDidLoad:(NSDictionary *)imageDicInfo;
@end

@interface IconDownloader : NSOperation
{
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
	
//	NSMutableArray *arrayIndex;
//	NSMutableDictionary *m_arrayImage;
	NSMutableDictionary *m_itemInfo;
}

@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

//@property (nonatomic, retain) NSMutableData *activeDownload;
//@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)setArrayIndexPath:(id)indexPath setNo:(int)i setImageUrl:(NSString*)url;

- (void)setArrayImgae:(NSMutableDictionary*)array;


@end