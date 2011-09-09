//
//  Photoset.h
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SKGirl;

@protocol SKPhotosetDelegate;

@interface SKPhotoset : NSObject

/*! @{
 * \name Initialization
 */

/*!
 * \param theURL The URL from which to load the information.
 * \param immediatelyLoadPhotos A boolean which let's you choose if you want to load the photos immediately.
 *
 * \return A SKPhotoset object initialized with the data from the location specified by aURL.
 *
 * \sa SKPhotoset#photoWithContentsOfURL:immediatelyLoadPhotos:
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKPhotoset object with the data from the location specified by aURL.
 *
 * This method initializes a newly allocated SKPhotoset object with the data from the location specified by aURL.
 * You can also specify if you want the object to automatically start loading the photos it contains.
 * If you supply NO as the second argument to this method, the object will only store information about
 * where to find the photos but doesn't load it. The loading of the photos happens asynchrounouly and you might
 * supply a delegate object which implements the SKPhotosetDelegate protocol.
 *
 * \discussion This is a blocking call since it uses blocking NSURLConnection calls. You have several options to
 * handle this situation. 
 * - Handle object instantiation and initialization on a seperate thread.
 * - Load the data yourself and use SKPhotoset#initWithData:immediatelyLoadPhotos:delegate:
 * - Instantiate an "empty" instance of SKPhotoset and use SKPhotoset#loadContensAtURL:immediatelyLoadPhotos:delegate:
 * - Do URL loading and the potential photo loading yourself and use SKPhotoset#initWithURLs:photos:
 */
- (id)initWithContentsOfURL:(NSURL*)aURL immediatelyLoadPhotos:(BOOL)immediatelyLoadPhotos delegate:(id<SKPhotosetDelegate>)aDelegate; 

/*!
 * \param theURL The URL from which to load the information.
 * \param immediatelyLoadPhotos A boolean which let's you choose if you want to load the photos immediately.
 *
 * \return An autoreleased SKPhotoset object initialized with the data from the location specified by aURL. Returns
 * nil if the SKPhotoset could not be created.
 *
 *
 * \sa SKPhotoset#initWithContentsOfURL:immediatelyLoadPhotos:
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKPhotoset object with the data from the location specified by aURL.
 *
 * This method returns a SKPhotoset object with the data from the location specified by aURL.
 * You can also specify if you want the object to automatically start loading the photos it contains.
 * If you supply NO as the second argument to this method, the object will only store information about
 * where to find the photos but doesn't load it. The loading of the photos happens asynchrounouly and you might
 * supply a delegate object which implements the SKPhotosetDelegate protocol.
 *
 * \discussion This is a blocking call since it uses blocking NSURLConnection calls to download the required data.
 * Please note that the loading of the photos is _NONBLOCKING_. You have several options to handle this situation. 
 * - Handle object instantiation and initialization on a seperate thread.
 * - Load the data yourself and use SKPhotoset#photosetWithData:immediatelyLoadPhotos:delegate:
 * - Instantiate an "empty" instance of SKPhotoset and use SKPhotoset#loadContensAtURL:immediatelyLoadPhotos:delegate:
 * - Do URL loading and the potential photo loading yourself and use SKPhotoset#photosetWithURLs:photos:
 */
- (SKGirl*)photosetWithContentsOfURL:(NSURL*)theURL immediatelyLoadPhotos:(BOOL)immediatelyLoadPhotos delegate:(id<SKPhotosetDelegate>)aDelegate;

/*! @} */
- (void)loadPhotos;

@property(retain) NSString* title;
@property(retain) NSArray*  photos;
@property(retain) NSArray*  URLs;
@property(assign) SKGirl*   girl;

@end

@protocol SKPhotosetDelegate

@required
	-(void)photoset:(SKPhotoset*)thePhotoset didFinishLoadingPhotos:(NSArray*)thePhotos;
	-(void)photosetDidFailLoadingPhotos:(SKPhotoset *)thePhotoset withError:(NSError*)anError;
	
@end