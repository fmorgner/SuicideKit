//
//  PhotosetParser.h
//  SuicideBrowser
//
//  Created by Felix Morgner on 07.12.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SKPhotoset;

@interface SKPhotosetParser : NSObject
	{
	}

- (id)initWithURL:(NSURL*)aURL;

- (void) parsePhotosetAtURL:(NSURL*)aURL;
- (void) parse;

@property(nonatomic, retain) NSString* htmlDocument;
@property(nonatomic, retain) SKPhotoset* parserResult;

@end
