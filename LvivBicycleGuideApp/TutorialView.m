//
//  TutorialView.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/16/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "TutorialView.h"

@interface TutorialView ()
{
    int countGestures;
}
@property (weak, nonatomic) IBOutlet UILabel *tutorialText;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage;
@property (weak, nonatomic) IBOutlet UIImageView *innerImage;
@property (weak, nonatomic) IBOutlet UIView *backgroundTextView;

@end

@implementation TutorialView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender {
    static int count = 0;
    count ++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TutorialData" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.tutorialTexts = [dict objectForKey:@"Description"];
    self.tutorialImages = [dict objectForKey:@"Image"];
    [self.tutorialText.layer setCornerRadius:15.0f];
    [self.backgroundTextView.layer setCornerRadius:15.0f];
    self.tutorialImage.image = [UIImage imageNamed: @"111.png"];
    self.tutorialText.text = NSLocalizedString([_tutorialTexts objectAtIndex:0], nil);
    UISwipeGestureRecognizer *gestureRecognizerToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(proceed:)];
    [gestureRecognizerToLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizerToLeft];
    UISwipeGestureRecognizer *gestureRecognizerToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rewindTutorial:)];
    [gestureRecognizerToRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizerToRight];
    countGestures = 0;

}
- (IBAction)proceedButton:(id)sender {
    if (countGestures > [_tutorialImages count]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
    self.tutorialText.text = NSLocalizedString([_tutorialTexts objectAtIndex:countGestures], nil);
    }
}

-(void)proceed :(UISwipeGestureRecognizer*) recognizer
{
    if (countGestures == [_tutorialImages count]-1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        countGestures = 0;
    } else {
        countGestures++;
        [self swipeEffect:[UIImage imageNamed:[_tutorialImages objectAtIndex:countGestures]] :kCATransitionFromRight];
        self.tutorialText.text = NSLocalizedString([_tutorialTexts objectAtIndex:countGestures], nil);
    }
}

-(void)rewindTutorial: (UISwipeGestureRecognizer*) recognizer
{
  if (countGestures == 0)
  {
      [self dismissViewControllerAnimated:YES completion:nil];
  } else {
      countGestures--;
      [self swipeEffect:[UIImage imageNamed:[_tutorialImages objectAtIndex:countGestures]] :kCATransitionFromLeft];
      self.tutorialText.text = NSLocalizedString([_tutorialTexts objectAtIndex:countGestures], nil);
  }

}

- (IBAction)exitTutorial:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    countGestures = 0;
}

-(void)swipeEffect: (UIImage*) pendingImage :(NSString *)transitionType
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:transitionType];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.innerImage.image = pendingImage;
    [[self.innerImage layer] addAnimation:animation forKey:@"showSecondViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
