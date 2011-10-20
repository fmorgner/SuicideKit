//
//  NSString+FMStringAdditions.m
//  Suicide
//
//  Created by Felix Morgner on 04.10.10.
//  Copyright 2010 Felix Morgner. All rights reserved.
//

#import "NSString+FMStringAdditions.h"


@implementation NSString (FMStringAdditions)

- (NSString*) stringByTrimmingLeadingWhitespaces
	{
	NSInteger i = 0;

	while ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]])
		{
		i++;
    }
	
	return [self substringFromIndex:i];
	}


@end
