//
//  SuicideGirl.m
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "SKGirl.h"

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
	
	}

@end
