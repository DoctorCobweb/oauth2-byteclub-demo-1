//
//  PeopleEditDetailViewController.m
//  ByteClub
//
//  Created by andre on 3/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "PeopleEditDetailViewController.h"
#import "Person.h"
#import "PeopleNavigationViewController.h"
#import "AppDelegate.h"
#import "PersonDetailViewController.h"

@interface PeopleEditDetailViewController ()

@end

@implementation PeopleEditDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 800);
    NSLog(@"person details to edit: %@", self.person);
    
    //get the person object passed through from segue
    self.firstName.text = self.person.firstName;
    self.lastName.text = self.person.lastName;
    self.supportLevel.text = [self.person.supportLevel stringValue];
    self.email.text = self.person.email;
    self.phone.text = self.person.phone;
    self.mobile.text = self.person.mobile;
    
    self.note.text = @"Tap to add a new note";
    
    int number_of_tags = [self.person.tags count];
    if (number_of_tags) {
        NSLog(@"person has >= 1  tags associated");
        NSMutableString * tags_concatenated = [[NSMutableString alloc] init];
        for (int i = 0; i < number_of_tags; i++) {
            [tags_concatenated appendFormat:@" %@", self.person.tags[i]];
        }
        self.tags.text = tags_concatenated;
    } else {
        self.tags.text = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveChanges:(id)sender {
    NSLog(@"saveChanges method called");
    
    Person *updated_person = [[Person alloc] init];
    
    updated_person.firstName = self.firstName.text;
    updated_person.lastName = self.lastName.text;
    updated_person.supportLevel = [NSNumber numberWithInteger:[self.supportLevel.text integerValue]];
    updated_person.email = self.email.text;
    updated_person.phone = self.phone.text;
    updated_person.mobile = self.mobile.text;
    
    NSLog(@"updated_person.email: %@", [updated_person valueForKey:@"email"]);
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UINavigationController *nav_con = [storyboard]
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    UITabBarController * tab_bar_con = (UITabBarController *)([delegate window]).rootViewController;
    
    // outputs UITabBarController
    NSLog(@"rootViewController: %@" ,tab_bar_con);
    
    // outputs PeopleNavigationViewController
    // the navigation controller which has a stack of view controllers
    UINavigationController * the_nav_cont = (UINavigationController *)[tab_bar_con selectedViewController];
    NSLog(@"selectedViewController: %@", the_nav_cont);
    
    // outputs PeopleEditDeleteViewController
    NSLog(@"top View Controller: %@ ", [ the_nav_cont topViewController]);
    
    NSArray *conts_in_nav_stack = [the_nav_cont viewControllers];
    
    // output array
    //["<PeopleTableViewController: 0x8a6e780>",
    // "<PersonDetailViewController: 0x8b780f0>",
    // "<PeopleEditDetailViewController: 0x8dcc3e0>"]
    NSLog(@"controllers in current nav stack: %@", conts_in_nav_stack);
    
    
    // the a reference to the previous view controller. set its
    //person property to be the new updated person property in this
    //instance
    int no_of_conts_in_stack = [conts_in_nav_stack count];
    PersonDetailViewController *prev_cont = (PersonDetailViewController *) conts_in_nav_stack[no_of_conts_in_stack -1];
    
    NSLog(@"updated_person.email: %@", updated_person.email);
    prev_cont.person.firstName = self.firstName.text;
    prev_cont.person.lastName = self.lastName.text;
    prev_cont.person.supportLevel =[NSNumber numberWithInteger:[self.supportLevel.text integerValue]];
    prev_cont.person.email = updated_person.email;
    prev_cont.person.phone= self.phone.text;
    prev_cont.person.mobile= self.mobile.text;

    //now pop off the current view controller to see previous
    //controller with updated person details
    [the_nav_cont popViewControllerAnimated:YES];
}

@end
