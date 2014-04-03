//
//  PeopleTableViewController.h
//  ByteClub
//
//  Created by andre on 2/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface PeopleTableViewController : UITableViewController

-(Person *) personFieldsForObject:(NSDictionary *)person;

@end
