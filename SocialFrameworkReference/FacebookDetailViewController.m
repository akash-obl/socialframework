//
//  FacebookDetailViewController.m
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 14/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//

#import "FacebookDetailViewController.h"

@interface FacebookDetailViewController ()

@property NSArray *dataArray; // We store the data from the Facebook response in this array.
@property NSString *errorString;

@end

@implementation FacebookDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFriendsList];
}



-(void)getFriendsList
{
    // Create the URL to the end point
    NSURL *friendsList = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    
    // Create the SLReqeust
    SLRequest *getFriends = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:friendsList parameters:nil];

    // Create a reference to the shared facebook account
    FacebookAccountManager* sharedManager = [FacebookAccountManager sharedAccount];
    // Set the account
    [getFriends setAccount:sharedManager.facebookAccount];
    
    // Perform the request
    [getFriends performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error)
        {
            // If there is an error we populate the error string with error
            _errorString = [NSString stringWithFormat:@"%@", [error localizedDescription]];
            NSLog(@"Error: %@", _errorString);
        } else
        {
            NSLog(@"HTTP Response: %i", [urlResponse statusCode]);
            // The output of the request is placed in the log.
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            
            _dataArray = [[jsonResponse objectForKey:@"data"] valueForKey:@"name"];
            
            [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:YES];
            // Tidy Up
            jsonResponse = nil;
        }
    }];
    
    // Tidy Up
    getFriends = nil;
    friendsList = nil;
}

-(void)refresh
{
    // Sort the array alphabetically
    NSMutableArray *sortedFriends  = [[NSMutableArray alloc] initWithArray:_dataArray];
    [sortedFriends sortUsingSelector:@selector(caseInsensitiveCompare:)];
    _dataArray = [sortedFriends copy];
    sortedFriends = nil;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        // Configure the cell...
    [[cell textLabel] setText:[_dataArray objectAtIndex:indexPath.row]];
    [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
