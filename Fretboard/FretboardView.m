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
        // Initialization code here.
    }
    
    return self;
}

/*
 NSSize imageSize = NSMakeSize(512, 512);
 NSImage *image = [[[NSImage alloc] initWithSize:imageSize] autorelease];
 [image lockFocus];
 //draw a line:
 [NSBezierPath strokeLineFromPoint:NSMakePoint(100, 100) toPoint:NSMakePoint(200, 200)];
 //...
 NSBitmapImageRep *imageRep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, imageSize.width, imageSize.height)] autorelease];
 NSData *pngData = [imageRep representationUsingType:NSPNGFileType properties:nil];
 [image unlockFocus];
 [pngData writeToFile:@"/path/to/your/file.png" atomically:YES];
 */


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
    [fbD drawFretboard:ctx];
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawGuitar];
   // [super drawRect:dirtyRect];
}

@end
