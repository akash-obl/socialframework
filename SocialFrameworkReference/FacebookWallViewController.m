//
//  FacebookWallViewController.m
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 15/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//

#import "FacebookWallViewController.h"

@interface FacebookWallViewController ()

@property NSMutableArray *statuses;
@property NSMutableArray *statusAuthors;
@property NSMutableArray *statusesMutable;
@property NSMutableArray *authorsMutable;

@end

@implementation FacebookWallViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFacebookWall];
}


-(void)getFacebookWall
{    
    // Create the URL to the end-point
    NSURL *newsFeed = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    
    // Create an SLRequest
    SLRequest *retriveWall = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:newsFeed parameters:nil];
    
    FacebookAccountManager* sharedManager = [FacebookAccountManager sharedAccount];
    // Set the account to use
    
    if (sharedManager.publishPermissionsGranted == NO)
    {
        NSLog(@"Publish Permissions Have Not Been Granted");
    }
    
    else
    {
    [retriveWall setAccount:sharedManager.facebookAccount];
    
    
    // Perform the request
    [retriveWall performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error: %@", [error localizedDescription]);
         }
         
         else
         {
             // The output of the request is placed in the log.
             NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
             NSLog(@"JSON Response: %@", jsonResponse);
             
             _statuses = [[jsonResponse objectForKey:@"data"] valueForKey:@"message"];
             _statusAuthors = [[[jsonResponse objectForKey:@"data"] valueForKey:@"from"] valueForKey:@"name"];
             
             _statusesMutable = [[NSMutableArray alloc] init];
             _authorsMutable = [[NSMutableArray alloc] init];
             
             
             for(int i=0;i<[_statuses count]; i++)
             {
                 if([_statuses objectAtIndex:i] != [NSNull null])
                 {
                    [_statusesMutable addObject:[_statuses objectAtIndex:i]];
                    [_authorsMutable addObject:[_statusAuthors objectAtIndex:i]];
                 }
             }
             
             NSLog(@"Statuses: %@", _statusesMutable);
             NSLog(@"Authors: %@", _authorsMutable);
             
             [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
             
             // Tidy Up
             jsonResponse = nil;
         }
         
     }];
    }
    
    // Tidy Up
    retriveWall = nil;
    newsFeed = nil;
}

-(void)refresh
{
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
    return [_statusesMutable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    //NSString *stringToCheck = (NSString *)[_statuses objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[_statusesMutable objectAtIndex:indexPath.row]];
    [[cell detailTextLabel] setText:[_authorsMutable objectAtIndex:indexPath.row]];
    
    
    [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [[cell textLabel] setNumberOfLines:3];
    [[cell detailTextLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
