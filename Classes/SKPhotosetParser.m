//
//  PhotosetParser.m
//  SuicideBrowser
//
//  Created by Felix Morgner on 07.12.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "SKPhotosetParser.h"
#import "SKAsynchronousFetcher.h"

@implementation SKPhotosetParser

@synthesize htmlDocument, parserResult;

- (id)init
	{
	if((self = [super init]))
		{
		parserResult = [[NSMutableArray alloc] init];
		}
		
	return self;
	}

- (void)dealloc
	{
	[htmlDocument release];
	[parserResult release];
	}

- (void) parsePhotosetAtURL:(NSURL*)aURL
	{
	SKAsynchronousFetcher* dataFetcher = [SKAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:aURL withCompletionHandler:^(id fetchResult) {
		self.htmlDocument = [[NSString alloc] initWithData:fetchResult encoding:NSUTF8StringEncoding];
		[self parse];
	}];
	}

- (void) parse
	{
	NSMutableArray* URLArray = [NSMutableArray array];
	NSString* photosetName = nil;
	NSString* girlName = nil;
	
	NSString* scannerString = htmlDocument;
	NSScanner* scanner = [NSScanner scannerWithString:scannerString];
	NSString* arrayCode = nil;
	
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
	
	}

@end
