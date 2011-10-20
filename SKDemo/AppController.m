//
//  AppController.m
//  SuicideKit
//
//  Created by Felix Morgner on 18.10.11.
//  Copyright (c) 2011 Felix Morgner. All rights reserved.
//

#import "AppController.h"
#import <SuicideKit/SKGirl.h>
#import <SuicideKit/SKPhotoset.h>

@implementation AppController

@synthesize girlNameField;
@synthesize photosetCountField;
@synthesize fetchButton;
@synthesize photosetDropdown;
@synthesize downloadButton;
@synthesize girlPortraitView;
@synthesize downloadIndicator;
@synthesize theGirl;
@synthesize downloadCount;
@synthesize finishedDownloadCount;

- (void)awakeFromNib
	{
	[photosetDropdown removeAllItems];
	[girlPortraitView setImage:[NSImage imageNamed:@"sg_logo"]];
	}

- (IBAction)fetchPhotosets:(id)sender
	{
	self.theGirl = [SKGirl girlWithName:[girlNameField stringValue] andPhotosets:nil withAdditionalData:NO];
	NSObjectController* girlController = [[NSObjectController alloc] init];
	[girlController bind:@"content" toObject:self withKeyPath:@"theGirl" options:nil];
	[girlPortraitView bind:@"value" toObject:girlController withKeyPath:@"selection.portrait" options:nil];
	[fetchButton setEnabled:NO];
	[theGirl fetchAdditionalData];
	[theGirl fetchPhotosets];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photosetsDidFinishLoading:) name:SKGirlPhotosetsDidFinishLoadingNotification object:theGirl];
	[theGirl addObserver:self forKeyPath:@"photosets" options:NSKeyValueObservingOptionNew context:NULL];
	}

- (IBAction)downloadPhotoset:(id)sender
	{
	SKPhotoset* selectedPhotoset = [[theGirl photosets] objectAtIndex:[photosetDropdown indexOfSelectedItem]];
	
	self.downloadCount = [[selectedPhotoset URLs] count];
	self.finishedDownloadCount = 0;
	
	int i = 1;
	
	NSString* downloadPath = [@"~/Downloads/" stringByExpandingTildeInPath];
	downloadPath = [downloadPath stringByAppendingFormat:@"/%@/%@", [theGirl name], [selectedPhotoset title]];
	
	[downloadIndicator setMaxValue:downloadCount];
	[downloadIndicator setDoubleValue:finishedDownloadCount];
	
	[[NSFileManager defaultManager] createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	for(NSURL* photoURL in [selectedPhotoset URLs])
		{
		NSURLDownload* photoDownload = [[NSURLDownload alloc] initWithRequest:[NSURLRequest requestWithURL:photoURL] delegate:self];
		if(i < 10)
			[photoDownload setDestination:[downloadPath stringByAppendingFormat:@"/0%i.jpg", i] allowOverwrite:NO];
		else
			[photoDownload setDestination:[downloadPath stringByAppendingFormat:@"/%i.jpg", i] allowOverwrite:NO];
		i++;
		}
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	int numberOfPhotosets = [[object photosets] count];
	
	[photosetCountField setIntValue:numberOfPhotosets];
	}
	
- (void)photosetsDidFinishLoading:(NSNotification*)aNotification
	{
	[photosetDropdown removeAllItems];
	NSArray* photosets = [theGirl photosets];
	
	for(SKPhotoset* photoset in photosets)
		{
		[photosetDropdown addItemWithTitle:[photoset title]];
		}
	
	[fetchButton setEnabled:YES];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SKGirlPhotosetsDidFinishLoadingNotification object:theGirl];
	[theGirl removeObserver:self forKeyPath:@"photosets"];
	}

- (void)downloadDidFinish:(NSURLDownload *)download
	{
	self.finishedDownloadCount++;
	[downloadIndicator setDoubleValue:finishedDownloadCount];
	[download release];
	}

- (void)dealloc
	{
	[theGirl release];
	}
	
@end
