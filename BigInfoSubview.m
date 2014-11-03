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
#import "PlaceCategory.h"
#import "SNSGooglePlus.h"
#import "SlideMenuViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>


@interface BigInfoSubview ()
{
    SLComposeViewController *composeController;
    GMSMarker *markerToParticularObject;
    CLLocationCoordinate2D particularPosition;
    PlaceCategory *storage;
    PlaceDetailInfo*detailInfo;
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
    SNSTwitter *twitter =[[SNSTwitter alloc]init];
    [twitter shareTwitter:detailInfo];
}
- (IBAction)facebook:(id)sender
{
    SNSFacebook *facebook=[[SNSFacebook alloc]init];
    [facebook shareFacebook:detailInfo];
}
-(IBAction)GooglePlus:(id)sender
{
    SNSGooglePlus* plus=[[SNSGooglePlus alloc] init];
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [GPPShare sharedInstance].delegate = self;
    [shareBuilder open];
    [plus share];
}

-(void)setDataOfWindow : (PlaceDetailInfo*) infoForMarker
{
    detailInfo=[[PlaceDetailInfo alloc] init];
    composeController =[[SLComposeViewController alloc]init];
    storage = [PlaceCategory sharedManager];
    [self.smallMap.settings setAllGesturesEnabled:NO];
    self.name.text = infoForMarker.name;
    self.address.text = infoForMarker.address;
    self.description.text = infoForMarker.description;
    particularPosition = CLLocationCoordinate2DMake([infoForMarker.latitude floatValue], [infoForMarker.longtitude floatValue]);
    markerToParticularObject = [GMSMarker markerWithPosition:particularPosition];
    markerToParticularObject.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", infoForMarker.type]];
    [_smallMap animateToLocation:particularPosition];
    [_smallMap animateToZoom:16];
    markerToParticularObject.map = _smallMap;
}

@end
