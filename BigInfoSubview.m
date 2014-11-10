//
//  BigDetailPanel.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "BigInfoSubview.h"
#import "PlaceCategories.h"
#import "SlideMenuControllerViewController.h"

@interface BigInfoSubview ()
{
    
    GMSMarker *markerToParticularObject;
    CLLocationCoordinate2D particularPosition;
    PlaceCategories *storage;
    AAShareBubbles *bubles;
    SNSNetworkFactory* networkFactory;
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

//share
-(IBAction)Share:(id)sender
{
    bubles=[[AAShareBubbles alloc]initWithPoint:self.center radius:80 inView:self];
    bubles.delegate=self;
    bubles.radius=80;
    bubles.showTwitterBubble=YES;
    bubles.showVkBubble=YES;
    bubles.showGooglePlusBubble=YES;
    bubles.showFacebookBubble=YES;
    [bubles show];
    
}

//fill fields with relevant information
-(void)setDataOfWindow : (PlaceDetailInfo*) infoForMarker
{
    networkFactory=[SNSNetworkFactory new];
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
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    
    
    SNSSocialNetworkType type = SNSSocialNetworkTypeFacebook;
    switch(bubbleType)
    {
        case AAShareBubbleTypeFacebook: type=SNSSocialNetworkTypeFacebook; break;
            // case AAShareBubbleTypeLinkedIn: type=SNSSocialNetworkTypeLinkedIn; break;
        case AAShareBubbleTypeTwitter: type=SNSSocialNetworkTypeTwitter; break;
        case AAShareBubbleTypeVk: type=SNSSocialNetworkTypeVkontakte;   break;
        case AAShareBubbleTypeGooglePlus: type=SNSSocialNetworkTypeGooglePlus; break;
    }
    
    id socialNetwork= [networkFactory getNetwork:type];
    self.some=socialNetwork;
    [socialNetwork share];
    
}
-(void)aaShareBubblesDidHide
{
    
}

@end
