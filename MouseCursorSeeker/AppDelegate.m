//
//  AppDelegate.m
//  MouseCursorSeeker
//
//  Created by tommy on 2015/02/20.
//  Copyright (c) 2015年 gigatune. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    NSMutableArray *maskWindows;
    NSMutableArray *maskViews;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self setMask];
}

- (void)setMask{
    maskWindows = [NSMutableArray array];
    maskViews = [NSMutableArray array];
    
    for(NSScreen* screen in [NSScreen screens])
    {
        NSRect cocoaScreenFrame = [screen frame];
        
        NSWindow *maskWindow = [[NSWindow alloc] initWithContentRect:NSZeroRect
                                                           styleMask:NSBorderlessWindowMask
                                                             backing:NSBackingStoreBuffered
                                                               defer:YES];
        [maskWindow setOpaque:NO];
        [maskWindow makeKeyAndOrderFront:nil];
        [maskWindow setBackgroundColor:[NSColor clearColor]];
        [maskWindow setLevel:NSFloatingWindowLevel];
        [maskWindow setFrame:cocoaScreenFrame display:YES];
        [maskWindows addObject:maskWindow];
        
        
        MaskView *maskView = [[MaskView alloc] initWithFrame:cocoaScreenFrame];
        [maskWindow setContentView:maskView];
        [maskViews addObject:maskView];
        
        if( [self mousePointIsInScreen:screen]){
            [maskView setShowHole:YES];
            [maskView setHolePoint:[self mousePointInScreen:screen]];
        }else{
            [maskView setShowHole:NO];
        }

        [maskWindow setAlphaValue:0];
        [[NSAnimationContext currentContext] setDuration:0.5];
        [[maskWindow animator] setAlphaValue:1.0];
        
    }
}

- (void)hideMask{
    for (NSWindow *maskWindow in maskWindows) {
        [maskWindow setAlphaValue:1.0];
        [[NSAnimationContext currentContext] setDuration:0.5];
        [[maskWindow animator] setAlphaValue:0.0];
    }
    maskWindows = nil;
    maskViews = nil;
}

- (BOOL)mousePointIsInScreen:(NSScreen *)screen{

    NSPoint mousePoint = [NSEvent mouseLocation];
    if( NSMouseInRect(mousePoint, screen.frame, NO)){
        return YES;
    }
    return NO;
}

- (NSPoint)mousePointInScreen:(NSScreen *)screen{

    NSPoint mousePoint = [NSEvent mouseLocation];

    float x = mousePoint.x - screen.frame.origin.x;
    float y = mousePoint.y - screen.frame.origin.y;

    return NSMakePoint(x, y);
}

@end
