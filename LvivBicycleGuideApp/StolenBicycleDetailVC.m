//
//  StolenBicycleDetailVC.m
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "StolenBicycleDetailVC.h"

@interface StolenBicycleDetailVC ()

@end

@implementation StolenBicycleDetailVC

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
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Stolen bicycle details", nil);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kyiv"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateString = [dateFormatter stringFromDate: _detailToDisplay[@"date"]];
    self.dateLabel.text = dateString;
    self.addressLabel.text = _detailToDisplay[@"address"];
    self.modelLabel.text = _detailToDisplay[@"model"];
    self.descriptionTextView.text = _detailToDisplay[@"description"];
    if (_detailToDisplay[@"photo"] != nil) {
        self.stolenBicyclePhoto.image = [UIImage imageWithData:_detailToDisplay[@"photo"]];
    } else {
        self.stolenBicyclePhoto.image = [UIImage imageNamed:@"noPhoto.jpg"];
    }
    if ([_detailToDisplay[@"udid"] isEqualToString:[UIDevice currentDevice].identifierForVendor.UUIDString]) {
        self.editButton.hidden = NO;
        self.deleteButton.hidden = NO;
    }
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonAction:(id)sender {
    NSLog(@"edit button");
}

- (IBAction)deleteButtonAction:(id)sender {
    NSLog(@"delete button");
}

- (IBAction)showPhotoInFullScreen:(id)sender {
    NSLog(@"full screen");
}
@end













