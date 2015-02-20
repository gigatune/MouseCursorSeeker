//
//  MaskView.h
//  MouseCursorSeeker
//
//  Created by tommy on 2015/02/20.
//  Copyright (c) 2015年 gigatune. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MaskView : NSView

@property(nonatomic) BOOL showHole;
@property(nonatomic) NSPoint holePoint;

- (void)setHolePoint:(NSPoint)point;
- (void)setShowHole:(BOOL)flag;
@end
