//
//  SNSTwitter.m
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SNSTwitter.h"


@implementation SNSTwitter

-(void)share
{     DataModel*model=[DataModel sharedModel];
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
       SLComposeViewController* composeController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSURL *url=[NSURL URLWithString:model.infoForMarker.homePage];
        if(url)
            [composeController addURL:url];        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:composeController animated:YES completion:nil];
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
