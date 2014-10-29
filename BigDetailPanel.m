//
//  BigDetailPanel.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "BigDetailPanel.h"
#import "DetailInfoViewController.h"
#import "SNSFacebook.h"
#import "SNSTwitter.h"
#import "StorageClass.h"

@interface BigDetailPanel ()
{
    SLComposeViewController *composeController;
    GMSMarker *markerToParticularObject;
    CLLocationCoordinate2D particularPosition;
    StorageClass *storage;
    NSInteger indexOfCategory;
    SlideMenuViewController *menu;
}

@end

@implementation BigDetailPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        menu = [[SlideMenuViewController alloc] init];
        composeController =[[SLComposeViewController alloc]init];
        storage = [StorageClass sharedManager];
        [self.smallMap.settings setAllGesturesEnabled:NO];
        [menu setIndexValueWithCompletion:^(NSInteger index) {
            indexOfCategory = index;
        }];
        [self setDataOfWindow];
    }
    return self;
}

- (IBAction)Twitter:(id)sender
{
    SNSTwitter *twitter =[[SNSTwitter alloc]init];
    [twitter shareTwitter:storage.detailInfoForObject];
}
- (IBAction)facebook:(id)sender
{
    SNSFacebook *facebook=[[SNSFacebook alloc]init];
    [facebook shareFacebook:storage.detailInfoForObject];
}


-(void)setDataOfWindow {
    self.nameLabel.text = storage.detailInfoForObject.name;
    self.addressLabel.text = storage.detailInfoForObject.address;
    self.phoneLabel.text = storage.detailInfoForObject.phone;
    self.description.text = storage.detailInfoForObject.description;
    particularPosition = CLLocationCoordinate2DMake([storage.detailInfoForObject.latitude floatValue], [storage.detailInfoForObject.longtitude floatValue]);
    markerToParticularObject = [GMSMarker markerWithPosition:particularPosition];
    markerToParticularObject.icon = [UIImage imageNamed:storage.markersImages[indexOfCategory]];
    [_smallMap animateToLocation:particularPosition];
    [_smallMap animateToZoom:16];
    
    markerToParticularObject.map = _smallMap;
}

@end
