//
//  SecondViewController.m
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 07/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//
//  This view controller looks after the Facebook methods.
//  Be sure to read the API documents provided by Apple in relation to Facebook - http://developer.apple.com

#import "SecondViewController.h"
#import "FacebookAccountManager.h"

@interface SecondViewController ()

// Decalare private ivars/properties

@property NSString *errorString;
@property IBOutlet UILabel *errorLabel; // If there are any errors in the requests, we use the label to communicate them.
@property IBOutlet UIBarButtonItem *permissionsButton;

@end

@implementation SecondViewController


// IGNORE
-(void)stub
{
    // Ignore
    // This is here to ensure pragma marks are displayed correctly in the navigator.
}

#pragma
#pragma mark - Part 1. Loading and Customising the View
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Reset the error label
    [_errorLabel setText:@"Errors will appear here."];
    
    FacebookAccountManager* sharedManager = [FacebookAccountManager sharedAccount];
    
    if (sharedManager.publishPermissionsGranted) {
        [_permissionsButton setTintColor:[UIColor greenColor]];
    }
    
    if (!sharedManager.publishPermissionsGranted) {
        [_permissionsButton setTintColor:[UIColor redColor]];
    }
}


#pragma
#pragma mark - Part 3. Basic Posting With SLComposeViewController
// Unlike SLRequest, all posts with SLComposeViewController are displayed on Facebook as "via iOS"

// Method 1. Creating a Facebook Post with Text Only
-(IBAction)postWithTextOnly:(id)sender
{
    // Create an SLComposeViewController (the Facebook post sheet)
    SLComposeViewController *fbPostWithTextOnly = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    // Set the initial text of the post
    [fbPostWithTextOnly setInitialText:@"This is test post with text only"];
    
    // Display the post sheet
    [self presentViewController:fbPostWithTextOnly animated:YES completion:nil];
    
    // Tidy Up
    fbPostWithTextOnly = nil;
}

// Method 2. Creating a Facebook Post with an Image Only
-(IBAction)postWithImageOnly:(id)sender
{
    // Create an SLComposeViewController (the Facebook post sheet)
    SLComposeViewController *fbPostWithImageOnly = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    // Set the image of the post
    [fbPostWithImageOnly addImage:[UIImage imageNamed:@"449-sdk1@2x.png"]];
    
    // Show the post sheet
    [self presentViewController:fbPostWithImageOnly animated:YES completion:nil];
    
    // Tidy up
    fbPostWithImageOnly = nil;
}

// Method 3. Creating a Facebook Post with text and an image
-(IBAction)postWithTextAndImage:(id)sender
{
    // Check if we can send a Facebook Post
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        // Create an SLComposeViewController (the Facebook post sheet)
        SLComposeViewController *fbPostWithTextAndImage = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // Set the Text of the Post
        [fbPostWithTextAndImage setInitialText:@"This is a post with image and text."];
        
        // Add an image to the Post
        [fbPostWithTextAndImage addImage:[UIImage imageNamed:@"449-sdk1@2x.png"]];
                
        // Show the post sheet
        [self presentViewController:fbPostWithTextAndImage animated:YES completion:nil];
        
        // Tidy Up
        fbPostWithTextAndImage = nil;
    }
    
    else
    {
        [self performSelectorOnMainThread:@selector(showError) withObject:nil waitUntilDone:NO];
    }
}

-(void)showError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Post" message:@"Make Sure A Facebook Has Been Setup" delegate:nil cancelButtonTitle:@"Ok." otherButtonTitles:nil, nil];
    
    [alert show];
    alert = nil;
}


#pragma
#pragma mark - Part 4. Using SLRequest To Post Or Retrieve Information
// SLRequest will allow you to both obtain and post information to Facebook. Posts via SLRequest are displayed with "via <your app name>" and SLRequest uses the Social Graph.
// The relevant end-points are documented at https://developers.facebook.com/docs/reference/api/
// Facebook responses are in a JSON format.

// Method 4. Retrieving The User's Facebook Wall Posts - See Methods in FacebookWallViewController
// Method 5. Get The User's Friends List - See Methods in FacebookDetailViewController

// Method 6. Post a multipart message.
// Have a look at the 'Components of a Facebook Post' section of the Tutorial.
-(IBAction)postMessage:(id)sender
{
    // Create the URL to the end point
    NSURL *postURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    
    NSString *link = [[NSString alloc] init];
    NSString *message = [[NSString alloc] init];
    NSString *picture = [[NSString alloc] init];
    NSString *name = [[NSString alloc] init];
    NSString *caption = [[NSString alloc] init];
    NSString *description = [[NSString alloc] init];
    
    link = @"http://developer.apple.com/library/ios/#documentation/Social/Reference/Social_Framework/_index.html%23//apple_ref/doc/uid/TP40012233";
    message = @"Testing Social Framework";
    picture = @"http://www.stuarticus.com/wp-content/uploads/2012/08/SDKsmall.png";
    name = @"Social Framework";
    caption = @"Reference Documentation";
    description = @"The Social framework lets you integrate your app with supported social networking services. On iOS and OS X, this framework provides a template for creating HTTP requests. On iOS only, the Social framework provides a generalized interface for posting requests on behalf of the user.";
    
    NSDictionary *postDict = @{
    @"link": link,
    @"message" : message,
    @"picture" : picture,
    @"name" : name,
    @"caption" : caption,
    @"description" : description
    };
    
    SLRequest *postToMyWall = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:postURL parameters:postDict];

    FacebookAccountManager* sharedManager = [FacebookAccountManager sharedAccount];
    [postToMyWall setAccount:sharedManager.facebookAccount];
    
    [postToMyWall performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if (error) {
            // If there is an error we populate the error string with error
            _errorString = [NSString stringWithFormat:@"%@", [error localizedDescription]];
            
            // We then perform the UI update on the main thread. All UI updates must be completed on the main thread.
            [self performSelectorOnMainThread:@selector(updateErrorString) withObject:nil waitUntilDone:NO];
        }
        
        else
        {
            NSLog(@"Post successful");
            NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSStringEncodingConversionAllowLossy];
            NSLog(@"Response Data: %@", dataString);
        }
     }];
    
    // Tidy Up
    link = nil;
    message = nil;
    picture = nil;
    name = nil;
    caption = nil;
    description = nil;
    postDict = nil;
    postToMyWall = nil;
    postURL = nil;
    
}

// Request Permissions on Tab Bar
-(IBAction)requestPermissions:(id)sender
{
    FacebookAccountManager* sharedManager = [FacebookAccountManager sharedAccount];
    
    if ([sharedManager publishPermissionsGranted] == NO)
    {
        NSLog(@"Renew");
        [sharedManager renew];
        if ([sharedManager publishPermissionsGranted] == YES) {
            [_permissionsButton setTintColor:[UIColor greenColor]];
        }
    }
}

-(void)updateErrorString
{
    [_errorLabel setText:_errorString];
}


#pragma
#pragma mark - Memory Warnings
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
