//
//  DataModel.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/30/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PlaceCategory.h"

@class PlaceDetailInfo;

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *selectedPlaces;
@property (nonatomic, strong) PlaceDetailInfo *infoForMarker;
@property (nonatomic, strong)PlaceCategory *currentCategory;

+ (id)sharedModel;
- (id)init;
-(void) reactToCategorySelection :(NSString*)title;
-(void)buildInfoForMarker: (GMSMarker*)marker;
-(void)findObjectForTappedRow :(NSInteger)indexOfRow;


-(void)changeCategory :(NSInteger)index;

@end
