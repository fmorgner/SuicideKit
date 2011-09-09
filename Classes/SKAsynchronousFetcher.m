//
//  SKAsynchronousFetcher.m
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "SKAsynchronousFetcher.h"

@implementation SKAsynchronousFetcher

- (id)init
	{
  if ((self = [super init]))
		{
		receivedData = [NSMutableData new];
    }
    
  return self;
	}

- (void)dealloc
	{
	[url release];
	[completionHandler release];
  [super dealloc];
	}

- (void)fetchDataAtURL:(NSURL*)theURL withCompletionHandler:(void (^)(id fetchResult))block
	{
	if(!block)
		{
		NSException* exception = [NSException exceptionWithName:@"FlickrKitCompletionHandlerNilException" reason:@"The completion handler must not be NULL" userInfo:nil];
		[exception raise];
		return;
		}
	if(!theURL)
		{
		NSException* exception = [NSException exceptionWithName:@"FlickrKitURLNilException" reason:@"The URL must not be nil" userInfo:nil];
		[exception raise];
		return;
		}
	
	url = [theURL copy];
	completionHandler = [block copy];
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:request delegate:self];
	}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
	{
	if(((NSHTTPURLResponse*)response).statusCode >= 400)
		{
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
		
		[userInfo setObject:url forKey:@"url"];
		[userInfo setObject:[NSNumber numberWithInteger:((NSHTTPURLResponse*)response).statusCode] forKey:@"status"];
		[userInfo setObject:[NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse*)response).statusCode] forKey:@"statusdesc"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SKAsynchronousFetcherDidFail" object:self userInfo:(NSDictionary*)userInfo];
		}
	}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[receivedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	completionHandler(receivedData);

	[receivedData setLength:0];
	}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
	{
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	[userInfo setObject:url forKey:@"url"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SKAsynchronousFetcherDidFail" object:self userInfo:(NSDictionary*)userInfo];

	completionHandler(error);
	}

@end
