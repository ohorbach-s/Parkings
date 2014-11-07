//
//  DetailAboutStolenBicycleViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DetailAboutStolenBicycleViewController.h"

@interface DetailAboutStolenBicycleViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detaiStolenPhoto;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailStolenLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelDetailStolenLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateDetailStolenLabel;
@property (weak, nonatomic) IBOutlet UITextView *dascriptionDetailStolenTextview;

@end

@implementation DetailAboutStolenBicycleViewController

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
    self.detaiStolenPhoto.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stolen.jpg"]];
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
