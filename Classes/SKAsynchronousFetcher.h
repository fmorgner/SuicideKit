//
//  SKAsynchronousFetcher.h
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __MAC_10_7
@interface SKAsynchronousFetcher : NSObject <NSURLConnectionDelegate>
#else
@interface SKAsynchronousFetcher : NSObject
#endif
	{
	@private
    void (^completionHandler)(id);
		NSURL* url;
		NSMutableData* receivedData;
	}

- (void)fetchDataAtURL:(NSURL*)theURL withCompletionHandler:(void (^)(id fetchResult))block;

@end
