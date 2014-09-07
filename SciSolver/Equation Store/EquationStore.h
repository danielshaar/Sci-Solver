//
//  EquationStor.h
//  StulinFinal
//
//  Created by Shiv Roychowdhury on 5/27/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquationStore : NSObject
{
    NSMutableArray *chemEquations;
    NSMutableArray *physicsEquation;
    NSMutableArray *allEquations;
    
#define DILUTION @"Dilution"
#define LIGHT_QUANTA_ENERGY @"Energy of Light"
#define HYDROGEN_ATOM_LEVELS @"Energy Levels"
#define BOHR_RADIUS @"Bohr Radius"
#define ENERGY_TO_MASS @"Energy to Mass"
#define HEISENBERG @"Heisenberg Principle"
#define LIGHT_FREQUENCY_WAVELENGTH @"Light Hz to λ"
#define HALF_LIFE @"Nuclear Decay"
#define MOLE_CONVERSIONS @"Mole Conversions"
#define IDEAL_GAS @"Ideal Gas Law"
#define KE @"Kinetic Energy"
#define HEAT @"Heat"
#define WORK_C @"Work(Chemistry)"
#define FIRST_LAW_THERMO @"First Law of TD"
#define PH @"pH"
    
#define ONE_D_MOTION @"1-D Motion"
#define NEWTON_2ND @"Newton's 2nd Law"
#define IMPULSE @"Impulse Momentum"
#define MOMENTUM @"Momentum"
#define WORK_P @"Work(Physics)"
#define LINEAR_KE @"Linear KE"
#define POWER @"Power"
#define PE @"Potential Energy"
#define CENTER_ACC @"Centripetal Accel."
#define TORQUE @"Torque"
#define LIN_ANG_V @"Lin. to Ang. Velocity"
#define ANG_MOMENTUM @"Angular Momentum"
#define ROTATE_KE @"Rotational KE"
#define SPRINGS @"Springs"
#define PERIOD @"Period"
#define UNIV_GRAV @"Gravity"
    
}

+ (EquationStore *)sharedStore;
+ (NSDictionary *)equationDictionary;

- (NSMutableArray *)chemEquations;
- (NSMutableArray *)physicsEquations;
- (NSMutableArray *)allEquations;
- (void)allUnits;

@end
