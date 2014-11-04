//
//  SNSNetworkFactory.m
//  SocialNetworksSharing
//
//  Created by Sasha Gypsy on 06.09.14.
//  Copyright (c) 2014 Sasha Gypsy. All rights reserved.
//

#import "SNSNetworkFactory.h"
//#import "SNSNetworksViewController.h"
#import "SNSFacebook.h"
#import "SNSTwitter.h"
//#import "SLVLinkedInApi.h"

#import "SNSGooglePlus.h"
//#import "SNSLinkedInShare.h"

@implementation SNSNetworkFactory

-(id) getNetwork:(SNSSocialNetworkType) type
{
    
    switch (type)
    {
        case SNSSocialNetworkTypeFacebook:
            return [[SNSFacebook alloc]  init];
            break;
               case SNSSocialNetworkTypeTwitter:
            return [[SNSTwitter alloc]init];
            break;
        case SNSSocialNetworkTypeVkontakte:
       //     return [[SNSVkontakteApi alloc]init];
            break;
        case SNSSocialNetworkTypeGooglePlus:
            return [[SNSGooglePlus alloc] init];
            break;
    }
    return nil;
} 

-(void) share
{
}

@end
