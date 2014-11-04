//
//  DataModel.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/30/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DataModel.h"
#import "PlaceDetailInfo.h"
#import "PlaceCategories.h"

@interface DataModel ()
{
    GMSMarker *infoMarker;
    PlaceCategories *namesArray;
}

@property (nonatomic,strong) NSArray *allRetrievedPlaces;

@end

@implementation DataModel
//retrieving information about all objects from the cloud
-(void)firstLoad
{
    PFQuery *query = [PFQuery queryWithClassName:
                      NSLocalizedString(@"PlaceEng", nil)];
    _allRetrievedPlaces = [query findObjects];
    _selectedPlaces = [[NSMutableArray alloc] init];
    _infoForMarker = [[PlaceDetailInfo alloc] init];
    namesArray = [PlaceCategories sharedManager];
    self.currentCategory = [[PlaceCategory alloc] init];
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
//retrieve information for particular object (for tapped marker)
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
            NSMutableString *test = [NSMutableString stringWithString: @""];
            if (object[@"description"]) {
                [test appendString:[NSString stringWithFormat:@"%@", object[@"description"]]];
            }
            if (object[@"workTime"]) {
                [test appendString:[NSString stringWithFormat:@"\n %@", object[@"workTime"]]];
            }
            if (object[@"phone"]) {
                [test appendString:[NSString stringWithFormat:@"\n %@", object[@"phone"]]];
            }
            if (object[@"homePage"]) {
                [test appendString:[NSString stringWithFormat:@"\n %@", object[@"homePage"]]];
            }
            _infoForMarker.description = [NSString stringWithString:test];
            _infoForMarker.type = object[@"type"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fillSubviewOfMap" object:nil];
}
//etrieve information for particular object (for tapped row)
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
    NSMutableString *test = [NSMutableString stringWithString: @""];
    if (chosenPlace[@"description"]) {
        [test appendString:[NSString stringWithFormat:@"%@", chosenPlace[@"description"]]];
    }
    if (chosenPlace[@"workTime"]) {
        [test appendString:[NSString stringWithFormat:@"\n %@", chosenPlace[@"workTime"]]];
    }
    if (chosenPlace[@"phone"]) {
        [test appendString:[NSString stringWithFormat:@"\n %@", chosenPlace[@"phone"]]];
    }
    if (chosenPlace[@"homePage"]) {
        [test appendString:[NSString stringWithFormat:@"\n %@", chosenPlace[@"homePage"]]];
    }
    _infoForMarker.description = [NSString stringWithString:test];
    _infoForMarker.type = chosenPlace[@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fillSubviewOfMap" object:nil];
}
//rebuild the selected objects array
-(void) reactToCategorySelection :(NSString*)title
{
    [_selectedPlaces removeAllObjects];
    for (PFObject* objectFromDataBase in _allRetrievedPlaces) {
        
        if ([objectFromDataBase[@"type"]isEqualToString:title])  {
            [_selectedPlaces addObject:objectFromDataBase];
        }
    }
}
//accept new category value
-(void)changeCategory :(NSInteger)index
{
    [self reactToCategorySelection:[namesArray.categoryNamesArray objectAtIndex:index]];
    self.currentCategory.categoryName = [namesArray.categoryNamesArray objectAtIndex:index];
    self.currentCategory.categoryIcon = [namesArray.markersImages objectAtIndex:index];
}



@end
