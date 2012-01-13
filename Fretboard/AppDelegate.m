//
//  AppDelegate.m
//  Fretboard
//
//  Created by Jeffrey Rosenbluth on 1/9/12.
//  Copyright (c) 2012 Applause Code. All rights reserved.
//

#import "AppDelegate.h"
#import "FretboardView.h"
#import "FretboardPNG.h"
#import "FretboardDiagram.h"

@implementation AppDelegate
@synthesize fretboardView = _fretboardView;
@synthesize title = _title;
@synthesize startingFret = _startingFret;
@synthesize eString = _eString;
@synthesize aString = _aString;
@synthesize dString = _dString;
@synthesize gString = _gString;
@synthesize bString = _bString;
@synthesize eeString = _eeString;
@synthesize fbD;

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    fbD = [[FretboardDiagram alloc] init];
    [fbD getUserInputs];
    [fbD parseUserInputs];
}

- (void)exportFretboard:(NSURL *)url {
    float nutOffset = [fbD nutOffset];
    int numOfFrets = [fbD numOfFrets];
    float fretSpacing = [fbD fretSpacing];
    int numOfStrings = [fbD numOfStrings];
    float stringSpacing = [fbD stringSpacing];
    CGRect mediaBox = CGRectMake(0, 0, nutOffset + (numOfFrets + 1) * fretSpacing, (numOfStrings + 1) * stringSpacing);
    CGContextRef pdfContext = CGPDFContextCreateWithURL((__bridge CFURLRef) url, &mediaBox, NULL);
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextSaveGState(pdfContext);
    CGContextClipToRect(pdfContext, mediaBox);
    [fbD drawFretboard:pdfContext];
    CGContextRestoreGState(pdfContext);
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);

}

- (IBAction)apply:(NSButton *)sender {
    [fbD getUserInputs];
    [fbD parseUserInputs];
    [[self fretboardView] setNeedsDisplay:YES];
}

- (IBAction)savePNG:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    [savePanel runModal];
    [self exportFretboard:[savePanel URL]];
}

@end
