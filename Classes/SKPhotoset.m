//
//  Photoset.m
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "SKPhotoset.h"
#import "SKAsynchronousFetcher.h"
#import "NSString+FMStringAdditions.h"

@implementation SKPhotoset

@synthesize title, URLs, photos, girl;

- (id)initWithContentsOfURL:(NSURL*)aURL immediatelyLoadPhotos:(BOOL)immediatelyLoadPhotos delegate:(id<SKPhotosetDelegate>)aDelegate
	{
	if((self = [super init]))
		{
		NSURLResponse* connectionResponse = nil;
		NSError* connectionError = nil;
		NSData* htmlData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:aURL] returningResponse:&connectionResponse error:&connectionError];
		
		if(connectionError)
			{
			self = nil;
			}
		else
			{
			NSString* htmlString = [[[NSString alloc] initWithData:htmlData encoding:NSASCIIStringEncoding] autorelease];
			
			if(!([htmlString rangeOfString:@"<div id=\"content\" class=\"loggedout\">"].location == NSNotFound))
				{
				self = nil;
				return self;
				}
			
			NSString* photosetName = nil;
			NSMutableArray* URLArray = [NSMutableArray array];
	
			NSString* scannerString = htmlString;
			NSString* arrayCode = nil;
			NSScanner* scanner = [NSScanner scannerWithString:scannerString];
	
			[scanner scanUpToString:@"list[0]" intoString:nil];
			[scanner scanUpToString:@"PicViewerNav.loadImageList(list,false);" intoString:&arrayCode];
	
			scanner = [NSScanner scannerWithString:arrayCode];
	
			NSString* URLString = nil;
	
			while(![scanner isAtEnd])
				{
				[scanner  scanUpToString:@"\"" intoString:nil];
				[scanner  setScanLocation:([scanner scanLocation] + 1)];
				[scanner  scanUpToString:@"\"" intoString:&URLString];
				[URLArray addObject:[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
				[scanner  scanUpToString:@"list[" intoString:nil];
				}
			
			self.URLs = (NSArray*)URLArray;
			
			scanner = [NSScanner scannerWithString:[[URLArray objectAtIndex:0] absoluteString]];
			
			[scanner scanUpToString:@"/photos/" intoString:nil];
			[scanner setScanLocation:([scanner scanLocation] + 8)];
			[scanner scanUpToString:@"/" intoString:&photosetName];
			
			self.title = [[photosetName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByTrimmingLeadingWhitespaces];
			
			scanner = nil;
			
			if(immediatelyLoadPhotos)
				{
				
				}
			}
		}

	return self;
	}

+ (SKPhotoset*)photosetWithContentsOfURL:(NSURL*)aURL immediatelyLoadPhotos:(BOOL)immediatelyLoadPhotos delegate:(id<SKPhotosetDelegate>)aDelegate
	{
	return [[[SKPhotoset alloc] initWithContentsOfURL:aURL immediatelyLoadPhotos:immediatelyLoadPhotos delegate:aDelegate] autorelease];
	}

- (void)dealloc
	{
	[title release];
	[URLs release];
	[photos release];
	self.girl = nil;
	}

- (void) loadPhotos
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
	}



@end
