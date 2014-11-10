//
//  StolenDetailViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/6/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "WriteAboutStolenBiceViewController.h"

@interface WriteAboutStolenBiceViewController () {
    int pushButtonTime;
}
@property (weak, nonatomic) IBOutlet UITextField *stolenAddressTexfield;
@property (weak, nonatomic) IBOutlet UITextField *stolenModelTextfield;
@property (weak, nonatomic) IBOutlet UIDatePicker *stolenDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIImageView *stolenBImage;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIButton *datebutton;
@property (weak, nonatomic) IBOutlet UIButton *photobutton;

@end

@implementation WriteAboutStolenBiceViewController

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
    [self.stolenDatePicker setHidden:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]]];    // Do any additional setup after loading the view.
    [self.postButton.layer setCornerRadius:8.0f];
    [self.description.layer setCornerRadius:15.0f];
    [self.description.layer setBackgroundColor:[[UIColor colorWithRed:204/255.0f green:245/255.0f blue:107/255.0f alpha:1.0f] CGColor]];
    [self.datebutton.layer setCornerRadius:7.0f];
    [self.photobutton.layer setCornerRadius:7.0f];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    pushButtonTime = 0;
    [self.stolenDatePicker setHidden:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.stolenBImage.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)tapOnAddPhotoButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (IBAction)TapOnDateButton:(id)sender
{
    if(pushButtonTime == 0){
        
        [self.stolenDatePicker setHidden:NO];
        [self.dateButton setTitle:@"SET" forState:UIControlStateNormal];
        pushButtonTime = 1;
    }else{
        [self.stolenDatePicker setHidden:YES];
        [self.dateButton setTitle:@"Data" forState:UIControlStateNormal];
        pushButtonTime = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
