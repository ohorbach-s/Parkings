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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cleanPolylineDelegate cleanPolylineFromMap];
    self.markerIcon = storage.markersImages[indexPath.row];
    self.category = storage.categoryNamesArray [indexPath.row];
    indexOfCategory = indexPath.row;
    [self.revealViewController revealToggle:self];
    
    [dataModel changeCategory:indexPath.row];

   
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
