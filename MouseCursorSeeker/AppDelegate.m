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
    NSMutableArray *maskScreens;
    NSMutableArray *maskViews;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self setMask];
}

- (void)setMask{
    maskScreens = [NSMutableArray array];
    maskViews = [NSMutableArray array];
    
    for(NSScreen* screen in [NSScreen screens])
    {
        NSRect cocoaScreenFrame = [screen frame];
        
        NSWindow *maskScreen = [[NSWindow alloc] initWithContentRect:NSZeroRect
                                                           styleMask:NSBorderlessWindowMask
                                                             backing:NSBackingStoreBuffered
                                                               defer:YES];
        [maskScreen setOpaque:NO];
        [maskScreen makeKeyAndOrderFront:nil];
        [maskScreen setBackgroundColor:[NSColor clearColor]];
        [maskScreen setLevel:NSFloatingWindowLevel];
        [maskScreen setFrame:cocoaScreenFrame display:YES];
        [maskScreens addObject:maskScreen];
        
        
        MaskView *maskView = [[MaskView alloc] initWithFrame:cocoaScreenFrame];
        [maskScreen setContentView:maskView];
        [maskViews addObject:maskView];
        
        if( [self mousePointIsInScreen:screen]){
            [maskView setShowHole:YES];
            [maskView setHolePoint:NSMakePoint(100, 100)];
        }else{
            [maskView setShowHole:NO];
        }

        [maskScreen setAlphaValue:0];
        [[NSAnimationContext currentContext] setDuration:0.5];
        [[maskScreen animator] setAlphaValue:1.0];
        
    }
}

- (BOOL)mousePointIsInScreen:(NSScreen *)screen{

    NSPoint mousePoint = [NSEvent mouseLocation];
    if( NSMouseInRect(mousePoint, screen.frame, NO)){
        return YES;
    }
    return NO;
}

@end
