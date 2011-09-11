//
//  SKRSSParser.m
//  SuicideKit
//
//  Created by Felix Morgner on 01.07.10.
//  Copyright 2011 Felix Morgner.
//

#import "SKRSSParser.h"

@implementation SKRSSParser

#pragma mark - Initialization

- (id)initWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler
	{
	if((self = [super init]))
		{
		completionHandler = [aCompletionHandler copy];
		}
	
	return self;
	}
	
- (id)initWithDelegate:(id<SKRSSParserDelegate>)aDelegate
	{
	if((self = [super init]))
		{
		delegate = aDelegate;
		}
	
	return self;
	}

+ (SKRSSParser*)parserWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler
	{
	return [[[SKRSSParser alloc] initWithCompletionHandler:aCompletionHandler] autorelease];
	}

+ (SKRSSParser*)parserWithDelegate:(id<SKRSSParserDelegate>)aDelegate
	{
	return [[[SKRSSParser alloc] initWithDelegate:aDelegate] autorelease];
	}

#pragma mark - Parsing

- (void) parserDidStartDocument:(NSXMLParser *)parser
	{
	parsedDocument = [[NSMutableArray alloc] init];
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

#pragma mark - Parse result handling

- (void) parserDidEndDocument:(NSXMLParser *)parser
	{
	if(delegate && [delegate conformsToProtocol:@protocol(SKRSSParserDelegate)])
		{
		[delegate rssParserDidFinishParsing:self document:(NSArray*)parsedDocument];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:(NSArray*)parsedDocument forKey:SKRSSParserDocumentKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:SKRSSParserDidFinishParsingNotification object:self userInfo:userInfo];
	
	completionHandler((NSArray*)parsedDocument);
	}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
	{
	if(delegate && [delegate conformsToProtocol:@protocol(SKRSSParserDelegate)])
		{
		[delegate rssParserDidFailParsing:self withError:parseError];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:parseError forKey:SKRSSParserErrorKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:SKRSSParserDidFailParsingNotification object:self userInfo:userInfo];
	
	completionHandler(parseError);
	}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
	{
	if(delegate && [delegate conformsToProtocol:@protocol(SKRSSParserDelegate)])
		{
		[delegate rssParserDidFailParsing:self withError:validationError];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:validationError forKey:SKRSSParserErrorKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:SKRSSParserDidFailParsingNotification object:self userInfo:userInfo];
	
	completionHandler(validationError);
	}
@end
