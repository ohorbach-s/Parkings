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
    PlaceCategories *placeCategories;
    DataModel *dataModel;
    SlideMenuControllerViewController *menuObject;
    RoutePoints *routePoints;
    NSString *iconOfSelectedMarker;
    NSMutableArray *cells;
    NSMutableArray *distances;
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
    menuObject = [[SlideMenuControllerViewController alloc] init];
    [self setAppearance];
    if (!iconOfSelectedMarker) {
        //iconOfSelectedMarker = @"Parking.png";
        //self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Parkings", nil);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillSubview:) name:@"fillSubviewOfMap" object:nil];
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
        for (PFObject *object in [dataModel.arrangedPlaces valueForKey:tag])
        {
        [cells addObject:object];
        }
        for (PFObject *object in [dataModel.arrangedDistances valueForKey:tag]){
         [distances addObject:object];
        }
    }
    [self.placesTable reloadData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
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
    int countRows =0;
    for (NSString *tag in dataModel.onTags){
        countRows +=[[dataModel.arrangedPlaces valueForKey:tag] count];
        }
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
            TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        cell.placeName.text = [cells objectAtIndex:indexPath.row][@"name"];
        cell.routeToPlace.tag = indexPath.row;
        cell.infoAboutPlace.tag = indexPath.row;
        cell.distance.text = [NSString stringWithFormat:@"%@ km",[distances objectAtIndex:indexPath.row]];
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
    
    
    _bigDetailPanel.translucentAlpha = 0.7;
    _bigDetailPanel.translucentStyle = UIBarStyleBlack;
    _bigDetailPanel.translucentTintColor = [UIColor colorWithRed:218/255.0f green:255/255.0f blue:120/255.0f alpha:0.7f];
}
//displaying detail subview
- (IBAction)pressInfoButton:(UIButton *)sender
{
    [_bigDetailPanel setHidden:NO];
    [dataModel findObjectForTappedRow:[cells objectAtIndex:sender.tag]];
    self.bigDetailPanel.description.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};

}
//setting observance for values
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"categoryIcon"]) {

        if ([[object categoryName] isEqualToString:@"Parking"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Parkings", nil);
        } else if ([[object categoryName] isEqualToString:@"BicycleShop"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Services", nil);
        } else if ([[object categoryName] isEqualToString:@"Cafe"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Cafes", nil);
        } else if ([[object categoryName] isEqualToString:@"Supermarket"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Supermarkets", nil);
        }
//        self.navigationController.navigationBar.topItem.title = [object categoryName];
        iconOfSelectedMarker = [object categoryIcon];
        [_placesTable reloadData];
    }
    }

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
