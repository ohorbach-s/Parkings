//
//  DetailComplaintViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/7/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DetailComplaintViewController.h"
#import "DataModel.h"

@interface DetailComplaintViewController ()
{
    DataModel *dataModel;
}
@property (weak, nonatomic) IBOutlet UILabel *complaintHeader;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailComplaintLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionDetailComplaintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionDetailComplaintImage;

@end

@implementation DetailComplaintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]]];
    dataModel = [DataModel sharedModel];
    [self showDetailComplaintView];
}

-(void)showDetailComplaintView
{
    self.complaintHeader.text = self.complaint.complaintSubject;
    self.descriptionDetailComplaintLabel.text = self.complaint.complaintDescription;
    self.addressDetailComplaintLabel.text = dataModel.infoForMarker.address;
    self.descriptionDetailComplaintImage.image = self.complaint.likeDislike == YES  ? [UIImage imageNamed:@"like.png"] : [UIImage imageNamed:@"dislike.png"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
