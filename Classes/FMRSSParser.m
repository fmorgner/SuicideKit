//
//  FMRSSParser.m
//  Yet another XMLParser delegate for parsing RSS feeds.
//
//  Created by Felix Morgner on 01.07.10.
//  Copyright 2011 Felix Morgner.
//

#import "FMRSSParser.h"

@implementation FMRSSParser

#pragma mark - Initialization

- (id)initWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler
	{
	if((self = [super init]))
		{
		completionHandler = [aCompletionHandler copy];
		}
	
	return self;
	}
	
- (id)initWithDelegate:(id<FMRSSParserDelegate>)aDelegate
	{
	if((self = [super init]))
		{
		delegate = aDelegate;
		}
	
	return self;
	}

+ (FMRSSParser*)parserWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler
	{
	return [[[FMRSSParser alloc] initWithCompletionHandler:aCompletionHandler] autorelease];
	}

+ (FMRSSParser*)parserWithDelegate:(id<FMRSSParserDelegate>)aDelegate
	{
	return [[[FMRSSParser alloc] initWithDelegate:aDelegate] autorelease];
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
	if(delegate && [delegate conformsToProtocol:@protocol(FMRSSParserDelegate)])
		{
		[delegate rssParserDidFinishParsing:self document:(NSArray*)parsedDocument];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:(NSArray*)parsedDocument forKey:FMRSSParserDocumentKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:FMRSSParserDidFinishParsingNotification object:self userInfo:userInfo];
	
	completionHandler((NSArray*)parsedDocument);
	}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
	{
	if(delegate && [delegate conformsToProtocol:@protocol(FMRSSParserDelegate)])
		{
		[delegate rssParserDidFailParsing:self withError:parseError];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:parseError forKey:FMRSSParserErrorKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:FMRSSParserDidFailParsingNotification object:self userInfo:userInfo];
	
	completionHandler(parseError);
	}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
	{
	if(delegate && [delegate conformsToProtocol:@protocol(FMRSSParserDelegate)])
		{
		[delegate rssParserDidFailParsing:self withError:validationError];
		}

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:validationError forKey:FMRSSParserErrorKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:FMRSSParserDidFailParsingNotification object:self userInfo:userInfo];
	
	completionHandler(validationError);
	}
@end
