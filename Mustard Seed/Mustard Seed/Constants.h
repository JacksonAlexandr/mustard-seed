//
//  Constants.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/23/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#ifndef Mustard_Seed_Constants_h
#define Mustard_Seed_Constants_h

#define kTitle      @"KUBE-iT"

// ItemGridView
#define kItemGridViewImageHeight        130 * 2
#define kItemGridViewTitleHeight        20
#define kItemGridViewOwnerHeight        14
#define kItemGridViewBuffer       15
#define kItemGridViewButtonHeight       35
#define kItemGridViewHeight             kItemGridViewImageHeight + kItemGridViewTitleHeight + kItemGridViewOwnerHeight + kItemGridViewBuffer + kItemGridViewButtonHeight + kItemGridViewBuffer
#define kItemGridViewWidth              140 * 2
#define kDetailButtonHeightPercent      0.7

// Search view
#define kWaitingTimeInMicroseconds      10000

// Request Item
#define kRequestButtonHeight            75

// API
#define kAFMustardSeedAPIBaseURLString      @"http://mustard-seed.meteor.com/collectionapi/"
//#define kAFMustardSeedAPIBaseURLString      @"http://localhost:3000/collectionapi/"

// Titles
#define kSaveItemTitle                  @"Save this Item"
#define kAddCategoryTitle               @"Add a Category"

// Category Picker
#define kChooseCategoryComponent        1

// Google Analytics
#define kGoogleAnalyticsID              @"UA-34017942-1"
#define kGoogleAnalyticsDispatchPeriod  30

#endif
