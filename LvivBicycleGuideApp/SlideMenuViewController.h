//
//  SlideMenuViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "StorageClass.h"
#import "MapSingletone.h"

@interface SlideMenuViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSString *selectedCategoryOfDisplayedObjects;

-(void)setIndexValueWithCompletion :(void(^)(NSInteger))completion;

@end
