//
//  TableViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "TableViewController.h"
#import "SWRevealViewController.h"
#import "TableViewCell.h"

#import "DirectionAndDistance.h"
#import "StorageClass.h"


extern NSMutableArray *filteredObjects;
extern NSString *iconOfSelectedMarker;
extern GMSMarker *myMarker;

@interface TableViewController () {
    StorageClass *storage;
    SlideMenuViewController *menuObject;
    MapSingletone *mapSingletone;
}
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    storage = [StorageClass sharedManager];
    mapSingletone = [MapSingletone sharedManager];
    menuObject = [[SlideMenuViewController alloc] init];
    [self setAppearance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [_bigDetailPanel setHidden:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _bigDetailPanel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"Details"]){
//        [storage.detailInfoForObject setDetailInfoForTappedRow:[filteredObjects objectAtIndex:[sender tag]]];
//    }
//}

//#warning fix!
-(void)reloadTableView: (NSNotification *)notification
{
    [_places reloadData];
    [menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
        self.navigationController.navigationBar.topItem.title = storage.pickerData[indexValue];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    cell.placeType.image = [UIImage imageNamed:iconOfSelectedMarker];
    cell.placeName.text = [filteredObjects objectAtIndex:indexPath.row][@"name"];
    cell.routeToPlace.tag = indexPath.row;
    cell.infoAboutPlace.tag = indexPath.row;
    return cell;
}

- (IBAction)tapMenuButton:(id)sender
{
   [self.revealViewController revealToggle:sender];
}

- (IBAction)route:(UIButton *)sender
{
    DirectionAndDistance *findTheDirection = [DirectionAndDistance new];
    NSInteger index = sender.tag;
    float longt = [[filteredObjects objectAtIndex:index][@"longitude"] doubleValue];
    float lat = [[filteredObjects objectAtIndex:index][@"latitude"] doubleValue];
    [findTheDirection buildTheRouteAndSetTheDistance:longt :lat :^(NSString* theDistance) {
        [mapSingletone.waypoints_ removeObject:[mapSingletone.waypoints_ lastObject]];
        [mapSingletone.waypointStrings_ removeObject:[mapSingletone.waypointStrings_ lastObject]];
        
        CLLocationCoordinate2D boundLocation = CLLocationCoordinate2DMake(lat,longt);
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
        bounds = [bounds includingCoordinate:myMarker.position];
        bounds = [bounds includingCoordinate:boundLocation];
        [mapSingletone.mapView_ animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
     }];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;

}

- (IBAction)pressInfoButton:(UIButton *)sender
{
    [storage.detailInfoForObject setDetailInfoForTappedRow:[filteredObjects objectAtIndex:[sender tag]]];
    [_bigDetailPanel setDataOfWindow];
    [_bigDetailPanel setHidden:NO];
}

-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"clear.png"] drawInRect:self.view.bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.places.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //set up bigview
    _bigDetailPanel.translucentAlpha = 0.9;
    _bigDetailPanel.translucentStyle = UIBarStyleBlack;
    _bigDetailPanel.translucentTintColor = [UIColor clearColor];
}
@end
