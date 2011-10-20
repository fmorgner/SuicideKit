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

@synthesize name, photosets, portrait;

- (id)init
	{
	if((self = [super init]))
		{
		self.name = @"";
		self.photosets = [NSArray array];
		self.portrait = [NSImage imageNamed:@"sg_logo.png"];
		}
	return self;
	}

- (id)initWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets withAdditionalData:(BOOL)shouldFetchAdditionalData
	{
	if((self = [super init]))
		{
		self.name = (aName) ? aName : @"";
		self.photosets = (thePhotosets) ? thePhotosets : [NSArray array];
		self.portrait = [NSImage imageNamed:@"sg_logo.png"];
		}
	return self;
	}

+ (SKGirl*) girlWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets withAdditionalData:(BOOL)shouldFetchAdditionalData
	{
	return [[[SKGirl alloc] initWithName:aName andPhotosets:thePhotosets withAdditionalData:shouldFetchAdditionalData] autorelease];
	}

- (void)fetchAdditionalData
	{
	SKAsynchronousFetcher* fetcher = [SKAsynchronousFetcher fetcher];
	NSURL* portraitURL = [NSURL URLWithString:[NSString stringWithFormat:SKGirlPortraitURLString, name]];
	[fetcher fetchDataAtURL:portraitURL withCompletionHandler:^(id fetchResult) {
	if([fetchResult isKindOfClass:[NSData class]])
		{
		self.portrait = [[[NSImage alloc] initWithData:fetchResult] autorelease];
		[self.portrait setName:self.name];
		}
	}];
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
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				for(NSString* key in [photosetDictionary allKeys])
					{
					SKPhotoset* photoset = [SKPhotoset photosetWithContentsOfURL:[photosetDictionary objectForKey:key] immediatelyLoadPhotos:NO delegate:nil];
					[photoset setGirl:self];
					if(photoset)
						[[self mutableArrayValueForKey:@"photosets"] addObject:photoset];
					}
				static dispatch_once_t onceToken;
				
				dispatch_once(&onceToken, ^{
					NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.photosets, SKGirlPhotosetsKey, nil];
    			[[NSNotificationCenter defaultCenter] postNotificationName:SKGirlPhotosetsDidFinishLoadingNotification object:self userInfo:userInfo];
				});	
			});
			}
		
		}
	
	[htmlDocument release];
	}

@end