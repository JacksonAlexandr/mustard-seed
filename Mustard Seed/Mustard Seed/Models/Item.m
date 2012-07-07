//
//  Item.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Item.h"
#import "AFMustardSeedAPIClient.h"

@implementation Item {
@private
    NSUInteger _itemID;
    NSString *_name;
    NSString *_description;
    NSString *_owner;
    NSURL *_imgURL;
    NSURL *_commerceURL;
    NSUInteger _viewCount;
}

@synthesize itemID = _itemID;
@synthesize name = _name;
@synthesize description = _description;
@synthesize owner = _owner;
@synthesize imgURL = _imgURL;
@synthesize commerceURL = _commerceURL;
@synthesize viewCount = _viewCount;
    
- (id) initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemID = [[attributes valueForKey:@"_id"] integerValue];
    _name = [attributes valueForKey:@"name"];
    _owner = [attributes valueForKey:@"owner"];
    _description = [attributes valueForKey:@"description"];
    _imgURL = [NSURL URLWithString:[attributes valueForKey:@"img_url"]];
    _commerceURL = [NSURL URLWithString:[attributes valueForKey:@"commerce_url"]];
    _viewCount = [[attributes valueForKey:@"view_count"] integerValue];
    
    return self;
}

#pragma mark -

+ (void)itemsWithBlock:(void (^)(NSArray *items))block {
    [[AFMustardSeedAPIClient sharedClient] getPath:@"items" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            Item * item = [[Item alloc] initWithAttributes:attributes];
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
