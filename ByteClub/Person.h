//
//  Person.h
//  ByteClub
//
//  Created by andre on 2/04/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * note;
@property (nonatomic, strong) NSNumber * supportLevel;
@property (nonatomic, strong) NSArray  * tags;

//this is the Nation Builder unique id for the person's record
@property (nonatomic, strong) NSNumber * recordID;
@end
