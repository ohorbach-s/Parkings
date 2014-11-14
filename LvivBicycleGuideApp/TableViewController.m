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
#import "SlideMenuControllerViewController.h"
#import "RoutePoints.h"
#import "BigInfoSubview.h"
#import "DirectionAndDistance.h"
#import "PlaceCategories.h"

@interface TableViewController ()
{
    DataModel *dataModel;
    RoutePoints *routePoints;
    NSMutableArray *cells;
    NSMutableArray *distances;
}

@property (weak, nonatomic) IBOutlet UITableView *placesTable;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataModel = [DataModel sharedModel];
    routePoints = [RoutePoints sharedManager];
    [self setAppearance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillSubview:) name:@"fillSubviewOfMap" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"performMapAndTableRenew" object:nil];
}
//passing data to detail subview
-(void)fillSubview:(NSNotification *)notification
{
    [_bigDetailPanel setDataOfWindow:dataModel.infoForMarker];
}

-(void)reloadTableView: (NSNotification*)notification
{
    dataModel = [DataModel sharedModel];
    cells = [[NSMutableArray alloc] init];
    distances = [[NSMutableArray alloc] init];
    [distances removeAllObjects];
    [cells removeAllObjects];
    for (NSString *tag in dataModel.onTags) {
        for (PFObject *object in [dataModel.arrangedPlaces valueForKey:tag]) {
            [cells addObject:object];
        }
        if ([dataModel.arrangedDistances count]) {
            for (NSString *object in [dataModel.arrangedDistances valueForKey:tag]) {
                [distances addObject:object];
            }
        }
    }
    if (distances.count) {
        id mySort = ^(PFObject * key1, PFObject * key2){
            NSInteger index1 = [cells indexOfObject:key1];
            NSInteger index2 = [cells indexOfObject:key2];
            id distance1 = distances[index1];
            id distance2 = distances[index2];
            
            if ([distance1 doubleValue] > [distance2 doubleValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([distance1 doubleValue] < [distance2 doubleValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        cells = [[cells sortedArrayUsingComparator:mySort] mutableCopy];
        distances = [[distances sortedArrayUsingDescriptors:
                      @[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue"
                                                      ascending:YES]]] mutableCopy];
    }
    [self.placesTable reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_bigDetailPanel setHidden:YES];
}
//display subview or hide it
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bigDetailPanel.hidden) {
        [_bigDetailPanel setHidden:NO];
        PFObject *object = [cells objectAtIndex:indexPath.row];
        [dataModel findObjectForTappedRow:object];
    }else {
        [_bigDetailPanel setHidden:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_bigDetailPanel setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    cell.placeName.text = [cells objectAtIndex:indexPath.row][@"name"];
    cell.routeToPlace.tag = indexPath.row;
    cell.infoAboutPlace.tag = indexPath.row;
    if([distances count]){
        cell.distance.text = [NSString stringWithFormat:@"%@ km",[distances objectAtIndex:indexPath.row]];}
    else {
    cell.distance.text = @"";
    }
    cell.placeType.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [cells objectAtIndex:indexPath.row][@"type"]]];
    [cells addObject:cell];
    return cell;
}
//display menu
- (IBAction)tapMenuButton:(id)sender
{
    [self.revealViewController revealToggle:sender];
    self.bigDetailPanel.hidden = YES;
}
//build and display  the route to selected destination
- (IBAction)pressRouteButton:(UIButton *)sender
{
    float latitude = [[cells objectAtIndex:sender.tag][@"latitude"] floatValue];
    float longitude = [[cells objectAtIndex:sender.tag][@"longitude"] floatValue];
    [self.delagate findDirectionForLatitude:latitude AndLongitude:longitude];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}
//setting view visual appearance
-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"beige.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"clear.png"] drawInRect:self.view.bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.placesTable.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _bigDetailPanel.backgroundColor = [UIColor clearColor];
    _bigDetailPanel.translucentAlpha = 1.;
    _bigDetailPanel.translucentStyle = UIBarStyleBlackTranslucent;
    [_bigDetailPanel.layer setCornerRadius:15.0f];
    _bigDetailPanel.translucentTintColor = [UIColor clearColor];
    self.complaintButton.clipsToBounds = YES;
    [self.complaintButton.layer setCornerRadius:15.0f];
}
//displaying detail subview
- (IBAction)pressInfoButton:(UIButton *)sender
{
    [_bigDetailPanel setHidden:NO];
    [dataModel findObjectForTappedRow:[cells objectAtIndex:sender.tag]];
    self.bigDetailPanel.description.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
