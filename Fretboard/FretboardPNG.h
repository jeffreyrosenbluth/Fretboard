//
//  FretboardPNG.h
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/10/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FretboardPNG : NSObject

- (CGContextRef) createFretboardImage;
- (void)drawVericalGrid:(CGContextRef)c;

@end
