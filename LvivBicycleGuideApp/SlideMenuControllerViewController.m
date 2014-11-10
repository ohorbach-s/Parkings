//
//  SlideMenuControllerViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/7/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "SlideMenuControllerViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface SlideMenuControllerViewController ()
{
    PlaceCategories *storage;
    RoutePoints *routePoints;
    //PlaceCategory *currentCategory;
    DataModel *dataModel;
}

@end
@implementation SlideMenuControllerViewController

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
    storage = [PlaceCategories sharedManager];
    routePoints = [RoutePoints sharedManager];
    self.markerIcon = @"Parking.png";
    self.category = @"Parking";
    [self setAppearance];
    dataModel = [DataModel sharedModel];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    [self.parkingButton.layer setCornerRadius:15.0f];
    [self.parkingButton.layer setShadowOpacity:50.0f];
    [self.parkingButton.layer setShadowRadius:5.0f];
    [self.cafeButton.layer setCornerRadius:15.0f];
    [self.cafeButton.layer setShadowOpacity:20.0f];
    [self.cafeButton.layer setShadowRadius:5.0f];
    [self.supermarketsButton.layer setCornerRadius:15.0f];
    [self.supermarketsButton.layer setShadowOpacity:20.0f];
    [self.supermarketsButton.layer setShadowRadius:5.0f];
    [self.shopsButton.layer setCornerRadius:15.0f];
    [self.shopsButton.layer setShadowOpacity:20.0f];
    [self.shopsButton.layer setShadowRadius:5.0f];
    [self.complaintButton.layer setCornerRadius:15.0f];
    [self.complaintButton.layer setShadowOpacity:20.0f];
    [self.complaintButton.layer setShadowRadius:5.0f];
    [self.stolenButton.layer setCornerRadius:15.0f];
    [self.stolenButton.layer setShadowOpacity:20.0f];
    [self.stolenButton.layer setShadowRadius:5.0f];
    [self.rentalButton.layer setCornerRadius:15.0f];
    [self.rentalButton.layer setShadowOpacity:20.0f];
    [self.rentalButton.layer setShadowRadius:5.0f];
}

- (IBAction)supermarketsButtonPressed:(id)sender {
    
    static BOOL isActive = NO;
    if (!isActive) {
        [self.supermarketsButton setAlpha:0.7f];
        [self.supermarketsButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        isActive = YES;
        
         [dataModel changeCategory:[sender tag]];
        //[dataModel.onTags addObject:dataModel.buttonTag];
    } else {
        [self.supermarketsButton setAlpha:1.0f];
         [self.supermarketsButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
      
        
        [dataModel deselectCategory:[sender tag]];
          [dataModel.onTags removeObject:dataModel.buttonTag];
       // [self.cleanPolylineDelegate cleanDeselectedCategory:[NSString stringWithFormat:@"%d", [sender tag]]];
    }
    
}

- (IBAction)parkingButtonPressed:(id)sender {
    static BOOL isActive = NO;
    if (!isActive) {
        [self.parkingButton setAlpha:0.7f];
        [self.parkingButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        isActive = YES;
        
        [dataModel changeCategory:[sender tag]];
        //[dataModel.onTags addObject:dataModel.buttonTag];
    } else {
        [self.parkingButton setAlpha:1.0f];
        [self.parkingButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
        [dataModel.onTags removeObject:dataModel.buttonTag];
        [dataModel deselectCategory:[sender tag]];
        
       // [self.cleanPolylineDelegate cleanDeselectedCategory:[NSString stringWithFormat:@"%d", [sender tag]]];
    }
}

- (IBAction)cafeButtonPressed:(id)sender {
    static BOOL isActive = NO;
    if (!isActive) {
        [self.cafeButton setAlpha:0.7f];
        [self.cafeButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        isActive = YES;
        
        [dataModel changeCategory:[sender tag]];
        //[dataModel.onTags addObject:dataModel.buttonTag];
    } else {
        [self.cafeButton setAlpha:1.0f];
        [self.cafeButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
        [dataModel deselectCategory:[sender tag]];
        [dataModel.onTags removeObject:dataModel.buttonTag];
        //[self.cleanPolylineDelegate cleanDeselectedCategory:[NSString stringWithFormat:@"%d", [sender tag]]];
    }}

- (IBAction)shopsButtonPressed:(id)sender {
    
    static BOOL isActive = NO;
    if (!isActive) {
        [self.shopsButton setAlpha:0.7f];
        [self.shopsButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        isActive = YES;
        
         [dataModel changeCategory:[sender tag]];
        //[dataModel.onTags addObject:dataModel.buttonTag];
    } else {
        [self.shopsButton setAlpha:1.0f];
        [self.shopsButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
        [dataModel deselectCategory:[sender tag]];
        [dataModel.onTags removeObject:dataModel.buttonTag];
        //[self.cleanPolylineDelegate cleanDeselectedCategory:[NSString stringWithFormat:@"%d", [sender tag]]];
    }}



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
