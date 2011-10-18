//
//  Photoset.h
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

/*!
 * \class SKPhotoset
 *
 * \author Felix Morgner
 *
 * \since 1.0
 *
 * \brief This class represents a SuicideGirls photoset
 *
 * This class represents a SuicideGirls photoset. Each photoset consists of a certain number of photos. A photoset
 * is associated with a specific girl. You can either load the photos your self or let the SuicideKit do the heavy
 * lifting for you, which is the recommended way. Please note that a photoset is always associated with a single
 * girl, even though there can be multiple girls in the shot. This is due to limitation of the SuicideGirls website.
 */

#import <Cocoa/Cocoa.h>

@class SKGirl;

@protocol SKPhotosetDelegate;

@interface SKPhotoset : NSObject

/*! @{
 * \name Initialization
 */

/*!
 * \param aURL The URL from which to load the information.
 * \param immediatelyLoadPhotos A boolean which let's you choose if you want to load the photos immediately.
 * \param aDelegate An object that implements the SKPhotosetDelegate protocol
 *
 * \return A SKPhotoset object initialized with the data from the location specified by aURL.
 *
 * \sa SKPhotoset#photosetWithContentsOfURL:immediatelyLoadPhotos:delegate:
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKPhotoset object with the data from the location specified by aURL.
 *
 * This method initializes a newly allocated SKPhotoset object with the data from the location specified by aURL.
 * You can also specify if you want the object to automatically start loading the photos it contains.
 * If you supply NO as the second argument to this method, the object will only store information about
 * where to find the photos but doesn't load it. The loading of the photos happens asynchrounouly and you might
 * supply a delegate object which implements the SKPhotosetDelegate protocol. This is a blocking call since it uses blocking NSURLConnection calls. You have several options to
 * handle this situation. 
 * - Handle object instantiation and initialization on a seperate thread.
 * - Load the data yourself and use SKPhotoset#initWithData:immediatelyLoadPhotos:delegate:
 * - Instantiate an "empty" instance of SKPhotoset and use SKPhotoset#loadContensAtURL:immediatelyLoadPhotos:delegate:
 * - Do URL loading and the potential photo loading yourself and use SKPhotoset#initWithURLs:photos:
 */
- (id)initWithContentsOfURL:(NSURL*)aURL immediatelyLoadPhotos:(BOOL)immediatelyLoadPhotos delegate:(id<SKPhotosetDelegate>)aDelegate; 

/*!
 * \param aURL The URL from which to load the information.
 * \param immediatelyLoadPhotos A boolean which let's you choose if you want to load the photos immediately.
 * \param aDelegate An object that implements the SKPhotosetDelegate protocol
 *
 * \return An autoreleased SKPhotoset object initialized with the data from the location specified by aURL. Returns
 * nil if the SKPhotoset could not be created.
 *
 *
 * \sa SKPhotoset#initWithContentsOfURL:immediatelyLoadPhotos:delegate:
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKPhotoset object with the data from the location specified by aURL.
 *
 * This method returns a SKPhotoset object with the data from the location specified by aURL.
 * You can also specify if you want the object to automatically start loading the photos it contains.
 * If you supply NO as the second argument to this method, the object will only store information about
 * where to find the photos but doesn't load it. The loading of the photos happens asynchrounouly and you might
 * supply a delegate object which implements the SKPhotosetDelegate protocol. This is a blocking call since it uses blocking NSURLConnection calls to download the required data.
 * Please note that the loading of the photos is _NONBLOCKING_. You have several options to handle this situation. 
 * - Handle object instantiation and initialization on a seperate thread.
 * - Load the data yourself and use SKPhotoset#photosetWithData:immediatelyLoadPhotos:delegate:
 * - Instantiate an "empty" instance of SKPhotoset and use SKPhotoset#loadContensAtURL:immediatelyLoadPhotos:delegate:
 * - Do URL loading and the potential photo loading yourself and use SKPhotoset#photosetWithURLs:photos:
 */
+ (SKPhotoset*)photosetWithContentsOfURL:(NSURL*)aURL immediatelyLoadPhotos:(BOOL)immediatelyLoadPhotos delegate:(id<SKPhotosetDelegate>)aDelegate;

/*! @} */

/*! @{
 * \name Photo Loading
 */

/*!
 * \return nothing
 *
 * \sa SKPhotoset#initWithContentsOfURL:immediatelyLoadPhotos:delegate:
 * \sa SKPhotoset#photosetWithContentsOfURL:immediatelyLoadPhotos:delegate:
 *
 * \since 1.0
 *
 * \brief This method loads the photos contained in a photoset
 *
 * This method loads the photos contained in a photoset
 */
- (void)loadPhotos;

/*! @} */

/*! @{
 * \name Properties
 */

@property(retain) NSString* title; /*!< The title of the photoset*/
@property(retain) NSArray*  photos; /*!< The photos included in the photoset*/
@property(retain) NSArray*  URLs; /*!< The URLs of the photos included in the photoset*/
@property(assign) SKGirl*   girl; /*!< The girl featured in the photoset*/

/*! @} */

@end

/*!
 * \protocol SKPhotosetDelegate
 *
 * \since 1.0
 *
 * \brief Implement these methods on your delegate to get informed on photoset photo changes
 *
 * You can implement these methods on your delegate to get informed whenever the photos of a photoset get changed.
 * Changes to to photos happen while the photos get loaded from the network. These methods also inform you about errors
 * while trying to load the photos.
 */

@protocol SKPhotosetDelegate

@required

/*!
 * \param thePhotoset The Photoset wich called this method.
 * \param thePhotos The photos that were loaded.
 *
 * \return nothing
 *
 * \sa SKPhotosetDelegate#photosetDidFailLoadingPhotos:withError:
 *
 * \since 1.0
 *
 * \brief This method gets called when a SKPhotoset finishes loading of all photos.
 *
 * This method gets called when a SKPhotoset finishes loading of all photos. It provides you with the list of photos
 * that were loaded. This method also gets called if some photos could not be loaded.
 */
-(void)photoset:(SKPhotoset*)thePhotoset didFinishLoadingPhotos:(NSArray*)thePhotos;

/*!
 * \param thePhotoset The Photoset wich called this method.
 * \param anError An NSError object representing the occured error.
 *
 * \return nothing
 *
 * \sa SKPhotosetDelegate#photoset:didFinishLoadingPhotos:
 *
 * \since 1.0
 *
 * \brief This method gets called when a SKPhotoset fails loading of all photos.
 *
 * This method gets called when a SKPhotoset fail loading of all photos. It provides you with an NSError object representing
 * the occured error.
 */
-(void)photosetDidFailLoadingPhotos:(SKPhotoset *)thePhotoset withError:(NSError*)anError;
	
@end
