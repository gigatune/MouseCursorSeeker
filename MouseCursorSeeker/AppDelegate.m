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
    NSWindow *maskWindow;
    MaskView *maskView;
    BOOL isMasked;
    NSStatusItem *_statusItem;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSFlagsChangedMask|NSKeyDownMask handler:^(NSEvent *event){

        if(( [event modifierFlags] & NSCommandKeyMask ) && ( [event modifierFlags] & NSControlKeyMask ) ){
            if( isMasked == YES ){
                [self hideMask];
            }else{
                [self setMask];
            }
        }

        if( ! ([event modifierFlags] & NSCommandKeyMask ) ){
            if( isMasked == YES ){
                [self hideMask];
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
    
    maskWindow = nil;
    maskView = nil;

    for(NSScreen* screen in [NSScreen screens])
    {
        
        if( [self mousePointIsInScreen:screen]){

            NSRect cocoaScreenFrame = [screen frame];

            maskWindow = [[NSWindow alloc] initWithContentRect:NSZeroRect
                                                               styleMask:NSBorderlessWindowMask
                                                                 backing:NSBackingStoreBuffered
                                                                   defer:YES];
            [maskWindow setOpaque:NO];
            [maskWindow makeKeyAndOrderFront:nil];
            [maskWindow setBackgroundColor:[NSColor clearColor]];
            [maskWindow setLevel:NSFloatingWindowLevel];
            [maskWindow setFrame:cocoaScreenFrame display:YES];

            maskView = [[MaskView alloc] initWithFrame:cocoaScreenFrame];
            [maskWindow setContentView:maskView];

            [maskView setShowHole:YES];
            [maskView setHolePoint:[self mousePointInScreen:screen]];

            [maskWindow setAlphaValue:0];
            [[NSAnimationContext currentContext] setDuration:0.5];
            [[maskWindow animator] setAlphaValue:1.0];
        }
        
    }
}

- (void)hideMask{
    [maskWindow setAlphaValue:1.0];
    [[NSAnimationContext currentContext] setDuration:0.5];
    [[maskWindow animator] setAlphaValue:0.0];
    maskWindow = nil;
    maskView = nil;
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
