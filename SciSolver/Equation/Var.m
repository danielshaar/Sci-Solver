//
//  Var.m
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 5/25/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "Var.h"

@implementation Var

@synthesize var, power;

//Init using a string
- (id)initWithVar:(NSString *)t
{
    self = [super init];
    if (self) {
        var = [[t componentsSeparatedByString:@"^"] objectAtIndex:0];
        //If the name is numeric, then throw an exception
        power = 1;
        if ([[t componentsSeparatedByString:@"^"] count] == 2) {
            power = [[[t componentsSeparatedByString:@"^"] objectAtIndex:1] intValue];
        }
    }
    return self;
}

//Set the variable value, passing NSNotFound denotes no value
- (void)setVarValue:(double)d
{
    if (d == NSNotFound) {
        value = nil;
        return;
    }
    value = [NSNumber numberWithDouble:d];
}

//Net value of the variable
- (NSNumber *)netValue
{
    if (power == 0) {
        return [NSNumber numberWithDouble:1];
    }
    if (!value) {
        return nil;
    }
    return [NSNumber numberWithDouble:pow(value.doubleValue, power)];
}

- (NSString *)description
{
    if ([self netValue]) {
        return [[self netValue] description];
    }
    if (power != 0 && power != 1) {
        return [NSString stringWithFormat:@"%@^%g", var, power];
    }
    return var;
}

- (void)dealloc
{
    value = nil;
    var = nil;
    NSLog(@"var");
}

@end
