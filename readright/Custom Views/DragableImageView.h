//
//  UIImageDragable.h
//  ReadRight
//
//  Created by Thanh on 8/27/14.
//  Copyright (c) 2014 QTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragableImageView : UIImageView
{
    CGPoint startLocation;
}
@property float MaxLimit;
@property float MinLimit;

@end
