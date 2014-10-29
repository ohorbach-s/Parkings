//
//  SNSTwitter.h
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "DetailInfoClass.h"

@interface SNSTwitter : NSObject
-(void)shareTwitter:(DetailInfoClass *)detailInfo;

@end
