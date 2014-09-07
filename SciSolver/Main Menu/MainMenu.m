//
//  Main Menu.m
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/4/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import "MainMenu.h"
#import "ChemistryMenu.h"
#import "PhysicsMenu.h"
#import "SearchTable.h"

@implementation MainMenu

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        options = @[@"Chemistry Equations", @"Physics Equations", @"Search For Equation", /*@"Help*/];
       
        UIViewController *help = [[UIViewController alloc] init];
        UIView *detailView = [[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:nil options:nil] objectAtIndex:0];
        //The scroller for the help menu is set up. the detail view is added immediately
        UIScrollView *newScroller2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 480) ? 568 : 480)];
        newScroller2.contentSize = CGSizeMake(320, detailView.frame.size.height);
        [newScroller2 addSubview:detailView];
        [help.view addSubview:newScroller2];
        help.title = @"Help";
        
        optionViewControllers = @ [
            [ChemistryMenu class],
            [PhysicsMenu class],
            [SearchTable class]
        ];
        icons = @[@"Beaker.png", @"Gear.png", @"MagGlass.png", @"questionmark-1.png"];
        
        self.title = @"Main Menu";
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Reuse cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Create if nonexistent
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //Cell title correpsonds to option at row
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // ...
     // Pass the selected object to the new view controller.
    UIViewController *vc;
    if (indexPath.row == 3) {
        UIViewController *help = [[UIViewController alloc] init];
        UIView *detailView = [[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:nil options:nil] objectAtIndex:0];
        //The scroller for the help menu is set up. the detail view is added immediately
        UIScrollView *newScroller2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 480) ? 568 : 480)];
        newScroller2.contentSize = CGSizeMake(320, detailView.frame.size.height);
        [newScroller2 addSubview:detailView];
        [help.view addSubview:newScroller2];
        help.title = @"Help";
        vc = help;
    } else {
        vc = [[[optionViewControllers objectAtIndex:indexPath.row] alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
     
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

- (void)dealloc
{
    currentTitle = nil;
    options = nil;
    optionViewControllers = nil;
    icons = nil;
}

@end
