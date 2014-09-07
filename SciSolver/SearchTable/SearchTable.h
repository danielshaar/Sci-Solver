//
//  SearchTable.h
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchHelper;

@interface SearchTable : UITableViewController <UISearchBarDelegate>
{
    SearchHelper *searchHelper;
    NSArray *searchedChemEquations;
    NSArray *searchedPhysicsEquations;
    BOOL isSearching;
}

@end
