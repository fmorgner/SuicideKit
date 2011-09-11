//
//  Girl.h
//  SuicideBrowser
//
//  Created by Felix Morgner on 26.11.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SKGirl : NSObject

- (id) initWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets;

+ (SKGirl*) girlWithName:(NSString*)aName andPhotosets:(NSArray*)thePhotosets;

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSArray*  photosets;

@end
