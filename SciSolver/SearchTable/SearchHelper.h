//
//  SearchHelper.h
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/9/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHelper : NSObject
{
    NSArray *allChemEquations;
    NSArray *allPhysicsEquations;
}

- (NSArray *)getFilteredArrayWithString:(NSString *)searchString;

@end
