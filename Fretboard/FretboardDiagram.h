//
//  FretboardDiagram.h
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/11/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FretboardDiagram : NSObject

@property (nonatomic) float stringSpacing;
@property (nonatomic) float fretSpacing;
@property (nonatomic) float nutOffset;
@property (nonatomic) int numOfFrets;
@property (nonatomic) int numOfStrings;
@property (nonatomic, strong) NSMutableArray *dots;

- (void)drawHorizontalGrid:(CGContextRef)ctx;
- (void)drawVericalGrid:(CGContextRef)ctx;
- (void)drawFingerCircle:(CGContextRef)ctx;
- (void)drawFretMarkers:(CGContextRef)ctx;
- (void)drawFretboard:(CGContextRef)ctx;

    
@end
