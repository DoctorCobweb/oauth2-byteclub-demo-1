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
#import "AFNetworking.h"

@interface PeopleEditDetailViewController ()
{
    NSString *contact_url_post;
    NSString *person_url_put;
    PersonDetailViewController *prev_cont;
    Person *updated_person;
    UINavigationController *the_nav_cont;
}

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
    
    //OAUTH2 STUFF
    // get the access_token to make oauth2 api calls
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    contact_url_post = [NSString stringWithFormat:@"https://agtest.nationbuilder.com/api/v1/people/%@/contacts?access_token=%@", [self.person.recordID stringValue], token];
    
    person_url_put = [NSString stringWithFormat:@"https://agtest.nationbuilder.com/api/v1/people/%@?access_token=%@", [self.person.recordID stringValue], token ];
    
    //NAVIGATION STUFF
    //view controller stuff. get the navigation stack. get the
    //previous view controller etc
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    UITabBarController * tab_bar_con = (UITabBarController *)([delegate window]).rootViewController;
    
    // outputs UITabBarController
    NSLog(@"rootViewController: %@" ,tab_bar_con);
    
    // outputs PeopleNavigationViewController
    // the navigation controller which has a stack of view controllers
    the_nav_cont = (UINavigationController *)[tab_bar_con selectedViewController];
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
    prev_cont = (PersonDetailViewController *) conts_in_nav_stack[no_of_conts_in_stack -1];
    
    
    
    //UI STUFF
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
    
    updated_person = [[Person alloc] init];
    
    updated_person.firstName = self.firstName.text;
    updated_person.lastName = self.lastName.text;
    updated_person.supportLevel = [NSNumber numberWithInteger:[self.supportLevel.text integerValue]];
    updated_person.email = self.email.text;
    updated_person.phone = self.phone.text;
    updated_person.mobile = self.mobile.text;
    
    
    //begine the server update chain. hitting multiple api endpoints
    //in series. if anyone of them return an error then abort whole
    //process. get user to try again.
    [self updatePersonEndpoint];
}


-(void)updatePersonEndpoint
{
    //TODO: implement this for tags and notes field
    // => may require network calls etc
    //TODO: send updates to netork/NB servers
    prev_cont.person.firstName = self.firstName.text;
    prev_cont.person.lastName = self.lastName.text;
    prev_cont.person.supportLevel =[NSNumber numberWithInteger:[self.supportLevel.text integerValue]];
    prev_cont.person.email = self.email.text;
    prev_cont.person.phone= self.phone.text;
    prev_cont.person.mobile= self.mobile.text;

    NSDictionary *parameters = @{ @"person": @{@"first_name": self.firstName.text, @"last_name": self.lastName.text, @"support_level":[NSNumber numberWithInteger:[self.supportLevel.text integerValue]], @"email1":self.email.text, @"phone":self.phone.text, @"mobile":self.mobile.text}};
    
    NSError *error;
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:person_url_put parameters:parameters error:&error];
    
    NSString *request_body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    NSLog(@"request_body: %@", request_body);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"UPDATE PERSON ENDPOINT: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSString *request_body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    NSLog(@"request_body: %@", request_body);
       [self updateContactEnpoint];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];

}


-(void)updateContactEnpoint
{
    #warning hardcoding POST new contact data
    //HARDCODE: update the contacts with some hardcoded JSON
    NSDictionary *parameters = @{ @"contact": @{@"note": self.note.text, @"type_id":@"1", @"method":@"door_knock", @"sender_id":@"9", @"status":@"left_message", @"broadcaster_id": @"1"}  };
    NSError *error;
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:contact_url_post parameters:parameters error:&error];
    
    NSString *request_body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    NSLog(@"request_body: %@", request_body);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"UPDATE CONTACT ENPOINT: %@", responseObject);
       //now pop off the current view controller to see previous
       //controller with updated person details
       [the_nav_cont popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];

}

@end
