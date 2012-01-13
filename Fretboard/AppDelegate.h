//
//  AppDelegate.h
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/9/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FretboardView;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet FretboardView *fretboardView;
- (IBAction)savePNG:(id)sender;
- (void)exportFretboard:(NSURL *)url;

@end
