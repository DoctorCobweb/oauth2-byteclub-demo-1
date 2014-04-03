//
//  PersonDetailViewController.m
//  ByteClub
//
//  Created by andre on 2/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "AFNetworking.h"

@interface PersonDetailViewController ()

@end

@implementation PersonDetailViewController

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
	// Do any additional setup after loading the view.
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
   
    NSLog(@"recordID: %@", self.person.recordID);
    
    NSString * contact_url = [NSString stringWithFormat:@"https://agtest.nationbuilder.com/api/v1/people/%@/contacts?page=1&per_page=10&access_token=%@", [self.person.recordID stringValue], token];
    self.scrollView.contentSize =CGSizeMake(320, 800);
    
    
    //get the person object passed through from segue
    self.firstName.text = self.person.firstName;
    self.lastName.text = self.person.lastName;
    self.supportLevel.text = [self.person.supportLevel stringValue];
    self.email.text = self.person.email;
    self.phone.text = self.person.phone;
    self.mobile.text = self.person.mobile;
    
    //set to blank. making network call to get contents later on
    self.note.text = nil;
    
    
    int number_of_tags = [self.person.tags count];
    if (number_of_tags) {
        NSLog(@"person has >= 1  tags associated");
        self.tags.text = @"TAGSSSSSS HERE";
        NSMutableString * tags_concatenated = [[NSMutableString alloc] init];
        for (int i = 0; i < number_of_tags; i++) {
            [tags_concatenated appendFormat:@" %@", self.person.tags[i]];
        }
        self.tags.text = tags_concatenated;
    } else {
        self.tags.text = nil;
    }
    
    //need to get notes on the person from a different api, namely
    // the contacts api
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    AFHTTPRequestSerializer *req_serializer = manager.requestSerializer;
    
    [req_serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req_serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"AFHTTPRequestOperationManager.requestSerializer.HTTPRequestHeaders: %@", manager.requestSerializer.HTTPRequestHeaders);
    
    NSLog(@"response serializer: %@", [manager responseSerializer]);
    AFHTTPResponseSerializer *res_ser = [manager responseSerializer];
    res_ser.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"application/json", nil];
    NSLog(@"acceptableContentTypes for response: %@",res_ser.acceptableContentTypes);
    [manager GET:contact_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"PERSON DETAIL VIEW CONTROLLER and CONTACTS response: %@", responseObject);
        
        NSSet * contacts_set = [responseObject objectForKey:@"results"];
        
        NSArray * tmp_contacts= [contacts_set allObjects];
        
        NSLog(@"%d people records returned", [tmp_contacts count]);
        
        //check if there are non zero number of notes for person
        if ([tmp_contacts count]) {
             int tmp_contacts_count = [tmp_contacts count];
             for (int i = 0; i < tmp_contacts_count; i++) {
            
             NSLog(@"tmp_contacts[i] objectForKey:@\"note\": %@",[tmp_contacts[i] objectForKey:@"note"]);
            
             }
        
#warning for now just use the latest note. later we will include all
             self.note.text = [tmp_contacts[0] objectForKey:@"note"];
        } 
        
        //alloc and init the people array
        //contact_notes = [[NSMutableArray alloc] initWithCapacity:[tmp_contacts count]];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
