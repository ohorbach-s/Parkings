//
//  AdditionMenuViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "AdditionMenuViewController.h"
#import "ILTranslucentView.h"
#import "MapViewController.h"
@interface AdditionMenuViewController ()
@property (weak, nonatomic) IBOutlet ILTranslucentView *routeView;
@property (weak, nonatomic) IBOutlet ILTranslucentView *stolenView;
@property (weak, nonatomic) IBOutlet ILTranslucentView *complaintView;
- (IBAction)backButton:(id)sender;
- (IBAction)switchButton:(id)sender;

@end

@implementation AdditionMenuViewController

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
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
    
    _routeView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _routeView.translucentAlpha = 0.9;
    _routeView.translucentStyle = UIBarStyleDefault;
    _routeView.translucentTintColor = [UIColor clearColor];

    _stolenView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _stolenView.translucentAlpha = 0.9;
    _stolenView.translucentStyle = UIBarStyleDefault;
    _stolenView.translucentTintColor = [UIColor clearColor];
    
    _complaintView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _complaintView.translucentAlpha = 0.9;
    _complaintView.translucentStyle = UIBarStyleDefault;
    _complaintView.translucentTintColor = [UIColor clearColor];

    // Do any additional setup after loading the view.
}

-(void)setAppearance
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"greenbsck.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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
- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)switchButton:(id)sender {
  //  MapViewController *controller = [[[[[[[[[UIApplication sharedApplication] keyWindow] rootViewController] childViewControllers] objectAtIndex:1] childViewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0];
}


@end
