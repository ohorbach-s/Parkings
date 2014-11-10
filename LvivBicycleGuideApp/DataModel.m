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
    //GMSMarker *infoMarker;
    PlaceCategories *namesArray;
}

@property (nonatomic,strong) NSArray *allRetrievedPlaces;

@end

@implementation DataModel
//retrieving information about all objects from the cloud
-(void)firstLoad
{

    _infoForMarker = [[PlaceDetailInfo alloc] init];
    namesArray = [PlaceCategories sharedManager];
    //self.currentCategory = [[PlaceCategory alloc] init];
    self.arrangedPlaces = [[NSMutableDictionary alloc] init];
    self.arrangedDistances = [[NSMutableDictionary alloc] init];
    self.deselectedIcon = [[NSString alloc] init];
    self.onTags = [[NSMutableArray alloc]init];
    self.currentCategory = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"type = 'Parking'"];
    PFQuery *query = [PFQuery queryWithClassName:
                                       NSLocalizedString(@"PlaceEng", nil) predicate:predicate];
    
    [self.arrangedPlaces setValue:[query findObjects] forKey:@"0"];
    predicate = [NSPredicate predicateWithFormat:
                 @"type = 'BicycleShop'"];
    query = [PFQuery queryWithClassName:@"PlaceEng" predicate:predicate];
    
    [self.arrangedPlaces setValue:[query findObjects] forKey:@"1"];
    
    predicate = [NSPredicate predicateWithFormat:
                 @"type = 'Cafe'"];
    query = [PFQuery queryWithClassName:@"PlaceEng" predicate:predicate];
    
    [self.arrangedPlaces setValue:[query findObjects] forKey:@"2"];
    predicate = [NSPredicate predicateWithFormat:
                 @"type = 'Supermarket'"];
    query = [PFQuery queryWithClassName:@"PlaceEng" predicate:predicate];
    
    [self.arrangedPlaces setValue:[query findObjects] forKey:@"3"];
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
        //self.buttonTag = @"0";
    }
    return self;
}
//retrieve information for particular object (for tapped marker)
-(void)buildInfoForMarker: (GMSMarker*)marker
{
    //infoMarker = marker;
    for(NSString *tag in self.onTags){
    for (PFObject *object in [self.arrangedPlaces valueForKey:tag]) {
        if (([object[@"longitude"] floatValue] == marker.position.longitude ) && ([object[@"latitude"] floatValue] == marker.position.latitude)) {
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
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fillSubviewOfMap" object:nil];
}
//etrieve information for particular object (for tapped row)
-(void)findObjectForTappedRow :(PFObject*)chosenPlace
{
    //PFObject *chosenPlace = [_selectedPlaces objectAtIndex:indexOfRow];
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
//    [_selectedPlaces removeAllObjects];
//    for (PFObject* objectFromDataBase in _allRetrievedPlaces) {
//        
//        if ([objectFromDataBase[@"type"]isEqualToString:title])  {
//            [_selectedPlaces addObject:objectFromDataBase];
//        }
//    }
}
//accept new category value
-(void)changeCategory :(NSInteger)index
{
    PlaceCategory *category = [[PlaceCategory alloc] init];
    category.categoryName = [namesArray.categoryNamesArray objectAtIndex:index];
    self.buttonTag = [@(index) stringValue];
    [self.onTags addObject:self.buttonTag];
    category.categoryIcon = [namesArray.markersImages objectAtIndex:index];
    [self.currentCategory addObject:category];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showMarker" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"performMapAndTableRenew" object:nil];
}

-(void)deselectCategory :(NSInteger)index
{
    PlaceCategory *category = [[PlaceCategory alloc] init];
    category.categoryName = [namesArray.categoryNamesArray objectAtIndex:index];
    category.categoryIcon = [namesArray.markersImages objectAtIndex:index];

    [self.currentCategory removeObjectIdenticalTo:category];
    
    
     self.buttonTag = [@(index) stringValue];
    [self.onTags removeObject:self.buttonTag];
     // [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanMarkers" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"performMapAndTableRenew" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMarker" object:nil];
}

@end
