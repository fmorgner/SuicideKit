//
//  SuicideGirl.m
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "SKGirl.h"
#import "SKAsynchronousFetcher.h"
#import "SKInternalConstants.h"
#import "SKPhotoset.h"

@interface SKGirl(Private)

- (void)parsePhotosetIndexHTML:(NSString*)htmlString;

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
			NSString* receivedHTML = [[[NSString alloc] initWithData:fetchResult encoding:NSASCIIStringEncoding] autorelease];
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

- (void)parsePhotosetIndexHTML:(NSString *)htmlString
	{
	NSError* error;
	NSXMLDocument* htmlDocument = [[NSXMLDocument alloc] initWithXMLString:htmlString options:NSXMLDocumentTidyHTML error:nil];
	
	
	if(![[[[htmlDocument nodesForXPath:SKInternalIndexPageTitleXPath error:nil] objectAtIndex:0] stringValue] isEqualToString:SKInternalIndexPageTitle])
		{
		NSArray* nodes = [htmlDocument nodesForXPath:SKInternalGirlPhotosetIndexXPath error:&error];
		NSXMLNode* theNode = [nodes objectAtIndex:0];
		
		NSMutableDictionary* photosetDictionary = [NSMutableDictionary dictionary];
		
		for(NSXMLNode* node in [theNode children])
			{
			if([(NSXMLElement*)node attributeForName:@"id"])
				{
				NSString* photosetTitle = [[(NSXMLElement*)node attributeForName:@"title"] stringValue];
				NSString* photosetURL = [[(NSXMLElement*)[[node children] objectAtIndex:0] attributeForName:@"href"] stringValue];
				
				if([photosetURL rangeOfString:@"albums/site"].location == NSNotFound)
					{
					[photosetDictionary setValue:[NSURL URLWithString:[NSString stringWithFormat:@"http://suicidegirls.com/%@", photosetURL]] forKey:photosetTitle];
					}
				}
			}
		
		if([photosetDictionary count])
			{
			NSMutableArray* photosetArray = [NSMutableArray array];
			
			for(NSString* key in [photosetDictionary allKeys])
				{
				SKPhotoset* photoset = [SKPhotoset photosetWithContentsOfURL:[photosetDictionary objectForKey:key] immediatelyLoadPhotos:NO delegate:nil];
				[photoset setGirl:self];
				[photosetArray addObject:photoset];
				}
			
			self.photosets = (NSArray*)photosetArray;
			}
		}
	
	[htmlDocument release];
	}

@end