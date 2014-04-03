//
//  PeopleTableViewController.m
//  ByteClub
//
//  Created by andre on 2/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "Person.h"
#import "PersonDetailViewController.h"

@interface PeopleTableViewController ()
{
    NSMutableArray * people;
}
@end

@implementation PeopleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSLog(@"access_token: %@", token);
    
    NSString * people_url = [NSString stringWithFormat:@"https://agtest.nationbuilder.com/api/v1/people?page=1&per_page=10&access_token=%@", token];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:people_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"PEOPLE TABLE VIEW CONTROLLER and response: %@", responseObject);
        
        //responseObject is an NSDictionary with a "results" key with value of type
        //NSSet.
        //in this set then there are NSDictionary objects for each person
        //the following will thus get all people returned from the api call
        NSSet * people_set = [responseObject objectForKey:@"results"];
        //NSLog(@"people_set SET: %@", people_set);
        
        NSArray * people_array = [people_set allObjects];
        //NSLog(@"tmp_keys: %@", tmp_keys);
        NSLog(@"%d people records returned", [people_array count]);
        //NSLog(@"tmp_people ARRAY: %@", tmp_people);
        
        //alloc and init the people array
        people = [[NSMutableArray alloc] initWithCapacity:[people_array count]];
        
        int people_array_count = [people_array count];
        for (int i = 0; i < people_array_count; i++) {
            
            Person *demo_person = [self personFieldsForObject:people_array[i]];
            [people addObject:demo_person];
        }
        
        //reload tableview to display new data returned from server
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}


//get arbitrary fields from each person.
-(Person *) personFieldsForObject:(NSDictionary *)person
{

    Person * tmp_person = [[Person alloc] init];
   
    //check to see if any of the entries are equal to the
    //null singleton returned by [NSNull null]
    //from inspection some fields in the console print out to
    //"<null>" which is how [NSNull null] is printed out
    
    
    if ([person objectForKey:@"id"] == [NSNull null]) {
        tmp_person.recordID = nil;
    } else {
        tmp_person.recordID = [person objectForKey:@"id"];
    }
    
    
    if ([person objectForKey:@"first_name"] == [NSNull null]) {
        tmp_person.firstName = nil;
    } else {
        tmp_person.firstName = [person objectForKey:@"first_name"];
    }
    
    
    if ([person objectForKey:@"last_name"] == [NSNull null]) {
        tmp_person.lastName = nil;
    } else {
        tmp_person.lastName = [person objectForKey:@"last_name"];
    }
    
    
    if ([person objectForKey:@"email"] == [NSNull null]) {
        tmp_person.email = nil;
    } else {
        tmp_person.email = [person objectForKey:@"email"];
    }
    
    
    if ([person objectForKey:@"phone"] == [NSNull null]) {
        tmp_person.phone = nil;
    } else {
        tmp_person.phone = [person objectForKey:@"phone"];
    }
    
    
    if ([person objectForKey:@"mobile"] == [NSNull null]) {
        tmp_person.mobile= nil;
    } else {
        tmp_person.mobile= [person objectForKey:@"mobile"];
    }
    
    
    if ([person objectForKey:@"note"] == [NSNull null]) {
        tmp_person.note= nil;
    } else {
        tmp_person.note = [person objectForKey:@"note"];
    }
    
    
    if ([person objectForKey:@"support_level"] == [NSNull null]) {
        tmp_person.supportLevel= nil;
    } else {
        tmp_person.supportLevel= [person objectForKey:@"support_level"];
    }

    
    if ([person objectForKey:@"tags"] == [NSNull null]) {
        tmp_person.tags= nil;
    } else {
        tmp_person.tags = [person objectForKey:@"tags"];
    }
    
    return tmp_person;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"personCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //construct the cell text label from first and last name
    NSString *_firstName = ((Person *)[people objectAtIndex:indexPath.row]).firstName;
    NSString *_lastName = ((Person *)[people objectAtIndex:indexPath.row]).lastName;
    NSString * _textLabel = [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];

    cell.textLabel.text = _textLabel;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPersonsDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PersonDetailViewController *destViewController = (PersonDetailViewController *) segue.destinationViewController;
        destViewController.person = [people objectAtIndex:indexPath.row];
        //NSLog(@"%@", ((PersonDetailViewController *)segue.destinationViewController).person);
    }
}


@end
