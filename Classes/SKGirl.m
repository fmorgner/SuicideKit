//
//  SuicideGirl.m
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "SKGirl.h"
#import "SKAsynchronousFetcher.h"

@interface SKGirl(Private)

- (void)parsePhotosetIndexHTML:(NSString*)HTMLString;

@end

@implementation SKGirl

@synthesize name, photosets;

- (id)init
	{
	if((self = [super init]))
		{
		self.name = nil;
		self.photosets = nil;
		}
	return self;
	}

- (id)initWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets withAdditionalData:(BOOL)shouldFetchAdditionalData
	{
	if((self = [super init]))
		{
		[self setName:aName];
		[self setPhotosets:thePhotosets];
		}
	return self;
	}

+ (SKGirl*) girlWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets withAdditionalData:(BOOL)shouldFetchAdditionalData
	{
	return [[[SKGirl alloc] initWithName:aName andPhotosets:thePhotosets withAdditionalData:shouldFetchAdditionalData] autorelease];
	}

- (void)fetchAdditionalData
	{
	
	}

- (void)fetchPhotosets
	{
	SKAsynchronousFetcher* fetcher = [SKAsynchronousFetcher fetcher];
	NSURL* photosetsIndexURL = [NSURL URLWithString:[NSString stringWithFormat:SKPhotosetIndexURLString, name]];
	
	[fetcher fetchDataAtURL:photosetsIndexURL withCompletionHandler:^(id fetchResult) {
		
		if([fetchResult isKindOfClass:[NSData class]])
			{
			NSString* receivedHTML = [[NSString alloc] initWithData:fetchResult encoding:NSASCIIStringEncoding];
			[self parsePhotosetIndexHTML:receivedHTML];
			}
		else
			{
			// TODO: implement gracefull error handling
			}
			
	}];
	}

@end

@implementation SKGirl(Private)

- (void)parsePhotosetIndexHTML:(NSString *)HTMLString
	{
	
	}

@end