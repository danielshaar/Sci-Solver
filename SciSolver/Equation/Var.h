//
//  Var.h
//  StulinFinal
//
// This object represents a singe variable in an equation, and includes its variable
//
//  Created by Shiv Roychowdhury on 5/25/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Var : NSObject
//an absoluste value macro
#define absolute(a) ((a < 0) ? -a : a)
#define nonNumericRegex(name) ([[NSRegularExpression regularExpressionWithPattern:@"\\D" options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])] == 0)

{
    //The value of the var
    NSNumber *value;
}

//name of the variable i.e. x, y, n
@property (nonatomic, readonly) NSString *var;
//The real number power of the variable
@property (nonatomic, readonly) double power;

//Intialize a variable with a string that details its non-numeric name and power, not value
- (id)initWithVar:(NSString *)t;

//Set the variable value
- (void)setVarValue:(double)d;

//The net value of the variable
- (NSNumber *)netValue;


@end
