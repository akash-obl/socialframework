//
//  FacebookAccountManager.h
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 15/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//
//  This is a singleton designed to managed the Facebook Account.

#import <Foundation/Foundation.h>

@interface FacebookAccountManager : NSObject



@property NSString *facebookAppID; // This is required when using SLRequest and identifies your app. Posts using SLRequest use the Facebook Social Graph and will be identified as "via 'app name'".
@property NSDictionary *facebookOptions; // A dictionary of permissions to request (e.g. to read the users stream) is required for SLRequest.
@property NSArray *facebookPermissions; // An array of permissions.
@property ACAccountStore *facebookAccountStore; // Facebook Account Store.
@property ACAccountType *facebookAccountType;
@property ACAccount *facebookAccount;
@property NSArray *arrayOfAccounts;
@property (readonly, assign) BOOL readPermissionsGranted;
@property (readonly, assign) BOOL publishPermissionsGranted;


+(id)sharedAccount;

-(void)requestPermissions;
-(void)renew;
-(void)revokePermissions;

@end
