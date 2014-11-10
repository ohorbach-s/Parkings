//
//  TableViewCell.h
//  LvivBicycleGuideApp
//
//  Created by Admin on 23.10.14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeType;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UIButton *routeToPlace;
@property (weak, nonatomic) IBOutlet UIButton *infoAboutPlace;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
