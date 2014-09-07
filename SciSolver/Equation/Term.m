//
//  Term.m
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 5/25/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "Term.h"
#import "Var.h"

@implementation Term

- (id)initWithCoef:(double)d vars:(NSArray *)v
{
    self = [super init];
    if (self) {
        coef = [NSNumber numberWithDouble:d];
        //Set up the name dictionary
        NSMutableDictionary *varNames = [NSMutableDictionary dictionary];
        for (int i = 0; i < v.count; i++) {
            [varNames setValue:[v objectAtIndex:i] forKey:[[(Var *)[v objectAtIndex:i] var] copy]];
        }
        
        varDict = varNames;
        
        //Sort the var names
        NSArray *sortedKeys = [varNames.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        vars = [NSMutableArray array];
        for (int i = 0; i < sortedKeys.count; i++) {
            [vars addObject:[varNames valueForKey:[sortedKeys objectAtIndex:i]]];
        }
    }
    return self;
}

//Set the value of a variable name
- (void)setValue:(double)d
      forVar:(NSString *)i
{
    for (int j = 0; j < vars.count; j++) {
        if ([[[vars objectAtIndex:j] var] isEqualToString:i]) {
            [[vars objectAtIndex:j] setVarValue:d];
        }
    }
}

//Get the variables
- (NSArray *)vars
{
    return vars;
}

//Get the variables
- (double)coef
{
    return coef.doubleValue;
}

//Get the simplified term
- (Term *)simplifiedTerm
{
    double coefD = [coef doubleValue];
    NSMutableArray *newVars = [NSMutableArray array];
    
    for (int i = 0; i < vars.count; i++) {
        if ([[vars objectAtIndex:i] netValue]) {
            //If the varialbe has a value, multiply the net value into the constant
            coefD *= [[[vars objectAtIndex:i] netValue] doubleValue];
        } else {
            //Add the variable to the list of new variables
            [newVars addObject:[vars objectAtIndex:i]];
        }
    }
    
    Term *simpleTerm = [[Term alloc] initWithCoef:coefD vars:newVars];
    
    return simpleTerm;

}

//Get the net real number value for the term
- (NSNumber *)netValue
{
    double constant = [coef doubleValue];
    
    if (!vars) {
        return [NSNumber numberWithDouble:constant];
    }
    
    for (int i = 0; i < vars.count; i++) {
        if ([[vars objectAtIndex:i] netValue]) {
            //Multiply the net value, if there is one, into the constant
            constant *= [[[vars objectAtIndex:i] netValue] doubleValue];
        } else {
            //If one variable has no net value, then the term has not net value
            return nil;
        }
    }
    
    return [NSNumber numberWithDouble:constant];
}

- (NSString *)description
{
    double coefD = [coef doubleValue];
    NSMutableArray *newVars = [NSMutableArray array];
    
    for (int i = 0; i < vars.count; i++) {
        if ([[vars objectAtIndex:i] netValue]) {
            coefD *= [[[vars objectAtIndex:i] netValue] doubleValue];
        } else {
            [newVars addObject:[vars objectAtIndex:i]];
        }
    }
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%g", coefD];
    for (int i = 0; i < newVars.count; i++) {
        [string appendFormat:@"%@", [newVars objectAtIndex:i]];
    }
    return string;
}

- (void)dealloc
{
    coef = nil;
    vars = nil;
    varDict = nil;
    NSLog(@"term");
}

@end
