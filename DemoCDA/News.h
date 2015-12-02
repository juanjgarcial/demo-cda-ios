//
//  News.h
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "JSONModel.h"

@interface News : JSONModel

@property NSString *nText;
@property NSString *nPicture;
@property NSString *nLink;
@property BOOL nActive;

@end
