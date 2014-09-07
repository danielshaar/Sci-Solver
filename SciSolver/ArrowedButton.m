//
//  ArrowedButton.m
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import "ArrowedButton.h"

@implementation ArrowedButton

@synthesize drawUpArrow, drawDownArrow, titleLabel;

- (id)initWithPoint:(CGPoint)p
             length:(int)length
{
    CGRect frame = CGRectMake(p.x, p.y, length, 30);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        if (!(currentOS >= 7.0)) {
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowRadius = 1;
            self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
            self.layer.opacity = 1.0;
        }
        
        //Set up label
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-10, frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.layer.cornerRadius = 5;
        titleLabel.textColor = properBlueColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //Set up the control intended to show the picker view
        responder = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:responder];
    }
    return self;

}

- (void)addTarget:(id)target
           action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents
{
    [responder addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    responder.userInteractionEnabled = userInteractionEnabled;
    if (!userInteractionEnabled) {
        titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:5.0];
    [[UIColor clearColor] set];
    if (!(currentOS >= 7.0)) {
        [[UIColor whiteColor] set];
    }
    [roundedRectPath fill];
    
    // Drawing code
    if (!responder.userInteractionEnabled) {
        [titleLabel setNeedsDisplay];
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [properBlueColor set];
    
    int length = self.frame.size.width;
    
    if (drawUpArrow) {
        [path moveToPoint:CGPointMake(length-9, 11)];
        [path addLineToPoint:CGPointMake(length-6, 3)];
        [path addLineToPoint:CGPointMake(length-3, 11)];
        [path fill];
    }
    
    if (drawDownArrow) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(length-9, 19)];
        [path addLineToPoint:CGPointMake(length-6, 27)];
        [path addLineToPoint:CGPointMake(length-3, 19)];
        [path fill];
    }
    
    [titleLabel setNeedsDisplay];
}

- (void)dealloc
{
    [responder removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    responder = nil;
    titleLabel = nil;
    NSLog(@"arrowed button");
}

@end
