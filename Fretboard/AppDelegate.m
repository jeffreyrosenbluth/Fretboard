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

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)exportFretboard:(NSURL *)url {
    FretboardDiagram * fbD = [[FretboardDiagram alloc] init];
    float nutOffset = [fbD nutOffset];
    int numOfFrets = [fbD numOfFrets];
    float fretSpacing = [fbD fretSpacing];
    int numOfStrings = [fbD numOfStrings];
    float stringSpacing = [fbD stringSpacing];
    CGRect mediaBox = CGRectMake(0, 0, nutOffset + (numOfFrets + 1) * fretSpacing, (numOfStrings + 1) * stringSpacing);
    /*NSString *homeDirectory = NSHomeDirectory();
    NSString *destinationFilename = [homeDirectory stringByAppendingPathComponent:@"Desktop/jrid.pdf"];
    NSURL *url = [NSURL fileURLWithPath:destinationFilename];*/
    CGContextRef pdfContext = CGPDFContextCreateWithURL((__bridge CFURLRef) url, &mediaBox, NULL);
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextSaveGState(pdfContext);
    CGContextClipToRect(pdfContext, mediaBox);
    [fbD drawFretboard:pdfContext];
    CGContextRestoreGState(pdfContext);
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);

}

- (IBAction)savePNG:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    [savePanel runModal];
    [self exportFretboard:[savePanel URL]];
}

@end
