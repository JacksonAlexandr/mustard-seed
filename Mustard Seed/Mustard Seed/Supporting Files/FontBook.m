//
//  FontBook.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/13/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "FontBook.h"

// Constants
NSString *kRobotoRegular = @"Roboto-Regular";
NSString *kRobotoBold = @"Roboto-Bold";

@implementation FontBook

+ (UIFont *) robotoFont {
    return [self fontWithName:kRobotoRegular];
}

+ (UIFont *) robotoFontWithSize:(float)size {
    return [self fontWithName:kRobotoRegular size:size];
}

+ (UIFont *) robotoBoldFont {
    return [self fontWithName:kRobotoBold];
}

+ (UIFont *) robotoBoldFontWithSize:(float)size {
    return [self fontWithName:kRobotoBold size:size];
}

+ (UIFont *) fontWithName:(NSString *)name {
    return [UIFont fontWithName:name size:16.0];
}

+ (UIFont *) fontWithName:(NSString *)name size:(float)size {
    return [UIFont fontWithName:name size:size];
}

@end
