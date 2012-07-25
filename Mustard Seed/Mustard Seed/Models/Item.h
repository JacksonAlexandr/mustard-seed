//
//  Item.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (readonly) NSString *itemID;
@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) NSString * owner;
@property (readonly) NSURL * imgURL;
@property (readonly) NSURL * commerceURL;
@property (readonly) NSUInteger viewCount;
@property (nonatomic, assign) BOOL favorite;

- (id) initWithAttributes:(NSDictionary *) attributes;
- (void) toggleFavorite;

+ (void) itemsWithBlock:(void (^)(NSArray * items))block;
+ (void) favoriteItemsWithBlock:(void (^)(NSArray * items))block;

+ (void) postRequest:(NSString *)request;

@end
