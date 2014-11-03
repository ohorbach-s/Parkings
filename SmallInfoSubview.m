//
//  SmallDetaiPanel.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SmallInfoSubview.h"
#import "DirectionAndDistance.h"

@interface SmallInfoSubview ()
{
    float longitude;
    float latitude;
    DirectionAndDistance *findTheDirection;
    RoutePoints *routePoints;
}

@end

@implementation SmallInfoSubview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDetail :(NSString*) acceptedName :(float)acceptedLongitude :(float) acceptedLatitude
{
    self.name.text = acceptedName;
    longitude = acceptedLongitude;
    latitude = acceptedLatitude;
}

@end