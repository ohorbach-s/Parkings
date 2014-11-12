//
//  StolenBicyclesTVC.m
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "StolenBicyclesTVC.h"
#import "CellForStolenBicycles.h"
#import <Parse/Parse.h>
#import "StolenBicycleDetailVC.h"

@interface StolenBicyclesTVC (){
    NSArray *allStollenBicycles;
    NSArray *allStollenBicyclesSorted;
}

@end

@implementation StolenBicyclesTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Stolen bicycles", nil);
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:6/255.0f green:118/255.0f blue:0/255.0f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
}

-(void)viewWillAppear:(BOOL)animated{
    PFQuery *queryForStolenBicycles = [PFQuery queryWithClassName:@"stolenBicycles"];
    allStollenBicycles = [queryForStolenBicycles findObjects];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    allStollenBicyclesSorted = [allStollenBicycles sortedArrayUsingDescriptors:sortDescriptors];
     [self.tableView reloadData];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [self.tableView reloadData];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return allStollenBicycles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForStolenBicycles *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (allStollenBicyclesSorted[indexPath.row][@"photo"] == nil) {
        cell.stolenBicyclePhoto.image = [UIImage imageNamed:@"noPhoto.jpg"];
    } else {
        cell.stolenBicyclePhoto.image = [UIImage imageWithData: allStollenBicyclesSorted[indexPath.row][@"photo"]];
    }
    cell.stolenBicycleModel.text = allStollenBicyclesSorted[indexPath.row][@"model"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kyiv"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateString = [dateFormatter stringFromDate: allStollenBicyclesSorted[indexPath.row][@"date"]];
    cell.dateOfCrime.text = dateString;
    return cell;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"seeDetails"]){
        StolenBicycleDetailVC *detailsForSegue = [[StolenBicycleDetailVC alloc] init];
        detailsForSegue = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        detailsForSegue.detailToDisplay = allStollenBicyclesSorted[path.row];
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end























