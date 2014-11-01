//
//  DataModel.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/30/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SlideMenuViewController.h"

@class DetailInfoClass;
@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *filteredObjects;
@property (nonatomic, strong) DetailInfoClass *infoForMarker;
-(void)setCategoryValue :(NSString*)value;
+ (id)sharedModel;
- (id)init ;
-(void) performFilterRenew :(NSString*)title;
-(void)setMarkerForInfo: (GMSMarker*)marker;
@end
