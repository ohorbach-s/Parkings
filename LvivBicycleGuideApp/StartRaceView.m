//
//  StartRaceView.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/15/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "StartRaceView.h"
#import "RNGridMenu.h"

@interface StartRaceView ()
{
    BOOL running;
    BOOL paused;

    NSTimeInterval startTime;
    NSTimeInterval currentTime;
    CLLocationCoordinate2D myPosition;
    CLLocationCoordinate2D myBoundLocation;
    GMSPolyline *myPolyline;
     CLLocationManager *locationManager;
    NSArray *myPolylines;
    GMSPath *path;
    CLLocation *currentLocation;
    int mins;
    NSMutableArray *speeds;
    float speedSum;
    float averageSpeed;
}
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *stopWatch;
@property (weak, nonatomic) IBOutlet GMSMapView *raceMap;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation StartRaceView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goButtonPressed:(UIButton *)sender {
    if ((!running)&&(!paused)) {
        [locationManager startUpdatingLocation];
        running = YES;
        speedSum = 0;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self.pauseButton setHidden:NO];
        [self updateTime];
    }   else  {
        paused = NO;
        [sender setTitle:@"GO" forState:UIControlStateNormal];
        [self.pauseButton setHidden:YES];
        running = NO;
        self.stopWatch.text = @"00:00:00";
        averageSpeed = speedSum / [speeds count];
        [speeds removeAllObjects];
        [locationManager stopUpdatingLocation];
        float caloriesBurnt = [self calculateCalories:averageSpeed :mins];
        NSInteger numberOfOptions = 4;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd.MM.YY"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"stopwatch2.png"] title:[NSString stringWithFormat:@" %@", self.stopWatch.text]],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bc.png"] title:[NSString stringWithFormat:@"%.2f kcal", caloriesBurnt]],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"speedometer2.png"] title:[NSString stringWithFormat:@"%.2f mps", averageSpeed]],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"calendar2.png"] title:dateString]
                           ];
        
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stopWatch.text = @"00:00:00";
    running = NO;
    speeds = [[NSMutableArray alloc] init];
    startTime = [NSDate timeIntervalSinceReferenceDate];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
    [self.stopWatch.layer setCornerRadius:15.0f];
    [self.stopWatch.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.stopWatch.layer setBorderWidth:1.0f];
    
    [self.goButton.layer setCornerRadius:15.0f];
    [self.goButton.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.goButton.layer setBorderWidth:1.0f];
    
    [self.raceMap.layer setCornerRadius:10.0f];
    [self.raceMap.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.raceMap.layer setBorderWidth:2.0f];
    
    [self.speedLabel.layer setCornerRadius:15.0f];
    [self.speedLabel.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.speedLabel.layer setBorderWidth:1.0f];
    
    [self.pauseButton.layer setCornerRadius:15.0f];
    [self.pauseButton.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.pauseButton.layer setBorderWidth:1.0f];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = 20;
    [locationManager startUpdatingLocation];
    
    self.pauseButton.hidden = YES;
    self.raceMap.delegate = self;
    
     [self.raceMap animateToZoom:12];
     GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate:myPosition];
    bounds = [bounds includingCoordinate:myBoundLocation];
    [self.raceMap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
    for (NSString *pathElement in myPolylines)
    {
        path = [GMSPath pathFromEncodedPath:pathElement];
        myPolyline = [GMSPolyline polylineWithPath:path];
        myPolyline.map = self.raceMap;
    }
    self.raceMap.myLocationEnabled = YES;
    // Do any additional setup after loading the view.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    [self.raceMap animateToLocation:currentLocation.coordinate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.speedLabel.text = [NSString stringWithFormat:@"   %.2f  km/h      %.2f  m/s", currentLocation.speed* 3.6, currentLocation.speed];
    });
    [speeds addObject:@(currentLocation.speed)];
    speedSum +=currentLocation.speed;
    NSLog(@"%.2f", currentLocation.speed * 3.6);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passMapp: (NSArray*)polylines :(CLLocationCoordinate2D)boundLocation :(CLLocationCoordinate2D)position;

{
    myPolylines = polylines;
    myPosition = position;
    myBoundLocation = boundLocation;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate:position];
    bounds = [bounds includingCoordinate:boundLocation];
    myPolyline.map = self.raceMap;
    [self.raceMap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
}

-(void)updateTime
{
    if (!running) return ;
    currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    mins = (int)(elapsed / 60.0);
    elapsed -= mins * 60;
    int secs = (int) (elapsed);
    elapsed -= secs;
    int fraction = elapsed * 10.0;
    self.stopWatch.text  = [NSString stringWithFormat:@"%02u:%02u:%02u", mins, secs, fraction];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (IBAction)pauseButtonPressed:(UIButton *)sender {
    if (!paused) {
        paused = YES;
        running = NO;
        [sender setTitle:@"Continue" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        paused = NO;
        running = YES;
        [self updateTime];
    }
}

-(float)calculateCalories:(float)averageSpeedToPass :(int)elapsedTime
{
    float result = 0;
    result = (3.509 * averageSpeedToPass + 0.2581 * averageSpeedToPass * averageSpeedToPass * averageSpeedToPass) / 20.78;
    if (elapsedTime>0) {
         return result * elapsedTime;
    }
    return result;
}


@end
