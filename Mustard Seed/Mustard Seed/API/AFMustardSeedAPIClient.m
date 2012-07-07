//
//  AFMustardSeedAPIClient.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AFMustardSeedAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFMustardSeedAPIBaseURLString = @"http://mustard-seed.meteor.com/collectionapi/";
//static NSString * const kAFMustardSeedAPIBaseURLString = @"http://api.twitter.com/1/";

@implementation AFMustardSeedAPIClient

+ (AFMustardSeedAPIClient *) sharedClient {
    static AFMustardSeedAPIClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[AFMustardSeedAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFMustardSeedAPIBaseURLString]];
    });
    
    return client;
}

- (id) initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) return nil;
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
