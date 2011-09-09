//
//  PNRSSParserDelegate.h
//  Polizeinews
//
//  Created by Felix Morgner on 01.07.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKRSSParser : NSObject <NSXMLParserDelegate>
	{
	@public
		NSArray* result;
		
	@private
		NSString* currentElement;
		
		NSMutableString* currentTitle;
		NSMutableString* currentLink;
		NSMutableString* currentDescription;
		NSMutableString* currentDate;
		
		NSMutableDictionary* currentItem;
		
		NSMutableArray* parsedDocument;
		
		id delegate;
	}

- (void) setDelegate:(id)aDelegate;

@property(nonatomic,retain) NSArray* result;

@end

@protocol FMRSSParserDelegate

- (void) rssParserDidFinishParsing:(SKRSSParser*)theParser;

@end