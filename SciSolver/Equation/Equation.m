//
//  Equation.m
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 5/25/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "Equation.h"
#import "EquationInput.h"
#import "Term.h"
#import "Var.h"
#import "Formatter.h"

@implementation Equation
@synthesize title, equationString, varDefs;

- (id)initWithTitle:(NSString *)t
     equationString:(NSString *)eqStr
    literalEquation:(NSString *)litEq
            varDefs:(NSDictionary *)vd
{
    self = [super init];
    if (self) {
        title = t;
        equationString = eqStr;
        terms = [self decodeEquation:litEq];
        varDefs = vd;
    }
    return self;
}

//Decode an equation
- (NSMutableArray *)decodeEquation:(NSString *)s
{
    NSMutableArray *newTerms = [NSMutableArray array];
    //Separate each term
    NSArray *stringTerms = [s componentsSeparatedByString:@"+"];
    //Decode each term
    for (int i = 0; i < stringTerms.count; i++) {
        //Divide each term for evaluation
        NSArray *termParts = [[stringTerms objectAtIndex:i] componentsSeparatedByString:@"*"];
        //Coef is first component
        double coefficient = [[Formatter defaultFormatter] getInputAsDouble:[termParts objectAtIndex:0]];
        NSMutableArray *vars = [NSMutableArray array];
        //Get al variables
        for (int j = 1; j < termParts.count; j++) {
            NSString *stringVar = [termParts objectAtIndex:j];
            Var *var = [[Var alloc] initWithVar:stringVar];
            [vars addObject:var];
        }
        //Add the term to the new set of terms
        Term *t = [[Term alloc] initWithCoef:coefficient vars:vars];
        [newTerms addObject:t];
    }
    return newTerms;
}

//Set the value for a variable. NSNotFound indicates no value
- (void)setValue:(double)d
      forVar:(NSString *)i
{
    //Go thorugh all terms and set the value
    for (int j = 0; j < terms.count; j++) {
        [[terms objectAtIndex:j] setValue:d forVar:i];
    }
}

//Solve
- (NSString *)solve
{
    //Use the solve block if necessary
    if (solveBlock) {
        return solveBlock(terms);
    }
    double constant = 0;
    NSMutableArray *termsLeft = [NSMutableArray array];
    //Find the constant of the equation and the terms left
    for (int i = 0; i < terms.count; i++) {
        //Add the net value into the constant if there is one
        if ([[terms objectAtIndex:i] netValue]) {
            constant += [[[terms objectAtIndex:i] netValue] doubleValue];
            //Add the simplified term to the terms left in the equation
        } else {
            [termsLeft addObject:[[terms objectAtIndex:i] simplifiedTerm]];
        }
    }
    constant *= -1;
    //Find the vars that are left
    NSMutableSet *varsLeft = [NSMutableSet set];
    for (int i = 0; i < terms.count; i++) {
        NSArray *vars = [[terms objectAtIndex:i] vars];
        for (int j = 0; j < vars.count; j++) {
            //If there is no value to the var, then it to the vars left
            if (![[vars objectAtIndex:j] netValue])
                [varsLeft addObject:[(Var *)[vars objectAtIndex:j] var]];
        }
    }
    //This model only solves for one variable
    if (varsLeft.count != 1) {
        return nil;
    }
    //Get the var
    Term *term = [termsLeft objectAtIndex:0];
    Var *var = [term.vars objectAtIndex:0];
    //Calculate the answer and format correctly
    @try {
        double base = constant/[term coef];
        double power = var.power;
        double absBase = absolute(base);
        double answer = powf(absBase, 1.0/power);
        if (base < 0) {
            if (isEven((int)power) | isEven((int)(1.0/power))) {
                return [NSString stringWithFormat:@"i*%g", answer];
            } else {
                answer *= -1.0000;
            }
        }
        return [NSString stringWithFormat:@"%g", answer];
    } @catch (NSException *e) {
        return @"nan";
    }
}

- (void)clear
{
    NSArray *vars = [self vars];
    for (int i = 0; i < vars.count; i++) {
        [self setValue:NSNotFound forVar:[vars objectAtIndex:i]];
    }
}

//Get the formatted equation string, using the Formatter class
- (NSMutableAttributedString *)formattedEquationString
{
    return [[Formatter defaultFormatter] getFormattedEquationString:self.equationString];
}

//Get the vars in alphabetical order
- (NSArray *)vars
{
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    for (int i = 0; i < terms.count; i++) {
        NSArray *termVars = [[terms objectAtIndex:i] vars];
        for (int j = 0; j < termVars.count; j++) {
            [vars setValue:[NSArray array] forKey:[[termVars objectAtIndex:j] var]];
        }
    }
    return [vars.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

//Set solve block
- (void)setSolveBlock:(SolveBlock)s
{
    solveBlock = s;
}

- (id)equationInput
{
    return [[EquationInput alloc] initWithEquation:self];
}

- (void)dealloc
{
    terms = nil;
    solveBlock = NULL;
    title = nil;
    equationString = nil;
    varDefs = nil;
    NSLog(@"equation");
}

@end