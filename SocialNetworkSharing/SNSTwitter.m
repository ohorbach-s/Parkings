//
//  SNSTwitter.m
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SNSTwitter.h"
#import "MapViewController.h"

extern DetailInfoClass *detailInfoForObject;

@implementation SNSTwitter

-(void)shareTwitter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *composeController=[SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
        composeController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString* txt = [NSString stringWithString:detailInfoForObject.name];
        NSURL *url= [NSURL URLWithString:detailInfoForObject.homePage];
        [composeController setInitialText: txt];
        if(url){
            
            [composeController addURL:url];
        }
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:composeController animated:YES completion:nil];
    }else
    {
        UIAlertView* allertView=[[UIAlertView alloc] initWithTitle:@"Error login accaunt"
                                                           message:@"Please log in"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        [allertView show];
    }
    
}

@end
