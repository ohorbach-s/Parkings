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

//@property (nonatomic, strong) NSMutableArray *selectedPlaces;
@property (nonatomic, strong) PlaceDetailInfo *infoForMarker;
//@property (nonatomic, strong)NSMutableArray *currentCategory;
@property (nonatomic, strong)NSString *deselectedIcon;
@property (nonatomic)NSString *buttonTag;
@property (nonatomic,strong)NSMutableArray *onTags;
@property (nonatomic, strong)NSMutableDictionary *arrangedPlaces;
@property (nonatomic, strong)NSMutableDictionary *arrangedDistances;
@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue;
@property (nonatomic,strong) NSMutableArray *races;

+ (id)sharedModel;
- (id)init;
//-(void) reactToCategorySelection :(NSString*)title;
-(void)buildInfoForMarker: (GMSMarker*)marker;
-(void)findObjectForTappedRow :(PFObject*)chosenPlace;
-(void)changeCategory :(NSInteger)index;
-(void)deselectCategory :(NSInteger)index;

@end
