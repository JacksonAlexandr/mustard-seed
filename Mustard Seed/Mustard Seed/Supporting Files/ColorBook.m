//
//  ColorBook.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/17/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "ColorBook.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ColorBook

+ (UIColor *) darkGreen {
    return UIColorFromRGB(0x2f635c);
}

+ (UIColor *) green {
    return UIColorFromRGB(0x63d2ac);
}

+ (UIColor *) lightGreen {
    return UIColorFromRGB(0xc1edde);
}

+ (UIColor *) hexColor:(int)hex {
    return UIColorFromRGB(hex);
}

@end
