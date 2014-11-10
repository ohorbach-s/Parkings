//
//  SlideMenuControllerViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/7/14.
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
-(void)cleanDeselectedCategory :(NSString*)buttonTag;

@end

@protocol ChangeCategory <NSObject>

-(void)changeCategory :(NSInteger)index;

@end

//@protocol CleanMarkersDelegate <NSObject>
//
//-(void)cleanDeselectedCategory :(NSString*)buttonTag;
//
//@end

@interface SlideMenuControllerViewController : UIViewController
@property (strong,nonatomic)NSString *markerIcon;
@property (strong, nonatomic)NSString *category;

@property (weak, nonatomic) IBOutlet UIButton *parkingButton;
@property (weak, nonatomic) IBOutlet UIButton *supermarketsButton;
@property (weak, nonatomic) IBOutlet UIButton *cafeButton;

@property (weak, nonatomic) IBOutlet UIButton *shopsButton;

@property (weak, nonatomic) IBOutlet UIButton *complaintButton;
@property (weak, nonatomic) IBOutlet UIButton *stolenButton;
@property (weak, nonatomic) IBOutlet UIButton *rentalButton;
@property (weak, nonatomic) IBOutlet UIView *viewLower;

@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic)id<CleanPolylineDelegate>cleanPolylineDelegate;
@property (weak, nonatomic)id<ChangeCategory>changeCategoryDelegate;
//@property (weak, nonatomic)id<CleanMarkersDelegate>cleanMarkersDelegate;


@end
