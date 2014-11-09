//
//  SlideMenuViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//


#define Parkings 0
#define BicycleShop 1
#define Cafe 2
#define Supermarket 3


#import "SlideMenuViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GClusterManager.h"



//static NSInteger indexOfCategory;

@interface SlideMenuViewController ()
{
    PlaceCategories *storage;
    RoutePoints *routePoints;
    PlaceCategory *currentCategory;
    DataModel *dataModel;
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
    
    storage = [PlaceCategories sharedManager];
    routePoints = [RoutePoints sharedManager];
    self.markerIcon = @"Parking.png";
    self.category = @"Parking";
    [self setAppearance];
    dataModel = [DataModel sharedModel];
    
    
}
//setting custom height for cells

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return 4;
    }
    else{
        return 4;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"Choose markers to show:";
            break;
        default:
            sectionName = @"lalala";
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *cellName;
    switch (indexPath.row) {
        case Parkings:
            cellName = @"Parking";
            break;
        case BicycleShop:
            cellName = @"BicycleShop";
            break;
        case Cafe:
            cellName = @"Cafe";
            break;
        case Supermarket:
            cellName = @"Supermarket";
            break;
    }
    cell.textLabel.text = cellName;
    
    return cell;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [storage.categoryNamesArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = [storage.categoryNamesArray objectAtIndex:indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    return cell;
//}
////clean previous routes and implementing changes on data model
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.cleanPolylineDelegate cleanPolylineFromMap];
//    self.markerIcon = storage.markersImages[indexPath.row];
//    self.category = storage.categoryNamesArray [indexPath.row];
//    indexOfCategory = indexPath.row;
//    [self.revealViewController revealToggle:self];
//    [dataModel changeCategory:indexPath.row];
//}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int categorySelection = indexPath.row;
  
    NSDictionary *userInfo;
    switch(categorySelection) {
        case Parkings:
            userInfo = @{@"Category":@0};
            break;
        case BicycleShop:
           userInfo = @{@"Category":@1};
            break;
        case Cafe:
           userInfo = @{@"Category":@2};
            break;
        case Supermarket:
            userInfo = @{@"Category":@3};
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryChanged" object:nil userInfo:userInfo];
    return;
}
//set visual appearance
-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}
@end
