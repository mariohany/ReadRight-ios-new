//
//  CustomSlider.m
//  إقرأ لتكون
//
//  Created by Yassin Gamal on 12/14/14.
//  Copyright (c) 2014 TrianglZ. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider


- (void) setThumbPosition:(int) percentage
{
    int percentageInverse = 100 - percentage;
    float gaugeHeight = self.Gauge.frame.size.height;
    float thumbY = (float)percentageInverse / 100 * gaugeHeight;
    CGRect frame = [self.Thumb frame];
    frame.origin.y = thumbY;
    [self.Thumb setFrame:frame];
}

- (int) getThumbPercentage
{
    float percentage = (self.Thumb.frame.origin.y / self.Gauge.frame.size.height) * 100 ;
    int percentageInverse = 100 - percentage;
    
    return percentageInverse;
    
}

@end
