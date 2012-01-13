//
//  FingerDot.h
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/11/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FingerDot : NSObject

@property (nonatomic) int string;
@property (nonatomic) int fret;
@property (nonatomic, copy) NSString *label;
@property (nonatomic) BOOL isEmphasized;

@end
