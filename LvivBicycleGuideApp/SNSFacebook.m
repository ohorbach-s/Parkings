//
//  SNSFacebook.m
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SNSFacebook.h"




@implementation SNSFacebook

-(void)share:(id)sender
{
        DataModel*model=[DataModel sharedModel];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        
        SLComposeViewController* composeController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
              [composeController setInitialText:[NSString stringWithFormat: @"I was here: %@",model.infoForMarker.name]];
        NSURL *url=[NSURL URLWithString:model.infoForMarker.homePage];
        if(url)
            [composeController addURL:url];
      
      //  [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:composeController animated:YES completion:nil];
        [sender presentViewController:composeController animated:YES completion:nil];
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
