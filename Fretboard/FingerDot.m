//
//  FingerDot.m
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/11/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import "FingerDot.h"

@implementation FingerDot

@synthesize string;
@synthesize fret;
@synthesize label;
@synthesize isEmphasized;

- (id)init
{
    self = [super init];
    if (self) {
        [self setString:1];
        [self setFret:1];
        [self setLabel:@"5"];
        [self setIsEmphasized:NO];
    }
    return self;
}

@end
