//
//  TableViewController.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BigInfoSubview;

@protocol TableRouteDelegate <NSObject>

-(void)findDirectionForLatitude:(float)markerLatitude AndLongitude:(float)markerLongitude;

@end

@interface TableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet BigInfoSubview *bigDetailPanel;
@property (strong, nonatomic) id<TableRouteDelegate> delagate;

- (IBAction)pressRouteButton:(UIButton *)sender;
- (IBAction)pressInfoButton:(UIButton *)sender;
- (void)fillSubview:(NSNotification *)notification;

-(void)reloadTableView: (NSNotification*)notification;

@end
