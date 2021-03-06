//
//  PeopleEditDetailViewController.h
//  ByteClub
//
//  Created by andre on 3/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface PeopleEditDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *supportLevel;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UITextField *tags;

@property (nonatomic, strong) Person * person;

- (IBAction)saveChanges:(id)sender;

-(void)updateContactEndpoint;
-(void)updatePersonEndpoint;

@end
