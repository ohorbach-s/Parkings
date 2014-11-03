//
//  SNSFacebook.h
//  LvivBicycleGuideApp
//
//  Created by Andriy on 10/27/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "PlaceDetailInfo.h"

@interface SNSFacebook : NSObject

-(void)shareFacebook:(PlaceDetailInfo*)detailInfo;

@end
