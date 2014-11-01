//
//  BigDetailPanel.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "BigDetailPanel.h"
#import "SNSFacebook.h"
#import "SNSTwitter.h"
#import "PlaceCategory.h"
#import "SlideMenuViewController.h"

@interface BigDetailPanel ()
{
    SLComposeViewController *composeController;
    GMSMarker *markerToParticularObject;
    CLLocationCoordinate2D particularPosition;
    PlaceCategory *storage;
    NSInteger indexOfCategory;
    SlideMenuViewController *menu;
}

@end

@implementation BigDetailPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (IBAction)Twitter:(id)sender
{
//    SNSTwitter *twitter =[[SNSTwitter alloc]init];
//    [twitter shareTwitter:storage.detailInfoForObject];
}
- (IBAction)facebook:(id)sender
{
//    SNSFacebook *facebook=[[SNSFacebook alloc]init];
//    [facebook shareFacebook:storage.detailInfoForObject];
}



-(void)setDataOfWindow : (DetailInfoClass*) infoForMarker {
    menu = [[SlideMenuViewController alloc] init];
    composeController =[[SLComposeViewController alloc]init];
    storage = [PlaceCategory sharedManager];
    [self.smallMap.settings setAllGesturesEnabled:NO];
    [menu setIndexValueWithCompletion:^(NSInteger index) {
        indexOfCategory = index;
           }];
    self.nameLabel.text = infoForMarker.name;
  self.bigAddressLabel.text = infoForMarker.address;
    self.description.text = infoForMarker.description;
    particularPosition = CLLocationCoordinate2DMake([infoForMarker.latitude floatValue], [infoForMarker.longtitude floatValue]);
    markerToParticularObject = [GMSMarker markerWithPosition:particularPosition];
    markerToParticularObject.icon = [UIImage imageNamed:storage.markersImages[indexOfCategory]];

    [_smallMap animateToLocation:particularPosition];
    [_smallMap animateToZoom:16];
    
    markerToParticularObject.map = _smallMap;
}

@end
