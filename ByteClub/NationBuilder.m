//
//  NationBuilder.m
//  ByteClub
//
//  Created by andre on 30/03/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "NationBuilder.h"

// INSERT YOUR OWN API KEY and SECRET HERE
static NSString * NationBuilderApiKey = @"3y4rxw097ih12fo";
static NSString * NationBuilderAppSecret = @"7z3gl93i7motvtr";

NSString * const appFolder = @"byteclub";

// note: the values dont have nation builder prefix. mimicing
// how dropbox responds
NSString * const NationBuilderOAuthTokenKey = @"oauth_token";
NSString * const NationBuilderOAuthTokenKeySecret = @"oauth_token_secret";
NSString * const NationBuilderUIDKey = @"nation_builder_uid";
NSString * const NationBuilderTokenReceivedNotification = @"nation_builder_have_user_request_token";

#pragma mark - saved in NSUserDefaults
NSString * const NationBuilderRequestToken = @"nation_builder_request_token";
NSString * const NationBuilderRequestTokenSecret = @"nation_builder_request_token_secret";
NSString * const NationBuilderAccessToken = @"nation_builder_access_token";
NSString * const NationBuilderAccessTokenSecret = @"access_token_secret";

@implementation NationBuilder


+(void)requestTokenWithCompletionHandler:(NationBuilderRequestTokenCompletionHandler)completionBlock
{
    
    //TODO
    // hard code the nation builder authorize url for now
    //NSString * NationBuilderAuthUri = @"https://avg.nationbuilder.com/oauth/authorize?responseType=code&client_id=XXXXXXX&redirect_uri=YYYYYYYYY";
    
    
    NSString *authorizationHeader = [self plainTextAuthorizationHeaderForAppKey:NationBuilderApiKey
                                                                      appSecret:NationBuilderAppSecret
                                                                          token:nil
                                                                    tokenSecret:nil];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{@"Authorization": authorizationHeader}];
   
    //TODO
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.dropbox.com/1/oauth/request_token"]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    [[session dataTaskWithRequest:request completionHandler:completionBlock] resume];
}

+(void)exchangeTokenForUserAccessTokenURLWithCompletionHandler:(NationBuilderRequestTokenCompletionHandler)completionBlock
{
    //TODO
    NSString *urlString = [NSString stringWithFormat:@"https://api.dropbox.com/1/oauth/access_token?"];
    NSURL *requestTokenURL = [NSURL URLWithString:urlString];
    
    NSString *reqToken = [[NSUserDefaults standardUserDefaults] valueForKey:NationBuilderRequestToken];
    NSString *reqTokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:NationBuilderRequestTokenSecret];
    
    NSString *authorizationHeader = [self plainTextAuthorizationHeaderForAppKey:NationBuilderApiKey
                                                                      appSecret:NationBuilderAppSecret
                                                                          token:reqToken
                                                                    tokenSecret:reqTokenSecret];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{@"Authorization": authorizationHeader}];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestTokenURL];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:request completionHandler:completionBlock] resume];
}

+(NSString*)plainTextAuthorizationHeaderForAppKey:(NSString*)appKey appSecret:(NSString*)appSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret
{
    //TODO
    // version, method, and oauth_consumer_key are always present
    NSString *header = [NSString stringWithFormat:@"OAuth oauth_version=\"1.0\",oauth_signature_method=\"PLAINTEXT\",oauth_consumer_key=\"%@\"",NationBuilderApiKey];
    
    // look for oauth_token, include if one is passed in
    if (token) {
        header = [header stringByAppendingString:[NSString stringWithFormat:@",oauth_token=\"%@\"",token]];
    }
    
    // add oauth_signature which is app_secret&token_secret , token_secret may not be there yet, just include @"" if it's not there
    if (!tokenSecret) {
        tokenSecret = @"";
    }
    header = [header stringByAppendingString:[NSString stringWithFormat:@",oauth_signature=\"%@&%@\"",NationBuilderAppSecret,tokenSecret]];
    return header;
}


+(NSString*)apiAuthorizationHeader
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:NationBuilderAccessToken];
    NSString *tokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:NationBuilderAccessTokenSecret];
    return [self plainTextAuthorizationHeaderForAppKey:NationBuilderApiKey
                                             appSecret:NationBuilderAppSecret
                                                 token:token
                                           tokenSecret:tokenSecret];
}


+(NSDictionary*)dictionaryFromOAuthResponseString:(NSString*)response
{
    NSArray *tokens = [response componentsSeparatedByString:@"&"];
    NSMutableDictionary *oauthDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    for(NSString *t in tokens) {
        NSArray *entry = [t componentsSeparatedByString:@"="];
        NSString *key = entry[0];
        NSString *val = entry[1];
        [oauthDict setValue:val forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:oauthDict];
}


+ (NSURL*)appRootURL
{
    NSString *url = [NSString stringWithFormat:@"https://api.dropbox.com/1/metadata/dropbox/%@",appFolder];
    NSLog(@"listing files using url %@", url);
    return [NSURL URLWithString:url];
}

+ (NSURL*)uploadURLForPath:(NSString*)path
{
    NSString *urlWithParams = [NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/dropbox/%@/%@",
                               appFolder,
                               [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlWithParams];
    return url;
}

+ (NSURL*)createPhotoUploadURL
{
    NSString *urlWithParams = [NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/dropbox/%@/photos/byteclub_pano_%i.jpg",appFolder,arc4random() % 1000];
    NSURL *url = [NSURL URLWithString:urlWithParams];
    return url;
}



@end
