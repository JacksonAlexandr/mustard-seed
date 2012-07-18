//
//  UIImage+Autofit.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/17/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Autofit)

- (UIImage *) autofitToSize:(CGSize) size;

- (UIImage *) crop:(CGRect) rect;

@end
