//
//  SlideMenuViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/24/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "PlaceCategory.h"
#import "MapSingletone.h"
//#import "DataModel.h"

@protocol MenuPassDelegate <NSObject>
    
-(void)setCategoryValue :(NSString*)value;


@end

@interface SlideMenuViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSString *selectedCategoryOfDisplayedObjects;
@property (weak, nonatomic)id<MenuPassDelegate>delegate;
-(void)setIndexValueWithCompletion :(void(^)(NSInteger))completion;
-(void)passCategoryStringWithBlock: (void(^)(NSString*))comletion;
@end
