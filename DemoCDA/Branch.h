//
//  Branch.h
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "JSONModel.h"

@interface Branch : JSONModel <MKAnnotation>

@property NSString *sAddress;
@property NSString *sLatitude;
@property NSString *sLength;
@property NSString *shoursFrom;
@property NSString *shoursUntil;
@property NSString *stypeEstablishment;
@property NSString *sName;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
