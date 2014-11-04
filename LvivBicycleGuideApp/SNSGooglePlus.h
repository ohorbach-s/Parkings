//
//  SNSGooglePlus.h
//  LvivBicycleGuideApp
//
//  Created by Andriy on 11/27/14.
//  Copyright (c) 2014 Sasha Gypsy. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
//#import "SNSNetworksViewController.h"
#import "SNSSocialNetwork.h"
#import "MapViewController.h"

@interface SNSGooglePlus : UIViewController < SNSSocialNetwork>

@property(assign, nonatomic) BOOL authorised;
//@property(weak, nonatomic) SNSNetworksViewController * controller;
@property(weak, nonatomic) GPPSignIn*signIN;
@property(weak, nonatomic) MapViewController *controller;
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error;

@end