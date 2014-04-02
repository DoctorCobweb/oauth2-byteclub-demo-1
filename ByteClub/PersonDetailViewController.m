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
   
    NSString *person_id = @"528";
      NSString * contact_url = [NSString stringWithFormat:@"https://agtest.nationbuilder.com/api/v1/people/%@/contacts?page=1&per_page=10&access_token=%@", person_id, token];
    self.scrollView.contentSize =CGSizeMake(320, 700);
    
    
    //get the person object passed through from segue, then populate the info fields
    if (self.person.firstName != [NSNull null]) {
        self.firstName.text = self.person.firstName;
    } else {
        self.firstName.text = @"";
    }
    
    if (self.person.lastName != [NSNull null]) {
        self.lastName.text = self.person.lastName;
    } else {
        self.lastName.text = @"";
    }
    
    
    if (self.person.supportLevel != [NSNull null]) {
        NSLog(@"self.person.supportLevel: %@", self.person.supportLevel);
        //self.supportLevel.text = self.person.supportLevel;
        self.supportLevel.text = [self.person.supportLevel stringValue];
    } else {
        self.supportLevel.text = @"0";
    }
    
    
    if (self.person.email != [NSNull null]) {
        self.email.text = self.person.email;
    } else {
        self.email.text = @"";
    }
    
    
    if (self.person.phone != [NSNull null]) {
        self.phone.text = self.person.phone;
    } else {
        self.phone.text = @"";
    }
    
    
    if (self.person.mobile != [NSNull null]) {
        self.mobile.text = self.person.mobile;
    } else {
        self.mobile.text = @"";
    }
    
    
    /*
    if (self.person.note != [NSNull null]) {
        self.note.text = self.person.note;
    } else {
        self.note.text = @"";
    }
     */
    
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
        //NSLog(@"tmp_keys: %@", tmp_keys);
        NSLog(@"%d people records returned", [tmp_contacts count]);
        //NSLog(@"tmp_people ARRAY: %@", tmp_people);
        
        //alloc and init the people array
        //contact_notes = [[NSMutableArray alloc] initWithCapacity:[tmp_contacts count]];
        
        int tmp_contacts_count = [tmp_contacts count];
        for (int i = 0; i < tmp_contacts_count; i++) {
            
            NSLog(@"tmp_contacts[i] objectForKey:@\"note\": %@",[tmp_contacts[i] objectForKey:@"note"]);
            
        }
        
        //for now just use the latest note. later we will include all
        self.note.text = [tmp_contacts[0] objectForKey:@"note"];
        
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
