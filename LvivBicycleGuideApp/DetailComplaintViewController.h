//
//  DetailComplaintViewController.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/7/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentComplaint.h"

@interface DetailComplaintViewController : UIViewController

@property (nonatomic, strong) NSDictionary *complaint;
@property (nonatomic,strong)NSString *address;

@end
