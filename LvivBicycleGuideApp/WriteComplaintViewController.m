//
//  WriteComplaintViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "WriteComplaintViewController.h"
#import "CurrentComplaint.h"
#import "DataModel.h"

@interface WriteComplaintViewController ()
{
    NSString *like;
    NSString *dislike;
    DataModel *dataModel;
}

@property (weak, nonatomic) IBOutlet UITextField *complaintSubjectTextfield;
@property (weak, nonatomic) IBOutlet UITextView *complaintDescriptionTextview;
@property (weak, nonatomic) IBOutlet UILabel *likeDislikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) CurrentComplaint *complaint;

@end

@implementation WriteComplaintViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]]];
    like = @"Like";
    dislike = @"Dislike";
    self.likeDislikeLabel.text = dislike;
    dataModel = [DataModel sharedModel];
    [self.postButton.layer setCornerRadius:8.0f];
    [self.postButton.layer setShadowOpacity:50.0f];
    [self.postButton.layer setShadowRadius:5.0f];
    [self.complaintDescriptionTextview.layer setCornerRadius:10.0f];
    [self.complaintDescriptionTextview.layer setShadowOpacity:35.0f];
    [self.complaintDescriptionTextview.layer setShadowRadius:5.0f];
    [self.complaintDescriptionTextview.layer setBackgroundColor:[[UIColor colorWithRed:204/255.0f green:245/255.0f blue:107/255.0f alpha:1.0f]CGColor]];
}

- (IBAction)tapOnDislikeButton:(id)sender
{
    self.complaint.likeDislike = NO;
    self.likeDislikeLabel.text = dislike;
}

- (IBAction)tapOnLikeButton:(id)sender
{
    self.complaint.likeDislike = YES;
    self.likeDislikeLabel.text = like;
}

- (IBAction)tapOnPostButton:(id)sender
{
    if(!([self.complaintSubjectTextfield.text isEqual: @""]) && ![self.complaintDescriptionTextview.text isEqual: @""]){
        self.complaint = [[CurrentComplaint alloc] init];
        self.complaint.complaintSubject = self.complaintSubjectTextfield.text;
        self.complaint.complaintDescription = self.complaintDescriptionTextview.text;
        self.complaint.likeDislike = self.likeDislikeLabel.text == like  ? YES : NO;
        self.complaint.address = dataModel.infoForMarker.address;
        [dataModel.arrangedPlaces enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                                          usingBlock:^(id key, id object, BOOL *stop) {
                                                              for(PFObject *arrayElement in object){
                                                                  if (arrayElement[@"comment"]) {
                                                                  }
                                                                if  ([arrayElement[@"address"] isEqualToString:dataModel.infoForMarker.address]){
                                                                      if(!arrayElement[@"comment"]) {
                                                                          arrayElement[@"comment"] = [[NSMutableArray alloc] init];
                                                                      }
                                                                      [arrayElement[@"comment"] addObject:self.complaint];
                                                                      [arrayElement saveInBackground];
                                                                  }
                                                                }
                                                          }];
    } else {
        UIAlertView *message = [[UIAlertView alloc]
                                initWithTitle:@"Incomplete Data"
                                message:@"Fill in all fields"
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.complaintSubjectTextfield.isFirstResponder) {
        [self.complaintSubjectTextfield resignFirstResponder];
    }
    if (self.complaintDescriptionTextview.isFirstResponder) {
        [self.complaintDescriptionTextview resignFirstResponder];
    }
    
}

- (IBAction)tapOnView:(UITapGestureRecognizer *)sender {
    if (self.complaintSubjectTextfield.isFirstResponder) {
        [self.complaintSubjectTextfield resignFirstResponder];
    }
    if (self.complaintDescriptionTextview.isFirstResponder) {
        [self.complaintDescriptionTextview resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
