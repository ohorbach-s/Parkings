//
//  RaceViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "RaceViewController.h"
#import "StartRaceView.h"

@interface RaceViewController ()
{
    CLLocationManager *locationManager;
    GMSPath *path;
    GMSPolyline *polyline;
    CLLocationCoordinate2D boundLocation;
    CLLocationCoordinate2D position;
    NSDate *myDateOfEvent;
    UILocalNotification* localNotification;
}
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *smallMapView;
@property (weak, nonatomic) IBOutlet UIButton *participateButton;
@property (weak, nonatomic) IBOutlet UIButton *startRaceButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelRaceButton;

@end

@implementation RaceViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
    self.placeLabel.text = self.raceDeteailInView.place;
    self.dateLabel.text = self.raceDeteailInView.date;
    self.timeLabel.text = self.raceDeteailInView.time;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    self.smallMapView.delegate = self;
    [_smallMapView animateToZoom:12];
    for (NSString *pathElement in self.raceDeteailInView.arrayOfPath) {
        path = [GMSPath pathFromEncodedPath:pathElement];
        polyline = [GMSPolyline polylineWithPath:path];
        polyline.map = self.smallMapView;
    }
    boundLocation = CLLocationCoordinate2DMake(self.raceDeteailInView.startLatitude,self.raceDeteailInView.startLongitude);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    position = CLLocationCoordinate2DMake(self.raceDeteailInView.endLatitude, self.raceDeteailInView.endLongitude);
    bounds = [bounds includingCoordinate:position];
    bounds = [bounds includingCoordinate:boundLocation];
    [self.smallMapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
    [self.placeLabel.layer setCornerRadius:5.0f];
    [self.dateLabel.layer setCornerRadius:5.0f];
    [self.timeLabel.layer setCornerRadius:5.0f];
    [self.smallMapView.layer setCornerRadius:10.0f];
    [self.smallMapView.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.smallMapView.layer setBorderWidth:2.0f];
    [self.participateButton.layer setCornerRadius:10.0f];
    [self.participateButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.participateButton.layer setBorderWidth:1.5f];
    [self.startRaceButton.layer setCornerRadius:10.0f];
    [self.startRaceButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.startRaceButton.layer setBorderWidth:1.5f];
    [self.cancelRaceButton.layer setCornerRadius:10.0f];
    [self.cancelRaceButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.cancelRaceButton.layer setBorderWidth:1.5f];
}

-(void) viewWillAppear:(BOOL)animated
{
    if ([self.raceObject[@"selectedToParticipate"] boolValue]) {
        [self.participateButton setHidden:YES];
    }
    
}

-(void)passRaceDetail:(RaceDetail*)raceDetail :(NSDate*)dateOfevent :(PFObject*)object
{
    self.raceDeteailInView = raceDetail;
    myDateOfEvent = dateOfevent;
    self.raceObject = object;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StartRaceView *destination = segue.destinationViewController;
    self.passMapDelegate = destination;
    [self.passMapDelegate passMapp:self.raceDeteailInView.arrayOfPath :boundLocation: position];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)participateButtonPressed:(UIButton *)sender {
    
    self.raceObject [@"selectedToParticipate"] = @YES;
    [self.raceObject saveInBackground];
    [self.participateButton setHidden:YES];
    localNotification= [[UILocalNotification alloc] init];
    localNotification.fireDate =  myDateOfEvent;
    localNotification.alertBody = [NSString stringWithFormat:@"Scheduled race at %@ is coming", self.placeLabel.text];
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (IBAction)cancelButtonPressed:(id)sender {
    self.raceObject [@"selectedToParticipate"] = @NO;
    [self.raceObject saveInBackground];
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    [self.participateButton setHidden:NO];
}


@end
