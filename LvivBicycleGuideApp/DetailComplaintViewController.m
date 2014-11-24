//
//  DetailComplaintViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/7/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DetailComplaintViewController.h"
//#import "DataModel.h"

@interface DetailComplaintViewController ()
{
    //DataModel *dataModel;
}
@property (weak, nonatomic) IBOutlet UILabel *complaintHeader;
@property (weak, nonatomic) IBOutlet UITextView *descriptionDetailComplaintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionDetailComplaintImage;

@end

@implementation DetailComplaintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSettingsOfApplication];
}

-(void)setSettingsOfApplication
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]]];
    [self showDetailComplaintView];
    [self.descriptionDetailComplaintLabel.layer setCornerRadius:10.0f];
    [self.descriptionDetailComplaintLabel.layer setShadowOpacity:35.0f];
    [self.descriptionDetailComplaintLabel.layer setShadowRadius:5.0f];
    [self.descriptionDetailComplaintLabel.layer setBackgroundColor:[[UIColor colorWithRed:204/255.0f green:245/255.0f blue:107/255.0f alpha:1.0f]CGColor]];
    [self.descriptionDetailComplaintLabel.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.descriptionDetailComplaintLabel.layer setBorderWidth:3.0f];
    [self.complaintHeader.layer setCornerRadius:10.0f];
    [self.complaintHeader.layer setShadowOpacity:35.0f];
    [self.complaintHeader.layer setShadowRadius:5.0f];
    [self.complaintHeader.layer setBackgroundColor:[[UIColor colorWithRed:204/255.0f green:245/255.0f blue:107/255.0f alpha:1.0f]CGColor]];
    [self.complaintHeader.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.complaintHeader.layer setBorderWidth:2.0f];
    self.descriptionDetailComplaintLabel.font = [UIFont fontWithName:@"System Bold" size:20.0f];

}

-(void)showDetailComplaintView
{
    self.complaintHeader.text = [self.complaint valueForKey:@"subject"];
    self.descriptionDetailComplaintLabel.text = [self.complaint valueForKey:@"content"];
    self.descriptionDetailComplaintImage.image = [[self.complaint valueForKey:@"likeDislike"] isEqualToString:@"Like"/*:@1*/] ? [UIImage imageNamed:@"like.png"] : [UIImage imageNamed:@"dislike.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
