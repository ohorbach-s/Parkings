//
//  SmallDetaiPanel.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SmallDetaiPanel.h"
#import "DirectionAndDistance.h"
extern GMSMarker *myMarker;

@interface SmallDetaiPanel (){

    float longitude;
    float latitude;
    DirectionAndDistance *findTheDirection;
    MapSingletone *mapSingletone;
   //int trackTapps;
}

@end

@implementation SmallDetaiPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setDetail :(NSString*) acceptedName :(float)lon :(float) lat{
    self.nameLabel.text = acceptedName;
    longitude = lon;
    latitude = lat;
}



//- (IBAction)pressRouteButton:(id)sender {
//    
//    if (trackTapps == 0) {
//        mapSingletone = [MapSingletone sharedManager];
//        [UIView animateWithDuration:1
//                         animations:^{
//                         }
//                         completion:^(BOOL finished) {
//                             _routeButton.highlighted = true;
//                             _routeButton.selected = true;
//                         }
//         ];
//        trackTapps ++;
//        DirectionAndDistance *findTheDirection = [[DirectionAndDistance alloc] init];
//        [findTheDirection buildTheRouteAndSetTheDistance:longitude :latitude :^(NSString* theDistance) {
//            self.distanceLabel.text = theDistance;
//            [mapSingletone.waypoints_ removeObject:[mapSingletone.waypoints_ lastObject]];
//            [mapSingletone.waypointStrings_ removeObject:[mapSingletone.waypointStrings_ lastObject]];
//            CLLocationCoordinate2D boundLocation = CLLocationCoordinate2DMake(latitude,longitude);
//            
//            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
//            bounds = [bounds includingCoordinate:myMarker.position];
//            bounds = [bounds includingCoordinate:boundLocation];
//            [mapSingletone.mapView_ animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
//        }];
//    } else {
//        trackTapps--;
//        mapSingletone.polyline.map = nil;
//        mapSingletone.polyline = nil;
//        
//        _routeButton.highlighted = false;
//        _routeButton.selected = false;
//    }
//    
//}

@end
