//
//  Formatter.m
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 6/2/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "Formatter.h"

@implementation Formatter

+ (Formatter *)defaultFormatter
{
    static Formatter *defualt = nil;
    
    if (!defualt) {
        defualt = [[super allocWithZone:nil] init];
    }
    
    return defualt;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultFormatter];
}

- (double)getInputAsDouble:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"e"];
    double d = [[arr objectAtIndex:0] doubleValue];
    if (arr.count == 2) {
        double p = [[arr objectAtIndex:1] doubleValue];
        d*=pow(10.000000000, p);
    }
    return d;
}

- (NSMutableAttributedString *)getFormattedEquationString:(NSString *)str
{
    NSMutableAttributedString *whole = [[NSMutableAttributedString alloc] initWithString:@""];
    int i = 0;
    while (i < str.length) {
        NSString *s = [str substringWithRange:NSMakeRange(i, 1)];
        NSMutableAttributedString *specialPart = nil;
        if ([s isEqualToString:@"@"] || [s isEqualToString:@"^"]) {
            i++;
            specialPart = [[NSMutableAttributedString alloc] initWithString:@""];
            while (true) {
                NSMutableAttributedString *specialPartChar = [[NSMutableAttributedString alloc] initWithString:[str substringWithRange:NSMakeRange(i, 1)]];
                BOOL b = [s isEqualToString:@"@"];
                if (i == str.length-1 || [[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"|"]) {
                    [specialPart addAttribute:(id)kCTSuperscriptAttributeName
                                        value:(b ? @"-1" : @"1")
                                        range:NSMakeRange(0, specialPart.length)];
                    break;
                }
                [specialPart appendAttributedString:specialPartChar];
                i++;
            }
        }
        NSMutableAttributedString *piece = [[NSMutableAttributedString alloc] initWithString:s];
        if (specialPart) {
            [whole appendAttributedString:specialPart];
        } else {
            [whole appendAttributedString:piece];
        }
        i++;
    }
    return whole;
}

- (NSMutableAttributedString *)getFormattedVar:(NSString *)var
{
    NSArray *arr = [var componentsSeparatedByString:@"@"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[arr objectAtIndex:0]];
    if (arr.count == 2) {
        NSMutableAttributedString *sub = [[NSMutableAttributedString alloc] initWithString:[arr objectAtIndex:1]];
        [sub addAttribute:(id)kCTSuperscriptAttributeName
                    value:@"-1"
                    range:NSMakeRange(0, sub.length)];
        [str appendAttributedString:sub];
    }
    return str;
}

@end
