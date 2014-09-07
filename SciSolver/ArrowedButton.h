//
//  ArrowedButton.h
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ArrowedButton : UIView

#define currentOS [[[UIDevice currentDevice] systemVersion] floatValue]
#define specialBlueColor_iOS6 [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0]
#define specialBlueColor_iOS7 [UIColor colorWithRed:0.0/255.0 green:82.0/255.0 blue:255.0/255.0 alpha:1.0]
#define properBlueColor (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? [UIColor colorWithRed:0.0/255.0 green:82.0/255.0 blue:255.0/255.0 alpha:1.0] : [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0])

{
    //Respond to touch
    UIControl *responder;
}

@property (nonatomic) BOOL drawUpArrow;
@property (nonatomic) BOOL drawDownArrow;
@property (nonatomic, readonly) UILabel *titleLabel;

- (id)initWithPoint:(CGPoint)p
             length:(int)length;
- (void)addTarget:(id)target
           action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents;

@end
