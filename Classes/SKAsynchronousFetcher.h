//
//  SKAsynchronousFetcher.h
//  SuicideKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

/*!
 * \class SKAsynchronousFetcher SKAsynchronousFetcher.h
 *
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * \version 1.0
 *
 * \brief A class to asynchronously fetch data from the network.
 *
 * The SKAsynchronousFetcher class enables you to easily load data asynchronously from the network without
 * having to implement the NSURLConnectionDelegate. You can create an instance using SKAsynchronousFetcher#fetcher.
 * After you obtained a valid instance you call SKAsynchronousFetcher#fetchDataAtURL:withCompletionHandler:
 * supplying a URL and a completion handler in form of a block.
 */

#import <Foundation/Foundation.h>

@interface SKAsynchronousFetcher : NSObject <NSURLConnectionDelegate>
	{

	@private
    void (^completionHandler)(id);
		NSURL* url;
		NSMutableData* receivedData;

	}

/*! @{
 * \name Initialization
 */

/*!
 * \return An autoreleased SKAsynchronousFetcher object.
 *
 * \since 1.0
 *
 * \brief Allocate an initialize a SKAsynchronousFetcher object.
 *
 * This methods returns a newly allocated and initialized SKAsynchronousFetcher object. Returns nil if the
 * object could not be allocated.
 */
+ (SKAsynchronousFetcher*)fetcher;

/*! @} */

/*! @{
 * \name Data Fetching
 */

/*!
 * \param aURL The URL of the data you'd like to fetch
 * \param block The completion handler youd like to get run
 *
 * \return nothing
 *
 * \since 1.0
 *
 * \brief Asynchronously fetch data from the network.
 *
 * This method asynchronously fetches the data found at the location specified by aURL. I provides you with the result
 * of the fetch operation via the block you specify as the completion handler. Note that if an error happens this also
 * gets pushed to to your block, so you need to destinguish between the fetchResult being an error or the returned data.
 * You can do so by checking if the class of the fetchResult object is equal to NSError (in case of an error) or NSData
 * (in case of the received data).
 *
 * Sample usage:
 *
 * \code
 * [aFetcher fetchDataAtURL:someFancyURL withCompletionHandler:^(id fetchResult) {
 *   if([fetchResult isKindOfClass:[NSError class]])
 *		 {
 *     handleSomeError();
 *		 }
 *	 else
 *		 {
 *		 handleSomeData();
 *		 }
 *	 };
 * ];
 * \endcode 
 */
- (void)fetchDataAtURL:(NSURL*)aURL withCompletionHandler:(void (^)(id fetchResult))block;

/*! @ }*/
@end
