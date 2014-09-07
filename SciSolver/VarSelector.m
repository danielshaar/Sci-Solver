//
//  VarSelector.m
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import "VarSelector.h"
#import "ArrowedButton.h"
#import "EquationInput.h"
#import "Formatter.h"
#import "FPPopoverController.h"

@interface VarSelector ()

@end

@implementation VarSelector

@synthesize selectorButton;

- (id)initWithEquationInput:(EquationInput *)eqi
                       vars:(NSArray *)n
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        selectorButton = [[ArrowedButton alloc] initWithPoint:CGPointMake(110, 75) length:70];
        [selectorButton addTarget:self
                       action:@selector(presentSelectorPopover)
             forControlEvents:UIControlEventTouchUpInside];
        
        equationInput = eqi;
        vars = n;
        selected = [vars objectAtIndex:0];
        
        selectorButton.drawUpArrow = ![selected isEqualToString:[vars objectAtIndex:0]];
        selectorButton.drawDownArrow = ![selected isEqualToString:[vars objectAtIndex:vars.count-1]];
        
        selectorButton.titleLabel.attributedText = [[Formatter defaultFormatter] getFormattedVar:selected];
    }
    return self;
}

- (void)presentSelectorPopover;
{
    [self.tableView reloadData];
    fp = [[FPPopoverController alloc] initWithViewController:self];
    [fp presentPopoverFromView:selectorButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return vars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Make if nonexistent
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
        [cell setBounds:CGRectMake(0, 0, 280, 44)];
    }
    
    //Set up checmark for cell, if necessary
    if ([selected isEqualToString:[vars objectAtIndex:indexPath.row]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        cell.textLabel.textColor = specialBlueColor;
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.attributedText = [[Formatter defaultFormatter] getFormattedVar:[vars objectAtIndex:indexPath.row]];
    return cell;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected = [vars objectAtIndex:indexPath.row];
    [equationInput setUnknownVar:selected];
    selectorButton.titleLabel.attributedText = [[Formatter defaultFormatter] getFormattedVar:selected];
    selectorButton.drawUpArrow = ![selected isEqualToString:[vars objectAtIndex:0]];
    selectorButton.drawDownArrow = ![selected isEqualToString:[vars objectAtIndex:vars.count-1]];
    [selectorButton setNeedsDisplay];
    [fp dismissPopoverAnimated:YES];
}

- (void)dealloc
{
    fp = nil;
    vars = nil;
    selected = nil;
    equationInput = nil;
    selectorButton = nil;
    NSLog(@"var selector");
}

@end
