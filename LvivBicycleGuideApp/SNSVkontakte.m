//
//  SNSVkontakte.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/18/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SNSVkontakte.h"

@implementation SNSVkontakte

-(void)share:(id)sender
{
    DataModel*model=[DataModel sharedModel];
    NSString *homePage=[NSString stringWithString:model.infoForMarker.homePage];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        VKShareDialogController* shareDialog = [VKShareDialogController new];
        if(!homePage){
        shareDialog.text=[NSString stringWithFormat: @"Lviv Bicycle Guide app %@",homePage];
        //        shareDialog.uploadImages = @[[VKUploadImage uploadImageWithImage:[UIImage imageNamed:@"google.png"]  andParams:[VKImageParameters jpegImageWithQuality:0.9]]];
        }else
        {
            shareDialog.text=@"Lviv Bicycle Guide";
        }
        [shareDialog presentIn:sender];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            NSArray* SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
            [VKSdk initializeWithDelegate:sender andAppId:@"4601008"];
            [VKSdk authorize:SCOPE revokeAccess:YES];
            
        });
        
    });
}
@end
