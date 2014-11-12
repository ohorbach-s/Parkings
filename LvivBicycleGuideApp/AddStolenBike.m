//
//  AddStolenBike.m
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "AddStolenBike.h"
#import <Parse/Parse.h>

@interface AddStolenBike (){
    UITextField *activeField;
}
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation AddStolenBike
@synthesize scrollView, descriptionTextView, imageView, datePicker,
addressTextField, modelTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerForKeyboardNotifications];
    [[self.descriptionTextView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:1];
    [[self.imageView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.imageView layer] setBorderWidth:1];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
}

#pragma mark - autoscrolling
//Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
    if (descriptionTextView.isFirstResponder && !CGRectContainsPoint(aRect, descriptionTextView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:descriptionTextView.frame animated:YES];
    }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - adding photo
- (IBAction)addPhoto:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
    NSLog(@"%.0f X %.0f", imageView.image.size.width, imageView.image.size.height);
}

- (IBAction)post:(id)sender {
    UIImage *resizedImage;
    CGSize newImageSize;
    CGFloat ratio = imageView.image.size.width/imageView.image.size.height;
    if (imageView.image.size.width > imageView.image.size.height) {
        newImageSize = CGSizeMake(1000.f, 1000.f/ratio);
        resizedImage = [self imageWithImage:imageView.image scaledToSize:newImageSize];
    } else {
        newImageSize = CGSizeMake(1000.f*ratio, 1000.f);
        resizedImage = [self imageWithImage:imageView.image scaledToSize:newImageSize];
    }
    //convert image to NSData & get it's size
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.1);
    if ([imageData length] > 127000) {
        UIAlertView *tooLargeAllert = [[UIAlertView alloc]
                                       initWithTitle:nil
                                       message:NSLocalizedString(@"The image's size is too large. Please select another image", nil)
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
        [tooLargeAllert show];
    } else {
        PFObject *stolenBicycle = [PFObject objectWithClassName:@"stolenBicycles"];
        stolenBicycle[@"date"] = datePicker.date;
        stolenBicycle[@"address"] = addressTextField.text;
        stolenBicycle[@"model"] = modelTextField.text;
        stolenBicycle[@"description"] = descriptionTextView.text;
        if (imageData != nil) {
            stolenBicycle[@"photo"] = imageData;
        }
        stolenBicycle[@"udid"] = [UIDevice currentDevice].identifierForVendor.UUIDString;
        if ([addressTextField.text isEqualToString:@""] ||
            [modelTextField.text isEqualToString:@""] ||
            [descriptionTextView.text isEqualToString:@""]) {
            UIAlertView *fillingIsNotComplete = [[UIAlertView alloc]
                                                 initWithTitle:nil
                                                 message:NSLocalizedString(@"Please fill in all the fields", nil)
                                                 delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [fillingIsNotComplete show];
        } else {
            [stolenBicycle saveInBackground];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//change image's size
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - hide keyboard
- (IBAction)hideKeyboard:(id)sender {
}

- (IBAction)hideKeyboardButton:(id)sender {
    [addressTextField resignFirstResponder];
    [modelTextField resignFirstResponder];
    [descriptionTextView resignFirstResponder];
}

#pragma mark - other methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end




