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
#import "DirectionAndDistance.h"
#import "PlaceCategories.h"
#import "DetailTVC.h"

@interface TableViewController ()
{
    DataModel *dataModel;
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
    [self setAppearance];
}
//passing data to detail subview

-(void)reloadTableView: (NSNotification*)notification
{
    dataModel = [DataModel sharedModel];
    cells = [[NSMutableArray alloc] init];
    distances = [[NSMutableArray alloc] init];
        for (NSString *tag in dataModel.onTags) {
        for (PFObject *object in [dataModel.arrangedEnglishPlaces valueForKey:tag]) {
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
    
    
}
//display subview or hide it
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [cells objectAtIndex:indexPath.row];
    [dataModel findObjectForTappedRow:object];
    //[self performSegueWithIdentifier:@"GoToDetaisFromTable" sender:c];
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
    
}


//go to Complaints
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToDetaisFromTable"])
    {
        UINavigationController *navigationController =segue.destinationViewController;
        
        DetailTVC *datail =[[navigationController viewControllers] objectAtIndex:0];
        datail.sentDetails = dataModel.infoForMarker;
    }
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
