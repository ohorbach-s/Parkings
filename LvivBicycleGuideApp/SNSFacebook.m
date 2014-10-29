//
//  SNSFacebook.m
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SNSFacebook.h"
#import "MapViewController.h"


@implementation SNSFacebook

-(void)shareFacebook:(DetailInfoClass *)detailInfo{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *composeController=[SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeFacebook];
        composeController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString* txt = [NSString stringWithString:detailInfo.name];
        NSURL *url= [NSURL URLWithString:detailInfo.homePage];
        [composeController setInitialText: txt];
        if(url){
            
            [composeController addURL:url];
        }
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:composeController animated:YES completion:nil];
    }else
    {
        UIAlertView* allertView=[[UIAlertView alloc] initWithTitle:@"Error login accaunt"
                                                           message:@"Please log in"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        [allertView show];
    }
}
@end
