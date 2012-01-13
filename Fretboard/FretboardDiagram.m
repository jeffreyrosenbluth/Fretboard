//
//  FretboardDiagram.m
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/11/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import "FretboardDiagram.h"
#import "FingerDot.h"

@implementation FretboardDiagram

@synthesize stringSpacing;
@synthesize fretSpacing;
@synthesize nutOffset;
@synthesize numOfFrets;
@synthesize numOfStrings;
@synthesize dots;

- (id)init
{
    self = [super init];
    if (self) {
        [self setStringSpacing:20.0];
        [self setFretSpacing:20.0];
        [self setNutOffset:72.];
        [self setNumOfFrets:16];
        [self setNumOfStrings:6];
        
        dots = [[NSMutableArray alloc] initWithCapacity:18];
        FingerDot *dot = [[FingerDot alloc] init];
        [dot setFret:3];
        [dot setString:1];
        [dot setLabel:@"R"];
        [dot setIsEmphasized:YES];
        [dots addObject:dot];
        dot = [[FingerDot alloc] init];
        [dot setFret:3];
        [dot setString:3];
        [dot setLabel:@"2"];
        [dots addObject:dot];
        dot = [[FingerDot alloc] init];
        [dot setFret:5];
        [dot setString:4];
        [dot setLabel:@"\u266D7"];
        [dots addObject:dot];
        dot = [[FingerDot alloc] init];
        [dot setFret:7];
        [dot setString:6];
        [dot setLabel:@"4"];
        [dots addObject:dot];
    }
    return self;
}

- (void)drawStrokedCircle:(CGContextRef)ctx 
             circleCenter:(CGPoint)center 
             circleRadius:(float)radius 
             fingerNumber:(NSString *)label 
{
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, radius, 0.0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(ctx, CGColorGetConstantColor(kCGColorWhite));
    CGContextDrawPath(ctx, kCGPathFillStroke); NSGraphicsContext *gc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]; 
    [NSGraphicsContext saveGraphicsState]; 
    [NSGraphicsContext setCurrentContext:gc]; 
    NSMutableDictionary *stringAttributes = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSFont *font = [NSFont fontWithName:@"Times-Roman" size:9.0];
    [stringAttributes setObject:font forKey:NSFontAttributeName];
    NSNumber *num = [NSNumber numberWithFloat: -2.5f];    
    [stringAttributes setObject:num forKey:NSKernAttributeName];
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:label attributes:stringAttributes];
    NSSize size = [aString size];
    float adjust;
    if (size.width > 8) 
        adjust  = -1.5;
    else if ([label isEqualToString:@"R"]) 
        adjust = -0.5;
    NSPoint p = NSMakePoint(center.x - 0.5 * size.width + adjust, center.y - 0.5 * size.height);
    [aString drawAtPoint:p];
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawFilledCircle:(CGContextRef)ctx circleCenter:(CGPoint)center circleRadius:(float)radius {
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, radius, 0.0, 2 * M_PI, 0);
    CGColorRef gray = CGColorCreateGenericRGB(0.6, 0.6, 0.6, 1.0);
    CGContextSetFillColorWithColor(ctx, gray);
    CGContextDrawPath(ctx, kCGPathFill);
}

- (void)drawStrokedLine:(CGContextRef)ctx startPoint:(CGPoint)start endPoint:(CGPoint)end {
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, start.x, start.y);
    CGContextAddLineToPoint(ctx, end.x, end.y);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)drawHorizontalGrid:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGPoint start = CGPointMake(nutOffset - 1.3, stringSpacing); // 1.5 is 1/2 nut width
    CGPoint end = CGPointMake(nutOffset + fretSpacing * numOfFrets, stringSpacing);
    [self drawStrokedLine:ctx startPoint:start endPoint:end];
    for(int i = 0;i < numOfStrings - 1; i++) {
        CGContextTranslateCTM(ctx, 0.0, stringSpacing);
        [self drawStrokedLine:ctx startPoint:start endPoint:end];
    }
    CGContextRestoreGState(ctx);
}

- (void)drawVericalGrid:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGPoint start = CGPointMake(nutOffset, stringSpacing);
    CGPoint end = CGPointMake(nutOffset, stringSpacing * numOfStrings);
    [self drawStrokedLine:ctx startPoint:start endPoint:end];
    CGContextSetLineWidth(ctx, 0.5);
    for(int i = 0;i < numOfFrets; i++) {
        CGContextTranslateCTM(ctx, fretSpacing, 0.0);
        [self drawStrokedLine:ctx startPoint:start endPoint:end];
    }
    CGContextRestoreGState(ctx);
}

- (void)drawFretMarkers:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGPoint center;
    center.x = nutOffset + 2.5 * fretSpacing;
    center.y = 3.5 * stringSpacing;
    [self drawFilledCircle:ctx circleCenter:center circleRadius:4];
    for (int i = 0; i < 3; i++) {
        CGContextTranslateCTM(ctx,  2 * fretSpacing, 0.0);
        [self drawFilledCircle:ctx circleCenter:center circleRadius:4];
    }
    CGContextTranslateCTM(ctx,  3 * fretSpacing, stringSpacing);
    [self drawFilledCircle:ctx circleCenter:center circleRadius:4];
    CGContextTranslateCTM(ctx,  0, - 2 * stringSpacing);
    [self drawFilledCircle:ctx circleCenter:center circleRadius:4];
    CGContextTranslateCTM(ctx,  3 * fretSpacing, stringSpacing);
    [self drawFilledCircle:ctx circleCenter:center circleRadius:4];
    CGContextRestoreGState(ctx);
}

- (void)drawFingerCircle:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, 1.0);
    CGPoint center;
    for (FingerDot *d in dots) {
        center.x = nutOffset + ([d fret] - 0.5) * fretSpacing;
        center.y = stringSpacing * [d string];
        if ([d isEmphasized]) {
            CGContextSetLineWidth(ctx, 2.0);
            CGContextSetRGBStrokeColor(ctx, 0.7, 0.2, 0.2, 1.0);
        }
        [self drawStrokedCircle:ctx circleCenter:center circleRadius:fretSpacing / 3.25 fingerNumber:[d label]];
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
        CGContextSetLineWidth(ctx, 1.0);
    }
    CGContextRestoreGState(ctx);
}

- (void)drawFretboard:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    [self drawHorizontalGrid:ctx];
    [self drawVericalGrid:ctx];
    [self drawFretMarkers:ctx];
    [self drawFingerCircle:ctx];
    CGContextRestoreGState(ctx);
}

@end
