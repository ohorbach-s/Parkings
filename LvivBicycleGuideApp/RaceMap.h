//
//  RaceViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PathDelegate <NSObject>

-(void)setPath:(NSMutableArray*)encodedPathWithStartPosition :(GMSMarker*)startPosition andEndPosition :(GMSMarker*)endPosition;

@end


@interface RaceMap : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic,weak)id<PathDelegate>pathDelegate;

@end
