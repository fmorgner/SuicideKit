//
//  SKRSSParser.h
//  SuicideKit
//
//  Created by Felix Morgner on 01.07.10.
//  Copyright 2011 Felix Morgner.
//

/*!
 * \class SKRSSParser SKRSSParser.h
 *
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * \since 1.0
 *
 * \brief An object to use as a NSXMLParser delegate to parse an RSS feed
 *
 * This class can be used in conjuntion with NSXMLParser to parse RSS feeds. It implements all 3 common Cocoa
 * callback schemes to inform you about the state of the parsing. You can either listen for the
 * SKRSSParserDidFinishParsingNotification and SKRSSParserDidFailParsingNotification notifiactions, supply a 
 * delegate object implementing the SKRSSParserDelegate protocol or supply it with a block called the completionHandler.
 * On successful parsing, this class provides you with an NSArray object containing several NSDictionary object wich
 * represent each node in the RSS feed. On Failure it gives to an NSError object, describing the occured error.
 */

#import <Foundation/Foundation.h>

static NSString* SKRSSParserDidFinishParsingNotification = @"SKRSSParserDidFinishParsing"; /*!< The ParserDidFinish notification name*/
static NSString* SKRSSParserDidFailParsingNotification = @"SKRSSParserDidFailParsing"; /*!< The ParserDidFinish notification name*/

static NSString* SKRSSParserDocumentKey = @"parsedDocument"; /*!< The user info dictionary key for the parsed document*/
static NSString* SKRSSParserErrorKey = @"parseError"; /*!< The user info dictionary key for the parse error*/

@protocol SKRSSParserDelegate; // forward declaration of the SKRSSParserDelegate protocol

@interface SKRSSParser : NSObject <NSXMLParserDelegate>
	{
	@private
		NSString* currentElement;
		
		NSMutableString* currentTitle;
		NSMutableString* currentLink;
		NSMutableString* currentDescription;
		NSMutableString* currentDate;
		
		NSMutableDictionary* currentItem;
		
		NSMutableArray* parsedDocument;
		
		id delegate;
		
		void (^completionHandler)(id);
	}

/*! @{
 * \name Instantiation and Initialisation
 */

/*!
 * \param aCompletionHandler A block that gets called when parsing ends.
 *
 * \return A initiliazed SKRSSParser object.
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKRSSParser object
 *
 * This method initializes a newly allcoated SKRSSParser object and sets the comletionHandler ivar to be the block you supply.
 */
- (id)initWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler;

/*!
 * \param aCompletionHandler A block that gets called when parsing ends.
 *
 * \return An autoreleased SKRSSParser object.
 *
 * \since 1.0
 *
 * \brief Allocates and initializes an autoreleased SKRSSParser object
 *
 * This method allocates and initializes an autoreleased SKRSSParser object and sets the comletionHandler ivar to be the block you supply.
 */
+ (SKRSSParser*)parserWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler;

/*!
 * \param aDelegate An object that implements the SKRSSParser delegate protocol
 *
 * \return A initiliazed SKRSSParser object.
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKRSSParser object
 *
 * This method initializes a newly allcoated SKRSSParser object and sets the delegate ivar to be the object you supply.
 * Your delegate object must implement the SKRSSParserDelegate protocol.
 */
- (id)initWithDelegate:(id<SKRSSParserDelegate>)aDelegate;

/*!
 * \param aDelegate An object that implements the SKRSSParser delegate protocol
 *
 * \return A initiliazed SKRSSParser object.
 *
 * \since 1.0
 *
 * \brief Allocates and initializes an autoreleased SKRSSParser object
 *
 * This method allocates and initializes an autoreleased SKRSSParser object and sets the delegate ivar to be the object you supply.
 * Your delegate object must implement the SKRSSParserDelegate protocol.
 */
+ (SKRSSParser*)parserWithDelegate:(id<SKRSSParserDelegate>)aDelegate;

/*! @} */
@end

/*!
 * \protocol SKRSSParserDelegate SKRSSParser.h
 *
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * \since 1.0
 *
 * \brief This protocol defines the methods your object must implement to function as a delegate for SKRSSParser
 *
 * This protocol defines the methods your object must implement to function as a delegate for SKRSSParser. If you want to use the
 * delegation scheme supported by SKRSSParser your delegate object must implement all of these methods. You can use the delegation
 * scheme to be informed when ever an error occurs or the parsing finishes.
 */

@protocol SKRSSParserDelegate

@required

/*!
 * \param theParser The object that invoked the method
 * \param aDocument The parse result
 *
 * \return nothing
 *
 * \brief This method gets called whenever parsing finishes.
 *
 * This method gets called whenever parsing finishes. It supplies you with the parsed document in the form of an NSArray of NSDictionary objects
 * of which each one represents an entry in the RSS feed.
 */
- (void) rssParserDidFinishParsing:(SKRSSParser*)theParser document:(NSArray*)aDocument;

/*!
 * \param theParser The object that invoked the method
 * \param anError The error that occured
 *
 * \return nothing
 *
 * \brief This methods gets called whenever an error occurs
 *
 * This methods gets called whenever an error occurs. Errors include parse errors and validation errors. You might examine the supplied anError
 * object to handle the occured error. For more information refer to the Apple Developer Documentation on the NSXMLParserDelegate protocol.
 */
- (void) rssParserDidFailParsing:(SKRSSParser*)theParser withError:(NSError*)anError;

@end