//
//  StolenBicycleDetailVC.h
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StolenBicycleDetailVC : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *stolenBicyclePhoto;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) PFObject *detailToDisplay;
@property (weak, nonatomic) IBOutlet UIButton *showPhotoInFullScreen;

- (IBAction)showPhotoInFullScreen:(id)sender;
- (IBAction)editButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;

@end
