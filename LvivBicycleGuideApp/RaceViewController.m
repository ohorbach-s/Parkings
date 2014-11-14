//
//  RaceViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "RaceViewController.h"


@interface RaceViewController ()
{
CLLocationManager *locationManager;
    GMSPath *path;
    GMSPolyline *polyline;
}
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *smallMapView;

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
   // [self.smallMapView.settings setAllGesturesEnabled:NO];
    
    [_smallMapView animateToZoom:12];
    
    for (NSString *pathElement in self.raceDeteailInView.arrayOfPath)
    {
        path = [GMSPath pathFromEncodedPath:pathElement];
        polyline = [GMSPolyline polylineWithPath:path];
        polyline.map = self.smallMapView;
    }
    CLLocationCoordinate2D boundLocation = CLLocationCoordinate2DMake(self.raceDeteailInView.startLatitude,self.raceDeteailInView.startLongitude);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.raceDeteailInView.endLatitude, self.raceDeteailInView.endLongitude);
    //[self.smallMapView animateToLocation:position];
    bounds = [bounds includingCoordinate:position];
    bounds = [bounds includingCoordinate:boundLocation];
    [self.smallMapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
    
    
    [self.placeLabel.layer setCornerRadius:5.0f];
    [self.dateLabel.layer setCornerRadius:5.0f];
    [self.timeLabel.layer setCornerRadius:5.0f];
    [self.smallMapView.layer setCornerRadius:10.0f];
    [self.smallMapView.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.smallMapView.layer setBorderWidth:2.0f];

}

-(void)passRaceDetail:(RaceDetail*)raceDetail
{
    self.raceDeteailInView = raceDetail;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
