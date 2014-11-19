//
//  RaceTableView.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "RaceTableView.h"
#import "RaceDetail.h"
#import "RaceViewController.h"

@interface RaceTableView ()
{
    NSArray *allRaces;
    RaceDetail *raceDetail;
    PFObject *raceObject;
}
@end

@implementation RaceTableView

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
    allRaces = [[NSArray alloc] init];
    raceDetail = [[RaceDetail alloc] init];
    self.title = NSLocalizedString(@"Races", nil);
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:6/255.0f green:118/255.0f blue:0/255.0f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];

}

-(void)viewWillAppear:(BOOL)animated
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        PFQuery *queryForRaces = [PFQuery queryWithClassName:@"BikePool"];
        allRaces = [queryForRaces findObjects];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [self.tableView reloadData];
        });
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allRaces count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"raceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [allRaces objectAtIndex:indexPath.row][@"place"];
    cell.detailTextLabel.text = [allRaces objectAtIndex:indexPath.row][@"date"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    raceDetail.place = [allRaces objectAtIndex:indexPath.row][@"place"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    NSDate *dateofEvent = [allRaces objectAtIndex:indexPath.row][@"date"];
    NSDate *dateToNotify = [gregorian dateByAddingComponents:comps toDate:dateofEvent options:0];
    NSString *dateString = [dateFormatter stringFromDate:[allRaces objectAtIndex:indexPath.row][@"date"]];
    raceDetail.date = dateString;
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kyiv"];
    [dateFormatter setTimeZone:timeZone];
    dateString = [dateFormatter stringFromDate:[allRaces objectAtIndex:indexPath.row][@"date"]];
    raceDetail.time = dateString;
    raceDetail.arrayOfPath = [[allRaces objectAtIndex:indexPath.row][@"path"] valueForKey:@"path"];
    raceDetail.startLatitude = [[[allRaces objectAtIndex:indexPath.row][@"path"] valueForKey:@"startPosition1"] floatValue];
    raceDetail.startLongitude = [[[allRaces objectAtIndex:indexPath.row][@"path"] valueForKey:@"startPosition2"] floatValue];
    raceDetail.endLatitude = [[[allRaces objectAtIndex:indexPath.row][@"path"] valueForKey:@"endPosition1"] floatValue];
    raceDetail.endLongitude = [[[allRaces objectAtIndex:indexPath.row][@"path"] valueForKey:@"endPosition2"] floatValue];
    raceDetail.selectedToParticipate = [[allRaces objectAtIndex:indexPath.row][@"selectedToParticipate"] boolValue];
    raceObject = [allRaces objectAtIndex:indexPath.row];
    [self.raceDelegate passRaceDetail:raceDetail :dateToNotify :raceObject];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDetailView"]) {
        RaceViewController *destController = segue.destinationViewController;
        self.raceDelegate = destController;
    }
}
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
