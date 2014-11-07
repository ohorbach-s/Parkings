//
//  SlideMenuViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SlideMenuViewController.h"
#import <GoogleMaps/GoogleMaps.h>

static NSInteger indexOfCategory;

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
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return [storage.categoryNamesArray count];
    }
    else{
        return [storage.categoryNamesArray count];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if(section == 0)
//        return @"Section 1";
//    if(section == 1)
//        return @"Section 2";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==0) {
    //    ObjectData *theCellData = [array1 objectAtIndex:indexPath.row];
        NSString *cellValue =[storage.categoryNamesArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = cellValue;
    }
    else {
        NSString *cellValue =[storage.categoryNamesArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = cellValue;
    }
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
