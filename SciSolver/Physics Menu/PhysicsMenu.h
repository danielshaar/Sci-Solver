//
//  PhysicsMenu.h
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/4/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhysicsMenu : UITableViewController
{
    NSString *currentTitle;
}

//A macro used to get the equation title for a given row
//Despite only being used once, it cleans up the code quite a bit
#define pGetEqTitleForRow(r) [[[EquationStore sharedStore] physicsEquations] objectAtIndex:r]

//A macro used to get all the equations for a given row
//Despite only being used once, it cleans up the code quite a bit
#define pGetEqArrayForRow(r) [[EquationStore  equationDictionary] valueForKey:[[[EquationStore sharedStore] physicsEquations] objectAtIndex:r]];


@end
