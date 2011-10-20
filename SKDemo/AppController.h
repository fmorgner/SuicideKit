//
//  AppController.h
//  SuicideKit
//
//  Created by Felix Morgner on 18.10.11.
//  Copyright (c) 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKGirl;

@interface AppController : NSObject <NSURLDownloadDelegate>

- (IBAction)fetchPhotosets:(id)sender;
- (IBAction)downloadPhotoset:(id)sender;
- (void)photosetsDidFinishLoading:(NSNotification*)aNotification;

@property (assign) IBOutlet NSTextField *girlNameField;
@property (assign) IBOutlet NSTextField *photosetCountField;
@property (assign) IBOutlet NSButton *fetchButton;
@property (assign) IBOutlet NSPopUpButton *photosetDropdown;
@property (assign) IBOutlet NSButton *downloadButton;
@property (assign) IBOutlet NSImageView *girlPortraitView;
@property (assign) IBOutlet NSProgressIndicator *downloadIndicator;
@property (retain) SKGirl* theGirl;

@property (assign) NSInteger downloadCount;
@property (assign) NSInteger finishedDownloadCount;

@end
