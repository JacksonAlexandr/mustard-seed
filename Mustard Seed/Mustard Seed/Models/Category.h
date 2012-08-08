//
//  Category.h
//  Mustard Seed
//
//  Created by Isaac Wang on 8/6/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject <NSCopying>

@property (strong) NSString *categoryID;
@property (strong) NSString *name;

- (id) initWithAttributes:(NSDictionary *)attributes;
- (id) copyWithZone: (NSZone *) zone;

+ (void) categoriesWithBlock:(void (^)(NSDictionary *categories))block;
+ (void) addCategory:(NSString *)category withBlock:(void (^)(NSString *categoryID))block;
+ (NSDictionary *) cachedCategories;
+ (void) populateCategories;

@end
