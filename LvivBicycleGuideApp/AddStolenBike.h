//
//  AddStolenBike.h
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddStolenBike : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewAboveScrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)hideKeyboardButton:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)post:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)cancelButton:(id)sender;

@property (strong, nonatomic) PFObject *detailsToEdit;

@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
