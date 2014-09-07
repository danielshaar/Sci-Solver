//
//  SearchTable.m
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import "SearchTable.h"
#import "SearchHelper.h"
#import "EquationStore.h"
#import "Equation.h"
#import "EquationLister.h"

@interface SearchTable ()

@end

@implementation SearchTable

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = @"Search For Equation";
        searchHelper = [[SearchHelper alloc] init];
    }
    return self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isSearching = NO;
        [self.tableView reloadData];
        return;
    }
    isSearching = YES;
    NSArray *searchedEquations = [searchHelper getFilteredArrayWithString:searchText];
    searchedChemEquations = [searchedEquations objectAtIndex:0];
    searchedPhysicsEquations = [searchedEquations objectAtIndex:1];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    isSearching = false;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) {
        if (section == 0) {
            return searchedChemEquations.count;
        } else {
            return searchedPhysicsEquations.count;
        }
    }
    if (section == 0) {
        return [[EquationStore sharedStore] chemEquations].count;
    } else {
        return [[EquationStore sharedStore] physicsEquations].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (isSearching) {
        NSArray *searchedEquations;
        if (indexPath.section == 0) {
            searchedEquations = searchedChemEquations;
        } else  {
            searchedEquations = searchedPhysicsEquations;
        }
        cell.textLabel.text = [searchedEquations objectAtIndex:indexPath.row];
        NSMutableAttributedString *eqStr;
        NSArray *equations = [[EquationStore  equationDictionary] valueForKey:[searchedEquations objectAtIndex:indexPath.row]];
        if (equations.count == 1) {
            eqStr = [[equations objectAtIndex:0] formattedEquationString];
        } else {
            eqStr = [[NSMutableAttributedString alloc] initWithString:@"(Several)"];
        }
        cell.detailTextLabel.attributedText = eqStr;
        return cell;
    }
    [[cell textLabel] setText:[[[EquationStore sharedStore] allEquations] objectAtIndex:[indexPath section] * [[EquationStore sharedStore] chemEquations].count + [indexPath row]]];
    NSMutableAttributedString *eqStr;
    NSArray *equations = [[EquationStore  equationDictionary] valueForKey:[[[EquationStore sharedStore] allEquations] objectAtIndex:[indexPath section] * [[EquationStore sharedStore] chemEquations].count + [indexPath row]]];
    if (equations.count == 1) {
        eqStr = [[equations objectAtIndex:0] formattedEquationString];
    } else {
        eqStr = [[NSMutableAttributedString alloc] initWithString:@"(Several)"];
    }
    cell.detailTextLabel.attributedText = eqStr;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Chemistry";
    }
    return @"Physics";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSArray *equations = [[EquationStore  equationDictionary] valueForKey:title];
    
    //Push the correct view controller according to the number of equations or else push a list of possible equations
    if (equations.count == 1) {
        [self.navigationController pushViewController:[[equations objectAtIndex:0] equationInput] animated:YES];
    } else {
        [self.navigationController pushViewController:[[EquationLister alloc] initWithEquations:equations] animated:YES];
    }
}

- (void)dealloc
{
    searchHelper = nil;
    searchedChemEquations = nil;
    searchedPhysicsEquations = nil;
    NSLog(@"search menu");
}

@end
