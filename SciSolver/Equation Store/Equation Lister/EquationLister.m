//
//  EquationLister.m
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/5/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "EquationLister.h"
#import "Equation.h"
#import "Formatter.h"

@interface EquationLister ()

@end

@implementation EquationLister

- (id)initWithEquations:(NSArray *)eq
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        equationArray = eq;
        self.title = [[eq objectAtIndex:0] title];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Only one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of equations
    return equationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Reuse a cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Create is nonexistent
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    //Add the arrow to the end of the cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if ([[[equationArray objectAtIndex:0] title] isEqualToString:@"Newton's 2nd Law"] && indexPath.row == 1) {
        cell.textLabel.attributedText = [[Formatter defaultFormatter] getFormattedEquationString:@"F@net| = F@1| + F@2| + F@3| +..."];
        return cell;
    }

    //Set cell to formatted equation string
    cell.textLabel.attributedText = [[equationArray objectAtIndex:indexPath.row] formattedEquationString];
    
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[equationArray objectAtIndex:0] title] isEqualToString:@"Newton's 2nd Law"] && indexPath.row == 1) {
        [self.navigationController pushViewController:[equationArray objectAtIndex:indexPath.row] animated:YES];
        return;
    }
    //Push the corresponding equation input
    [self.navigationController pushViewController:[[equationArray objectAtIndex:indexPath.row] equationInput] animated:YES];
}

- (void)dealloc
{
    equationArray = nil;
    NSLog(@"equation lister");
}

@end
