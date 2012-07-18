//
//  UIImage+Autofit.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/17/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "UIImage+Autofit.h"

@implementation UIImage (Autofit)

/**
 Scale image from center and crop to fit 'bounds' while preserving the aspect
 ratio of the image.
 */
- (UIImage *) autofitToSize:(CGSize)size {
    // Find zoom factor; will be larger of the horizontal / vertical ratios
    float widthScale = self.size.width / size.width;
    float heightScale = self.size.height / size.height;
    float scale = MAX(widthScale, heightScale);
    
    // Scale image
    UIImage *scaledImage = [UIImage imageWithCGImage:[self CGImage] scale:scale orientation:UIImageOrientationUp];
    
    // Calculate crop bounds
    CGPoint center = CGPointMake(scaledImage.size.width / 2.0, scaledImage.size.height / 2.0);
    CGRect bounds = CGRectMake(center.x - size.width / 2.0, center.y - size.height / 2.0, size.width, size.height);
    
    // Crop
    return [scaledImage crop:bounds];
}

/**
 Crop a UIImage and account for retina images
 */
- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
