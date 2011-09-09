		//
//  Photoset.m
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "SKPhotoset.h"


@implementation SKPhotoset

@synthesize title, URLs, photos;

- (id) init
	{
	if ((self = [super init]))
		{
		self.title = nil;
		}
	return self;
	}

- (id) initWithTitle:(NSString*)aTitle
	{
	if ((self = [super init]))
		{
		[self setTitle:aTitle];
		}
	return self;
	}

+ (SKPhotoset*) photosetWithTitle:(NSString*)aTitle
	{
	return [[[SKPhotoset alloc] initWithTitle:aTitle] autorelease];
	}

- (BOOL) loadPhotos
	{
	NSMutableArray* loadedPhotos = [NSMutableArray array];
	
	for(NSURL* URL in URLs)
		{
		NSURLRequest* request = [NSURLRequest requestWithURL:URL];
		NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSImage* photo = [[NSImage alloc] initWithData:receivedData];
		[loadedPhotos addObject:photo];
		[photo release];
		}
	
	[self setPhotos:(NSArray*)loadedPhotos];
	
	return YES;
	}

@end
