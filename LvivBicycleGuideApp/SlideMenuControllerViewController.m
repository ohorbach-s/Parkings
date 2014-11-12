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
    DataModel *dataModel;
}

@property (weak, nonatomic) IBOutlet UIButton *parkingButton;
@property (weak, nonatomic) IBOutlet UIButton *supermarketsButton;
@property (weak, nonatomic) IBOutlet UIButton *cafeButton;
@property (weak, nonatomic) IBOutlet UIButton *shopsButton;
@property (weak, nonatomic) IBOutlet UIButton *stolenButton;
@property (weak, nonatomic) IBOutlet UIButton *rentalButton;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;

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
    [self.stolenButton.layer setCornerRadius:15.0f];
    [self.stolenButton.layer setShadowOpacity:20.0f];
    [self.stolenButton.layer setShadowRadius:5.0f];
    [self.rentalButton.layer setCornerRadius:15.0f];
    [self.rentalButton.layer setShadowOpacity:20.0f];
    [self.rentalButton.layer setShadowRadius:5.0f];
    [self.complaintButton.layer setCornerRadius:15.0f];
    [self.complaintButton.layer setShadowOpacity:20.0f];
    [self.complaintButton.layer setShadowRadius:5.0f];
    
}

- (IBAction)supermarketsButtonPressed:(id)sender {
    
    static BOOL isActive = NO;
    if (!isActive) {
        [self.supermarketsButton setAlpha:0.7f];
        [self.supermarketsButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [self.supermarketsButton setBounds:CGRectMake(self.supermarketsButton.layer.position.x, self.supermarketsButton.layer.position.y, 105.0, 105.0)];
        isActive = YES;
        [dataModel changeCategory:[sender tag]];
    } else {
        [self.supermarketsButton setAlpha:1.0f];
        [self.supermarketsButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
        [self.supermarketsButton setBounds:CGRectMake(self.supermarketsButton.layer.position.x, self.supermarketsButton.layer.position.y, 119.0, 119.0)];
        [dataModel deselectCategory:[sender tag]];
        [dataModel.onTags removeObject:dataModel.buttonTag];
    }
}

- (IBAction)parkingButtonPressed:(id)sender {
    static BOOL isActive = NO;
    if (!isActive) {
        [self.parkingButton setAlpha:0.7f];
        [self.parkingButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [self.parkingButton setBounds:CGRectMake(self.parkingButton.layer.position.x, self.parkingButton.layer.position.y, 105.0, 105.0)];
        isActive = YES;
        [dataModel changeCategory:[sender tag]];
    } else {
        [self.parkingButton setAlpha:1.0f];
        [self.parkingButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
        [self.parkingButton setBounds:CGRectMake(self.parkingButton.layer.position.x, self.parkingButton.layer.position.y, 119.0, 119.0)];
        [dataModel.onTags removeObject:dataModel.buttonTag];
        [dataModel deselectCategory:[sender tag]];
    }
}

- (IBAction)cafeButtonPressed:(id)sender {
    static BOOL isActive = NO;
    if (!isActive) {
        [self.cafeButton setAlpha:0.7f];
        [self.cafeButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [self.cafeButton setBounds:CGRectMake(self.cafeButton.layer.position.x, self.cafeButton.layer.position.y, 105.0, 105.0)];
        isActive = YES;
        [dataModel changeCategory:[sender tag]];
    } else {
        [self.cafeButton setAlpha:1.0f];
        [self.cafeButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.cafeButton setBounds:CGRectMake(self.cafeButton.layer.position.x, self.cafeButton.layer.position.y, 119.0, 119.0)];
        isActive = NO;
        [dataModel deselectCategory:[sender tag]];
        [dataModel.onTags removeObject:dataModel.buttonTag];
    }}

- (IBAction)shopsButtonPressed:(id)sender {
    
    static BOOL isActive = NO;
    if (!isActive) {
        [self.shopsButton setAlpha:0.7f];
        [self.shopsButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [self.shopsButton setBounds:CGRectMake(self.shopsButton.layer.position.x, self.shopsButton.layer.position.y, 105.0, 105.0)];
        isActive = YES;
        [dataModel changeCategory:[sender tag]];
    } else {
        [self.shopsButton setAlpha:1.0f];
        [self.shopsButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.shopsButton setBounds:CGRectMake(self.shopsButton.layer.position.x, self.shopsButton.layer.position.y, 119.0, 119.0)];
        isActive = NO;
        [dataModel deselectCategory:[sender tag]];
        [dataModel.onTags removeObject:dataModel.buttonTag];
    }}

@end
