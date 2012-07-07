//
//  AFMustardSeedAPIClient.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"

@interface AFMustardSeedAPIClient : AFHTTPClient

+ (AFMustardSeedAPIClient *) sharedClient;

@end
