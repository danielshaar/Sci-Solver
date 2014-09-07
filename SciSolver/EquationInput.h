//
//  EquationInput.h
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VarSelector;
@class Equation;


@interface EquationInput : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

#define currentOS [[[UIDevice currentDevice] systemVersion] floatValue]
#define contentViewHeight 325 + ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 480) ? 568 : 480) - 480
#define specialBlueColor [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0]
#define screenHeight ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 480) ? 568 : 480)

{
    int answerIndex;

    UIScrollView *contentView;
    UIScrollView *viewPager;
    UIScrollView *detailScroller;
    VarSelector *varSelector;
    UIToolbar *keyboardToolbar;
    UITextField *currentField;
    UIButton *decimalButton;
    UIButton *minusButton;
    UIButton *eeButton;

    NSString *currentTitle;
    NSArray *vars;
    NSMutableArray *varDefs;
    NSMutableArray *textFields;
    NSMutableArray *unitSelectors;
}

//Equation of the this controller
@property (nonatomic, weak) Equation *equation;

//Initializae with equation
- (id)initWithEquation:(Equation *)eq;
- (void)setUpKeyboardNotifications;
- (void)setUpKeyboardToolbar;
- (void)setUpEquationView;
- (void)setUpRow:(int)i;
- (void)rectifyView;
- (void)configureForiOS6;
- (void)configureForiOS7;
- (void)nextField;
- (void)resignAllFirstResponders;
- (void)setUnknownVar:(NSString *)s;
- (void)clearAllFields;
- (void)clearField;
- (void)solveEquation;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)animateToHelp;
- (void)decimal;
- (void)E;
- (void)minus;
- (void)changeButtonColorClicked:(UIButton *)sender;
- (void)changeButtonColorReleased:(UIButton *)sender;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

@end
