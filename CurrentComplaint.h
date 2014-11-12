//
//  CurrentComplaint.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/10/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDetailInfo.h"

@interface CurrentComplaint : NSObject

@property (nonatomic,strong)NSString *complaintSubject;
@property (nonatomic,strong)NSString *complaintDescription;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BOOL likeDislike;

@end
