//
//  SNSGooglePlus.m
//  LvivBicycleGuideApp
//
//  Created by Andriy on 11/27/14.
//  Copyright (c) 2014 Sasha Gypsy. All rights reserved.
//

#import "SNSGooglePlus.h"
//#import "SNSPostData.h"
//#import "SNSAppDelegate.h"
#import "AppDelegate.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GTLPlusConstants.h>

@interface SNSGooglePlus() <GPPSignInDelegate, GPPShareDelegate>

@end
//#define GOOGLE_PLUS_CLIEND_ID 321900712972-gak9tlla42nd2bu3gbk68ebh9rh09up1.apps.googleusercontent.com"

@implementation SNSGooglePlus

static NSString * const kClientId = @"597787714490-5ja44i80t83qaut0cop24ur15a3q8b78.apps.googleusercontent.com";


- (void)SignInButtonSimulated
{
    self.signIN = [GPPSignIn sharedInstance];
    
    self.signIN.delegate=self;
    self.signIN.shouldFetchGooglePlusUser = YES;
    self.signIN.shouldFetchGoogleUserEmail = YES;
    self.signIN.scopes = @[ kGTLAuthScopePlusLogin ];
    self.signIN.clientID = kClientId;
    
    [self.signIN authenticate];

}

- (void)didReceiveMemoryWarning
{
    [self didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        
    } else {
        NSLog(@"%@ %@",[GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID);
        
        [self Share];
        self.authorised = TRUE;
    }
}

// Share Code



- (void) share {
       // NSLog(@"in share %@",self);
    if(!self.authorised)
    {
        NSLog(@"before call SignInButtonSimulated %@",self);
        [self SignInButtonSimulated];
        NSLog(@"after call SignInButtonSimulated %@",self);
     
        {
            NSLog(@"BAD day");
        }
        

    }
    else
//        
//        NSLog(@"BEGIN SHARING");
       [self Share];
}


// For Signout USe this code
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

// Disconnet User
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        NSLog(@"Ok");
    }
}

-(void)Share
{
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [GPPShare sharedInstance].delegate = self;
    [shareBuilder open];
}

- (void)finishedSharing:(BOOL)shared;
{
    if(shared)
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
}

@end
