//
//  SNSFacebook.m
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SNSFacebook.h"
#import "MapViewController.h"

extern DetailInfoClass *detailInfoForObject;

@implementation SNSFacebook

-(void)shareFacebook{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *composeController=[SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeFacebook];
        composeController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
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
