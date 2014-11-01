//
//  Spot.m
//  Google Maps iOS Example
//
//  Created by Colin Edwards on 2/1/14.
//
//

#import "Spot.h"

@implementation Spot

-(instancetype) initWithPosition:(CLLocationCoordinate2D)position {
    if(self=[super init])
        self.location = position;
    return self;
}

- (CLLocationCoordinate2D)position {
    return self.location;
}

@end
