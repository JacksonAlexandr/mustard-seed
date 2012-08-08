//
//  Item.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Category;

@interface Item : NSObject

@property (readonly) NSString *itemID;
@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) NSString *owner;
@property (readonly) Category *category;
@property (readonly) NSURL * imgURL;
@property (readonly) NSURL * commerceURL;
@property (readonly) NSUInteger viewCount;
@property (nonatomic, assign) BOOL favorite;

- (id) initWithAttributes:(NSDictionary *) attributes;
- (void) setCategory:(Category *)category;
- (void) toggleFavorite;

+ (void) itemsWithBlock:(void (^)(NSArray * items))block;
+ (void) favoriteItemsWithBlock:(void (^)(NSArray * items))block;
+ (void) itemsWithBlock:(void (^)(NSArray * items))block parameters: (NSDictionary *) parameters;

+ (void) postRequest:(NSString *)request;

@end
