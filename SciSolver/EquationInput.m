//
//  EquationInput.m
//  SciSolver
//
//  Created by Shiv Roychowdhury on 6/16/13.
//  Copyright (c) 2013 Water Works Development. All rights reserved.
//

#import "EquationInput.h"
#import "Equation.h"
#import "Formatter.h"
#import "VarSelector.h"
#import "UnitSelector.h"
#import "ArrowedButton.h"

@interface EquationInput (Hidden)

@end

@implementation EquationInput

@synthesize equation;

- (id)initWithEquation:(Equation *)eq
{
    self = [super init];
    if (self) {
        
        [self setUpKeyboardNotifications];
                
        [self setUpKeyboardToolbar];
        
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentViewHeight)];
        [contentView setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
        contentView.backgroundColor = [UIColor clearColor];
        
        //Set up the data sources for the equation input
        self.equation = eq;
        self.title = self.equation.title;
        vars = [self.equation vars];
        varDefs = [NSMutableArray array];
        textFields = [NSMutableArray array];
        unitSelectors = [NSMutableArray array];
        contentView.contentSize = CGSizeMake(320, 120+vars.count*40);
        
        [self setUpEquationView];
        
        //Set up the var chooser for this input
        UILabel *solveForLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 80, 30)];
        solveForLabel.text = @"Solve For ";
        solveForLabel.adjustsFontSizeToFitWidth = YES;
        solveForLabel.backgroundColor = [UIColor clearColor];
        [contentView addSubview:solveForLabel];
        varSelector = [[VarSelector alloc] initWithEquationInput:self vars:vars];
        [varSelector.selectorButton addTarget:self
                                       action:@selector(resignAllFirstResponders)
                             forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:varSelector.selectorButton];
        
        for (int i = 0; i < vars.count; i++) {
            [self setUpRow:i];
        }
        
        [self setUnknownVar:[vars objectAtIndex:0]];

        [self rectifyView];
        
        if (!(currentOS >= 7.0)) {
            [self configureForiOS6];
        } else {
            [self configureForiOS7];
        }
        eq = nil;
    }
    return self;
}

- (void)setUpKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)setUpKeyboardToolbar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextField)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearField)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAllFields)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignAllFirstResponders)],
                           nil];
    numberToolbar.backgroundColor = [UIColor lightGrayColor];
    [numberToolbar sizeToFit];
    keyboardToolbar = numberToolbar;
}

- (void)setUpEquationView
{
    //Get attributed equation string
    NSMutableAttributedString *eqStr = [[Formatter defaultFormatter] getFormattedEquationString:self.equation.equationString];
    //Set up the label displaying the equation
    UILabel *eqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 40)];
    eqLabel.attributedText = eqStr;
    eqLabel.backgroundColor = [UIColor clearColor];
    eqLabel.textAlignment = NSTextAlignmentCenter;
    //Ad to a UIView and return
    UIView *eqView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [eqView addSubview:eqLabel];
    [contentView addSubview:eqView];
}


- (void)setUpRow:(int)i
{
    int rowOffs = 120;
    UILabel *varLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, rowOffs+40*i, 80, 30)];
    varLabel.attributedText = [[Formatter defaultFormatter] getFormattedVar:[vars objectAtIndex:i]];
    varLabel.adjustsFontSizeToFitWidth = YES;
    varLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:varLabel];
    
    //Get varDef and unit. Var def and unit are separated by | key
    NSString *varDefWhole = [[[self.equation varDefs] valueForKey:[vars objectAtIndex:i]] copy];
    NSArray *components = [varDefWhole componentsSeparatedByString:@"|"];
    [varDefs addObject:[components objectAtIndex:0]];
    //Save unit for the unit picker later
    NSString *unit = [components objectAtIndex:1];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, rowOffs+40*i, 150, 30)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.inputAccessoryView = keyboardToolbar;
    [textFields addObject:textField];
    [contentView addSubview:textField];
    
    UnitSelector *us = [[UnitSelector alloc] initWithOrigin:CGPointMake(250, 120+40*i)];
    [us setDefaultUnit:unit];
    if ([[vars objectAtIndex:i] isEqualToString:@"ΔT"]) {
        [us.selectorButton setUserInteractionEnabled:NO];
    }
    [us.selectorButton addTarget:self
                          action:@selector(resignAllFirstResponders)
                forControlEvents:UIControlEventTouchUpInside];
    
    [unitSelectors addObject:us];
    [contentView addSubview:us.selectorButton];
}

