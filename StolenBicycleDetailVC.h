//
//  StolenBicycleDetailVC.h
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StolenBicycleDetailVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *stolenBicyclePhoto;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)showPhotoInFullScreen:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)editButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;

@property (strong, nonatomic) PFObject *detailToDisplay;




@end
