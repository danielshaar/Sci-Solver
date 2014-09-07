//
//  PhysicsMenu.m
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/4/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "PhysicsMenu.h"
#import "EquationStore.h"
#import "EquationLister.h"
#import "Equation.h"

@interface PhysicsMenu ()

@end

@implementation PhysicsMenu

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Set the title of view controller
        self.title = @"Physics Equations";
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Only one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //The number of chemistry equations
    return [[[EquationStore sharedStore] chemEquations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Reuse a cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Create is nonexistent
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellIdentifier];
    }
    //Add the arrow to the end of the cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //The chemistry topic at a given row
    NSString *topic = pGetEqTitleForRow(indexPath.row);
    cell.textLabel.text = topic;
    NSMutableAttributedString *eqStr;
    
    //If topic has one equation, the detail label is the equation string, else its simply
    //says several
    NSArray *equations = pGetEqArrayForRow(indexPath.row);
    
    if (equations.count == 1) {
        eqStr = [[equations objectAtIndex:0] formattedEquationString];
    } else {
        eqStr = [[NSMutableAttributedString alloc] initWithString:@"(Several)"];
    }
    
    cell.detailTextLabel.attributedText = eqStr;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get all possible equations
    NSArray *equations = pGetEqArrayForRow(indexPath.row);
    
    //Push the correct view controller according to the number of equations or else push a list of possible equations
    if (equations.count == 1) {
        [self.navigationController pushViewController:[[equations objectAtIndex:0] equationInput] animated:YES];
    } else {
        [self.navigationController pushViewController:[[EquationLister alloc] initWithEquations:equations] animated:YES];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    currentTitle = self.title;
    self.title = @"Back";
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    if (currentTitle) {
        self.title = currentTitle;
    }
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    currentTitle = nil;
    NSLog(@"feezax menu");
}

@end
