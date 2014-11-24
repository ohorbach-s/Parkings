//
//  WriteComplaintViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "WriteComplaintViewController.h"
#import "PlaceDetailInfo.h"
#import "DataModel.h"

@interface WriteComplaintViewController ()
{
    DataModel *dataModel;
}

@property (weak, nonatomic) IBOutlet UITextField *complaintSubjectTextfield;
@property (weak, nonatomic) IBOutlet UITextView *complaintDescriptionTextview;
@property (weak, nonatomic) IBOutlet UILabel *likeDislikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end

@implementation WriteComplaintViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    dataModel = [DataModel sharedModel];
    [self setSettingsOfApplication];
}

-(void)setSettingsOfApplication
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]]];
    self.likeDislikeLabel.text = @"Dislike";
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
    self.likeDislikeLabel.text = @"Dislike";
}

- (IBAction)tapOnLikeButton:(id)sender
{
   self.likeDislikeLabel.text = @"Like";
}

- (IBAction)tapOnPostButton:(id)sender
{
    if(!([self.complaintSubjectTextfield.text isEqual: @""]) && ![self.complaintDescriptionTextview.text isEqual: @""]){
        NSDate *dateOfComment = [NSDate date];
        PFObject *myComment = [PFObject objectWithClassName:@"Comments"];
        myComment[@"content"] = self.complaintDescriptionTextview.text;
        myComment[@"subject"] = self.complaintSubjectTextfield.text;
        myComment[@"likeDislike"] = self.likeDislikeLabel.text;
        myComment[@"Date"] = dateOfComment;
        [dataModel.arrangedEnglishPlaces enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                                          usingBlock:^(id key, id object, BOOL *stop) {
                                                              for(PFObject *arrayElement in object){
                                                                  if  ([arrayElement[@"address"] isEqualToString:dataModel.infoForMarker.address]) {
                                                                      myComment[@"parent"] = arrayElement;
                                                                      [myComment saveInBackground];
                                                                  }
                                                              }
                                                          }];
        [dataModel.arrangedUkrainianPlaces enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                                                 usingBlock:^(id key, id object, BOOL *stop) {
                                                                     for(PFObject *arrayElement in object){
                                                                         if  ([arrayElement[@"address"] isEqualToString:dataModel.infoForMarker.address]) {
                                                                             myComment[@"parent"] = arrayElement;
                                                                             [myComment saveInBackground];
                                                                         }
                                                                     }
                                                                 }];
    } else {
        UIAlertView *message = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"Incomplete Data", nil)
                                message:NSLocalizedString(@"Fill in all fields", nil)
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                otherButtonTitles:nil];
        [message show];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
}
@end
