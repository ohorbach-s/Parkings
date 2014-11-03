//
//  SNSSocialNetwork.h
//  SocialNetworksSharing
//
//  Created by Ostap R on 08.09.14.
//  Copyright (c) 2014 Ostap R. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNSSocialNetworkDataSource;
@protocol SNSSocialNetwork <NSObject>

@optional
-(void)share;
-(void)settingDataSource:(id<SNSSocialNetworkDataSource>)data;
@end
