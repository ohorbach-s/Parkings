//
//  DisplayBicycleLines.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/10/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "DisplayBicycleLines.h"

@implementation DisplayBicycleLines

-(id) init
{
    if (self = [super init]) {
        self.arrayOfStartLocations = [[NSMutableArray alloc] init];
        self.arrayOfEndLocations = [[NSMutableArray alloc] init];
        self.arrayOfPoints = [[NSArray alloc] init];
    }
    return self;
}

-(void)loadLines
{
    PFQuery *queryTest = [PFQuery queryWithClassName:@"BicycleLines"];
    self.arrayOfPoints = [queryTest findObjects];
}
@end
