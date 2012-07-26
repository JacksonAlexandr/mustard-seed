//
//  FontBook.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/13/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontBook : NSObject {
    
}

+ (UIFont*) robotoFont;
+ (UIFont*) robotoFontWithSize:(float) size;
+ (UIFont*) robotoBoldFont;
+ (UIFont*) robotoBoldFontWithSize:(float) size;
+ (UIFont*) pacificoFont;
+ (UIFont*) pacificoFontWithSize:(float) size;

+ (void) listAllFonts;

@end
