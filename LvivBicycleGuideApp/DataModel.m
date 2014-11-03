//
//  DataModel.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/30/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DataModel.h"
#import "PlaceDetailInfo.h"

@interface DataModel ()
{
    NSString *categoryName;
    GMSMarker *infoMarker;
}

@property (nonatomic,strong) NSArray *allRetrievedPlaces;

@end

@implementation DataModel

-(void)firstLoad
{
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    _allRetrievedPlaces = [query findObjects];
    _selectedPlaces = [[NSMutableArray alloc] init];
    _infoForMarker = [[PlaceDetailInfo alloc] init];
    
    for (PFObject* objectFromDataBase in _allRetrievedPlaces) {
        if ([objectFromDataBase[@"type"]isEqualToString:@"Parking"])
            [_selectedPlaces addObject:objectFromDataBase];
    }
}

+ (id)sharedModel
{
    static DataModel *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[DataModel alloc] init];
        [sharedModel firstLoad];
    });
    
    return sharedModel;
}

- (id)init
{
    if (self = [super init]) {
        _allRetrievedPlaces = [[NSArray alloc] init];
        _selectedPlaces = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)buildInfoForMarker: (GMSMarker*)marker
{
    infoMarker = marker;
    for (PFObject *object in _selectedPlaces) {
        if (([object[@"longitude"] floatValue] == infoMarker.position.longitude ) && ([object[@"latitude"] floatValue] == infoMarker.position.latitude)) {
            _infoForMarker.name = object[@"name"];
            _infoForMarker.address = object[@"address"];
            _infoForMarker.longtitude = object[@"longitude"];
            _infoForMarker.latitude = object[@"latitude"];
            _infoForMarker.homePage = object[@"homePage"];
            _infoForMarker.description = [NSString stringWithFormat:@"%@\n %@\n %@\n %@", object[@"description"], object[@"workTime"], object[@"phone"], object[@"homePage"]];
            _infoForMarker.type = object[@"type"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fillSubviewOfMap" object:nil];
}

-(void)findObjectForTappedRow :(NSInteger)indexOfRow
{
    PFObject *chosenPlace = [_selectedPlaces objectAtIndex:indexOfRow];
    _infoForMarker.name = chosenPlace[@"name"];
    _infoForMarker.address = chosenPlace[@"address"];
    _infoForMarker.longtitude = chosenPlace[@"longitude"];
    _infoForMarker.latitude = chosenPlace[@"latitude"];
    _infoForMarker.workTime = chosenPlace[@"workTime"];
    _infoForMarker.phone = chosenPlace[@"phone"];
    _infoForMarker.homePage = chosenPlace[@"homePage"];
    _infoForMarker.description = [NSString stringWithFormat:@"%@\n %@\n %@\n %@", chosenPlace[@"description"], chosenPlace[@"workTime"], chosenPlace[@"phone"], chosenPlace[@"homePage"]];
    _infoForMarker.type = chosenPlace[@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fillSubviewOfMap" object:nil];
}

-(void) reactToCategorySelection :(NSString*)title
{
    [_selectedPlaces removeAllObjects];
    for (PFObject* objectFromDataBase in _allRetrievedPlaces) {
        if ([objectFromDataBase[@"type"]isEqualToString:title]){
            
            [_selectedPlaces addObject:objectFromDataBase];
            
        }
    }
}



@end
