//
//  TableViewController.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuViewController.h"
#import "MapSingletone.h"
#import "BigDetailPanel.h"

@interface TableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *places;
@property (strong, nonatomic) IBOutlet BigDetailPanel *bigDetailPanel;

- (IBAction)route:(UIButton *)sender;
- (IBAction)pressInfoButton:(UIButton *)sender;


@end
