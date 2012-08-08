//
//  Category.m
//  Mustard Seed
//
//  Created by Isaac Wang on 8/6/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "Category.h"

#import "AFMustardSeedAPIClient.h"

@implementation Category {
    NSString *_name;
    NSString *_categoryID;
}

static NSMutableDictionary *_categories;

@synthesize categoryID = _categoryID;
@synthesize name = _name;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = [attributes valueForKey:@"name"];
    _categoryID = [attributes valueForKey:@"_id"];
    
    return self;
}

// Returns cached value of categories
+ (NSDictionary *)cachedCategories {
    if (!_categories || [_categories count] == 0) {
        _categories = [[NSMutableDictionary alloc] init];
        
        // Populate _categories
        [Category populateCategories];
    }
    
    return _categories;
}

// Calls API to populate cached categories dictionary
+ (void) populateCategories {
    // Populate _categories
    [Category categoriesWithBlock:^(NSArray *categories) {
        for (Category *category in categories) {
            [_categories setObject: category forKey: category.categoryID];
        }
    }];
}

+ (void)categoriesWithBlock:(void (^)(NSArray *categories))block {
    [[AFMustardSeedAPIClient sharedClient] getPath:@"category" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableCategories = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            Category * category = [[Category alloc] initWithAttributes:attributes];
            [mutableCategories addObject:category];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableCategories]);
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

// Adds a category to the database, updates cache, and calls block
+ (void) addCategory:(NSString *)category withBlock:(void (^)(NSString *categoryID))block {
    // Initialize NSDictionary command
    NSError *error;
    NSDictionary *data = [NSDictionary dictionaryWithObject: category forKey:@"name"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data 
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Make network call
    [[AFMustardSeedAPIClient sharedClient] postPath:@"category" parameterString:jsonString success:^(AFHTTPRequestOperation *operation, id JSON) {
        // Add to _categories
        NSString *categoryID = [JSON objectForKey:@"_id"];
        NSLog(@"Add Category Success with response %@ of type %@", categoryID, [JSON class]);
        
        // Update cache
        Category *newCategory = [[Category alloc] init];
        newCategory.name = category;
        newCategory.categoryID = categoryID;
        [_categories setObject:newCategory forKey:categoryID];
        
        if (block)
            block(categoryID);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end