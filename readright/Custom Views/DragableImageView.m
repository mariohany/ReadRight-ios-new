//
//  UIImageDragable.m
//  ReadRight
//
//  Created by Thanh on 8/27/14.
//  Copyright (c) 2014 QTS. All rights reserved.
//

#import "DragableImageView.h"

@implementation DragableImageView
{
    float newY;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    newY = frame.origin.y + pt.y - startLocation.y;
    
    if(newY >= self.MinLimit && newY <= self.MaxLimit)
    {
        frame.origin.y = newY;
        [self setFrame:frame];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //Round to the neareast 1/4
    CGRect frame = [self frame];
    newY = frame.origin.y;
//    float percentage = ((newY - self.MinLimit) / (self.MaxLimit - self.MinLimit));
    
//    int roundedQuarter = (percentage * 4.0 + 0.5);
//    float newPercentage = (float) roundedQuarter / 4.0;


//    newY = newPercentage * self.MaxLimit;
    frame.origin.y = newY;
    [self setFrame:frame];

}


@end
