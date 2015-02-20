//
//  MaskView.m
//  MouseCursorSeeker
//
//  Created by tommy on 2015/02/20.
//  Copyright (c) 2015年 gigatune. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

@synthesize holePoint;
@synthesize showHole;

int holeWidth = 50;
int holeHeight = 50;

- (void)drawRect:(NSRect)dirtyRect
{
    if( showHole == YES ){
        NSRect holeRect = NSMakeRect((holePoint.x - ( holeWidth / 2 ) ), (holePoint.y - ( holeHeight / 2 ) ), holeWidth, holeHeight);
        NSBezierPath* holePath = [NSBezierPath bezierPathWithRoundedRect:holeRect
                                                                 xRadius:holeWidth
                                                                 yRadius:holeHeight];
        [holePath appendBezierPathWithRect:dirtyRect];
        [holePath setWindingRule:NSEvenOddWindingRule];
        [[NSColor colorWithRed:0.5 green:0 blue:1.0 alpha:0.7] set];
        [holePath fill];
    }else{
        [[NSColor colorWithRed:0.5 green:0 blue:1 alpha:0.5] set];
        NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
    }
}

- (void)setHolePoint:(NSPoint)point{
    holePoint = point;
}

- (void)setShowHole:(BOOL)flag{
    showHole = flag;
}
@end
