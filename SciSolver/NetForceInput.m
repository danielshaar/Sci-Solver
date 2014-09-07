//
//  FnetInput.m
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import "NetForceInput.h"
#import "Equation.h"
#import "Formatter.h"
#import "VarSelector.h"
#import "UnitSelector.h"
#import "ArrowedButton.h"

@interface NetForceInput ()

@end

@implementation NetForceInput

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setUpKeyboardNotifications];
        
        [self setUpKeyboardToolbar];
        
        Equation *e = [[Equation alloc] initWithTitle:@"Newton's 2nd Law"
                                       equationString:@"F@net| = F@1| + F@2| + F@3| +..."
                                      literalEquation:nil
                                              varDefs:nil];
        
        self.equation = e;
        
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentViewHeight)];
        [contentView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
        contentView.backgroundColor = [UIColor clearColor];

        self.title = self.equation.title;
        vars = @[
                 @"F@net",
                 @"θ@net",
                 @"F@1",
                 @"θ@1",
                 @"F@2",
                 @"θ@2",
                 @"F@3",
                 @"θ@3",
                 ];
        
        varDefs = [@[
                   @"Net Force",
                   @"Final Angle"
                   @"Force 1"
                   @"Angle 1"
                   @"Force 2"
                   @"Angle 2"
                   @"Force 3"
                   @"Angle 3"
                   ] mutableCopy];
        
        textFields = [NSMutableArray array];
        unitSelectors = [NSMutableArray array];
        contentView.contentSize = CGSizeMake(320, 75+40*(vars.count));
        
        [self setUpEquationView];
        
        for (int i = 0; i < vars.count; i++) {
            [self setUpRow:i];
        }
        
        [self rectifyView];
        
        if (!(currentOS >= 7.0)) {
            [self configureForiOS6];
        } else {
            [self configureForiOS7];
        }
    }
    return self;
}

- (void)setUpRow:(int)i
{
    int rowOffs = 75;
    //var label
    UILabel *varLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, rowOffs+40*i, 80, 30)];
    varLabel.attributedText = [[Formatter defaultFormatter] getFormattedVar:[vars objectAtIndex:i]];
    varLabel.adjustsFontSizeToFitWidth = YES;
    varLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:varLabel];
    
    //Save unit for the unit picker later
    NSString *unit = ((i%2)==0) ? @"N" : @"rad";
    
    //Input field
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, rowOffs+40*i, 150, 30)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.inputAccessoryView = keyboardToolbar;
    if (!(i >=2 )) {
        textField.userInteractionEnabled = NO;
        textField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }
    [textFields addObject:textField];
    [contentView addSubview:textField];
    
    //The unit picker, which defaults to the first variable. This also attempts to emulate first responder behavior
    UnitSelector *up = [[UnitSelector alloc] initWithOrigin:CGPointMake(250, rowOffs+40*i)];
    [up setDefaultUnit:unit];
    [up.selectorButton addTarget:self action:@selector(resignAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
    
    [unitSelectors addObject:up];
    [contentView addSubview:up.selectorButton];
}

- (void)solveEquation
{
    [self resignAllFirstResponders];
    //Reset the size of the scroller
    [contentView setContentOffset:CGPointMake(0, 0)];
    contentView.frame = CGRectMake(0, 0, 320, contentViewHeight);
    
    int values[6];
    for (int i = 2; i < vars.count; i++) {
        NSString *value = [[textFields objectAtIndex:i] text];
        //If the string is empty, through an error message
        if ([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Improper input"
                                                            message:@"You must input a number."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        //Set the value, once converted to the correct units, for the variable
        double numValue = [[[unitSelectors objectAtIndex:i] toOriginalUnit:value] doubleValue];
        values[i-2] = numValue;
    }
    double force1 = values[0];
    double force2 = values[2];
    double force3 = values[4];
    double angle1 = values[1];
    double angle2 = values[3];
    double angle3 = values[5];
    double answer1 = pow(pow((force1 * cos(angle1) + force2 * cos(angle2) + force3 * cos(angle3)), 2) + pow((force1 * sin(angle1) + force2 * sin(angle2) + force3 * sin(angle3)), 2), 0.5);
    double answer2 = atan((force1 * cos(angle1) + force2 * cos(angle2) + force3 * cos(angle3)) / (force1 * sin(angle1) + force2 * sin(angle2) + force3 * sin(angle3)));
    [[textFields objectAtIndex:0] setText:[NSString stringWithFormat:@"%g", answer1]];
    [[textFields objectAtIndex:1] setText:[NSString stringWithFormat:@"%g", answer2]];
}

@end
