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

@interface ComplaintTableViewController ()
{
    NSMutableArray *testArray;
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
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.complaintTable.backgroundColor = [UIColor colorWithPatternImage:image];
    [self testComplaintCreate];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:6/255.0f green:118/255.0f blue:0/255.0f alpha:1.0f];
}

-(void)testComplaintCreate
{
    CurrentComplaint *complaint1 = [[CurrentComplaint alloc]init];
    CurrentComplaint *complaint2 = [[CurrentComplaint alloc]init];
    CurrentComplaint *complaint3 = [[CurrentComplaint alloc]init];
    CurrentComplaint *complaint4 = [[CurrentComplaint alloc]init];
    CurrentComplaint *complaint5 = [[CurrentComplaint alloc]init];
    complaint1.complaintSubject = @"Пошкоджена парковка";
    complaint2.complaintSubject = @"Пошкоджена велодоріжка";
    complaint3.complaintSubject = @"Класне кафе";
    complaint4.complaintSubject = @"Небезпечний район";
    complaint5.complaintSubject = @"Гопніки!!!";
    complaint1.likeDislike = NO;
    complaint2.likeDislike = NO;
    complaint3.likeDislike = YES;
    complaint4.likeDislike = NO;
    complaint5.likeDislike = NO;
    complaint1.complaintDescription = @"На парковці виламані два паркомісця. Не ризикнув там паркуватись";
    complaint2.complaintDescription = @"На велодоріжці робітники не закопали яму";
    complaint3.complaintDescription = @"Дуже класне велокафе на Дудаєва,7. Всім рекомендую!";
    complaint4.complaintDescription = @"Парковка в темному місці. Навколо крутяться небезпечні тіпи!!!";
    complaint5.complaintDescription = @"Біля парковки тусуються гопніки і просять покататись %(";
    testArray = [[NSMutableArray alloc]init];
    [testArray addObject:complaint1];
    [testArray addObject:complaint2];
    [testArray addObject:complaint3];
    [testArray addObject:complaint4];
    [testArray addObject:complaint5];
}

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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Complaint" forIndexPath:indexPath];
    CurrentComplaint *temp = testArray[indexPath.row];
    cell.likeImage.image = temp.likeDislike == YES  ? [UIImage imageNamed:@"like.png"] : [UIImage imageNamed:@"dislike.png"];
    cell.complainSubject.text = temp.complaintSubject;
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
