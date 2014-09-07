//
//  Equation.h
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 5/25/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EquationInput;

//A block used for solving the equation
typedef NSString *(^SolveBlock)(NSArray *terms);

@interface Equation : NSObject
//Is even?
#define isEven(a) ((((a<0) ? -a : a)%2) == 0)

{
    //Array of terms in the equation
    NSMutableArray *terms;
    //The solve algorithm used for the equation
    SolveBlock solveBlock;
}

//Title of the equation
@property (nonatomic, readonly) NSString *title;
//String detailing the equation
@property (nonatomic, readonly) NSString *equationString;
@property (nonatomic, readonly) NSDictionary *varDefs;

//Init with all relevant information
- (id)initWithTitle:(NSString *)t
     equationString:(NSString *)eqStr
    literalEquation:(NSString *)litEq
            varDefs:(NSDictionary *)vd;

//Set the value for a var
- (void)setValue:(double)d forVar:(NSString *)i;

//Solve the equation
- (NSString *)solve;

//Clear the variables in the equation
- (void)clear;

//Formatted equation string
- (NSMutableAttributedString *)formattedEquationString;

//All the variables
- (NSArray *)vars;

//Set the solveBlock
- (void)setSolveBlock:(SolveBlock)s;

//Get the input fot this equation
- (id)equationInput;

@end
