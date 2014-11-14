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
    //RaceMap *raceMap = [self.navigationController.viewControllers objectAtIndex:1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButtonPressed:(id)sender {
    if ([self.placeTextField.text isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete filling the view" message:@"place is not filled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
    
        if (self.datePicker.date < [NSDate date]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect date set" message:@"The event must be set for future" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {PFObject *newRace = [PFObject objectWithClassName:@"BikePool"];
            newRace [@"place"] = self.placeTextField.text;
            newRace[@"date"]= self.datePicker.date;
            newRace[@"path"] = path;
            [newRace saveInBackground];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    
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
     //[path setValue:endPosition forKey:@"endPosition"];
    
}


@end
