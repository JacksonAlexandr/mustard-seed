//
//  ColorBook.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/17/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorBook : NSObject

+ (UIColor *) lightGreen;
+ (UIColor *) green;
+ (UIColor *) darkGreen;
+ (UIColor *) hexColor: (int) hex;

@end
