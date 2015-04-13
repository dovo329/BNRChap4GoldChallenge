//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by John Gallagher on 1/6/14.
//  Copyright (c) 2014 John Gallagher. All rights reserved.
//

#import "BNRHypnosisView.h"

@implementation BNRHypnosisView

UIImage *logoImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
        logoImage = [UIImage imageNamed:@"BNRlogo.png"];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;

    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;

    // The largest circle will circumstribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;

    UIBezierPath *path = [[UIBezierPath alloc] init];

    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }

    // Configure line width to 10 points
    path.lineWidth = 10;

    // Configure the drawing color to light gray
    [[UIColor lightGrayColor] setStroke];

    // Draw the line!
    [path stroke];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect logoRect = CGRectInset(self.bounds, CGRectGetWidth(self.bounds)/5.0, CGRectGetHeight(self.bounds)/5.0);
    
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.0, 1.0, 0.0, 1.0,   // Start color is green
        1.0, 1.0, 0.0, 1.0 }; // End color is yellow
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(context);

    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    path = nil;
    path = [[UIBezierPath alloc] init];
    
    path.lineWidth = 0;
    [[UIColor clearColor] setStroke];
    
    [path moveToPoint:CGPointMake(CGRectGetMidX(logoRect), CGRectGetMinY(logoRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(logoRect), CGRectGetMaxY(logoRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(logoRect), CGRectGetMaxY(logoRect))];
    [path moveToPoint:CGPointMake(CGRectGetMidX(logoRect), CGRectGetMinY(logoRect))];
    [path stroke];
    [path addClip];
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(logoRect), CGRectGetMinY(logoRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(logoRect), CGRectGetMaxY(logoRect));;
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(4,7), 3);
    [logoImage drawInRect:logoRect];
    CGContextRestoreGState(context);
    
}

@end
