//
//  SecondViewController.h
//  SocialFrameworkReference
//
//  Created by Stuart G Breckenridge on 07/10/2012.
//  Copyright (c) 2012 Stuart G Breckenridge. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController

@property (readonly) NSArray *friends; // This array is used to store the user's list of friends.
@property (readonly) ACAccount *facebookAccount; // Facebook Account
@property ACAccountType *facebookAccountType; // Facbook Account Type.
@property (nonatomic, strong) NSArray *arrayOfAccounts; // Array of accounts...note: only one Facebook account is supported in iOS 6.

@end
