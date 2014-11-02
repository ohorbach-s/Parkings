//
//  TableViewController.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BigDetailPanel;

@protocol TableRouteDelegate <NSObject>

-(void)findDirection:(float)markerLatitude :(float)markerLongitude;

@end

@interface TableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *places;
@property (strong, nonatomic) IBOutlet BigDetailPanel *bigDetailPanel;
@property (strong, nonatomic) id<TableRouteDelegate> delagate;

- (IBAction)route:(UIButton *)sender;
- (IBAction)pressInfoButton:(UIButton *)sender;
-(void)fillSubview:(NSNotification *)notification;
@end
