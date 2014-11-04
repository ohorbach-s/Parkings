//
//  BigDetailPanel.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "ILTranslucentView.h"
#import "PlaceDetailInfo.h"
#import "AAShareBubbles.h"
#import "SNSNetworkFactory.h"


@interface BigInfoSubview : ILTranslucentView <GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (assign, nonatomic) NSNumber *tableRowIndex;
@property (strong, nonatomic) IBOutlet GMSMapView *smallMap;
@property (strong, nonatomic) id<SNSSocialNetwork> some;

-(void)setDataOfWindow : (PlaceDetailInfo*) infoForMarker;

@end
