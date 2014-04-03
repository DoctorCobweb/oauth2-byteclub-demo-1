//
//  AppDelegate.m
//  ByteClub
//
//  Created by Charlie Fulton on 7/24/13.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "AppDelegate.h"
#import "Dropbox.h"
#import "OAuthLoginViewController.h"
#import "NationBuilder.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initAppearance];
    
    //enable afnetworking to show spinner in top bar
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    
    
    NSString *controllerId = token ? @"TabBar" : @"Login";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    // always assumes token is valid - should probably check in a real app
    if (token) {
        [self.window setRootViewController:initViewController];
    } else {
        [(UINavigationController *)self.window.rootViewController pushViewController:initViewController animated:NO];
    }
    return YES;
}

- (void)initAppearance
{
    UIColor * theGreens = [UIColor colorWithRed:107/255.0f green:203/255.0f blue:64/255.0f alpha:1.0f];
    // Set appearance info
    [[UITabBar appearance] setBarTintColor:theGreens];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:theGreens];
    
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UIToolbar appearance] setBarTintColor:theGreens];

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - OAuth login flow and url scheme handling
// this method is invoked as a result of the heroku hosted 'cryptic-tundra-9564'
// app redirecting backing this app, all inside the mobile safari browser.
// had to use an external heroku app in order to get the code=... vale returned from
// nationbuilder to a VALIDE redirect_uri. i.e. nation builder does not allow for
// redirect_uris other than https for the uri scheme! => cannot use leadorganizerapp as
// scheme directly during oauth2 but instead need a hack like this redirect heroku app!
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    NSLog(@"IN APP DELEGATE AND CHECKING SCHEME");
    if ([[url scheme] isEqualToString:@"leadorganizerapp"]) {
        NSLog(@"sourceApplication: %@", sourceApplication);
        NSLog(@"annotation: %@", annotation);
        NSLog(@"url: %@", url);
        
        //need to put code=.... value into UserDefaults for later OAuth2 process
        NSString * queryString = [url query];
        NSLog(@"query string of url: %@", queryString);
        
        NSArray *tokens = [queryString componentsSeparatedByString:@"&"];
        NSLog(@"%@", tokens);
        NSMutableDictionary *oAuth2Dict = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        for(NSString *t in tokens) {
            NSArray *entry = [t componentsSeparatedByString:@"="];
            NSString *key = entry[0];
            NSString *val = entry[1];
            [oAuth2Dict setValue:val forKey:key];
        }
        
        NSDictionary * params = [NSDictionary dictionaryWithDictionary:oAuth2Dict];
        NSLog(@"params dic: %@", params);
        
        //put code key/val into UserDefaults obj
        [[NSUserDefaults standardUserDefaults] setObject:oAuth2Dict[@"code"] forKey:@"code"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self exchangeRequestTokenForAccessToken];
    }
    return NO;
}

- (void)exchangeRequestTokenForAccessToken
{
    // OAUTH Step 2 - exchange request token for user access token
    [NationBuilder exchangeTokenForUserAccessTokenURLWithCompletionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            
            NSLog(@"token response: %@", httpResp);
            if (httpResp.statusCode == 200) {
                NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSError *error;
                NSDictionary *dict_resp = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&error];
                NSLog(@"dict_resp[access_token]: %@",[dict_resp objectForKey:@"access_token"]);
                
                //response is JSON format
                NSLog(@"response: %@",response);
                
        
                //put code key/val into UserDefaults obj
                [[NSUserDefaults standardUserDefaults] setObject:dict_resp[@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
                NSLog(@"TOKEN FROM UserDefaults: %@", token);
                
                // now load main part of application
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    NSString *segueId = @"TabBar";
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UITabBarController *initViewController = [storyboard instantiateViewControllerWithIdentifier:segueId];
                    
                    UINavigationController *nav = (UINavigationController *) self.window.rootViewController;
                    nav.navigationBar.hidden = YES;
                    [nav pushViewController:initViewController animated:NO];
                });
                
            } else {
                // HANDLE BAD RESPONSE //
                NSLog(@"exchange request for access token unexpected response %@",
                      [NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode]);
            }
        } else {
            // ALWAYS HANDLE ERRORS :-] //
            NSLog(@"ERROR in app delegate.m exchangeRequestTokenForAccessToken method");
        }
    }];
}

@end
