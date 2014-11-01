//
//  SmallDetaiPanel.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "ILTranslucentView.h"

@interface SmallDetaiPanel : ILTranslucentView

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

- (IBAction)pressRouteButton:(id)sender;
-(void)setDetail :(NSString*) acceptedName :(float)lon :(float) lat;

@end

