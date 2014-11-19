//
//  ComplaintTableViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "ComplaintTableViewController.h"
#import "CurrentComplaint.h"
#import "ComplaintCell.h"
#import "DetailComplaintViewController.h"
#import "DataModel.h"

@interface ComplaintTableViewController ()
{
    NSMutableArray *testArray;
    DataModel *dataModel;
}
@property (strong, nonatomic) IBOutlet UITableView *complaintTable;


@end

@implementation ComplaintTableViewController

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
    dataModel = [DataModel sharedModel];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.complaintTable.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:6/255.0f green:118/255.0f blue:0/255.0f alpha:1.0f];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"address = %@", dataModel.infoForMarker.address];
    PFQuery *query = [PFQuery queryWithClassName:
                      NSLocalizedString(@"PlaceEng", nil) predicate:predicate];
    NSArray *foundObjects = [query findObjects];
    PFObject *foundObject = foundObjects[0];
    predicate = [NSPredicate predicateWithFormat:
                              @"parent = %@", foundObject];
    query = [PFQuery queryWithClassName:
                      NSLocalizedString(@"Comments", nil) predicate:predicate];
    NSArray *all = [query findObjects];
    testArray = [all mutableCopy];
    [self.tableView reloadData];
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
    return [testArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Complaint" forIndexPath:indexPath];
    NSDictionary *temp = testArray[indexPath.row];
    cell.likeImage.image = [[temp valueForKey:@"likeDislike"] isEqual:@1 ] ? [UIImage imageNamed:@"like.png"] : [UIImage imageNamed:@"dislike.png"];
    cell.complainSubject.text = [temp valueForKey:@"subject"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToDetailComplaint"])
    {
        DetailComplaintViewController *vc = [segue destinationViewController];
        vc.complaint = testArray[[self.tableView indexPathForCell:sender].row];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
