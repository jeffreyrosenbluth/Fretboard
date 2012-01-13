//
//  FretboardDiagram.h
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/11/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FretboardDiagram : NSObject

@property float stringSpacing;
@property float fretSpacing;
@property float nutOffset;
@property int numOfFrets;
@property int numOfStrings;
@property (strong) NSMutableArray *dots;

- (void)drawHorizontalGrid:(CGContextRef)ctx;
- (void)drawVericalGrid:(CGContextRef)ctx;
- (void)drawFingerCircle:(CGContextRef)ctx;
- (void)drawFretMarkers:(CGContextRef)ctx;
- (void)drawFretboard:(CGContextRef)ctx;
- (void)getUserInputs;
- (void)parseUserInputs;
    
@end
