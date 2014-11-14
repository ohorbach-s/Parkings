//
//  AddNewRace.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceMap.h"

@interface AddNewRace : UIViewController <PathDelegate>
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;



-(void)setPath:(NSMutableArray *)encodedPathWithStartPosition :(GMSMarker*)startPosition andEndPosition:(GMSMarker*)endPosition;
@end
