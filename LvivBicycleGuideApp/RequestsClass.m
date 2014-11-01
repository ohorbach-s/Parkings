//
//  RequestsClass.m
//  MapsDirections
//
//  Created by Yuliia on 10/21/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "RequestsClass.h"
#import "MapViewController.h"
#import <Parse/Parse.h>
#import "Spot.h"
#import "GClusterManager.h"

//extern GClusterManager *clusterManager;
NSArray *foundObjects;
NSMutableArray *filteredObjects;

@interface RequestsClass () {
    CLLocationCoordinate2D position;
}

@end

@implementation RequestsClass

+(void)firstLoad
{
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    foundObjects = [query findObjects];
    filteredObjects = [[NSMutableArray alloc] init];
}

-(void)displayObjectsMarkers:(NSString *)category :(NSString*) iconOfMarker
{
    Spot *spot;
    for (PFObject* object in foundObjects) {
        if ([object[@"type"]isEqualToString:category]) {
            [filteredObjects addObject:object];
            position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
            spot = [[Spot alloc] initWithPosition:position];
           // [clusterManager addItem:spot];
           // [clusterManager cluster];
        }
    }
}

-(void)cleanMarkersFromMap:(NSString*)category
{
//    [clusterManager removeItems];
//    [filteredObjects removeAllObjects];
}


@end
