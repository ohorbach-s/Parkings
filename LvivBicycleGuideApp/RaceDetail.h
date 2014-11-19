//
//  RaceDetail.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceDetail : NSObject
@property(nonatomic, strong)NSString *place;
@property(nonatomic, strong)NSString *date;
@property(nonatomic, strong)NSString *time;
@property(nonatomic, strong)NSMutableArray *arrayOfPath;
@property (nonatomic)float startLatitude;
@property (nonatomic)float startLongitude;
@property (nonatomic)float endLatitude;
@property (nonatomic)float endLongitude;
@property (nonatomic)BOOL selectedToParticipate;
@end
