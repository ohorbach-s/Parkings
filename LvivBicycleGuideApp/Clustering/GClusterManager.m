#import "GClusterManager.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "GDefaultClusterRenderer.h"
#import "Spot.h"
#import "DataModel.h"
#import <Parse/Parse.h>
#import "PlaceCategories.h"


//extern NSInteger indexOfCategory;

@interface GClusterManager()
{
    BOOL parkingsDisplayed,	bicycleShopsDisplayed,cafeDisplayed,supermarketDisplayed;
    NSArray *ParkingsMarkers,*BicycleShopsMarkers,*CafeMarkers,*SupermarketMarkers;
    DataModel *dataModel;
}
@end

@implementation GClusterManager {
}

- (void)setMapView:(GMSMapView*)mapView {
    //    previousCameraPosition = nil;
    _mapView = mapView;
}

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm {
    //    previousCameraPosition = nil;
    _clusterAlgorithm = clusterAlgorithm;
}

- (void)setClusterRenderer:(id <GClusterRenderer>)clusterRenderer {
    //    previousCameraPosition = nil;
    _clusterRenderer = clusterRenderer;
}

- (void)addItem:(id <GClusterItem>) item {
    [_clusterAlgorithm addItem:item];
}

- (void)removeItems {
    [_clusterAlgorithm removeItems];
}

- (void)cluster {
    NSSet *clusters = [_clusterAlgorithm getClusters:self.mapView.camera.zoom];
    [_clusterRenderer clustersChanged:clusters];
}

#pragma mark mapview delegate

-(void) setNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryPicked:) name:@"CategoryChanged" object:nil];
    dataModel = [DataModel sharedModel];
    [dataModel changeCategory:0];
    ParkingsMarkers = [dataModel.selectedPlaces copy];
    [dataModel changeCategory:1];
    BicycleShopsMarkers = [dataModel.selectedPlaces copy];
    [dataModel changeCategory:2];
    CafeMarkers = [dataModel.selectedPlaces copy];
    [dataModel changeCategory:3];
    SupermarketMarkers = [dataModel.selectedPlaces copy];
}

#pragma mark convenience
+ (instancetype)managerWithMapView:(GMSMapView*)googleMap
                         algorithm:(id<GClusterAlgorithm>)algorithm
                          renderer:(id<GClusterRenderer>)renderer {
    GClusterManager *mgr = [[[self class] alloc] init];
    if(mgr) {
        mgr.mapView = googleMap;
        mgr.clusterAlgorithm = algorithm;
        mgr.clusterRenderer = renderer;
        mgr->parkingsDisplayed = NO;
        mgr->bicycleShopsDisplayed = NO;
        mgr->cafeDisplayed = NO;
        mgr->supermarketDisplayed = NO;
        [mgr setNotifications];
    }
    return mgr;
}

#warning FUCKING SHIT!
-(void) addMarkersByType:(int)type {
    
    [self removeItems];

    if(parkingsDisplayed)
        [self insertItems:ParkingsMarkers ByType:0];
    if(bicycleShopsDisplayed)
        [self insertItems:BicycleShopsMarkers ByType:1];
    if(cafeDisplayed)
        [self insertItems:CafeMarkers ByType:2];
    if(supermarketDisplayed)
        [self insertItems:SupermarketMarkers ByType:3];



}

-(void) insertItems:(NSArray*)items ByType:(int)type {
    Spot *spot;
    PlaceCategories *placeCategories= [PlaceCategories sharedManager];
    
    for (PFObject* object in items) {
        CLLocationCoordinate2D _position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
        spot = [[Spot alloc] initWithPosition:_position andIconTypePath:placeCategories.markersImages[type]];
        [self addItem:spot];
        [self cluster];
    }
}
-(void) removeMarkersByType:(int)type {
//    _clusterAlgorithm 
}

-(void) CategoryPicked:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    int category = [[userInfo objectForKey:@"Category"] intValue];
    switch (category) {
        case 0:
            parkingsDisplayed = (parkingsDisplayed? NO : YES);
            [self addMarkersByType:0];
            break;
        case 1:
            bicycleShopsDisplayed = (bicycleShopsDisplayed? NO : YES);
            [self addMarkersByType:1];
            break;
        case 2:
            cafeDisplayed = (cafeDisplayed? NO : YES);
            [self addMarkersByType:2];
            break;
        case 3:
            supermarketDisplayed = (supermarketDisplayed? NO : YES);
            [self addMarkersByType:3];
            break;
            
            
    }
}

@end
