//
//  SlideMenuViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SlideMenuViewController.h"
//#import "RequestsClass.h"
#import <GoogleMaps/GoogleMaps.h>

extern NSString *iconOfSelectedMarker;
static NSInteger indexOfCategory;

@interface SlideMenuViewController () {
    PlaceCategory *storage;
 //   RequestsClass *requestToDisplay;
    MapSingletone *mapSingletone;
}

@end

@implementation SlideMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    storage = [PlaceCategory sharedManager];
    mapSingletone = [MapSingletone sharedManager];
  //  requestToDisplay = [[RequestsClass alloc] init];
    //_selectedCategoryOfDisplayedObjects = @"Parking";
    [self setAppearance];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [storage.categoryNamesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [storage.categoryNamesArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

-(void)setIndexValueWithCompletion :(void(^)(NSInteger)) completion
{
    completion(indexOfCategory);
}

-(void)passCategoryStringWithBlock: (void(^)(NSString*))comletion
{
    comletion(_selectedCategoryOfDisplayedObjects);
}
                                             
                                            
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedCategoryOfDisplayedObjects) {
   //     [requestToDisplay cleanMarkersFromMap:_selectedCategoryOfDisplayedObjects];
    }
    _selectedCategoryOfDisplayedObjects = storage.categoryNamesArray [indexPath.row];
    [self.delegate setCategoryValue:_selectedCategoryOfDisplayedObjects];

    iconOfSelectedMarker = storage.markersImages[indexPath.row];
    indexOfCategory = indexPath.row;
     [self.revealViewController revealToggle:self];
    //  [requestToDisplay displayObjectsMarkers:_selectedCategoryOfDisplayedObjects :iconOfSelectedMarker];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSelectedCategory" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"performFilterRenew"object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"performMapRenew"object:nil];
   
    mapSingletone.polyline.map = nil;
    mapSingletone.polyline = nil;
}

-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

@end
