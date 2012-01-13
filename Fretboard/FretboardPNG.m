//
//  FretboardPNG.m
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/10/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import "FretboardPNG.h"
#define WIDTH 20*16
#define HEIGHT 5*16 

@implementation FretboardPNG



- (CGContextRef) createFretboardImage {
    CGContextRef c = CGBitmapContextCreate(NULL, WIDTH, HEIGHT, 8, 4 * WIDTH, 
                                            CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB),
                                        kCGImageAlphaPremultipliedLast);
    CGContextSaveGState(c);
    CGContextSetFillColorWithColor(c, CGColorGetConstantColor(kCGColorWhite));
    CGContextFillRect(c, CGRectMake(0, 0, WIDTH, HEIGHT));
    CGContextRestoreGState(c);
    return c;
}

- (void)drawVericalGrid:(CGContextRef)c {
    //CGContextScaleCTM(c, 300./72, 300./72);
    CGContextStrokeRectWithWidth(c, CGRectMake(20, 20, 100, 100),1);
    CGImageRef image = CGBitmapContextCreateImage(c);
    CGContextRelease(c);
    NSString *homeDirectory = NSHomeDirectory();
    NSString *destinationFilename = [homeDirectory stringByAppendingPathComponent:@"Desktop/hrid2"];
    NSURL *url = [NSURL fileURLWithPath:destinationFilename];
    CGImageDestinationRef dest = CGImageDestinationCreateWithURL( (__bridge CFURLRef) url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(dest, image, nil);
    BOOL isSaved = CGImageDestinationFinalize(dest);
    NSLog(@"%i",isSaved);
}

@end