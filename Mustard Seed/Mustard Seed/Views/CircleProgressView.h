//
//  CircleProgressView.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/6/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CircleProgressLayer : CALayer

@property(nonatomic) CGFloat progress;

@end

@interface CircleProgressView : UIView

@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
