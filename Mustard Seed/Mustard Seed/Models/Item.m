//
//  Item.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Item.h"

#import "Category.h"
#import "AFMustardSeedAPIClient.h"

@implementation Item {
@private
    NSString *_itemID;
    NSString *_name;
    NSString *_description;
    NSString *_owner;
    NSURL *_imgURL;
    NSURL *_commerceURL;
    NSUInteger _viewCount;
    Category *_category;
    BOOL _favorite;
}

@synthesize itemID = _itemID;
@synthesize name = _name;
@synthesize description = _description;
@synthesize owner = _owner;
@synthesize imgURL = _imgURL;
@synthesize commerceURL = _commerceURL;
@synthesize viewCount = _viewCount;
@synthesize favorite = _favorite;
@synthesize category = _category;
    
- (id) initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemID = [attributes valueForKey:@"_id"];
    _name = [attributes valueForKey:@"name"];
    _owner = [attributes valueForKey:@"owner"];
    _description = [attributes valueForKey:@"description"];
    _imgURL = [NSURL URLWithString:[attributes valueForKey:@"img_url"]];
    _commerceURL = [NSURL URLWithString:[attributes valueForKey:@"commerce_url"]];
    _viewCount = [[attributes valueForKey:@"view_count"] integerValue];
    _favorite = [[attributes valueForKey:@"favorite"] boolValue];
    
    // TODO: Store category name + ID in JSON as nested object
    _category = [[Category alloc] init];
    _category.categoryID = [attributes valueForKey:@"categoryID"];
    
    return self;
}

- (void) toggleFavorite {    
    [self setFavorite:!_favorite];
}

- (void) setCategory:(Category *)category {
    _category = category;
    
    // Update backend
    NSString *path = [NSString stringWithFormat:@"items/%@", _itemID];
    NSError *error;
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject: category.categoryID forKey:@"categoryID"] forKey:@"$set"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data 
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    // Make network call
    [[AFMustardSeedAPIClient sharedClient] putPath:path parameterString:jsonString success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

+ (void) postRequest:(NSString *) request {
    // Initialize NSDictionary command
    NSError *error;
    NSDictionary *data = [NSDictionary dictionaryWithObject: request forKey:@"name"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data 
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    // Make network call
    [[AFMustardSeedAPIClient sharedClient] postPath:@"requests" parameterString:jsonString success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void) setFavorite:(BOOL)favorite {
    _favorite = favorite;
    
    // Initialize NSDictionary command
    NSString *path = [NSString stringWithFormat:@"items/%@", _itemID];
    NSError *error;
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject: [NSNumber numberWithBool:favorite] forKey:@"favorite"] forKey:@"$set"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data 
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    // Make network call
    [[AFMustardSeedAPIClient sharedClient] putPath:path parameterString:jsonString success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark -

+ (void)itemsWithBlock:(void (^)(NSArray *items))block {
    [[AFMustardSeedAPIClient sharedClient] getPath:@"items" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        [Category categoriesWithBlock:^(NSDictionary *categories) {
            NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *attributes in JSON) {
                Item * item = [[Item alloc] initWithAttributes:attributes];
                item.category = [categories objectForKey:item.category.categoryID];
                [mutableItems addObject:item];
            }
            
            if (block) {
                block([NSArray arrayWithArray:mutableItems]);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {        
#if __IPHONE_OS_VERSION_MIN_REQUIRED
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
#else
        [[NSAlert alertWithMessageText:NSLocalizedString(@"Error", nil) defaultButton:NSLocalizedString(@"OK", nil) alternateButton:nil otherButton:nil informativeTextWithFormat:[error localizedDescription]] runModal];  
#endif
        if (block) {
            block(nil);
        }
    }];
}

+ (void)favoriteItemsWithBlock:(void (^)(NSArray *items))block {
    [[AFMustardSeedAPIClient sharedClient] getPath:@"items" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        [Category categoriesWithBlock:^(NSDictionary *categories) {
            NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *attributes in JSON) {
                Item * item = [[Item alloc] initWithAttributes:attributes];
                if (!item.category.categoryID)
                    continue;
                item.category = [categories objectForKey:item.category.categoryID];
                [mutableItems addObject:item];
            }
            
            if (block) {
                block([NSArray arrayWithArray:mutableItems]);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {        
#if __IPHONE_OS_VERSION_MIN_REQUIRED
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
#else
        [[NSAlert alertWithMessageText:NSLocalizedString(@"Error", nil) defaultButton:NSLocalizedString(@"OK", nil) alternateButton:nil otherButton:nil informativeTextWithFormat:[error localizedDescription]] runModal];  
#endif
        if (block) {
            block(nil);
        }
    }];
}

+ (void)itemsWithBlock:(void (^)(NSArray *items))block 
            parameters:(NSDictionary *) parameters {
    [[AFMustardSeedAPIClient sharedClient] getPath:@"items" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            Item * item = [[Item alloc] initWithAttributes:attributes];
            
            // Check all parameters
            BOOL add = true;
            for (int i = 0; i < parameters.allKeys.count; ++i) {
                NSString *key = [parameters.allKeys objectAtIndex:i];
                NSString *value = [parameters.allValues objectAtIndex:i];
                
                if (key == @"category" && item.category.name != value) {
                    add = false;
                    break;
                }
            }
            
            if (add)
                [mutableItems addObject:item];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableItems]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {        
#if __IPHONE_OS_VERSION_MIN_REQUIRED
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
#else
        [[NSAlert alertWithMessageText:NSLocalizedString(@"Error", nil) defaultButton:NSLocalizedString(@"OK", nil) alternateButton:nil otherButton:nil informativeTextWithFormat:[error localizedDescription]] runModal];  
#endif
        if (block) {
            block(nil);
        }
    }];
}

@end