- (void)rectifyView
{
    //Get th detail view
    NSString *eqTitle = [self.equation title];
    NSString *eqDetail = [NSString stringWithFormat:@"%@ Detail", eqTitle];
    UIView *detailView = [[[NSBundle mainBundle] loadNibNamed:eqDetail owner:nil options:nil] objectAtIndex:0];
    
    //Create the scroller
    viewPager = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    viewPager.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    viewPager.bounces = NO;
    
    //The scroller for the help menu is set up. the detail view is added immediately
    detailScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    detailScroller.contentSize = CGSizeMake(320, detailView.frame.size.height+5+40*varDefs.count);
    [detailScroller addSubview:detailView];
    
    //Add in each variable definition to the bottom of the help screen
    double offs =  detailView.frame.size.height+5;
    for (int i = 0; i < varDefs.count; i++) {
        //Formate the definiton
        NSMutableAttributedString *def = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@", [varDefs objectAtIndex:i]] attributes:nil];
        //Format the variable
        NSMutableAttributedString *var = [[Formatter defaultFormatter] getFormattedVar:[vars objectAtIndex:i]];
        //Set up the label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, offs+40*i, 320, 35)];
        label.backgroundColor = [UIColor clearColor];
        [var appendAttributedString:def];
        label.attributedText = var;
        label.textAlignment = NSTextAlignmentCenter;
        [detailScroller addSubview:label];
    }
    
    [detailScroller setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    detailScroller.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223/255.0 alpha:1.0];

    //Add input section and detail section to view pager
    [viewPager addSubview:contentView];
    //[viewPager addSubview:detailScroller];
    
    //Set up the solve button
    UIButton *solveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [solveButton setTitle:@"Solve" forState:UIControlStateNormal];
    solveButton.frame = CGRectMake(25+1, self.view.frame.size.height-145+1, 270-1, 40-1);
    [solveButton addTarget:self action:@selector(solveEquation) forControlEvents:UIControlEventTouchUpInside];
    [viewPager addSubview:solveButton];
    
    //Set up the clear all button
    UIButton *clearAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearAllButton setTitle:@"Clear All" forState:UIControlStateNormal];
    clearAllButton.frame = CGRectMake(25+1, self.view.frame.size.height-105+1, 270-1, 40-1);
    [clearAllButton addTarget:self action:@selector(clearAllFields) forControlEvents:UIControlEventTouchUpInside];
    [viewPager addSubview:clearAllButton];
    
    //Finish up rectification
    [viewPager setPagingEnabled:YES];
    viewPager.delegate = self;
    [self.view addSubview:viewPager];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(animateToHelp)];
}

