//
//  DetailTVC.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAShareBubbles.h"
#import "SNSNetworkFactory.h"

@interface DetailTVC : UITableViewController<GMSMapViewDelegate, AAShareBubblesDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) id<SNSSocialNetwork,VKSdkDelegate> some;

@end
