//
//  FMRSSParser.h
//  Yet another XMLParser delegate for parsing RSS feeds.
//
//  Created by Felix Morgner on 01.07.10.
//  Copyright 2011 Felix Morgner.
//

/*!
 * \class FMRSSParser FMRSSParser.h
 *
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * \since 1.0
 *
 * \brief An object to use as a NSXMLParser delegate to parse an RSS feed
 *
 * This class can be used in conjuntion with NSXMLParser to parse RSS feeds. It implements all 3 common Cocoa
 * callback schemes to inform you about the state of the parsing. You can either listen for the
 * FMRSSParserDidFinishParsingNotification and FMRSSParserDidFailParsingNotification notifiactions, supply a 
 * delegate object implementing the FMRSSParserDelegate protocol or supply it with a block called the completionHandler.
 * On successful parsing, this class provides you with an NSArray object containing several NSDictionary object wich
 * represent each node in the RSS feed. On Failure it gives to an NSError object, describing the occured error.
 */

#import <Foundation/Foundation.h>

static NSString* FMRSSParserDidFinishParsingNotification = @"SKRSSParserDidFinishParsing"; /*!< The ParserDidFinish notification name*/
static NSString* FMRSSParserDidFailParsingNotification = @"SKRSSParserDidFailParsing"; /*!< The ParserDidFinish notification name*/

static NSString* FMRSSParserDocumentKey = @"parsedDocument"; /*!< The user info dictionary key for the parsed document*/
static NSString* FMRSSParserErrorKey = @"parseError"; /*!< The user info dictionary key for the parse error*/

static NSString* FMRSSParserErrorDomain = @"FMRSSParserErrorDomain"; /*!< The error domain for any errors that might occur*/

@protocol FMRSSParserDelegate; // forward declaration of the SKRSSParserDelegate protocol

@interface FMRSSParser : NSObject <NSXMLParserDelegate>
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
+ (FMRSSParser*)parserWithCompletionHandler:(void(^)(id parseResult))aCompletionHandler;

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
- (id)initWithDelegate:(id<FMRSSParserDelegate>)aDelegate;

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
+ (FMRSSParser*)parserWithDelegate:(id<FMRSSParserDelegate>)aDelegate;

/*! @} */
@end

/*!
 * \protocol FMRSSParserDelegate FMRSSParser.h
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

@protocol FMRSSParserDelegate

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
- (void) rssParserDidFinishParsing:(FMRSSParser*)theParser document:(NSArray*)aDocument;

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
- (void) rssParserDidFailParsing:(FMRSSParser*)theParser withError:(NSError*)anError;

@end