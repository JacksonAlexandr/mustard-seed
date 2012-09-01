//
//  Item.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Item.h"
#import "GANTracker.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "ActionSheetPicker.h"

#import "Category.h"
#import "AFMustardSeedAPIClient.h"
#import "Constants.h"

@implementation Item {
@private
    NSString *_itemID;
    NSString *_name;
    NSString *_description;
    NSString *_owner;
    NSURL *_imgURL;
    NSURL *_commerceURL;
    NSURL *_videoURL;
    NSUInteger _viewCount;
    Category *_category;
    BOOL _favorite;
    MPMoviePlayerController *_moviePlayer;
    MBProgressHUD *_HUD;
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
@synthesize videoURL = _videoURL;
    
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
    _videoURL = [NSURL URLWithString:[attributes valueForKey:@"video_url"]];
    _viewCount = [[attributes valueForKey:@"view_count"] integerValue];
    _favorite = [[attributes valueForKey:@"favorite"] boolValue];
    
    // TODO: Store category name + ID in JSON as nested object
    _category = [[Category alloc] init];
    _category.categoryID = [attributes valueForKey:@"category_id"];
    
    return self;
}

- (void) toggleFavorite {    
    [self setFavorite:!_favorite];
}

- (void) setCategory:(Category *)category {
    if (!category) return;
    
    _category = category;
    
    // Update backend
    NSString *path = [NSString stringWithFormat:@"items/%@", _itemID];
    NSError *error;
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject: category.categoryID forKey:@"category_id"] forKey:@"$set"];
    
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
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject: request forKey:@"name"];
    [data setValue:[[NSDate date] description] forKey:@"time"];
    [data setValue:[NSNumber numberWithBool:false] forKey:@"added"];
    
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
                if ([item.category.categoryID isEqualToString:@""])
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

#pragma mark - Actions

- (void) playVideoInView: (UIView *) view {
    // GA
    NSString *pageView = [NSString stringWithFormat: @"Play Video - [%@] %@", _itemID, _name];
    NSError* error = nil;
    if (![[GANTracker sharedTracker] trackPageview:pageView
                                         withError:&error]) {
        NSLog(@"Track page view error: %@", error);
    }
    
    NSURL *url = [NSURL URLWithString:[[self videoURL] absoluteString]];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"snowboard" ofType:@"mp4"]];
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void) videoFinished:(NSNotification *) notification {
    MPMoviePlayerController *moviePlayer = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self      
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
        [moviePlayer.view removeFromSuperview];
    }
}

- (void) shareInView: (UIView *) view {
    // GA
    NSString *pageView = [NSString stringWithFormat: @"Share - [%@] %@", _itemID, _name];
    NSError* error = nil;
    if (![[GANTracker sharedTracker] trackPageview:pageView
                                         withError:&error]) {
        NSLog(@"Track page view error: %@", error);
    }
    
    // Load HUD
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView: view];
    [view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Sharing on Facebook";
    [HUD show:YES];
    
    // @TODO: Facebook API calls here
    
    [HUD hide:YES afterDelay:2];
    //[HUD hide:YES];
}

- (void) chooseCategory: (id)sender withBlock:(void (^)(void))block {
    // Build array of values
    NSDictionary *categories = [Category cachedCategories];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *categoryID in categories) {
        Category *category = [categories objectForKey:categoryID];
        [values addObject: category.name];
    }
    [values addObject:kAddCategoryTitle];
    
    /*
    [ActionSheetStringPicker showPickerWithTitle:@"Select Category" 
                                            rows:values 
                                initialSelection:0
                                          target:self 
                                   successAction:@selector(categoryWasSelected:element:)
                                    cancelAction:@selector(cancel)
                                          origin:sender];
    */
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Category"
                                            rows:values
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self categoryWasSelected:[NSNumber numberWithInteger: selectedIndex] element:selectedValue];
                                           
                                           if (block)
                                               block();
                                       } 
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Cancelled");
                                       } 
                                          origin:sender];
    
}

- (void) cancel {
    NSLog(@"Cancelled");
}

- (void) categoryWasSelected:(NSNumber *)selectedIndex element:(id)element {
    int row = selectedIndex.intValue;
    
    NSDictionary *categories = [Category cachedCategories];
    
    if (row < [categories count]) {
        // Change category for item
        Category *category = [[categories allValues] objectAtIndex:row];
        
        // Submit analytics for both category and item
        NSString *pageView = [NSString stringWithFormat: @"Favorite - [%@] %@", _itemID, _name];
        NSError* error = nil;
        if (![[GANTracker sharedTracker] trackPageview:pageView
                                             withError:&error]) {
            NSLog(@"Track page view error: %@", error);
        }
        pageView = [NSString stringWithFormat: @"Category - [%@] %@", category.categoryID, category.name];
        if (![[GANTracker sharedTracker] trackPageview:pageView
                                             withError:&error]) {
            NSLog(@"Track page view error: %@", error);
        }
        
        [self setCategory:category];
        
        //_categoryLabel.text = category.name;
        //[_favoriteIndicator setSelected:true];
    } else {
        // Add category
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:kAddCategoryTitle
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Add", nil];
        message.alertViewStyle = UIAlertViewStylePlainTextInput;
        [message show];
    }
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"Clicked at %i with title %@", buttonIndex, buttonTitle);
    
    // Add Category alert methods
    if ([alertView.title isEqualToString: kAddCategoryTitle]) {
        if (buttonIndex == 1) {
            Category *category = [[Category alloc] init];
            category.name = [[alertView textFieldAtIndex:0] text];
            [Category addCategory:category.name withBlock:^(NSString *categoryID) {
                category.categoryID = categoryID;
                NSLog(@"Updated category ID: %@", category.categoryID);
                [self setCategory:category];
                //_categoryLabel.text = category.name;
                //[_favoriteIndicator setSelected:true];
            }];
        }
    }
}

@end
