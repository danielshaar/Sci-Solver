//
//  Units.m
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/4/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "UnitCollection.h"
#import "Equation.h"

@implementation UnitCollection

+ (NSArray *)completeUnitCollection
{
    NSMutableArray *allDictionaries = [NSMutableArray array];
    
    
    
    NSDictionary *defaultDictionary = @ {
        @"cubic m" : @(pow(10.0, -3.0)),
        @"L" : @1.0,
        @"mL" : @(pow(10.0, 3.0)),
        @"gal" : @0.264172,
        @"pint" : @2.11338,
        @"quart" : @1.05669
    };

    NSArray *possibleUnits = @[
                               @"cubic m",
                               @"L",
                               @"mL",
                               @"gal",
                               @"pint",
                               @"quart"
                               ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"km" : @0.001,
        @"m" : @1.0,
        @"cm" : @100.0,
        @"mm" : @1000.0,
        @"in" : @(39.3701),
        @"ft" : @(3.28084),
        @"yard" : @(1.09361),
        @"mi" : @(0.000621371)
    };
    
    possibleUnits = @[
                      @"km",
                      @"m",
                      @"cm",
                      @"mm",
                      @"in",
                      @"ft",
                      @"yard",
                      @"mi",
                      ];

    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"kg" : @0.001,
        @"g" : @1.0,
        @"mg" : @1000.0,
    };
    
    possibleUnits = @[
                      @"kg",
                      @"g",
                      @"mg",
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"km/s" : @0.001,
        @"m/s" : @1.0,
        @"mph" : @(2.23694),
    };
    
    possibleUnits = @[
                      @"km/s",
                      @"m/s",
                      @"mph",
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];

    defaultDictionary = @ {
        @"km/s^2" : @0.001,
        @"m/s^2" : @1.0
    };
    
    possibleUnits = @[
                      @"km/s^2",
                      @"m/s^2"
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"kJ" : @0.001,
        @"J" : @1.0,
        @"eV" : @(6.24150934 * pow(10.0, 18.0)),
        @"cal" : @(0.239005736),
        @"kcal" : @(0.000239005736)
    };
    
    possibleUnits = @[
                      @"kJ",
                      @"J",
                      @"eV",
                      @"cal",
                      @"kcal"
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"mol/kg" : @1000.0,
        @"mol/g" : @1.0
    };
    
    possibleUnits = @[
                      @"mol/kg",
                      @"mol/g"
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"M" : @1000.0,
        @"mol/mL" : @1.0
    };
    
    possibleUnits = @[
                      @"M",
                      @"mol/mL"
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"GHz" : @(pow(10.0, -9.0)),
        @"MHz" : @(pow(10.0, -6.0)),
        @"Hz" : @1.0
    };
    
    possibleUnits = @[
                      @"GHz",
                      @"MHz",
                      @"Hz"
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"mol" : @1.0,
        @"#obj" : @(6.02*pow(10.0, 23.0)),
    };
    
    possibleUnits = @[
                      @"mol",
                      @"#obj",
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    defaultDictionary = @ {
        @"hr" : @(1.0/3600.0),
        @"min" : @(1.0/60.0),
        @"sec" : @1.0
    };
    
    possibleUnits = @[
                      @"hr",
                      @"min",
                      @"sec"
                      ];
    
    [allDictionaries addObject:@[defaultDictionary, possibleUnits]];
    
    NSDictionary *momentumScales = @ {
        @"kg*m/s" : @1.0,
        @"g*m/s" : @1000.0,
        @"kg*km/s" : @(.001),
        @"g*km/s" : @1.0
    };
    
    NSArray *momentumUnits = @ [@"kg*m/s",@"g*m/s", @"kg*km/s", @"g*km/s"];
    
    [allDictionaries addObject:@[momentumScales, momentumUnits]];
    
    NSDictionary *pressureScales = @ {
        @"atm" : @1.0,
        @"bar" : @1.01325,
        @"kPa" : @(101.325),
        @"Pa" : @(101325),
        @"mm Hg" : @(760.0),
        @"in Hg" : @(29.921258300109447),
        @"torr" : @(760.0),
    };
    
    NSArray *pressureUnits = @[@"atm", @"bar", @"kPa", @"Pa", @"mm Hg", @"in Hg", @"torr"];

    [allDictionaries addObject:@[pressureScales, pressureUnits]];
    
    NSDictionary *degreeScales = @ {
        @"°" : @1.0,
        @"rad" : @(M_PI / 180.0)
    };
    
    NSArray *degreeUnits = @[@"°", @"rad"];

    [allDictionaries addObject:@[degreeScales, degreeUnits]];
    
    NSDictionary *degreeSpeedScales = @ {
        @"°/s" : @(180.0 / M_PI),
        @"rad/s" : @1.0,
        @"rpm" : @(1.0 / M_PI)
    };
    
    NSArray *degreeSpeedUnits = @[@"°/s", @"rad/s", @"rpm"];
    
    [allDictionaries addObject:@[degreeSpeedScales, degreeSpeedUnits]];

    NSDictionary *heatScales = @ {
        @"J/(g*K)" : @1.0,
        @"kJ/(g*K)" : @0.001,
        @"J/(kg*K)" : @1000.0,
        @"kJ/(kg*K)" : @1.0,
    };
    
    NSArray *heatUnits = @[@"J/(g*K)", @"kJ/(g*K)", @"J/(kg*K)", @"kJ/(kg*K)"];
    
    [allDictionaries addObject:@[heatScales, heatUnits]];

    Equation *fToK = [[Equation alloc] initWithTitle:nil
                                      equationString:nil
                                     literalEquation:@"1*K+-0.55555555555*F+-255.22222224"
                                             varDefs:nil];
    Equation *cToK = [[Equation alloc] initWithTitle:nil
                                      equationString:nil
                                     literalEquation:@"1*K+-1*C+-273"
                                             varDefs:nil];
    
    
    NSDictionary *tempScales = @ {
        @"K" : [NSNull null],
        @"°F" : fToK,
        @"°C" : cToK
    };
    
    NSArray *tempUnits = @[@"K", @"°F", @"°C"];
    
    [allDictionaries addObject:@[tempScales, tempUnits]];
    
    return [allDictionaries copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
