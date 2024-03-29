//
//  Girl.h
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!
 * \class SKGirl SKGirl.h
 *
 * \author Felix Morgner
 *
 * \since 1.0
 *
 * \brief This class that represents a Suicide Girl
 *
 * This class represents a Suicide Girl. A girl has the following properties:
 * - name
 * - photosets
 *
 * Via this object you can access this information. As for photosets, you can either download all
 * the photos yourself or let SuicideKit do the heavy lifting for you. For more information please
 * take a look into the SKPhotoset documentation.
 */

static NSString* SKPhotosetIndexURLString = @"http://suicidegirls.com/girls/%@/pics/all/";
static NSString* SKGirlPhotosetsKey = @"photosets";
static NSString* SKGirlPhotosetsDidFinishLoadingNotification = @"SKGirlPhotosetsDidFinishLoadingNotification";
static NSString* SKGirlPortraitURLString = @"http://img.suicidegirls.com/media/girls/%@/girl_pic_small.jpg";

@interface SKGirl : NSObject

/*! @{
 * \name Initialization
 */

/*!
 * \param aName The name of the girl
 * \param thePhotosets The photoset associated with that girl
 * \param shouldFetchAdditionalData A BOOL indicating if you'd like SuicideKit to fetch additional data (birthday, etc.)
 *
 * \return A SKGirl object initialized with the name and photosets that were supplied
 *
 * \sa SKGirl#girlWithName:andPhotosets:withAdditionalData:
 *
 * \since 1.0
 *
 * \brief Initializes a newly allocated SKGirl object with the name and photosets that were supplied.
 *
 * This method initializes a newly allocated SKGirl object with the name and photosets that were supplied.
 */
- (id)initWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets withAdditionalData:(BOOL)shouldFetchAdditionalData;

/*!
 * \param aName The name of the girl
 * \param thePhotosets The photoset associated with that girl
 * \param shouldFetchAdditionalData A BOOL indicating if you'd like SuicideKit to fetch additional data (birthday, etc.)
 *
 * \return An autoreleased SKGirl object initialized with the name and photosets that were supplied
 *
 * \sa SKGirl#initWithName:andPhotosets:withAdditionalData:
 *
 * \since 1.0
 *
 * \brief Allocates and initializes an SKGirl object with the name and photosets that were supplied.
 *
 * This method allocates and initializes an SKGirl object with the name and photosets that were supplied.
 */
+ (SKGirl*)girlWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets withAdditionalData:(BOOL)shouldFetchAdditionalData;

/*! @} */

/*! @{
 * \name Aquiring data
 */

- (void)fetchAdditionalData;

- (void)fetchPhotosets;

/*! @} */


/*! @{
 * \name Properties
 */

@property(copy) NSString* name; /*!< The name of the girl*/
@property(copy) NSArray*  photosets; /*!< The photosets of the girl*/
@property(copy)	NSImage*  portrait;

/*! @} */

@end
