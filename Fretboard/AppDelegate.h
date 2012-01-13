//
//  AppDelegate.h
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/9/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FretboardView;
@class FretboardDiagram;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet FretboardView *fretboardView;
@property (weak) IBOutlet NSTextField *title;
@property (weak) IBOutlet NSTextField *startingFret;
@property (weak) IBOutlet NSTextField *eString;
@property (weak) IBOutlet NSTextField *aString;
@property (weak) IBOutlet NSTextField *dString;
@property (weak) IBOutlet NSTextField *gString;
@property (weak) IBOutlet NSTextField *bString;
@property (weak) IBOutlet NSTextField *eeString;
@property (strong) FretboardDiagram *fbD;

- (IBAction)savePNG:(id)sender;
- (void)exportFretboard:(NSURL *)url;
- (IBAction)apply:(NSButton *)sender;

@end