- (void)configureForiOS6
{
    //Create custom buttons
    
    //Create the decimal button
	decimalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    decimalButton.frame = CGRectMake(71, 207, 35, 53);
	decimalButton.adjustsImageWhenHighlighted = NO;
    
    //Create scientific notation button
    eeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eeButton.frame = CGRectMake(35, 207, 36, 53);
	eeButton.adjustsImageWhenHighlighted = NO;
    
    //Create the minus button
    minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(0, 207, 34, 53);
	minusButton.adjustsImageWhenHighlighted = NO;
    
    //Set the images for each button
    [decimalButton setImage:[UIImage imageNamed:@"decimalprimed.png"] forState:UIControlStateNormal];
    [decimalButton setImage:[UIImage imageNamed:@"decimal.png"] forState:UIControlStateHighlighted];
    
    [eeButton setImage:[UIImage imageNamed:@"Eprimed.png"] forState:UIControlStateNormal];
    [eeButton setImage:[UIImage imageNamed:@"E.png"] forState:UIControlStateHighlighted];
    
    [minusButton setImage:[UIImage imageNamed:@"minusprimed.png"] forState:UIControlStateNormal];
    [minusButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
    
	[decimalButton addTarget:self action:@selector(decimal) forControlEvents:UIControlEventTouchUpInside];
    [eeButton addTarget:self action:@selector(E) forControlEvents:UIControlEventTouchUpInside];
    [minusButton addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
    
    //Set the view pager's background color
    viewPager.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table.png"]];
}

- (void)configureForiOS7
{
    decimalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    decimalButton.frame = CGRectMake(71, 207, 35, 53);
    decimalButton.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1.0];
    [decimalButton addTarget:self action:@selector(changeButtonColorClicked:) forControlEvents:UIControlEventTouchDown];
    [decimalButton addTarget:self action:@selector(changeButtonColorReleased:) forControlEvents:UIControlEventTouchUpInside];
    [decimalButton setTitle:@"." forState:UIControlStateNormal];
    [decimalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    eeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eeButton.frame = CGRectMake(35, 207, 36, 53);
    eeButton.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1.0];
    [eeButton addTarget:self action:@selector(changeButtonColorClicked:) forControlEvents:UIControlEventTouchDown];
    [eeButton addTarget:self action:@selector(changeButtonColorReleased:) forControlEvents:UIControlEventTouchUpInside];
    [eeButton setTitle:@"E" forState:UIControlStateNormal];
    [eeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(0, 207, 34, 53);
    minusButton.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1.0];
    [minusButton addTarget:self action:@selector(changeButtonColorClicked:) forControlEvents:UIControlEventTouchDown];
    [minusButton addTarget:self action:@selector(changeButtonColorReleased:) forControlEvents:UIControlEventTouchUpInside];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [decimalButton addTarget:self action:@selector(decimal) forControlEvents:UIControlEventTouchUpInside];
    [eeButton addTarget:self action:@selector(E) forControlEvents:UIControlEventTouchUpInside];
    [minusButton addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
    
    viewPager.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223/255.0 alpha:1.0];
}

//Move the cursor to the next available field
- (void)nextField
{
    //Get the current index;
    int currentIndex = [textFields indexOfObject:currentField];
    //Calculate the next index. Add one to the index if the next field is the
    //to-be-answered field
    int nextIndex = (currentIndex+1)%textFields.count;
    if (!((UITextField *)[textFields objectAtIndex:nextIndex]).userInteractionEnabled) {
        nextIndex = (nextIndex+1)%textFields.count;
    }
    //Cycle through all the fields to find an empty until the current field is reached
    while (nextIndex%textFields.count != currentIndex) {
        int j = nextIndex%textFields.count;
        if ([((UITextField *)[textFields objectAtIndex:j]).text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
            [[textFields objectAtIndex:j] becomeFirstResponder];
            currentField = [textFields objectAtIndex:j];
            return;
        }
        nextIndex++;
    }
    //if there are no empty fields, exit
    [self resignAllFirstResponders];
}

//Resign all the first reponders (which can only be text fields)
- (void)resignAllFirstResponders
{
    for (int i = 0; i < textFields.count; i++) {
        if ([[textFields objectAtIndex:i] isFirstResponder]) {
            [[textFields objectAtIndex:i] resignFirstResponder];
        }
    }
}

//Set the unknown variable. 
- (void)setUnknownVar:(NSString *)s
{
    int index = [vars indexOfObject:s];
    for (int i = 0; i < textFields.count; i++) {
        //The known variables will be enabled and have a normal background.
        [[textFields objectAtIndex:i] setUserInteractionEnabled:YES];
        [[textFields objectAtIndex:i] setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        //The unknown variable will be disabled and given a clearer background color.
        if (i == index) {
            [[textFields objectAtIndex:i] setUserInteractionEnabled:NO];
            [[textFields objectAtIndex:i] setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
        }
    }
}

//Clear all the fields
- (void)clearAllFields
{
    for (int i = 0; i < textFields.count; i++) {
        ((UITextField *)[textFields objectAtIndex:i]).text = @"";
        [self.equation setValue:NSNotFound forVar:[vars objectAtIndex:i]];
    }
}

//Clear field.
- (void)clearField
{
    currentField.text = @"";
}

//Solve the equaiton
- (void)solveEquation
{
    [self.equation clear];
    
    //Return from all fields
    [self resignAllFirstResponders];
    //Reset the size of the scroller
    [contentView setContentOffset:CGPointMake(0, 0)];
    contentView.frame = CGRectMake(0, 0, self.view.frame.size.height, contentViewHeight);
    
    //Go through each field and set the value for the var
    for (int i = 0; i < vars.count; i++) {
        NSString *var = [vars objectAtIndex:i];
        UITextField *itf = [textFields objectAtIndex:i];
        UnitSelector *up = [unitSelectors objectAtIndex:i];
        if (!itf.userInteractionEnabled) {
            answerIndex = i;
            continue;
        }
        NSString *value = [itf text];
        //If the string is empty, through an error message
        if ([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Improper input"
                                                            message:@"You must input a number."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        //Set the value, once converted to the correct units, for the variable
        double numValue = [[up toOriginalUnit:value] doubleValue];
        [self.equation setValue:numValue forVar:var];
    }
    
    //Get the answer in proper units
    NSString *answer = [self.equation solve];
    [[textFields objectAtIndex:answerIndex] setText:[[unitSelectors objectAtIndex:answerIndex] toSelectedUnit:answer]];
}

//Set the current field. This allows custom input from the keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentField = textField;
    CGPoint scrollPoint = CGPointMake(0.0, currentField.frame.origin.y-contentView.frame.size.height/2);
    [contentView setContentOffset:scrollPoint animated:YES];
}

//Perform operations when the view pager scrolls. On iOS 7, due to the chnaged behavior of the
//navigation bar, the y offset must be changed constantly
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //If iOS 7 or above, adjust the view pager's y offset continuously
    if (currentOS >= 7.0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -44);
    }
    //If the view pager's x offset is 0, add the help button
    if (scrollView.contentOffset.x == 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(animateToHelp)];
    }
    //if the view pager's x offset is so that only the detail view can be seen,
    //remove the keyboard
    if (scrollView.contentOffset.x == self.view.frame.size.width) {
        [self resignAllFirstResponders];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//Animate to the help view.
- (void)animateToHelp
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = detailScroller;
    vc.title = [self.title stringByAppendingString:@" Help"];
    [self.navigationController pushViewController:vc animated:YES];
}

// Type a decimal point
- (void)decimal
{
    NSString *str = [currentField text];
    NSArray *parts = [str componentsSeparatedByString:@"e"];
    if (parts.count == 1) {
        NSRange decRange = [[parts objectAtIndex:0] rangeOfString:@"."];
        if (decRange.location == NSNotFound) {
            str = [str stringByAppendingString:@"."];
        }
    } else {
        NSRange decRange = [[parts objectAtIndex:1] rangeOfString:@"."];
        if (decRange.location == NSNotFound) {
            str = [str stringByAppendingString:@"."];
        }
    }
    currentField.text = str;
}

//Type a scientific notation character
- (void)E
{
    NSString *str = [currentField text];
    NSRange eeRange = [str rangeOfString:@"e"];
    if (eeRange.location == NSNotFound && !([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)) {
        str = [str stringByAppendingString:@"e"];
    }
    currentField.text = str;

}

//Type a minus sign
- (void)minus
{
    NSString *str = [currentField text];
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        str = [str stringByAppendingString:@"-"];
    } else if ([str characterAtIndex:str.length-1] == 'e') {
        str = [str stringByAppendingString:@"-"];
    }
    currentField.text = str;
}

- (void)changeButtonColorClicked:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:176.0/255.0 blue:183.0/255.0 alpha:1.0];
}

- (void)changeButtonColorReleased:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1.0];
}

