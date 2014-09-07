//
//  Main Menu.h
//  StulinCPES
//
//  Created by Shiv Roychowdhury on 6/4/13.
//  Copyright (c) 2013 Royshaarfeld Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenu : UITableViewController
{
    NSString *currentTitle;
    //Options
    NSArray *options;
    //Options' view controlers
    NSArray *optionViewControllers;
    //Icons
    NSArray *icons;
}
@end
