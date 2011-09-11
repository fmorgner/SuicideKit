//
//  SKRSSParser.m
//  SuicideKit
//
//  Created by Felix Morgner on 01.07.10.
//  Copyright 2011 Felix Morgner.
//

#import "SKRSSParser.h"

@implementation SKRSSParser

@synthesize result;

- (void) setDelegate:(id)aDelegate
	{
	delegate = [aDelegate retain];
	}

- (void) parserDidStartDocument:(NSXMLParser *)parser
	{
	parsedDocument = [[NSMutableArray alloc] init];
	}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
	{
	}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
	{	
	currentElement = [elementName copy];
	
	if([currentElement isEqualToString:@"item"])
		{
		currentItem = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentDescription = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		}
	}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	{
	if([elementName isEqualToString:@"item"])
		{
		[currentItem setObject:currentTitle forKey:@"title"];
		[currentItem setObject:[currentLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"link"];
		[currentItem setObject:currentDescription forKey:@"description"];
		[currentItem setObject:currentDate forKey:@"date"];
		[parsedDocument addObject:currentItem];
		}
	}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
	{
	if([currentElement isEqualToString:@"title"])
		{
		[currentTitle appendString:string];
		}
	else if([currentElement isEqualToString:@"link"])
		{
		[currentLink appendString:string];
		}
	else if([currentElement isEqualToString:@"description"])
		{
		[currentDescription appendString:string];
		}
	else if([currentElement isEqualToString:@"pubDate"])
		{
		[currentDate appendString:string];
		}
	}

- (void) parserDidEndDocument:(NSXMLParser *)parser
	{
	[self setResult:(NSArray*)[parsedDocument copy]];
	
	if(delegate && [delegate respondsToSelector:@selector(rssParserDidFinishParsing:)])
		{
		[delegate rssParserDidFinishParsing:self];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:result forKey:@"parsedDocument"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FMRSSParserFinishedParsing" object:self userInfo:userInfo];
	}
@end
