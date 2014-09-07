//
//  SearchHelper.m
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/9/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "SearchHelper.h"
#import "EquationStore.h"

@implementation SearchHelper

- (id)init
{
    self = [super init];
    if (self) {
        allChemEquations = [[EquationStore sharedStore] chemEquations];
        allPhysicsEquations = [[EquationStore sharedStore] physicsEquations];
    }
    return self;
}

- (NSArray *)getFilteredArrayWithString:(NSString *)searchString
{
    NSArray *equationComponents;
    
    NSMutableArray *tempSearchedChem = [NSMutableArray array];
    for (int i = 0; i < allChemEquations.count; i++) {
        equationComponents = [[allChemEquations objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (int j = 0; j < equationComponents.count; j++) {
            NSRange range = [[equationComponents objectAtIndex:j] rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if (range.location == 0) {
                [tempSearchedChem addObject:[allChemEquations objectAtIndex:i]];
            }
        }
    }
    
    NSMutableArray *tempSearchedPhysics = [NSMutableArray array];
    for (int i = 0; i < allPhysicsEquations.count; i++) {
        equationComponents = [[allPhysicsEquations objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (int j = 0; j < equationComponents.count; j++) {
            NSRange range = [[equationComponents objectAtIndex:j] rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if (range.location == 0) {
                [tempSearchedPhysics addObject:[allPhysicsEquations objectAtIndex:i]];
            }
        }
    }
    
    NSMutableArray *allSearchedEquations = [NSMutableArray array];
    [allSearchedEquations addObject:tempSearchedChem];
    [allSearchedEquations addObject:tempSearchedPhysics];
    return allSearchedEquations;
}

- (void)dealloc
{
    allChemEquations = nil;
    allPhysicsEquations = nil;
    NSLog(@"search helper");
}

@end
