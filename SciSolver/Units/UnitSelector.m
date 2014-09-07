//
//  UnitSelector.m
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import "UnitSelector.h"
#import "ArrowedButton.h"
#import "UnitCollection.h"
#import "Equation.h"
#import "Formatter.h"
#import "FPPopoverController.h"

@interface UnitSelector ()

@end

@implementation UnitSelector

@synthesize selectorButton;

- (id)initWithOrigin:(CGPoint)p
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        selectorButton = [[ArrowedButton alloc] initWithPoint:p length:60];
        [selectorButton addTarget:self
                       action:@selector(presentSelectorPopover)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)presentSelectorPopover;
{
    [self.tableView reloadData];
    fp = [[FPPopoverController alloc] initWithViewController:self];
    [fp presentPopoverFromView:selectorButton];
}

//Set the default unit
- (void)setDefaultUnit:(NSString *)s
{
    //Get all units
    NSArray *units = [UnitCollection completeUnitCollection];
    for (int i = 0; i < units.count; i++) {
        //Go through each one and see if the given unit is in the view
        NSDictionary *unitDict = [[units objectAtIndex:i] objectAtIndex:0];
        NSArray *unitList = [[units objectAtIndex:i] objectAtIndex:1];
        if ([unitList indexOfObject:s] != NSNotFound) {
            unitDictionary = unitDict;
            selectableUnits = unitList;
            defaultUnit = s;
            targetUnit = s;
            break;
        }
    }
    
    selectorButton.drawUpArrow = ![targetUnit isEqualToString:[selectableUnits objectAtIndex:0]];
    selectorButton.drawDownArrow = ![targetUnit isEqualToString:[selectableUnits objectAtIndex:selectableUnits.count-1]];
    
    //If no default unit, the disable the unit picker
    if (!defaultUnit) {
        defaultUnit = s;
        selectorButton.userInteractionEnabled = NO;
    }
    selectorButton.titleLabel.text = defaultUnit;
    [selectorButton setNeedsDisplay];
}

- (NSString *)toOriginalUnit:(NSString *)s
{
    if (!selectorButton.userInteractionEnabled) {
        return s;
    }
    
    if ([defaultUnit isEqualToString:@"K"]) {
        return [self toKelvin:s];
    }
    
    double d = [[Formatter defaultFormatter] getInputAsDouble:s];
    double defaultScale = [[unitDictionary valueForKey:defaultUnit] doubleValue];
    double targetScale = [[unitDictionary valueForKey:targetUnit] doubleValue];
    d *= defaultScale / targetScale;
    return [NSString stringWithFormat:@"%g", d];
}

- (NSString *)toSelectedUnit:(NSString *)s
{
    if (!selectorButton.userInteractionEnabled) {
        return s;
    }
    
    if ([defaultUnit isEqualToString:@"K"]) {
        return [self toSelectedTempScale:s];
    }
    
    if ([s isEqualToString:@"nan"] || [s isEqualToString:@"inf"]) {
        return s;
    }
    
    double defaultScale = [[unitDictionary valueForKey:defaultUnit] doubleValue];
    double targetScale = [[unitDictionary valueForKey:targetUnit] doubleValue];
    
    if (([s rangeOfString:@"i"]).location != NSNotFound) {
        double d1 = [[[[[s componentsSeparatedByString:@","] objectAtIndex:0] componentsSeparatedByString:@"i"] objectAtIndex:0] doubleValue];
        double di1 = [[[[[s componentsSeparatedByString:@","] objectAtIndex:0] componentsSeparatedByString:@"i"] objectAtIndex:1] doubleValue];
        double d2 = [[[[[s componentsSeparatedByString:@","] objectAtIndex:1] componentsSeparatedByString:@"i"] objectAtIndex:0] doubleValue];
        double di2 = [[[[[s componentsSeparatedByString:@","] objectAtIndex:1] componentsSeparatedByString:@"i"] objectAtIndex:1] doubleValue];
        d1 *= targetScale / defaultScale;
        d2 *= targetScale / defaultScale;
        di1 *= targetScale / defaultScale;
        di2 *= targetScale / defaultScale;
        return [NSString stringWithFormat:@"%g+i*%g, %g-i%g", d1, di1, d2, di2];
    } else if (([s rangeOfString:@","]).location != NSNotFound) {
        double d1 = [[[s componentsSeparatedByString:@","] objectAtIndex:0] doubleValue];
        double d2 = [[[s componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
        d1 *= targetScale / defaultScale;
        d2 *= targetScale / defaultScale;
        return [NSString stringWithFormat:@"%g, %g", d1, d2];
    }
    
    double d = [[Formatter defaultFormatter] getInputAsDouble:s];
    d *= defaultScale / targetScale;
    return [NSString stringWithFormat:@"%g", d];
}

- (NSString *)toKelvin:(NSString *)s
{
    double d = [[Formatter defaultFormatter] getInputAsDouble:s];
    if ([targetUnit isEqualToString:@"°F"]) {
        Equation *eq = [unitDictionary valueForKey:targetUnit];
        [eq clear];
        [eq setValue:d forVar:@"F"];
        return [eq solve];
    } else if ([targetUnit isEqualToString:@"°C"]) {
        Equation *eq = [unitDictionary valueForKey:targetUnit];
        [eq clear];
        [eq setValue:d forVar:@"C"];
        return [eq solve];
    }
    return s;
}

- (NSString *)toSelectedTempScale:(NSString *)s
{
    double d = [[Formatter defaultFormatter] getInputAsDouble:s];
    if ([targetUnit isEqualToString:@"°F"] || [targetUnit isEqualToString:@"°C"]) {
        Equation *eq = [unitDictionary valueForKey:targetUnit];
        [eq clear];
        [eq setValue:d forVar:@"K"];
        return [eq solve];
    }
    return s;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return selectableUnits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
        [cell setBounds:CGRectMake(0, 0, 280, 44)];
    }
    
    //Set up checmark for cell, if necessary
    if ([targetUnit isEqualToString:[selectableUnits objectAtIndex:indexPath.row]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        cell.textLabel.textColor = properBlueColor;
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = [selectableUnits objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    targetUnit = [selectableUnits objectAtIndex:indexPath.row];
    selectorButton.titleLabel.text = targetUnit;
    selectorButton.drawUpArrow = ![targetUnit isEqualToString:[selectableUnits objectAtIndex:0]];
    selectorButton.drawDownArrow = ![targetUnit isEqualToString:[selectableUnits objectAtIndex:selectableUnits.count-1]];
    [selectorButton setNeedsDisplay];
    [fp dismissPopoverAnimated:YES];
}

 - (void)dealloc
{
    fp = nil;
    unitDictionary = nil;
    selectableUnits = nil;
    defaultUnit = nil;
    targetUnit = nil;
    selectorButton = nil;
    NSLog(@"unit selector");
}

@end
