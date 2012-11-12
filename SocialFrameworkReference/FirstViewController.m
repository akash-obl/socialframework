//
//  FirstViewController.m
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 07/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//
//  This view controller looks after all the Twitter methods
//  Be sure to read the following Twitter API documentation https://dev.twitter.com/docs/api/1.1



#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

#pragma
#pragma mark - Methods

#pragma
#pragma mark - Loading of the View

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma
#pragma mark - Posting Methods using the Tweet Sheet/SLComposeViewController

// Method 1: Posting Text Only using the Tweet Sheet
- (IBAction)postTextOnly:(id)sender
{
    // Create a compose view controller for the service type Twitter
    SLComposeViewController *postText = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    // Set the text of the tweet
    // If you want to use a user derived tweet string you could, for example, create an editable UITextfield and access the _textfield.text property. 
    [postText setInitialText:@"This is test tweet with text only."];
    
    // Display the tweet sheet to the user
    [self presentViewController:postText animated:YES completion:nil];
    
    // Tidy up
    postText = nil;
}

// Method 2: Posting Image Only using the Tweet Sheet
- (IBAction)postImageOnly:(id)sender
{
    // Create a compose view controller for the service type Twitter.
    SLComposeViewController *postImageOnly = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    // Create the image to post with the tweet
    UIImage *imageToTweet = [UIImage imageNamed:@"twitter"];
    
    // Add the image to the Tweet
    [postImageOnly addImage:imageToTweet];
    
    // Display the tweet sheet to the user
    [self presentViewController:postImageOnly animated:YES completion:nil];
    
    // Tidy up
    postImageOnly = nil;
    imageToTweet = nil;
}

// Method 3: Posting Text And Image using the Tweet Sheet
- (IBAction)multipartPost:(id)sender
{
    // Create a compose view controller for the service type Twitter
    SLComposeViewController *mulitpartPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    // Set the text of the tweet
    [mulitpartPost setInitialText:@"This is a test tweet with text and an image"];
    
    // Create the image to post with the tweet
    UIImage *imageToTweet = [UIImage imageNamed:@"twitter"];
    
    // Add the image to the tweet
    [mulitpartPost addImage:imageToTweet];
    
    // Display the tweet sheet to the user
    [self presentViewController:mulitpartPost animated:YES completion:nil];
    
    // Tidy up
    mulitpartPost = nil;
    imageToTweet = nil;
}

#pragma
#pragma mark - Retrieval Methods using SLRequest

// Method 4: Retrieving The User's Home Timeline. This uses v1.1 of the Twitter API. The v1.1 API link is included but commented out. 
- (IBAction)retrieveTweets:(id)sender
{
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    
    // Create an account type
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error)
      {
          if (granted)
          {
              // Create an Account
              ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
              NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
              twAccount = [accounts lastObject];
              
              
              // Version 1.1 of the Twitter API only supports JSON responses.
              // Create an NSURL instance variable that points to the home_timeline end point.
              NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
              
              
              // Version 1.0 of the Twiter API supports XML responses.
              // Use this URL if you want to see an XML response.
              //NSURL *twitterURL2 = [[NSURL alloc] initWithString:@"http://api.twitter.com/1/statuses/home_timeline.xml"];
            
               
              // Create a request 
              SLRequest *requestUsersTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                 requestMethod:SLRequestMethodGET
                                                                           URL:twitterURL
                                                                    parameters:nil];
              
              // Set the account to be used with the request
              [requestUsersTweets setAccount:twAccount];
              
              // Perform the request
              [requestUsersTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2)
              {
                  // The output of the request is placed in the log.
                  NSLog(@"HTTP Response: %i", [urlResponse statusCode]);
                  // The output of the request is placed in the log.
                  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                  
                  NSLog(@"%@", jsonResponse);
                  
              }];
              
              // Tidy Up
              twAccount = nil;
              accounts = nil;
              twitterURL = nil;
              requestUsersTweets = nil;
          }
          
          // If permission is not granted to use the Twitter account...
          
          else
              
          {
              NSLog(@"Permission Not Granted");
              NSLog(@"Error: %@", error);
          }
      }];
    
    // Tidy up
    twitter = nil;
    twAccountType = nil;
}

// Method 5: Retrieving The User's Favourites. This uses v1.1 of the Twitter API. 
- (IBAction)retrieveFavourties:(id)sender
{
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    
    // Create an account type
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // Create an Account
             ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
             NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
             twAccount = [accounts lastObject];
             
             
              // Version 1.1 of the Twitter API only supports JSON responses.
              // Create an NSURL instance variable that points to the DMs end point.
              NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/favorites/list.json"];
             
             
             // Create a request
             SLRequest *requestUsersFavourites = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                requestMethod:SLRequestMethodGET
                                                                          URL:twitterURL
                                                                   parameters:nil];
             
             // Set the account to be used with the request
             [requestUsersFavourites setAccount:twAccount];
             
             // Perform the request
             [requestUsersFavourites performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2)
              {
                  // The output of the request is placed in the log. 
                  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                  NSLog(@"%@", jsonResponse);
                  
                  // Tidy Up
                  jsonResponse = nil;
              }];
             
             
             // Tidy Up
             twAccount = nil;
             accounts = nil;
             twitterURL = nil;
             requestUsersFavourites = nil;
         }
         
         // If permission is not granted to use the Twitter account...
         
         else
             
         {
             NSLog(@"Permission Not Granted");
             NSLog(@"Error: %@", error);
         }
     }];
    
    // Tidy up
    twitter = nil;
    twAccountType = nil;
}

// Method 6: Retrieving The Suggested Users. This uses v1.1 of the Twitter API.
- (IBAction)retrieveSuggestedUsers:(id)sender
{
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    
    // Create an account type
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // Create an Account
             ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
             NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
             twAccount = [accounts lastObject];
             
             // Version 1.1 of the Twitter API only supports JSON responses.
             // Create an NSURL instance variable that points to the Suggested Users end point.
             NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/users/suggestions.json"];
             
             
             // Create a request
             SLRequest *requestSuggestedUsers = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                    requestMethod:SLRequestMethodGET
                                                                              URL:twitterURL
                                                                       parameters:nil];
             
             // Set the account to be used with the request
             [requestSuggestedUsers setAccount:twAccount];
             
             // Perform the request
             [requestSuggestedUsers performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2)
              {
                  // The output of the request is placed in the log.
                  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                  NSLog(@"%@", jsonResponse);
                  
                  // Tidy Up
                  jsonResponse = nil;
              }];
             
             
             // Tidy Up
             twAccount = nil;
             accounts = nil;
             twitterURL = nil;
             requestSuggestedUsers = nil;
         }
         
         // If permission is not granted to use the Twitter account...
         
         else
             
         {
             NSLog(@"Permission Not Granted");
             NSLog(@"Error: %@", [error localizedDescription]);
         }
     }];
    
    // Tidy up
    twitter = nil;
    twAccountType = nil;
}


#pragma
#pragma mark - Memory Warnings

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
