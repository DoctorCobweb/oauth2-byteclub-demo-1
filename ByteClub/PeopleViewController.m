//
//  PeopleViewController.m
//  ByteClub
//
//  Created by andre on 1/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "PeopleViewController.h"
#import "AFNetworking.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController

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
    //self.people.text = @"HAHAHAH";
    NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    
    NSString * people_url = [NSString stringWithFormat:@"https://agtest.nationbuilder.com/api/v1/people?page=1&per_page=10&access_token=%@", token];
    
     
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"response serializer: %@", [manager responseSerializer]);
    [manager GET:people_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"NOTES VIEW CONTROLLER and response is an NSDictionary: %@", responseObject);
        
        //responseObject is an NSDictionary with a "results" key with value of type
        //NSSet.
        //in this set then there are NSDictionary objects for each person
        //the following will thus get all people returned from the api call
        NSDictionary * person = [responseObject objectForKey:@"results"];
        NSLog(@"%d people records returned", [person count]);
        
        NSString * resp_str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"results"][0]];
        self.people.text = resp_str;
        
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