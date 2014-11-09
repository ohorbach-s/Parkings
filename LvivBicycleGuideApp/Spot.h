//
//  Spot.h
//  Google Maps iOS Example
//
//  Created by Colin Edwards on 2/1/14.
//
//

#import <Foundation/Foundation.h>
#import "GClusterItem.h"

@interface Spot : NSObject <GClusterItem>

@property (nonatomic) CLLocationCoordinate2D location;
@property (strong,nonatomic) UIImage *icon;

-(instancetype) initWithPosition:(CLLocationCoordinate2D)position andIconTypePath:(NSString*)iconPath;

@end
