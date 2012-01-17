//
//  FretboardView.m
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/9/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import "FretboardView.h"
#import "FretboardDiagram.h"

@implementation FretboardView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)drawVericalGridInRect:(CGRect)dataRect {
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:0.5];
    [path moveToPoint:CGPointMake(rint(CGRectGetMinX(dataRect)),
                                  rint(CGRectGetMinY(dataRect)))];
    [path lineToPoint:CGPointMake(rint(CGRectGetMinX(dataRect)),
                                  rint(CGRectGetMaxY(dataRect)) - 17.0)];    
    CGContextSaveGState(ctx);
    [path stroke];
    for(int i = 0;i < 16;i++) {
        CGContextTranslateCTM(ctx, rint(CGRectGetWidth(dataRect) / 16.0), 0.0);
        [path stroke];
    }
    CGContextRestoreGState(ctx);
}

- (void)drawGuitar {
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx, 2.0, 2.0);
    FretboardDiagram *fbD = [[FretboardDiagram alloc] init];
    [fbD getUserInputs];
    [fbD parseUserInputs];
    [fbD drawFretboard:ctx];
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawGuitar];
    [super drawRect:dirtyRect];
}

@end
