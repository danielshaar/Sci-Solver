//
//  Term.h
//  StulinFinal
//
//This object represents a term in an equation
//
//  Created by Shiv Roychowdhury on 5/25/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Term : NSObject
{
    //Coefficent of term
    NSNumber *coef;
    //Variables
    NSMutableArray *vars;
    //Identifiers are indexed based on the variable they belong
    NSDictionary *varDict;
}

//Initialize with a coefficient and an array of variables.
- (id)initWithCoef:(double)d
             vars:(NSArray *)v;
//Set the value for a variable
- (void)setValue:(double)d
      forVar:(NSString *)i;
//The variables in the term
- (NSArray *)vars;
//The coefficient of the term
- (double)coef;
//Simplify
- (Term *)simplifiedTerm;
//The net value of the term
- (NSNumber *)netValue;


@end
