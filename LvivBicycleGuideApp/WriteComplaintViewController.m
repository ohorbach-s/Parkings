//
//  WriteComplaintViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "WriteComplaintViewController.h"

@interface WriteComplaintViewController ()
@property (weak, nonatomic) IBOutlet UITextField *womplaintAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *complaintSubjectTextfield;
@property (weak, nonatomic) IBOutlet UITextView *complaintDescriptionTextview;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WriteComplaintViewController

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
}
- (IBAction)tapOnGoButton:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imageView.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)addPhotoButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
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
