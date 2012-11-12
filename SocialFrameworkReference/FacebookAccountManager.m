//
//  FacebookAccountManager.m
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 15/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//

#import "FacebookAccountManager.h"

@implementation FacebookAccountManager

static FacebookAccountManager *sharedAccount = nil;

// Get the shared account manager and create if necessary
+(FacebookAccountManager *)sharedAccount
{
    if (sharedAccount == nil) {
        sharedAccount = [[super allocWithZone:NULL] init];
    }
    return sharedAccount;
}


-(id)init
{
    self = [super init];
    
    if (self) {
        
        if (_facebookAppID == nil) {
            _facebookAppID = [[NSString alloc] init];
        }
        
        if (_facebookOptions == nil) {
            _facebookOptions = [[NSDictionary alloc] init];
        }
        
        if (_facebookPermissions == nil) {
            _facebookPermissions = [[NSArray alloc] init];
        }
       
        if (_facebookAccountStore == nil) {
            _facebookAccountStore = [[ACAccountStore alloc] init];
        }
        
        if (_facebookAccountType == nil) {
            _facebookAccountType = [[ACAccountType alloc] init];
        }
        
        if (_facebookAccount == nil) {
            _facebookAccount = [[ACAccount alloc] init];
        }
        
        _readPermissionsGranted = NO;
        _publishPermissionsGranted = NO;
    }
    
    return self;
}

-(void)renew
{
    [_facebookAccountStore renewCredentialsForAccount:_facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
    {
        if (ACAccountCredentialRenewResultRejected)
        {
            NSLog(@"ACAccountCredentialRenewResultRejected due to error: %@", [error localizedDescription]);
            
            _readPermissionsGranted = NO;
            _publishPermissionsGranted = NO;
        }
        
        if (ACAccountCredentialRenewResultRenewed)
        {
            NSLog(@"Account Credentials Renewed");
            _readPermissionsGranted = YES;
            _publishPermissionsGranted = YES;
        }
        
        if (ACAccountCredentialRenewResultFailed) {
            NSLog(@"Non user initiated cancel of prompt. Will attempt access again.");
            _readPermissionsGranted = NO;
            _publishPermissionsGranted = NO;
            [self requestPermissions];
        }
    }];
}

-(void)revokePermissions
{
    [_facebookAccountStore removeAccount:_facebookAccount withCompletionHandler:^(BOOL success, NSError *error)
    {
        if (error)
        {
            NSLog(@"Revokation Error: %@", [error localizedDescription]);
        }
        _readPermissionsGranted = NO;
        _publishPermissionsGranted = NO;
        
    }];
}


-(void)requestPermissions
{
    // Specify the Facebook App ID.
    _facebookAppID = @"123456789012345"; // You Must Specify Your App ID Here.
                       
    // Submit the first "read" request.
    // Note the format of the facebookOptions dictionary. You are required to pass these three keys: ACFacebookAppIdKey, ACFacebookAudienceKey, and ACFacebookPermissionsKey
    // Specify the read permission
    _facebookPermissions = @[@"read_stream", @"email"];
    
    // Create & populate the dictionary the dictionary
    _facebookOptions = @{   ACFacebookAppIdKey : _facebookAppID,
                         ACFacebookAudienceKey : ACFacebookAudienceFriends,
                      ACFacebookPermissionsKey : _facebookPermissions};
    
    _facebookAccountType = [_facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [_facebookAccountStore requestAccessToAccountsWithType:_facebookAccountType options:_facebookOptions completion:^(BOOL granted, NSError *error)
     {
         // If read permission are granted, we then ask for write permissions
         if (granted) {
             
             _readPermissionsGranted = YES;
             
             // We change the _facebookOptions dictionary to have a publish permission request
             _facebookPermissions =  @[@"publish_stream"];
             
             _facebookOptions = @{         ACFacebookAppIdKey : _facebookAppID,
                                        ACFacebookAudienceKey : ACFacebookAudienceFriends,
                                     ACFacebookPermissionsKey : _facebookPermissions};
             
             
             [_facebookAccountStore requestAccessToAccountsWithType:_facebookAccountType options:_facebookOptions completion:^(BOOL granted2, NSError *error)
              {
                  if (granted2)
                  {
                      _publishPermissionsGranted = YES;
                      // Create the facebook account
                      _facebookAccount = [[ACAccount alloc] initWithAccountType:_facebookAccountType];
                      _arrayOfAccounts = [_facebookAccountStore accountsWithAccountType:_facebookAccountType];
                      _facebookAccount = [_arrayOfAccounts lastObject];
                  }
                  
                  // If permissions are not granted to publish.
                  if (!granted2)
                  {
                      NSLog(@"Publish permission error: %@", [error localizedDescription]);
                      _publishPermissionsGranted = NO;
                  }
                  
              }];
         }
         
         // If permission are not granted to read.
         if (!granted)
         {
             NSLog(@"Read permission error: %@", [error localizedDescription]);
             _readPermissionsGranted = NO;
             
             if ([[error localizedDescription] isEqualToString:@"The operation couldn’t be completed. (com.apple.accounts error 6.)"])
             {
                 [self performSelectorOnMainThread:@selector(showError) withObject:error waitUntilDone:NO];
             }
         }
     }];
}

-(void)showError
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Account Required" message:@"You need to setup a Facebook account within the Settings app." delegate:nil cancelButtonTitle:@"Ok." otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}


@end
