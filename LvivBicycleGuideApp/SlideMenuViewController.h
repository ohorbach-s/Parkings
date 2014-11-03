//
//  SlideMenuViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "PlaceCategories.h"
#import "RoutePoints.h"
#import "PlaceCategory.h"
#import "DataModel.h"

@protocol CleanPolylineDelegate <NSObject>

-(void)cleanPolylineFromMap;

@end

@protocol ChangeCategory <NSObject>

-(void)changeCategory :(NSInteger)index;

@end

@interface SlideMenuViewController : UITableViewController

@property (strong,nonatomic)NSString *markerIcon;
@property (strong, nonatomic)NSString *category;

@property (weak, nonatomic)id<CleanPolylineDelegate>cleanPolylineDelegate;
@property (weak, nonatomic)id<ChangeCategory>changeCategoryDelegate;

-(void)setIndexValueWithCompletion :(void(^)(NSInteger))completion;

@end
