//
//  BezierPathView.m
//  DropIt
//
//  Created by Andres Kwan on 11/22/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    //Marks the receiver’s entire bounds rectangle as needing to be redrawn.
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor redColor] setStroke];
    self.path.lineWidth = 3.0;
    [self.path stroke];

}


@end
