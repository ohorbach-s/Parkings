//
//  StolenBicycleDetailVC.m
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "StolenBicycleDetailVC.h"
#import "AddStolenBike.h"
#import <QuartzCore/QuartzCore.h>

@interface StolenBicycleDetailVC ()
{
    CGSize screenSize;
    UIView *fullScreenView;
    UIImageView *fullScreenPhoto;
    CGAffineTransform *portraitOrientation;
    CGFloat imageRatio;
}

@end

@implementation StolenBicycleDetailVC
@synthesize detailToDisplay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([detailToDisplay[@"udid"] isEqualToString:[UIDevice currentDevice].identifierForVendor.UUIDString]) {
        self.editButton.hidden = NO;
        self.deleteButton.hidden = NO;
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
    self.title = NSLocalizedString(@"Bicycle details", nil);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = NSLocalizedString(@"Stolen bicycle details", nil);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kyiv"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateString = [dateFormatter stringFromDate: detailToDisplay[@"date"]];
    self.dateLabel.text = dateString;
    self.addressLabel.text = detailToDisplay[@"address"];
    self.modelLabel.text = detailToDisplay[@"model"];
    self.descriptionTextView.text = detailToDisplay[@"description"];
    if (detailToDisplay[@"photo"] != nil) {
        self.stolenBicyclePhoto.image = [UIImage imageWithData:detailToDisplay[@"photo"]];
    } else {
        self.stolenBicyclePhoto.image = [UIImage imageNamed:@"noPhoto.jpg"];
    }
}

- (void)alertOKCancelAction {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Are you sure you want to delete this post?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if(alert.tag == 1 && buttonIndex != alert.cancelButtonIndex)
    {
        [detailToDisplay deleteInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getScreenSize{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
}

- (IBAction)showPhotoInFullScreen:(id)sender {
    if (self.stolenBicyclePhoto.image != [UIImage imageNamed:@"noPhoto.jpg"]) {
        [self getScreenSize];
        fullScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        fullScreenView.backgroundColor = [UIColor blackColor];
        fullScreenView.userInteractionEnabled = NO;
        self.navigationController.navigationBarHidden = YES;
        [self.view addSubview:fullScreenView];
        
        UIImage *imageToDisplay = [UIImage imageWithData:detailToDisplay[@"photo"]];
        imageRatio = imageToDisplay.size.width/imageToDisplay.size.height;
        fullScreenPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.width/imageRatio)];
        fullScreenPhoto.center = CGPointMake(screenSize.width/2, screenSize.height/2);
        fullScreenPhoto.image = imageToDisplay;
        [fullScreenView addSubview:fullScreenPhoto];
        UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280.f, 40.f)];
        UIFont *customFont = [[UIFont alloc] init];
        if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"uk"]) {
            customFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
        } else {
            customFont = [UIFont fontWithName:@"HelveticaNeue" size:25];
        }
        hint.text = NSLocalizedString(@"Double tap to close", nil);
        hint.backgroundColor = [UIColor grayColor];
        hint.textColor = [UIColor whiteColor];
        hint.font = customFont;
        [self boldFontForLabel:hint];
        hint.center = CGPointMake(screenSize.width/2, screenSize.height/2);
        hint.textAlignment = NSTextAlignmentCenter;
        hint.clipsToBounds = YES;
        [[hint layer] setCornerRadius:10];
        [fullScreenView addSubview:hint];
        self.descriptionTextView.userInteractionEnabled = NO;
        self.showPhotoInFullScreen.enabled = NO;
        self.editButton.enabled = NO;
        self.deleteButton.enabled = NO;
        hint.alpha = 0.8;
        [UIView animateWithDuration:2
                              delay:1
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             hint.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [hint removeFromSuperview];
                         }];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
    CGAffineTransform scale = CGAffineTransformMakeScale(1.f, 1.f);
    CGFloat heightRelation;
    
    if ( orientation == UIDeviceOrientationLandscapeLeft ){
        heightRelation = fullScreenView.frame.size.width / fullScreenPhoto.frame.size.height;
        rotation = CGAffineTransformMakeRotation(M_PI_2);
        scale = CGAffineTransformMakeScale(heightRelation, heightRelation);
    }
    else if ( orientation == UIDeviceOrientationLandscapeRight ){
        heightRelation = fullScreenView.frame.size.width / fullScreenPhoto.frame.size.height;
        rotation = CGAffineTransformMakeRotation(-M_PI_2);
        scale = CGAffineTransformMakeScale(heightRelation, heightRelation);
    }
    else if ( orientation == UIDeviceOrientationPortraitUpsideDown ){
        rotation = CGAffineTransformMakeRotation(M_PI);
        scale = CGAffineTransformMakeScale(1.f, 1.f);
        NSLog(@"%.0f X %.0f", fullScreenPhoto.frame.size.width, fullScreenPhoto.frame.size.height);
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fullScreenPhoto.transform = CGAffineTransformConcat(rotation, scale);
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)boldFontForLabel:(UILabel *)label{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    if (touch.tapCount == 2) {
        [fullScreenView removeFromSuperview];
        self.navigationController.navigationBarHidden = NO;
        self.descriptionTextView.userInteractionEnabled = YES;
        self.showPhotoInFullScreen.enabled = YES;
        self.editButton.enabled = YES;
        self.deleteButton.enabled = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (IBAction)editButtonAction:(id)sender {
}

- (IBAction)deleteButtonAction:(id)sender {
    [self alertOKCancelAction];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddStolenBike *passData = [[AddStolenBike alloc] init];
    passData = [segue destinationViewController];
    passData.detailsToEdit = detailToDisplay;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


@end













;