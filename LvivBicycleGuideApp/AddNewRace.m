//
//  AddNewRace.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "AddNewRace.h"

#import "RaceMap.h"
#import "DataModel.h"

@interface AddNewRace (){
    NSMutableDictionary *path;
    
}

@end

@implementation AddNewRace

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    path = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
    self.datePicker.minimumDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:+2];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate options:0];
    self.datePicker.maximumDate = maxDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)saveButtonPressed:(id)sender {
    if ([self.placeTextField.text isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete filling the view" message:@"place is not filled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        PFObject *newRace = [PFObject objectWithClassName:@"BikePool"];
        newRace [@"place"] = self.placeTextField.text;
        newRace[@"date"]= self.datePicker.date;
        newRace[@"path"] = path;
        [newRace saveInBackground];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMap"]) {
        UINavigationController* controller = segue.destinationViewController;
        RaceMap* raceMap = [[controller viewControllers] objectAtIndex:0];
        raceMap.pathDelegate =self;
    }
}
- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didEndEditing:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)tapOnView:(UITapGestureRecognizer *)sender
{
    if (self.placeTextField.isFirstResponder) {
        [self.placeTextField resignFirstResponder];
    }
}

-(void)setPath:(NSMutableArray *)encodedPathWithStartPosition :(GMSMarker*)startPosition andEndPosition:(GMSMarker*)endPosition
{
    [path setValue:encodedPathWithStartPosition forKey:@"path"];
    [path setValue:[NSNumber numberWithFloat:startPosition.position.latitude] forKey:@"startPosition1"];
    [path setValue:[NSNumber numberWithFloat:startPosition.position.longitude] forKey:@"startPosition2"];
    [path setValue:[NSNumber numberWithFloat:endPosition.position.latitude] forKey:@"endPosition1"];
    [path setValue:[NSNumber numberWithFloat:endPosition.position.longitude] forKey:@"endPosition2"];
}

@end
