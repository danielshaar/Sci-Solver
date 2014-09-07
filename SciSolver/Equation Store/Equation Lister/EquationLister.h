//
//  EquationLister.h
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/5/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquationLister : UITableViewController
{
    //Array of the equations
    NSArray *equationArray;
}

//Init with equations
- (id)initWithEquations:(NSArray *)eq;

@end
