//
//  SlideMenuViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "PlaceCategory.h"
#import "RoutePoints.h"
//#import "DataModel.h"

@protocol CleanPolylineDelegate <NSObject>

-(void)cleanPolylineFromMap;

@end

@interface SlideMenuViewController : UITableViewController

@property (strong,nonatomic)NSString *markerIcon;
@property (strong, nonatomic)NSString *category;
@property (strong, nonatomic)id<CleanPolylineDelegate>cleanPolylineDelegate;

-(void)setIndexValueWithCompletion :(void(^)(NSInteger))completion;

@end
