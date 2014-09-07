//
//  VarSelector.h
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArrowedButton;
@class EquationInput;
@class FPPopoverController;

@interface VarSelector : UITableViewController

#define specialBlueColor [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0]

{
    FPPopoverController *fp;
    //Names of selectable variables
    NSArray *vars;
    //The currently selected var
    NSString *selected;
    //The corresponding equation input
    __weak EquationInput *equationInput;
}

@property (nonatomic, readonly) ArrowedButton *selectorButton;

//init with equation input and var names
- (id)initWithEquationInput:(EquationInput *)eqi vars:(NSArray *)n;

@end
