//
//  DetailInfoClass.m
//  MapsDirections
//
//  Created by Yuliia on 10/21/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "DetailInfoClass.h"

@interface DetailInfoClass () {

}

@end

@implementation DetailInfoClass


//-(void)setDetailInfoForTappedMarker: (CLLocationCoordinate2D) position
//{
//
//    for (PFObject *object in dataModel.foundObjects) {
//        if (([object[@"longitude"] floatValue] == position.latitude) && ([object[@"latitude"] floatValue] == position.longitude)) {
//            
//            _name = object[@"name"];
//            _address = object[@"address"];
//            _longtitude = object[@"longitude"];
//            _latitude = object[@"latitude"];
//            _workTime = object[@"workTime"];
//            _phone = object[@"phone"];
//            _homePage = object[@"homePage"];
//            _description = [NSString stringWithFormat:@"%@\n %@\n %@\n %@", object[@"description"], object[@"workTime"], object[@"phone"], object[@"homePage"]];
//            _type = object[@"type"];
//        }
//    }
//}

-(void)setDetailInfoForTappedRow: (PFObject*) chosenPlace
{
    _name = chosenPlace[@"name"];
    _address = chosenPlace[@"address"];
    _longtitude = chosenPlace[@"longitude"];
    _latitude = chosenPlace[@"latitude"];
    _workTime = chosenPlace[@"workTime"];
    _phone = chosenPlace[@"phone"];
    _homePage = chosenPlace[@"homePage"];
    _description = [NSString stringWithFormat:@"%@\n %@\n %@\n %@", chosenPlace[@"description"], chosenPlace[@"workTime"], chosenPlace[@"phone"], chosenPlace[@"homePage"]];
    _type = chosenPlace[@"type"];

}

//-(void)setObservingForTappedMarker {
//        [controller addObserver:self forKeyPath:@"markerPosition"
//                                                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    
//}
//
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                       change:(NSDictionary *)change context:(void *)context {
//       if ([keyPath isEqualToString:@"markerPosition"]) {
//           [self setDetailInfoForTappedMarker:[object markerPosition]];
//           [[NSNotificationCenter defaultCenter] postNotificationName:@"renewDataOfSubview"object:nil];
//
//           
//    }
//    
//}


@end
