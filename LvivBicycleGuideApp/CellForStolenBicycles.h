//
//  CellForStolenBicycles.h
//  LvivBicycleGuideApp
//
//  Created by Admin on 10.11.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellForStolenBicycles : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stolenBicyclePhoto;
@property (weak, nonatomic) IBOutlet UILabel *stolenBicycleModel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfCrime;

@end
