//
//  UnitSelector.h
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArrowedButton;
@class FPPopoverController;

@interface UnitSelector : UITableViewController
{
    FPPopoverController *fp;
    //Dictionary of selectable units and reference scales
    NSDictionary *unitDictionary;
    //List of selectalbe units
    NSArray *selectableUnits;
    NSString *defaultUnit;
    NSString *targetUnit;
}

@property (nonatomic, readonly) ArrowedButton *selectorButton;

//Init with origin and view that will display the unit picker
- (id)initWithOrigin:(CGPoint)p;
//Set the default unit
- (void)setDefaultUnit:(NSString *)s;
//Convert to Original unit
//will be edited for a special equation that may yield two answers for one for one variable
- (NSString *)toOriginalUnit:(NSString *)s;
//Convert to selected unit
//will be edited for a special equation that may yield two answers for one for one variable
- (NSString *)toSelectedUnit:(NSString *)s;

@end
