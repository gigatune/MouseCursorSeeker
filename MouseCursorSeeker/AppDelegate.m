//
//  AppDelegate.m
//  MouseCursorSeeker
//
//  Created by tommy on 2015/02/20.
//  Copyright (c) 2015年 gigatune. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
@property (weak) IBOutlet NSMenu *statusMenu;
@end

@implementation AppDelegate
{
    NSMutableArray *maskWindows;
    NSMutableArray *maskViews;
    BOOL isMasked;
    NSStatusItem *_statusItem;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSFlagsChangedMask|NSKeyDownMask handler:^(NSEvent *event){
        if( [event modifierFlags] == 1179922 ){         // [command] + [Shift] keys pressed
            if( isMasked == YES ){
                [self hideMask];
            }else{
                [self setMask];
            }
        }
        if(( [event type] == NSKeyDown ) && ([event keyCode] == 53 ) ){  // [ESC] key pressed
            [self hideMask];
        }
    }];
    [self setupStatusItem];
}

- (void)setMask{
    isMasked = YES;
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
    isMasked = NO;
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

- (void)setupStatusItem
{
    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];

    _statusItem = [systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setHighlightMode:YES];
    [_statusItem setTitle:@"MouseCursorSeeker"];
    [_statusItem setMenu:self.statusMenu];

}
@end
