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
#import "SlideMenuViewController.h"
#import "RoutePoints.h"
#import "BigInfoSubview.h"

#import "DirectionAndDistance.h"
#import "PlaceCategories.h"

@interface TableViewController ()
{
    PlaceCategories *placeCategories;
    DataModel *dataModel;
    SlideMenuViewController *menuObject;
    RoutePoints *routePoints;
    NSString *iconOfSelectedMarker;
}

@property (weak, nonatomic) IBOutlet UITableView *placesTable;


@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataModel = [DataModel sharedModel];
    placeCategories = [PlaceCategories sharedManager];
    routePoints = [RoutePoints sharedManager];
    menuObject = [[SlideMenuViewController alloc] init];
    [self setAppearance];
    if (!iconOfSelectedMarker) {
        iconOfSelectedMarker = @"Parking.png";
        self.navigationController.navigationBar.topItem.title = @"Parking";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"performMapAndTableRenew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillSubview:) name:@"fillSubviewOfMap" object:nil];
}

-(void)fillSubview:(NSNotification *)notification
{
    [_bigDetailPanel setDataOfWindow:dataModel.infoForMarker];
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
    if (_bigDetailPanel.hidden) {
        [_bigDetailPanel setHidden:NO];
        [dataModel findObjectForTappedRow:indexPath.row];
        
    }else {
    [_bigDetailPanel setHidden:YES];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // [self.bigDetailPanel setHidden:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(void)reloadTableView: (NSNotification *)notification    //contains nav.contr.title renew !!!
//{
   // [_placesTable reloadData];
//    [menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
//       self.navigationController.navigationBar.topItem.title = placeCategory.categoryNamesArray[indexValue];
//    }];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataModel.selectedPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    cell.placeType.image = [UIImage imageNamed:iconOfSelectedMarker];
    cell.placeName.text = [dataModel.selectedPlaces objectAtIndex:indexPath.row][@"name"];
    cell.routeToPlace.tag = indexPath.row;
    cell.infoAboutPlace.tag = indexPath.row;
    return cell;
}

- (IBAction)tapMenuButton:(id)sender
{
    [self.revealViewController revealToggle:sender];
    self.bigDetailPanel.hidden = YES;
}

- (IBAction)pressRouteButton:(UIButton *)sender
{
    float latitude = [[dataModel.selectedPlaces objectAtIndex:sender.tag][@"latitude"] floatValue];
    float longitude = [[dataModel.selectedPlaces objectAtIndex:sender.tag][@"longitude"] floatValue];
    [self.delagate findDirection:latitude :longitude];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
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
    self.placesTable.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
  //  _bigDetailPanel.translucentAlpha = 0.9;
   // _bigDetailPanel.translucentStyle = UIBarStyleBlack;
   // _bigDetailPanel.translucentTintColor = [UIColor clearColor];
}

- (IBAction)pressInfoButton:(UIButton *)sender
{
    [_bigDetailPanel setHidden:NO];
    [dataModel findObjectForTappedRow:sender.tag];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"markerIcon"]) {
//        iconOfSelectedMarker = [object markerIcon];
//    }
    if ([keyPath isEqualToString:@"categoryIcon"]) {
        self.navigationController.navigationBar.topItem.title = [object categoryName];
        iconOfSelectedMarker = [object categoryIcon];
        [_placesTable reloadData];
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    SlideMenuViewController *menuController = [[self.revealViewController childViewControllers] objectAtIndex:0];
//    [menuController removeObserver:self forKeyPath:@"markerIcon"];
}
@end