//Adjust the size of the content view when the keyboard shows up.
//Add the proper buttons to the keyboard
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for(int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
        if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES) {
            [keyboard addSubview:decimalButton];
            [keyboard addSubview:eeButton];
            [keyboard addSubview:minusButton];
        }
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    contentView.frame = CGRectMake(0, 0, aRect.size.width, aRect.size.height);
    CGPoint scrollPoint = CGPointMake(0.0, currentField.frame.origin.y-contentView.frame.size.height/2);
    [contentView setContentOffset:scrollPoint animated:YES];
}

//Adjust the size of the content view when the keyboard disapears
//Remove the proper buttons when the keyboard disappears
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight);
    contentView.contentOffset = CGPointMake(0, 0);
    [decimalButton removeFromSuperview];
    [eeButton removeFromSuperview];
    [minusButton removeFromSuperview];
}

- (void)dealloc
{
    [decimalButton removeFromSuperview];
    [eeButton removeFromSuperview];
    [minusButton removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resignAllFirstResponders];
    for (id o in contentView.subviews) {
        [o removeFromSuperview];
    }
    [contentView removeFromSuperview];
    contentView = nil;
    viewPager.delegate = nil;
    for (id o in viewPager.subviews) {
        [o removeFromSuperview];
    }
    viewPager = nil;
    varSelector = nil;
    for (id o in keyboardToolbar.subviews) {
        [o removeFromSuperview];
    }
    [keyboardToolbar removeFromSuperview];
    keyboardToolbar = nil;
    currentField.delegate = nil;
    currentField = nil;
    [decimalButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    decimalButton = nil;
    [eeButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    eeButton = nil;
    [minusButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    minusButton = nil;
    vars = nil;
    varDefs = nil;
    for (UITextField *t in textFields) {
        t.delegate = nil;
        t.inputAccessoryView = nil;
    }
    textFields = nil;
    unitSelectors = nil;
    equation = nil;
    self.view = nil;
    NSLog(@"equation input");
}

- (void)viewDidDisappear:(BOOL)animated
{
    currentTitle = self.title;
    self.title = @"Back";
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    if (currentTitle) {
        self.title = currentTitle;
    }
    [super viewWillAppear:animated];
}


@end