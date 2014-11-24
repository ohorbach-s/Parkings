//
//  DetailTVC.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DetailTVC.h"
#import "PlaceCategories.h"
#import "ComplaintTableViewController.h"

@interface DetailTVC (){
        AAShareBubbles *bubles;
        SNSNetworkFactory* networkFactory;
        CLLocationCoordinate2D particularPosition;
        GMSMarker *markerToParticularObject;
 }

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *smallMapView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;

@end

@implementation DetailTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    networkFactory=[SNSNetworkFactory new];
    [self setSettingsOfApplication];
    
}

//visual settings
-(void)setSettingsOfApplication
{
    self.complaintButton.clipsToBounds = YES;
    [self.complaintButton.layer setCornerRadius:15.0f];
    self.smallMapView.delegate = self;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:6/255.0f green:118/255.0f blue:0/255.0f alpha:1.0f];
}

//VK
- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
	[self presentViewController:controller animated:YES completion:nil];
}

//Done button
- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Pass info in Complaint Controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToComplaint"])
    {
        UINavigationController *navigationController =segue.destinationViewController;
        ComplaintTableViewController *complaints =[[navigationController viewControllers] objectAtIndex:0];
        complaints.complaintAddress = self.sentDetails.address;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setUpDetailsInTable];
}


-(void)setUpDetailsInTable
{
    self.nameLabel.text = self.sentDetails.name;
    self.addressLabel.text = self.sentDetails.address;
    self.descriptionTextView.text = self.sentDetails.description;
    particularPosition = CLLocationCoordinate2DMake([self.sentDetails.latitude floatValue], [self.sentDetails.longtitude floatValue]);
    markerToParticularObject = [GMSMarker markerWithPosition:particularPosition];
    markerToParticularObject.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.sentDetails.type]];
    markerToParticularObject.map = self.smallMapView ;
    [self.smallMapView.settings setAllGesturesEnabled:NO];
    [self.smallMapView.layer setCornerRadius:15.0f];
    [self.smallMapView.layer setBorderWidth:1.5f];
    [self.smallMapView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.smallMapView animateToLocation:particularPosition];
    [self.smallMapView  animateToZoom:16];

}

//SN
-(IBAction)Share:(id)sender
{
    bubles=[[AAShareBubbles alloc]initWithPoint:self.tableView.center radius:80 inView:self.tableView];
    bubles.delegate=self;
    bubles.radius=80;
    bubles.showTwitterBubble=YES;
    bubles.showVkBubble=YES;
    bubles.showGooglePlusBubble=YES;
    bubles.showFacebookBubble=YES;
    [bubles show];
 }

//ShareBubbles settings
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    SNSSocialNetworkType type = SNSSocialNetworkTypeFacebook;
    switch(bubbleType)
    {
        case AAShareBubbleTypeFacebook: type=SNSSocialNetworkTypeFacebook; break;
        case AAShareBubbleTypeTwitter: type=SNSSocialNetworkTypeTwitter; break;
        case AAShareBubbleTypeVk: type=SNSSocialNetworkTypeVkontakte;   break;
        case AAShareBubbleTypeGooglePlus: type=SNSSocialNetworkTypeGooglePlus; break;
    }
    id socialNetwork= [networkFactory getNetwork:type];
    self.some=socialNetwork;
    [socialNetwork share:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
