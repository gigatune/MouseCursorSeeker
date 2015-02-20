//
//  MaskView.m
//  MouseCursorSeeker
//
//  Created by tommy on 2015/02/20.
//  Copyright (c) 2015年 gigatune. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithRed:0.5 green:0 blue:1 alpha:0.5] set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}

@end
