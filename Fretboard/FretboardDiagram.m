//
//  FretboardDiagram.m
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/11/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import "FretboardDiagram.h"
#import "FingerDot.h"
#import "AppDelegate.h"

@interface FretboardDiagram () 
@property (copy) NSString *eString;
@property (copy) NSString *aString;
@property (copy) NSString *dString;
@property (copy) NSString *gString;
@property (copy) NSString *bString;
@property (copy) NSString *eeString;
@property (copy) NSString *title;
@property int startingFret;


@end


@implementation FretboardDiagram

@synthesize eeString;
@synthesize aString;
@synthesize dString;
@synthesize gString;
@synthesize bString;
@synthesize eString;
@synthesize title;
@synthesize startingFret;

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
    }
    return self;
}

- (void)getUserInputs {
    AppDelegate *delegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self setTitle:[[delegate title] stringValue]];
    [self setEString:[[delegate eString] stringValue]];
    [self setAString:[[delegate aString] stringValue]];
    [self setDString:[[delegate dString] stringValue]];
    [self setGString:[[delegate gString] stringValue]];
    [self setBString:[[delegate bString] stringValue]];
    [self setEeString:[[delegate eeString] stringValue]];
    [self setStartingFret:[[delegate startingFret] intValue]];
}

- (void)parseUserInputs {
    NSArray *neck = [NSArray arrayWithObjects:eString, aString, dString, gString, bString, eeString, nil];
    NSArray *oneString;
    NSString *flat;
    NSString *numLabel = @"1";
    NSRange second;
    second.location = 1;
    second.length = 1;
    NSRange third;
    third.location = 2;
    third.length = 1;
    BOOL isEmphasized;
    [dots removeAllObjects];
    FingerDot *dot;
    for (int i = 0; i <  numOfStrings; i++) {
        oneString = [[neck objectAtIndex:i] componentsSeparatedByString:@"/"];
        int j = 0;
        for (NSString *s in oneString) {
            if ([s isEqualToString:@"0"]) {
                j++;
                continue;
            }
            if ([[s substringToIndex:1] isEqualToString:@"-"]) {
                flat = @"\u266D";
                numLabel = [s substringWithRange:second];
                isEmphasized = ([s length] == 3);
            }
            else {
                flat = @"";
                numLabel = [s substringToIndex:1];
                isEmphasized = ([s length] == 2);
            }
            dot = [[FingerDot alloc] init];
            [dot setString:i+1];
            [dot setFret:startingFret + j];
            [dot setLabel:[NSString stringWithFormat:@"%@%@",flat,numLabel]];
            [dot setIsEmphasized:isEmphasized];
            if ((startingFret + j) < 17) [dots addObject:dot];
            j++;
        }
        
    }
    
}

- (void)drawTitle:(CGContextRef)ctx {
    NSGraphicsContext *gc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]; 
    [NSGraphicsContext saveGraphicsState]; 
    [NSGraphicsContext setCurrentContext:gc]; 
    NSMutableDictionary *stringAttributes = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:10.0];
    [stringAttributes setObject:font forKey:NSFontAttributeName];
    NSSize size = [[self title] sizeWithAttributes:stringAttributes];
    NSPoint p = NSMakePoint(nutOffset - size.width -10, 3.0 * stringSpacing);
    [[self title] drawAtPoint:p withAttributes:stringAttributes];
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawStrokedCircle:(CGContextRef)ctx 
             circleCenter:(CGPoint)center 
             circleRadius:(float)radius 
             fingerNumber:(NSString *)label 
{
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, radius, 0.0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(ctx, CGColorGetConstantColor(kCGColorWhite));
    CGContextDrawPath(ctx, kCGPathFillStroke); 
    NSGraphicsContext *gc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]; 
    [NSGraphicsContext saveGraphicsState]; 
    [NSGraphicsContext setCurrentContext:gc]; 
    NSMutableDictionary *stringAttributes = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSFont *font = [NSFont fontWithName:@"Times-Roman" size:9.0];
    [stringAttributes setObject:font forKey:NSFontAttributeName];
    NSNumber *num = [NSNumber numberWithFloat: -2.5f];    
    [stringAttributes setObject:num forKey:NSKernAttributeName];
    NSAttributedString *fingString = [[NSAttributedString alloc] initWithString:label attributes:stringAttributes];
    NSSize size = [fingString size];
    float adjust = 0.0;
    if (size.width > 8) 
        adjust  = -1.5;
    else if ([label isEqualToString:@"R"]) 
        adjust = -0.5;
    NSPoint p = NSMakePoint(center.x - 0.5 * size.width + adjust, center.y - 0.5 * size.height);
    [fingString drawAtPoint:p];
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
    CGContextSetLineWidth(ctx, 0.75);
    CGPoint center;
    for (FingerDot *d in dots) {
        center.x = nutOffset + ([d fret] - 0.5) * fretSpacing;
        center.y = stringSpacing * [d string];
        if ([d isEmphasized]) {
            CGContextSetLineWidth(ctx, 1.5);
            //CGContextSetRGBStrokeColor(ctx, 0.7, 0.2, 0.2, 1.0);
        }
        [self drawStrokedCircle:ctx circleCenter:center circleRadius:fretSpacing / 3.0 fingerNumber:[d label]];
        //CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
        CGContextSetLineWidth(ctx, 0.75);
    }
    CGContextRestoreGState(ctx);
}

- (void)drawFretboard:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    [self drawTitle:ctx];
    [self drawHorizontalGrid:ctx];
    [self drawVericalGrid:ctx];
    [self drawFretMarkers:ctx];
    [self drawFingerCircle:ctx];
    CGContextRestoreGState(ctx);
}

@end
