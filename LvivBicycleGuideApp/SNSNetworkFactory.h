//
//  SNSNetworkFactory.h
//  SocialNetworksSharing
//
//  Created by Sasha Gypsy on 06.09.14.
//  Copyright (c) 2014 Sasha Gypsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSSocialNetworkType.h"



@protocol SNSSocialNetwork;

@class SNSNetworksViewController;

@interface SNSNetworkFactory : NSObject

@property(weak, nonatomic) SNSNetworksViewController * controller;

- (id <SNSSocialNetwork>)getNetwork:(SNSSocialNetworkType)type;


//Methods that should be realized by subclass
- (void)share;

@end
