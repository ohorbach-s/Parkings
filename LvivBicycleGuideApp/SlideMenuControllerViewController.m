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
    DataModel *dataModel;
    NSMutableArray *buttons;
    BOOL isParkingActive;
    UIButton *parkButton;
    UIButton *shopButton;
    UIButton *cafeButton;
    UIButton *supermarketButton;
    UIButton *customRouteButton;
}

@property (weak, nonatomic) IBOutlet UIButton *stolenButton;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
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
    isParkingActive = NO;
    buttons = [[NSMutableArray alloc] init];
    [self setAppearance];
    dataModel = [DataModel sharedModel];
    [self createButtons];
    [self parkAction];
}

-(void)createButtons
{
    parkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    parkButton.backgroundColor = [UIColor colorWithRed:14/255.0f green:70/255.0f blue:255/255.0f alpha:1.0f];
    [parkButton setTag:0];
    [parkButton.layer setCornerRadius:15.0f];
    [parkButton.layer setShadowOpacity:50.0f];
    [parkButton.layer setShadowRadius:5.0f];
    [parkButton.layer setFrame:CGRectMake(10.0, 57.0, 119.0, 119.0)];
    [parkButton setBackgroundImage:[UIImage imageNamed:@"parking2.png"] forState:UIControlStateNormal];
    [parkButton addTarget:self action:@selector(parkAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:parkButton];
    
    shopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shopButton.backgroundColor = [UIColor colorWithRed:11/255.0f green:147/255.0f blue:29/255.0f alpha:1.0f];
    [shopButton setTag:1];
    [shopButton.layer setCornerRadius:15.0f];
    [shopButton.layer setShadowOpacity:50.0f];
    [shopButton.layer setShadowRadius:5.0f];
    [shopButton.layer setFrame:CGRectMake(135.0, 57.0, 119.0, 119.0)];
    [shopButton setBackgroundImage:[UIImage imageNamed:@"shop2.png"] forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopButton];
    
    cafeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cafeButton.backgroundColor = [UIColor colorWithRed:255/255.0f green:150/255.0f blue:6/255.0f alpha:1.0f];
    [cafeButton setTag:2];
    [cafeButton.layer setCornerRadius:15.0f];
    [cafeButton.layer setShadowOpacity:50.0f];
    [cafeButton.layer setShadowRadius:5.0f];
    [cafeButton.layer setFrame:CGRectMake(10.0, 185.0, 119.0, 119.0)];
    [cafeButton setBackgroundImage:[UIImage imageNamed:@"cafe2.png"] forState:UIControlStateNormal];
    [cafeButton addTarget:self action:@selector(cafeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cafeButton];
    
    supermarketButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    supermarketButton.backgroundColor = [UIColor colorWithRed:42/255.0f green:230/255.0f blue:235/255.0f alpha:1.0f];
    [supermarketButton setTag:3];
    [supermarketButton.layer setCornerRadius:15.0f];
    [supermarketButton.layer setShadowOpacity:50.0f];
    [supermarketButton.layer setShadowRadius:5.0f];
    [supermarketButton.layer setFrame:CGRectMake( 135.0, 185.0, 119.0, 119.0)];
    [supermarketButton setBackgroundImage:[UIImage imageNamed:@"supermarket2.png"] forState:UIControlStateNormal];
    [supermarketButton addTarget:self action:@selector(supermarketAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:supermarketButton];
    
    customRouteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    customRouteButton.backgroundColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:27/255.0f alpha:1.0f];
    [customRouteButton.layer setCornerRadius:15.0f];
    [customRouteButton.layer setShadowOpacity:50.0f];
    [customRouteButton.layer setShadowRadius:5.0f];
    [customRouteButton.layer setFrame:CGRectMake( 10.0, 442.0, 119.0, 119.0)];
    [customRouteButton setBackgroundImage:[UIImage imageNamed:@"custom_route.png"] forState:UIControlStateNormal];
    [customRouteButton addTarget:self action:@selector(customRouteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customRouteButton];
}

-(void)parkAction
{
    if (!isParkingActive) {
        [parkButton setAlpha:0.7f];
        [parkButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [parkButton.layer setBounds:CGRectMake(parkButton.layer.position.x, parkButton.layer.position.y, 105.0, 105.0)];
        [buttons addObject:parkButton];
        isParkingActive = YES;
        [dataModel changeCategory:0];
    } else {
        [parkButton setAlpha:1.0f];
        [parkButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isParkingActive = NO;
        [parkButton.layer setBounds:CGRectMake(parkButton.layer.position.x, parkButton.layer.position.y, 119.0, 119.0)];
        [buttons removeObject:parkButton];
        [dataModel.onTags removeObject:dataModel.buttonTag];
        [dataModel deselectCategory:0];
    }
}

-(void)shopAction
{
    static BOOL isActive = NO;
    if (!isActive) {
        [shopButton setAlpha:0.7f];
        [shopButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [shopButton.layer setBounds:CGRectMake(shopButton.layer.position.x, shopButton.layer.position.y, 105.0, 105.0)];
        [buttons addObject:shopButton];
        isActive = YES;
        [dataModel changeCategory:1];
    } else {
        [shopButton setAlpha:1.0f];
        [shopButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [shopButton.layer setBounds:CGRectMake(shopButton.layer.position.x, shopButton.layer.position.y, 119.0, 119.0)];
        [buttons removeObject:shopButton];
        isActive = NO;
        [dataModel deselectCategory:1];
        [dataModel.onTags removeObject:dataModel.buttonTag];
    }
}
-(void)cafeAction
{
    static BOOL isActive = NO;
    if (!isActive) {
        [cafeButton setAlpha:0.7f];
        [cafeButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [cafeButton.layer setBounds:CGRectMake(cafeButton.layer.position.x, cafeButton.layer.position.y, 105.0, 105.0)];
        [buttons addObject:cafeButton];
        isActive = YES;
        [dataModel changeCategory:2];
    } else {
        [cafeButton setAlpha:1.0f];
        [cafeButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [cafeButton.layer setBounds:CGRectMake(cafeButton.layer.position.x, cafeButton.layer.position.y, 119.0, 119.0)];
        [buttons removeObject:cafeButton];
        isActive = NO;
        [dataModel deselectCategory:2];
        [dataModel.onTags removeObject:dataModel.buttonTag];
    }
}

-(void)supermarketAction
{
    static BOOL isActive = NO;
    if (!isActive) {
        [supermarketButton setAlpha:0.7f];
        [supermarketButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [supermarketButton.layer setBounds:CGRectMake(supermarketButton.layer.position.x, supermarketButton.layer.position.y, 105.0, 105.0)];
        isActive = YES;
        [buttons addObject:supermarketButton];
        [dataModel changeCategory:3];
    } else {
        [supermarketButton setAlpha:1.0f];
        [supermarketButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        isActive = NO;
        [supermarketButton.layer setBounds:CGRectMake(supermarketButton.layer.position.x, supermarketButton.layer.position.y, 119.0, 119.0)];
        [buttons removeObject:supermarketButton];
        [dataModel deselectCategory:3];
        [dataModel.onTags removeObject:dataModel.buttonTag];
    }
    
}
-(void)setButtonInteractivity:(BOOL)decision
{
    [parkButton setUserInteractionEnabled:decision];
    [shopButton setUserInteractionEnabled:decision];
    [cafeButton setUserInteractionEnabled:decision];
    [supermarketButton setUserInteractionEnabled:decision];
}

-(void)customRouteAction
{
    static BOOL isActive = NO;
    if (!isActive) {
        [customRouteButton setAlpha:0.7f];
        [customRouteButton.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [customRouteButton.layer setBounds:CGRectMake(customRouteButton.layer.position.x, customRouteButton.layer.position.y, 105.0, 105.0)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mapForCustomRoute" object:nil];
        [self setButtonInteractivity:NO];
        for (UIButton *button in buttons) {
            [button setAlpha:1.0f];
            [button.layer setShadowColor:[[UIColor blackColor] CGColor]];
            isActive = NO;
            [button.layer setBounds:CGRectMake(supermarketButton.layer.position.x, supermarketButton.layer.position.y, 119.0, 119.0)];
        }
        isActive = YES;
    } else {
        [customRouteButton setAlpha:1.0f];
        [customRouteButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self setButtonInteractivity:YES];
        for (UIButton *button in buttons) {
            [button setAlpha:0.7f];
            [button.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            [button.layer setBounds:CGRectMake(supermarketButton.layer.position.x, supermarketButton.layer.position.y, 105.0, 105.0)];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showMarker" object:nil];
        isActive = NO;
        [customRouteButton.layer setBounds:CGRectMake(customRouteButton.layer.position.x, customRouteButton.layer.position.y, 119.0, 119.0)];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.stolenButton.layer setCornerRadius:15.0f];
    [self.stolenButton.layer setShadowOpacity:20.0f];
    [self.stolenButton.layer setShadowRadius:5.0f];
    [self.complaintButton.layer setCornerRadius:15.0f];
    [self.complaintButton.layer setShadowOpacity:20.0f];
    [self.complaintButton.layer setShadowRadius:5.0f];
    [self.helpButton.layer setCornerRadius:15.0f];
    [self.helpButton.layer setShadowOpacity:20.0f];
    [self.helpButton.layer setShadowRadius:5.0f];
}

@end
