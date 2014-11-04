//
//  SmallDetaiPanel.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "ILTranslucentView.h"

@interface SmallInfoSubview : ILTranslucentView

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

-(void)setDetailWithName :(NSString*) acceptedName AndLongitude:(float)acceptedLongitude AndLatitude:(float) acceptedLatitude;

@end

