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
NSString *kPacifico = @"Pacifico";

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

+ (UIFont *) pacificoFont {    
    return [self fontWithName:kPacifico];
}

+ (UIFont *) pacificoFontWithSize:(float)size {
    return [self fontWithName:kPacifico size:size];
}

+ (UIFont *) fontWithName:(NSString *)name {
    return [UIFont fontWithName:name size:16.0];
}

+ (UIFont *) fontWithName:(NSString *)name size:(float)size {
    return [UIFont fontWithName:name size:size];
}

+ (void) listAllFonts {
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

@end
