//
//  Formatter.h
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 6/2/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface Formatter : NSObject

+ (Formatter *)defaultFormatter;

- (double)getInputAsDouble:(NSString *)str;
- (NSMutableAttributedString *)getFormattedEquationString:(NSString *)str;
- (NSMutableAttributedString *)getFormattedVar:(NSString *)var;

@end
