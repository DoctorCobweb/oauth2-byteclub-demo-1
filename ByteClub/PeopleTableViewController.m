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
    
    
    AFHTTPRequestSerializer *req_serializer = manager.requestSerializer;
    
    [req_serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req_serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 NSLog(@"AFHTTPRequestOperationManager.requestSerializer.HTTPRequestHeaders: %@", manager.requestSerializer.HTTPRequestHeaders);
    
    NSLog(@"response serializer: %@", [manager responseSerializer]);
    AFHTTPResponseSerializer *res_ser = [manager responseSerializer];
    res_ser.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"application/json", nil];
    NSLog(@"acceptableContentTypes for response: %@",res_ser.acceptableContentTypes);
    [manager GET:people_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NOTES VIEW CONTROLLER and response: %@", responseObject);
        
        //responseObject is an NSDictionary with a "results" key with value of type
        //NSSet.
        //in this set then there are NSDictionary objects for each person
        //the following will thus get all people returned from the api call
        NSSet * people_set = [responseObject objectForKey:@"results"];
        //NSLog(@"people_set SET: %@", people_set);
        
        NSArray * tmp_people = [people_set allObjects];
        //NSLog(@"tmp_keys: %@", tmp_keys);
        NSLog(@"%d people records returned", [tmp_people count]);
        //NSLog(@"tmp_people ARRAY: %@", tmp_people);
        
        //alloc and init the people array
        people = [[NSMutableArray alloc] initWithCapacity:[tmp_people count]];
        
        int tmp_people_count = [tmp_people count];
        for (int i = 0; i < tmp_people_count; i++) {
            Person * tmp_person = [[Person alloc] init];
            
            NSLog(@"tmp_people[i] objectForKey:@\"email\": %@",[tmp_people[i] objectForKey:@"email"]);
            NSLog(@"tmp_people[i] objectForKey:@\"mobile\": %@",[tmp_people[i] objectForKey:@"mobile"]);
            
            tmp_person.firstName = [tmp_people[i] objectForKey:@"first_name"];
            tmp_person.lastName = [tmp_people[i] objectForKey:@"last_name"];
            tmp_person.email= [tmp_people[i] objectForKey:@"email"];
            tmp_person.phone= [tmp_people[i] objectForKey:@"phone"];
            tmp_person.mobile= [tmp_people[i] objectForKey:@"mobile"];
            tmp_person.note= [tmp_people[i] objectForKey:@"note"];
            tmp_person.supportLevel = [tmp_people[i] objectForKey:@"support_level"];
            
            //NSLog(@"temp_person.firstName: %@", tmp_person.firstName);
            [people addObject:tmp_person];
        }
        
        //NSLog(@"OUTSIDE LOOP: people array size: %d", [people count]);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    if ([segue.identifier isEqualToString:@"showPersonDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PersonDetailViewController *destViewController = (PersonDetailViewController *) segue.destinationViewController;
        destViewController.person = [people objectAtIndex:indexPath.row];
        //NSLog(@"%@", ((PersonDetailViewController *)segue.destinationViewController).person);
    }
}


@end
