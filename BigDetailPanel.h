//
//  BigDetailPanel.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "ILTranslucentView.h"


@interface BigDetailPanel : ILTranslucentView<GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bigAddressLabel;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (assign, nonatomic) NSNumber *tableRowIndex;
@property (strong, nonatomic) IBOutlet GMSMapView *smallMap;

-(void)setDataOfWindow;
@end
