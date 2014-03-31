//
//  NationBuilder.h
//  ByteClub
//
//  Created by andre on 30/03/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

// OAuth Stuff
extern NSString * const NationBuilderOAuthTokenKey;
extern NSString * const NationBuilderOAuthTokenKeySecret;
extern NSString * const NationBuilderRequestToken;
extern NSString * const NationBuilderRequestTokenSecret;
extern NSString * const NationBuilderAccessToken;
extern NSString * const NationBuilderAccessTokenSecret;
extern NSString * const NationBuilderUIDKey;
extern NSString * const NationBuilderReceivedNotification;

extern NSString * const appFolder;

typedef void (^NationBuilderRequestTokenCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);


@interface NationBuilder : NSObject

+ (void)requestTokenWithCompletionHandler:(NationBuilderRequestTokenCompletionHandler)completionBlock;
+ (void)exchangeTokenForUserAccessTokenURLWithCompletionHandler:(NationBuilderRequestTokenCompletionHandler)completionBlock;
+ (NSString*)apiAuthorizationHeader;

// helpers
+ (NSDictionary*)dictionaryFromOAuthResponseString:(NSString*)response;


+ (NSURL*)appRootURL;
+ (NSURL*)uploadURLForPath:(NSString*)path;
+ (NSURL*)createPhotoUploadURL;

@end
