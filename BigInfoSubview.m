//
//  BigDetailPanel.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "BigInfoSubview.h"
#import "SNSFacebook.h"
#import "SNSTwitter.h"
#import "PlaceCategories.h"
#import "SlideMenuViewController.h"

@interface BigInfoSubview ()
{
    SLComposeViewController *composeController;
    GMSMarker *markerToParticularObject;
    CLLocationCoordinate2D particularPosition;
    PlaceCategories *storage;
}

@end

@implementation BigInfoSubview

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

-(void)setDataOfWindow : (PlaceDetailInfo*) infoForMarker
{
    
    composeController =[[SLComposeViewController alloc]init];
    storage = [PlaceCategories sharedManager];
    [self.smallMap.settings setAllGesturesEnabled:NO];
    self.name.text = infoForMarker.name;
    self.address.text = infoForMarker.address;
    self.description.text = nil;
    self.description.text = infoForMarker.description;
    particularPosition = CLLocationCoordinate2DMake([infoForMarker.latitude floatValue], [infoForMarker.longtitude floatValue]);
    markerToParticularObject = [GMSMarker markerWithPosition:particularPosition];
    markerToParticularObject.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", infoForMarker.type]];
    [_smallMap animateToLocation:particularPosition];
    [_smallMap animateToZoom:16];
    markerToParticularObject.map = _smallMap;
}

@end
