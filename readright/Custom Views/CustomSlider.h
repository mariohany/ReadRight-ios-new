//
//  CustomSlider.h
//  إقرأ لتكون
//
//  Created by Yassin Gamal on 12/14/14.
//  Copyright (c) 2014 TrianglZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSlider : UIView

@property UIView* Gauge;
@property UIView* Thumb;

- (void) setThumbPosition:(int) percentage;
- (int) getThumbPercentage;


@end
