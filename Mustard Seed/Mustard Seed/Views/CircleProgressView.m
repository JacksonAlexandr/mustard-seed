//
//  CircleProgressView.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/6/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "CircleProgressView.h"

@implementation CircleProgressLayer

// Using Core Animation's generated properties allows
// it to do tweening for us.
@dynamic progress;

// This is the core of what does animation for us. It
// tells CoreAnimation that it needs to redisplay on
// each new value of progress, including tweened ones.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"progress"] || [super needsDisplayForKey:key];
}

// This is the other crucial half to tweening.
// The animation we return is compatible with that
// used by UIView, but it also enables implicit
// filling-up-the-pie animations.
- (id)actionForKey:(NSString *) aKey {
    if ([aKey isEqualToString:@"progress"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:aKey];
        animation.fromValue = [self.presentationLayer valueForKey:aKey];
        return animation;
    }
    return [super actionForKey:aKey];
}

// This is the gold; the drawing of the pie itself.
// In this code, it draws in a "HUD"-y style, using
// the same color to fill as the border.
- (void)drawInContext:(CGContextRef)context {
    CGRect circleRect = self.bounds;
    
    CGFloat radius = CGRectGetMidX(circleRect);
    CGPoint center = CGPointMake(radius, CGRectGetMidY(circleRect));
    CGFloat startAngle = -M_PI / 2;
    CGFloat endAngle = self.progress * 2 * M_PI + startAngle;
    CGContextSetFillColorWithColor(context, self.borderColor);
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    [super drawInContext:context];
}

@end


@implementation CircleProgressView

+ (Class)layerClass {
    return [CircleProgressLayer class];
}

- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.cornerRadius = CGRectGetMidX(frame);
        self.layer.backgroundColor = [[UIColor colorWithWhite:1.0 alpha:0.15] CGColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

// The method that actually sets the progress on the layer.
// Even if you're incrementing (with or without animation)
// for every .01 of the pie, each animation cancels out the
// previous one.
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    NSTimeInterval length = animated ? (1./3.) : 0.0;
    
    [UIView animateWithDuration:length delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [(CircleProgressLayer *)self.layer setProgress:progress];
    } completion:NULL];
}

- (CGFloat)progress {
    return [(CircleProgressLayer *)self.layer progress];
}

@end
