//
//  RequestsClass.h
//  MapsDirections
//
//  Created by Yuliia on 10/21/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface RequestsClass : NSObject

+(void)firstLoad;
-(void)displayObjectsMarkers: (NSString*)category  :(NSString*)iconOfMarker;
-(void)cleanMarkersFromMap :(NSString*)category ;

@end
