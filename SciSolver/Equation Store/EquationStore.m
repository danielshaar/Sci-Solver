//
//  EquationStor.m
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 5/27/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "EquationStore.h"
#import "Equation.h"
#import "Var.h"
#import "NetForceInput.h"

@implementation EquationStore

- (id)init
{
    self = [super init];
    
    if (self) {
        chemEquations = [[NSMutableArray alloc] init];
        physicsEquation = [[NSMutableArray alloc] init];
        allEquations = [[NSMutableArray alloc] init];
        
        [self addChemEquation:DILUTION];
        [self addChemEquation:LIGHT_QUANTA_ENERGY];
        [self addChemEquation:HYDROGEN_ATOM_LEVELS];
        [self addChemEquation:BOHR_RADIUS];
        [self addChemEquation:ENERGY_TO_MASS];
        [self addChemEquation:HEISENBERG];
        [self addChemEquation:LIGHT_FREQUENCY_WAVELENGTH];
        [self addChemEquation:HALF_LIFE];
        [self addChemEquation:MOLE_CONVERSIONS];
        [self addChemEquation:IDEAL_GAS];
        [self addChemEquation:KE];
        [self addChemEquation:HEAT];
        [self addChemEquation:WORK_C];
        [self addChemEquation:FIRST_LAW_THERMO];
        [self addChemEquation:PH];
        
        //Physics.
        [self addPhysicsEquation:ONE_D_MOTION];
        [self addPhysicsEquation:NEWTON_2ND];
        [self addPhysicsEquation:IMPULSE];
        [self addPhysicsEquation:MOMENTUM];
        [self addPhysicsEquation:WORK_P];
        [self addPhysicsEquation:LINEAR_KE];
        [self addPhysicsEquation:POWER];
        [self addPhysicsEquation:PE];
        [self addPhysicsEquation:CENTER_ACC];
        [self addPhysicsEquation:TORQUE];
        [self addPhysicsEquation:LIN_ANG_V];
        [self addPhysicsEquation:ANG_MOMENTUM];
        [self addPhysicsEquation:ROTATE_KE];
        [self addPhysicsEquation:SPRINGS];
        [self addPhysicsEquation:PERIOD];
        [self addPhysicsEquation:UNIV_GRAV];
        chemEquations = [[chemEquations sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        physicsEquation = [[physicsEquation sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        allEquations = [NSMutableArray arrayWithArray:chemEquations];
        [allEquations addObjectsFromArray:physicsEquation];
        //NSLog(@"%@", allEquations);
    }
    return self;
}

+ (EquationStore *)sharedStore
{
    static EquationStore *sharedStore = nil;
    
    //If the shared store does not exist, then create one.
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (NSDictionary *)equationDictionary
{
    static NSDictionary *eqDict = nil;
    
    //If the shared store does not exist, then create one.
    if (!eqDict) {
        eqDict = eqDictMake();
    }
    
    return eqDict;
}

//Overriden alloc with zone that prevents further CPESEquationStores from being made.
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (void)addChemEquation:(NSString *)equationTitle
{
    [chemEquations addObject:equationTitle];
    [allEquations addObject:equationTitle];
}

- (void)addPhysicsEquation:(NSString *)equationTitle
{
    [physicsEquation addObject:equationTitle];
    [allEquations addObject:equationTitle];
}

- (void)addEquation:(NSString *)equationTitle
{
    [allEquations addObject:equationTitle];
}

- (NSMutableArray *)chemEquations
{
    return chemEquations;
}

- (NSMutableArray *)physicsEquations
{
    return physicsEquation;
}

- (NSMutableArray *)allEquations
{
    return allEquations;
}

- (void)allUnits
{
    NSMutableSet *unitSet = [NSMutableSet set];
    for (int i = 0; i < [EquationStore  equationDictionary].allKeys.count; i++) {
        NSString *eqstr = [[EquationStore  equationDictionary].allKeys objectAtIndex:i];
        NSArray *equations = [[EquationStore  equationDictionary] valueForKey:eqstr];
        for (int j = 0; j < equations.count; j++) {
            NSArray *vardefs = [[[equations objectAtIndex:j] varDefs] allValues];
            for (int k = 0; k < vardefs.count; k++) {
                NSArray *parts = [[vardefs objectAtIndex:k] componentsSeparatedByString:@"|"];
                [unitSet addObject:[parts objectAtIndex:1]];
            }
        }
    }
    NSLog(@"%@", unitSet);
}

NSDictionary *eqDictMake()
{
    NSMutableDictionary *equationDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *varDefine = [NSMutableDictionary dictionary];
    
    //**********************************CHEMISTRY**************************************
    
    //Dilution
    [varDefine setValue:@"First Molarity|M" forKey:@"M@1"];
    [varDefine setValue:@"First Volume|L" forKey:@"V@1"];
    [varDefine setValue:@"Second Molarity|M" forKey:@"M@2"];
    [varDefine setValue:@"Second Volume|L" forKey:@"V@2"];
    
    Equation *dilution = [[Equation alloc] initWithTitle:DILUTION
                                          equationString:@"M@1|V@1| = M@2|V@2|"
                                         literalEquation:@"1*M@1*V@1+-1*M@2*V@2"
                                                 varDefs:varDefine];
    [equationDictionary setValue:@[dilution] forKey:DILUTION];
    
    //* Energy of Light Quanta: E = hv
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Energy|J" forKey:@"E"];
    [varDefine setValue:@"Frequency|Hz" forKey:@"v"];
    
    Equation *energyOfLightQuanta = [[Equation alloc] initWithTitle:LIGHT_QUANTA_ENERGY
                                                     equationString:@"E = hv"
                                                    literalEquation:@"1*E+-6.626e-34*v"
                                                            varDefs:varDefine];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Energy|J" forKey:@"E"];
    [varDefine setValue:@"Wavelength|m" forKey:@"λ"];
    
    Equation *energyOfLightQuanta2 = [[Equation alloc] initWithTitle:LIGHT_QUANTA_ENERGY                                                      equationString:@"E = hc/λ"
                                                     literalEquation:@"1*E+-1.98647e-25*λ^-1"
                                                             varDefs:varDefine];
    [equationDictionary setValue:@[energyOfLightQuanta, energyOfLightQuanta2] forKey:LIGHT_QUANTA_ENERGY];
    
    // Energy Levels of Hydrogen Atom: E = -2.178*10^-15 / n^2
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Energy|J" forKey:@"E"];
    [varDefine setValue:@"Energy Level|N/A" forKey:@"n"];
    
    Equation *eLevHAtom = [[Equation alloc] initWithTitle:HYDROGEN_ATOM_LEVELS                                           equationString:@"-2.178*10^-15|/n^2|"
                                          literalEquation:@"1*E+2.178e-15*n^-2"
                                                  varDefs:varDefine];
    
    [equationDictionary setValue:@[eLevHAtom] forKey:HYDROGEN_ATOM_LEVELS];
    
    //* Bohr Atomic Radius: mv = nh/(2*pi*r)
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Velocity|m/s" forKey:@"v"];
    [varDefine setValue:@"Energy|J" forKey:@"n"];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    
    Equation *bohr = [[Equation alloc] initWithTitle:BOHR_RADIUS
                                      equationString:@"mv = nh/(2πr)"
                                     literalEquation:@"1*m*v+-1.0545607e-34*n*r^-1"
                                             varDefs:varDefine];
    
    [equationDictionary setValue:@[bohr] forKey:BOHR_RADIUS];
    
    // Einstein Energy to Mass: E = mc^2
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Energy|J" forKey:@"E"];
    [varDefine setValue:@"Mass |kg" forKey:@"m"];
    
    Equation *massToEnergy = [[Equation alloc] initWithTitle:ENERGY_TO_MASS
                                              equationString:@"E = mc^2|"
                                             literalEquation:@"1*E+-8.98755179e16*m"
                                                     varDefs:varDefine];
    
    [equationDictionary setValue:@[massToEnergy] forKey:ENERGY_TO_MASS];
    
    // Heisenberg Uncertainty Principle: (Δx)(Δmv) <= h/(4*pi)
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Change in position|m" forKey:@"Δx"];
    [varDefine setValue:@"Change in momentum|kg*m/s" forKey:@"Δmv"];
    
    Equation *heisenberg = [[Equation alloc] initWithTitle:HEISENBERG                                            equationString:@"ΔxΔmv <= h/(4π)"
                                           literalEquation:@"1*Δx*Δmv+-5.27285738e-35"
                                                  varDefs :varDefine];
    [equationDictionary setValue:@[heisenberg] forKey:HEISENBERG];
    
    
    // Light Frequency to Wavelength: c = λ*v
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Wavelength|m" forKey:@"λ"];
    [varDefine setValue:@"Frequency|Hz" forKey:@"v"];
    
    Equation *light = [[Equation alloc] initWithTitle:LIGHT_FREQUENCY_WAVELENGTH
                                       equationString:@"c = λv"
                                      literalEquation:@"2.998e8+-1*λ*v"
                                              varDefs:varDefine];
    
    [equationDictionary setValue:@[light] forKey:LIGHT_FREQUENCY_WAVELENGTH];
    
    // Mole Conversions
    
    //Mol to gram
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Number of moles|mol" forKey:@"Moles"];
    [varDefine setValue:@"Mass|g" forKey:@"Mass"];
    [varDefine setValue:@"Molar mass|g/mol" forKey:@"Molar Mass"];
    
    Equation *moleMassConversion = [[Equation alloc] initWithTitle:MOLE_CONVERSIONS
                                                    equationString:@"Mass = (Moles)(Molar Mass)"
                                                   literalEquation:@"1*Mass+-1*Moles*Molar Mass"
                                                           varDefs:varDefine];
    
    //Mol to molarity
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Number of moles|mol" forKey:@"Moles"];
    [varDefine setValue:@"Molarity|M" forKey:@"Molarity"];
    [varDefine setValue:@"Volume|L" forKey:@"Volume"];
    
    Equation *moleMolarityConversion = [[Equation alloc] initWithTitle:MOLE_CONVERSIONS
                                                        equationString:@"Moles = (Molarity)(Volume)"
                                                       literalEquation:@"1*Moles+-1*Molarity*Volume"
                                                               varDefs:varDefine];
    
    //Mol to gas liters
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Number of moles|mol" forKey:@"Moles"];
    [varDefine setValue:@"Volume of gas|L" forKey:@"Volume"];
    
    Equation *moleLiterConversion = [[Equation alloc] initWithTitle:MOLE_CONVERSIONS
                                                     equationString:@"Volume = (22.4 L/mol)(Moles)"
                                                    literalEquation:@"22.4*Moles+-1*Volume"
                                                            varDefs:varDefine];
    
    //Mol to units
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Number of moles|mol" forKey:@"Moles"];
    [varDefine setValue:@"Number of particles|N/A" forKey:@"Objects"];
    
    Equation *moleUnitConversion = [[Equation alloc] initWithTitle:MOLE_CONVERSIONS
                                                    equationString:@"Objects = (Moles)(N@A|)"
                                                   literalEquation:@"6.02e23*Moles+-1*Objects"
                                                           varDefs:varDefine];
    
    [equationDictionary setValue:@[moleMassConversion, moleMolarityConversion, moleLiterConversion, moleUnitConversion] forKey:MOLE_CONVERSIONS];
    
    //Ideal Gas Law PV = nRT.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Pressure|atm" forKey:@"P"];
    [varDefine setValue:@"Volume|L" forKey:@"V"];
    [varDefine setValue:@"Number of moles|mol" forKey:@"n"];
    [varDefine setValue:@"Temperature|K" forKey:@"T"];
    
    Equation *idealGasLaw = [[Equation alloc] initWithTitle:IDEAL_GAS
                                             equationString:@"PV = nRT"
                                            literalEquation:@"1*P*V+-0.0821*n*T"
                                                    varDefs:varDefine];
    
    [equationDictionary setValue:@[idealGasLaw] forKey:IDEAL_GAS];
    
    
    //Kinetic Energy KE = 1/2mv^2.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Velocity|m/s" forKey:@"v"];
    [varDefine setValue:@"Kinetic Energy|J" forKey:@"KE"];
    
    Equation *kineticEnergy = [[Equation alloc] initWithTitle:KE
                                               equationString:@"KE = mv^2|/2"
                                              literalEquation:@"1*KE+-0.5*m*v^2"
                                                      varDefs:varDefine];
    
    [equationDictionary setValue:@[kineticEnergy] forKey:KE];
    
    //Heat Q = mcΔT.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Heat|J" forKey:@"Q"];
    [varDefine setValue:@"Mass|g" forKey:@"m"];
    [varDefine setValue:@"Specific Heat|J/(g*K)" forKey:@"c"];
    [varDefine setValue:@"Change in temperature|K" forKey:@"ΔT"];
    
    Equation *heat = [[Equation alloc] initWithTitle:HEAT
                                      equationString:@"Q = mcΔT"
                                     literalEquation:@"1*Q+-1*m*c*ΔT"
                                             varDefs:varDefine];
    
    [equationDictionary setValue:@[heat] forKey:HEAT];
    
    //Work w = -PΔV.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Work|L*atm" forKey:@"w"];
    [varDefine setValue:@"Pressure|atm" forKey:@"P"];
    [varDefine setValue:@"Change in volume|L" forKey:@"ΔV"];
    
    Equation *work = [[Equation alloc] initWithTitle:WORK_C
                                      equationString:@"w = -PΔV"
                                     literalEquation:@"1*w+-1*P*ΔV"
                                             varDefs:varDefine];
    
    [equationDictionary setValue:@[work] forKey:WORK_C];
    
    //First Law of Thermodynamics ΔE = q - PΔV.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Change in energy|J" forKey:@"E"];
    [varDefine setValue:@"Heat|J" forKey:@"q"];
    [varDefine setValue:@"Pressure|atm" forKey:@"P"];
    [varDefine setValue:@"Change in volume|L" forKey:@"ΔV"];
    
    Equation *firstLawOfThermodynamics = [[Equation alloc] initWithTitle:FIRST_LAW_THERMO
                                                          equationString:@"ΔE = q - PΔV"
                                                         literalEquation:@"1*E+-1*q+1*P*ΔV"
                                                                 varDefs:varDefine];
    
    [equationDictionary setValue:@[firstLawOfThermodynamics] forKey:FIRST_LAW_THERMO];
    
    // Nuclear Decay Half Life
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Original Amount of Moles|mol" forKey:@"N@0"];
    [varDefine setValue:@"Current Amount of Moles|mol" forKey:@"N@t"];
    [varDefine setValue:@"Decay Constant|N/A" forKey:@"k"];
    [varDefine setValue:@"Time|s" forKey:@"t"];
    
    Equation *halfLife = [[Equation alloc] initWithTitle:HALF_LIFE
                                          equationString:@"ln(N@t|/N@0|) = kt"
                                         literalEquation:@"1*N@0*N@t*k*t"
                                                 varDefs:varDefine];
    
    SolveBlock halfLifeSolve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        
        if ([lastOne isEqualToString:@"N@t"]) {
            double n0 = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"N@0"]] netValue] doubleValue];
            double k = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"k"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            double answer = n0*exp(k*t);
            return [NSString stringWithFormat:@"%g", answer];
        }
        
        if ([lastOne isEqualToString:@"N@0"]) {
            double nt = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"N@t"]] netValue] doubleValue];
            double k = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"k"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            double answer = nt/exp(k*t);
            return [NSString stringWithFormat:@"%g", answer];
            
        }
        
        if ([lastOne isEqualToString:@"t"]) {
            double n0 = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"N@0"]] netValue] doubleValue];
            double nt = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"N@t"]] netValue] doubleValue];
            double k = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"k"]] netValue] doubleValue];
            @try {
                double answer = log(nt/n0)/k;
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        
        if ([lastOne isEqualToString:@"k"]) {
            double n0 = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"N@0"]] netValue] doubleValue];
            double nt = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"N@t"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            @try {
                double answer = log(nt/n0)/t;
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        
        return nil;
    };
    
    [halfLife setSolveBlock:halfLifeSolve];
    
    [equationDictionary setValue:@[halfLife] forKey:HALF_LIFE];
    
    //pH
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Measure of acidity|N/A" forKey:@"pH"];
    [varDefine setValue:@"Molar Concentration|M" forKey:@"[H]"];
    
    Equation *ph = [[Equation alloc] initWithTitle:PH
                                    equationString:@"pH = -log[H]"
                                   literalEquation:@"1*pH*[H]"
                                           varDefs:varDefine];
    
    
    SolveBlock pHSolve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        
        if ([lastOne isEqualToString:@"pH"]) {
            double h = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"[H]"]] netValue] doubleValue];
            double answer = -log10(h);
            return [NSString stringWithFormat:@"%g", answer];
        }
        
        if ([lastOne isEqualToString:@"[H]"]) {
            double ph = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"pH"]] netValue] doubleValue];
            double answer = pow(10.0, -ph);
            return [NSString stringWithFormat:@"%g", answer];
            
        }
        
        return @"";
    };
    
    [ph setSolveBlock:pHSolve];
    
    [equationDictionary setValue:@[ph] forKey:PH];
    
    //*************************************PHYSICS********************************
    
    //1 Dimensional Motion. xf = xi + vit + 1/2at^2.
    //vf = vi + at
    //vf^2 = vi^2 + 2a(xf - xi)
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Initial Position|m" forKey:@"x@i"];
    [varDefine setValue:@"Final Position|m" forKey:@"x@f"];
    [varDefine setValue:@"Initial Velocity|m/s" forKey:@"v@i"];
    [varDefine setValue:@"Acceleration|m/s^2" forKey:@"a"];
    [varDefine setValue:@"Time|s" forKey:@"t"];
    
    Equation *oneDimensionalMotion1 = [[Equation alloc] initWithTitle:ONE_D_MOTION
                                                       equationString:@"x@f| = x@i| + v@i|t + at^2|/2"
                                                      literalEquation:@"1*x@i*v@i*t*a*x@f"
                                                              varDefs:varDefine];
    
    SolveBlock d1Solve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        if ([lastOne isEqualToString:@"x@f"]) {
            double xi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@i"]] netValue] doubleValue];
            double vi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v@i"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            double answer = xi+vi*t+a*t*t/2.0;
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"x@i"]) {
            double xf = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@f"]] netValue] doubleValue];
            double vi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v@i"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            double answer = xf-vi*t-a*t*t/2.0;
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"v@i"]) {
            double xf = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@f"]] netValue] doubleValue];
            double xi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@i"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            @try {
                double answer = (xf-xi-a*t*t/2.0)/t;
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"a"]) {
            double xf = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@f"]] netValue] doubleValue];
            double xi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@i"]] netValue] doubleValue];
            double vi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v@i"]] netValue] doubleValue];
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"t"]] netValue] doubleValue];
            @try {
                double answer = (xf-xi-vi*t)/(t*t/2.0);
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"t"]) {
            double xf = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@f"]] netValue] doubleValue];
            double xi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"x@i"]] netValue] doubleValue];
            double vi = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v@i"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            NSString *answer;
            @try {
                double disc = vi*vi-4.0*a*(xi-xf);
                if (disc < 0) {
                    answer = [NSString stringWithFormat:@"%g+i*%g, %g-i*%g", -vi/(2.0*a), sqrt(-disc)/(2.0*a), -vi/(2.0*a), sqrt(-disc)/(2.0*a)];
                } else {
                    answer = [NSString stringWithFormat:@"%g, %g", (-vi+sqrt(disc))/(2.0*a), (-vi-sqrt(disc))/(2.0*a)];
                }
                return answer;
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        return @"";
    };
    
    [oneDimensionalMotion1 setSolveBlock:d1Solve];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Final Velocity|m/s" forKey:@"v@f"];
    [varDefine setValue:@"Initial Velocity|m/s" forKey:@"v@i"];
    [varDefine setValue:@"Acceleration|m/s^2" forKey:@"a"];
    [varDefine setValue:@"Time|s" forKey:@"t"];
    
    Equation *oneDimensionalMotion2 = [[Equation alloc] initWithTitle:ONE_D_MOTION
                                                       equationString:@"v@f| = v@i| + at"
                                                      literalEquation:@"1*v@f+-1*v@i+-1*a*t"
                                                              varDefs:varDefine];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Initial Position|m" forKey:@"x@i"];
    [varDefine setValue:@"Final Position|m" forKey:@"x@f"];
    [varDefine setValue:@"Final Velocity|m/s" forKey:@"v@f"];
    [varDefine setValue:@"Initial Velocity|m/s" forKey:@"v@i"];
    [varDefine setValue:@"Acceleration|m/s^2" forKey:@"a"];
    [varDefine setValue:@"Time|s" forKey:@"t"];
    
    Equation *oneDimensionalMotion3 = [[Equation alloc] initWithTitle:ONE_D_MOTION
                                                       equationString:@"v@f|^2| =v@i|^2| + 2a(x@f|- x@i|)"
                                                      literalEquation:@"1*v@f^2+-1*v@i^2+-2*a*x@f+2*a*x@i"
                                                              varDefs:varDefine];
    
    [equationDictionary setValue:@[oneDimensionalMotion1, oneDimensionalMotion2, oneDimensionalMotion3] forKey:ONE_D_MOTION];
    
    //Newton's Second Law F = ma.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Force|N" forKey:@"F"];
    [varDefine setValue:@"Acceleration|m/s^2" forKey:@"a"];
    
    Equation *NewtonSecondLaw1 = [[Equation alloc] initWithTitle:NEWTON_2ND
                                                  equationString:@"F = ma"
                                                 literalEquation:@"1*F+-1*m*a"
                                                         varDefs:varDefine];
    
    [equationDictionary setValue:@[NewtonSecondLaw1, [[NetForceInput alloc] init]] forKey:NEWTON_2ND];
    
    //Impulse Momentum Theorem
    //J = m(Vf - Vi)
    //Ft = m(Vf - Vi)
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Final Velocity|m/s" forKey:@"v@f"];
    [varDefine setValue:@"Initial Velocity|m/s" forKey:@"v@i"];
    [varDefine setValue:@"Impulse|N*s" forKey:@"J"];
    
    Equation *ImpulseMomentumTheorem1 = [[Equation alloc] initWithTitle:IMPULSE
                                                         equationString:@"J = m(v@f| - v@i|)"
                                                        literalEquation:@"1*J+-1*m*v@f+1*m*v@i"
                                                                varDefs:varDefine];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Final Velocity|m/s" forKey:@"v@f"];
    [varDefine setValue:@"Initial Velocity|m/s" forKey:@"v@i"];
    [varDefine setValue:@"Force|N" forKey:@"F"];
    [varDefine setValue:@"Time|s" forKey:@"t"];
    
    Equation *ImpulseMomentumTheorem2 = [[Equation alloc] initWithTitle:IMPULSE
                                                         equationString:@"Ft = m(v@f| - v@i|)"
                                                        literalEquation:@"1*F*t+-1*m*v@f+1*m*v@i"
                                                                varDefs:varDefine];
    
    [equationDictionary setValue:@[ImpulseMomentumTheorem1, ImpulseMomentumTheorem2] forKey:IMPULSE];
    
    //Momentum p = mv.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Momentum|kg*m/s" forKey:@"p"];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Velocity|m/s" forKey:@"v"];
    
    Equation *momentum = [[Equation alloc] initWithTitle:MOMENTUM
                                          equationString:@"p = mv"
                                         literalEquation:@"1*p+-1*m*v"
                                                 varDefs:varDefine];
    
    [equationDictionary setValue:@[momentum] forKey:MOMENTUM];
    
    //Work W = Fdcos0.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Work|Nm" forKey:@"W"];
    [varDefine setValue:@"Force|N" forKey:@"F"];
    [varDefine setValue:@"Distance|m" forKey:@"d"];
    [varDefine setValue:@"Angle|°" forKey:@"θ"];
    
    Equation *physicsWork = [[Equation alloc] initWithTitle:WORK_P
                                             equationString:@"W = Fdcos(θ)"
                                            literalEquation:@"1*W*F*d*θ"
                                                    varDefs:varDefine];
    
    SolveBlock workSolve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        
        if ([lastOne isEqualToString:@"W"]) {
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double d = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"d"]] netValue] doubleValue];
            double o = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"θ"]] netValue] doubleValue];
            double answer = F*d*cosd(o);
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"F"]) {
            double W = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"W"]] netValue] doubleValue];
            double d = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"d"]] netValue] doubleValue];
            double o = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"θ"]] netValue] doubleValue];
            double answer = W/(d*cosd(o));
            return [NSString stringWithFormat:@"%g", answer];
            
        }
        if ([lastOne isEqualToString:@"d"]) {
            double W = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"W"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double o = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"θ"]] netValue] doubleValue];
            double answer = W/(F*cosd(o));
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"θ"]) {
            double W = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"W"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double d = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"d"]] netValue] doubleValue];
            double answer = acos(W/(F*d))*180.0/M_PI;
            return [NSString stringWithFormat:@"%g", answer];
        }
        
        return @"";
    };
    
    [physicsWork setSolveBlock:workSolve];
    
    [equationDictionary setValue:@[physicsWork] forKey:WORK_P];
    
    //Kinetic Energy KE = 1/2mv^2.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Velocity|m/s" forKey:@"v"];
    [varDefine setValue:@"Kinetic Energy|J" forKey:@"KE"];
    
    Equation *LinearKineticEnergy = [[Equation alloc] initWithTitle:LINEAR_KE
                                                     equationString:@"KE = mv^2|/2"
                                                    literalEquation:@"1*KE+-0.5*m*v^2"
                                                            varDefs:varDefine];
    
    [equationDictionary setValue:@[LinearKineticEnergy] forKey:LINEAR_KE];
    
    //Power P = Fvcos0.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Power|Nm" forKey:@"P"];
    [varDefine setValue:@"Force|N" forKey:@"F"];
    [varDefine setValue:@"Velocity|m/s" forKey:@"v"];
    [varDefine setValue:@"Angle|°" forKey:@"θ"];
    
    Equation *power = [[Equation alloc] initWithTitle:POWER
                                       equationString:@"P = Fvcos(θ)"
                                      literalEquation:@"1*P*F*v*θ"
                                              varDefs:varDefine];
    
    SolveBlock powerSolve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        
        if ([lastOne isEqualToString:@"P"]) {
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double v = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v"]] netValue] doubleValue];
            double o = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"θ"]] netValue] doubleValue];
            double answer = F*v*cosd(o);
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"F"]) {
            double P = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"P"]] netValue] doubleValue];
            double v = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v"]] netValue] doubleValue];
            double o = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"θ"]] netValue] doubleValue];
            @try {
                double answer = P/(v*cosd(o));
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"d"]) {
            double P = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"P"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double o = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"θ"]] netValue] doubleValue];
            @try {
                double answer = P/(F*cosd(o));
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"θ"]) {
            double P = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"P"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double v = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"v"]] netValue] doubleValue];
            @try {
                double answer = acos(P/(F*v))*180.0/M_PI;
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        
        return @"";
    };
    
    [power setSolveBlock:powerSolve];
    
    [equationDictionary setValue:@[power] forKey:POWER];
    
    //Potential Energy U = mgh.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Potential Energy|J" forKey:@"U"];
    [varDefine setValue:@"Mass|kg" forKey:@"m"];
    [varDefine setValue:@"Height|m" forKey:@"h"];
    
    Equation *potentialEnergy = [[Equation alloc] initWithTitle:PE
                                                 equationString:@"U = mgh"
                                                literalEquation:@"1*U+-9.8*m*h"
                                                        varDefs:varDefine];
    
    [equationDictionary setValue:@[potentialEnergy] forKey:PE];
    
    //Centripetal Acceleration a = v^2/r.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Centripetal Acceleration|m/s^2" forKey:@"a"];
    [varDefine setValue:@"Velocity|m/s" forKey:@"v"];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    
    Equation *centripetalAcceleration = [[Equation alloc] initWithTitle:CENTER_ACC
                                                         equationString:@"a = v^2|/r"
                                                        literalEquation:@"1*a+-1*v^2*r^-1"
                                                                varDefs:varDefine];
    
    [equationDictionary setValue:@[centripetalAcceleration] forKey:CENTER_ACC];
    
    //Torque
    //τ=rFsina
    //τ=Iα
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    [varDefine setValue:@"Force|N" forKey:@"F"];
    [varDefine setValue:@"Angle|°" forKey:@"a"];
    [varDefine setValue:@"Torque|Nm" forKey:@"τ"];
    
    Equation *torque1 = [[Equation alloc] initWithTitle:TORQUE
                                         equationString:@"τ = rFsin(a)"
                                        literalEquation:@"1*τ*r*F*a"
                                                varDefs:varDefine];
    
    SolveBlock torqueSolve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        
        if ([lastOne isEqualToString:@"τ"]) {
            double r = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"r"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            double answer = r*F*sind(a);
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"r"]) {
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"τ"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            @try {
                double answer = t/(F*sind(a));
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"F"]) {
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"τ"]] netValue] doubleValue];
            double r = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"r"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            @try {
                double answer = t/(r*sind(a));
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"a"]) {
            double t = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"τ"]] netValue] doubleValue];
            double r = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"r"]] netValue] doubleValue];
            double F = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"F"]] netValue] doubleValue];
            @try {
                double answer = asin(t/(r*F))*180.0/M_PI;
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        
        return @"";
    };
    
    [torque1 setSolveBlock:torqueSolve];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Torque|Nm" forKey:@"τ"];
    [varDefine setValue:@"Moment Of Inertia|kg*m^2" forKey:@"I"];
    [varDefine setValue:@"Angular Acceleration|rad/s^2|" forKey:@"α"];
    
    Equation *torque2 = [[Equation alloc] initWithTitle:TORQUE
                                         equationString:@"τ = Iα"
                                        literalEquation:@"1*τ+-1*I*α"
                                                varDefs:varDefine];
    
    [equationDictionary setValue:@[torque1, torque2] forKey:TORQUE];
    
    //Linear to Angular Velocity v = wr.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Angular Velocity|rad/s" forKey:@"w"];
    [varDefine setValue:@"Linear Velocity|m/s" forKey:@"v"];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    
    Equation *linearToAngularVelocity = [[Equation alloc] initWithTitle:LIN_ANG_V
                                                         equationString:@"v = wr"
                                                        literalEquation:@"1*v+-1*w*r"
                                                                varDefs:varDefine];
    
    [equationDictionary setValue:@[linearToAngularVelocity] forKey:LIN_ANG_V];
    
    //Angular Momentum
    //L = rpsina
    //L = Iw
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    [varDefine setValue:@"Momentum|kg*m/s" forKey:@"p"];
    [varDefine setValue:@"Angle|°" forKey:@"a"];
    [varDefine setValue:@"Angular Momentum|Js" forKey:@"L"];
    
    Equation *angularMomentum1 = [[Equation alloc] initWithTitle:ANG_MOMENTUM
                                                  equationString:@"L = rpsina"
                                                 literalEquation:@"1*L*r*p*a"
                                                         varDefs:varDefine];
    
    SolveBlock angularSolve = ^NSString *(NSArray *terms) {
        NSArray *vars = [[terms objectAtIndex:0] vars];
        NSMutableArray *varNames = [NSMutableArray array];
        NSString *lastOne;
        for (Var *v in vars) {
            if (![v netValue]) {
                lastOne = v.var;
            }
            [varNames addObject:v.var];
        }
        
        if ([lastOne isEqualToString:@"L"]) {
            double r = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"r"]] netValue] doubleValue];
            double p = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"p"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            double answer = r*p*sind(a);
            return [NSString stringWithFormat:@"%g", answer];
        }
        if ([lastOne isEqualToString:@"r"]) {
            double L = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"L"]] netValue] doubleValue];
            double p = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"p"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            @try {
                double answer = L/(p*sind(a));
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"p"]) {
            double L = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"L"]] netValue] doubleValue];
            double r = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"r"]] netValue] doubleValue];
            double a = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"a"]] netValue] doubleValue];
            @try {
                double answer = L/(r*sind(a));
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        if ([lastOne isEqualToString:@"a"]) {
            double L = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"L"]] netValue] doubleValue];
            double r = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"r"]] netValue] doubleValue];
            double p = [[(Var *)[vars objectAtIndex:[varNames indexOfObject:@"p"]] netValue] doubleValue];
            @try {
                double answer = asin(L/(r*p))*180.0/M_PI;
                return [NSString stringWithFormat:@"%g", answer];
            }
            @catch (NSException *exception) {
                return @"nan";
            }
        }
        
        return @"";
    };
    
    [angularMomentum1 setSolveBlock:angularSolve];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Angular Momentum|Js" forKey:@"L"];
    [varDefine setValue:@"Moment Of Inertia|kg*m^2" forKey:@"I"];
    [varDefine setValue:@"Angular Velocity|rad/s" forKey:@"w"];
    
    Equation *angularMomentum2 = [[Equation alloc] initWithTitle:ANG_MOMENTUM
                                                  equationString:@"L = Iw"
                                                 literalEquation:@"1*L+-1*I*w"
                                                         varDefs:varDefine];
    
    [equationDictionary setValue:@[angularMomentum1, angularMomentum2] forKey:ANG_MOMENTUM];
    
    //Rotational Kinetic Energy E = 1/2Iw^2.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Angular Velocity|rad/s" forKey:@"w"];
    [varDefine setValue:@"Moment Of Inertia|kg*m^2" forKey:@"I"];
    [varDefine setValue:@"Rotational Energy|J" forKey:@"E"];
    
    Equation *rotationalKineticEnergy = [[Equation alloc] initWithTitle:ROTATE_KE
                                                         equationString:@"E = 1/2Iw^2|"
                                                        literalEquation:@"1*E+-0.5*I*w^2"
                                                                varDefs:varDefine];
    
    [equationDictionary setValue:@[rotationalKineticEnergy] forKey:ROTATE_KE];
    
    //Spring Force, F = -kx.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Spring Force |N" forKey:@"F"];
    [varDefine setValue:@"Spring Constant|N/m" forKey:@"k"];
    [varDefine setValue:@"Displacement|m" forKey:@"x"];
    
    Equation *springForce = [[Equation alloc] initWithTitle:SPRINGS
                                             equationString:@"F = -kx"
                                            literalEquation:@"1*F+1*k*x"
                                                    varDefs:varDefine];
    
    //Spring Energy, F = 1/2kx^2.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Spring Energy|Nm" forKey:@"F"];
    [varDefine setValue:@"Spring Constant|N/m" forKey:@"k"];
    [varDefine setValue:@"Displacement|m" forKey:@"x"];
    
    Equation *springEnergy = [[Equation alloc] initWithTitle:SPRINGS
                                              equationString:@"F = 1/2kx^2|"
                                             literalEquation:@"1*F+-1*k*x^2"
                                                     varDefs:varDefine];
    
    [equationDictionary setValue:@[springForce,springEnergy] forKey:SPRINGS];
    
    //Period
    //T = 2pi/w
    //T = 1/f
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Angular Velocity|rad/s" forKey:@"w"];
    [varDefine setValue:@"Period|s" forKey:@"T"];
    
    Equation *period1 = [[Equation alloc] initWithTitle:PERIOD
                                         equationString:@"T = 2π/w"
                                        literalEquation:@"1*T+-6.28*w^-1"
                                                varDefs:varDefine];
    
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Frequency|Hz" forKey:@"f"];
    [varDefine setValue:@"Period|s" forKey:@"T"];
    
    Equation *period2 = [[Equation alloc] initWithTitle:PERIOD
                                         equationString:@"T = 1/f"
                                        literalEquation:@"1*T+-1*f^-1"
                                                varDefs:varDefine];
    
    [equationDictionary setValue:@[period1, period2] forKey:PERIOD];
    
    //Gravitational Force, F = -Gm1m2/(r^2).
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Gravitational Force|N" forKey:@"F"];
    [varDefine setValue:@"Mass 1|kg" forKey:@"m@1"];
    [varDefine setValue:@"Mass 2|kg" forKey:@"m@2"];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    
    Equation *universalGravitationalForce = [[Equation alloc] initWithTitle:UNIV_GRAV
                                                             equationString:@"F = -Gm@1|m@2|/r^2|"
                                                            literalEquation:@"1*F+6.67384e-11*m@1*m@2*r^-2"
                                                                    varDefs:varDefine];
    
    
    //Gravitational Energy, U = -Gm1m2/r.
    varDefine = [NSMutableDictionary dictionary];
    [varDefine setValue:@"Gravitational Potential Energy|J" forKey:@"U"];
    [varDefine setValue:@"Mass 1|kg" forKey:@"m@1"];
    [varDefine setValue:@"Mass 2|kg" forKey:@"m@2"];
    [varDefine setValue:@"Radius|m" forKey:@"r"];
    
    Equation *universalGravitationalEnergy = [[Equation alloc] initWithTitle:UNIV_GRAV
                                                              equationString:@"U = -Gm@1|m@2|/r"
                                                             literalEquation:@"1*U+6.67384e-11*m@1*m@2*r^-1"
                                                                     varDefs:varDefine];
    
    [equationDictionary setValue:@[universalGravitationalForce,universalGravitationalEnergy] forKey:UNIV_GRAV];
    
    return equationDictionary;
}

double sind(double degree) {
    return sin(degree*M_PI/180.0);
}

double cosd(double degree) {
    return cos(degree*M_PI/180.0);
}
double tand(double degree) {
    return tan(degree*M_PI/180.0);
}

- (void)dealloc
{
    chemEquations = nil;
    physicsEquation = nil;
    allEquations = nil;
}

@end