//
//  Ad.h
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "JSONModel.h"
@import UIKit;

@interface Ad : JSONModel

@property NSString *pText;
@property NSString *pPicture;
@property BOOL pActive;
@property UIImage *adImage;

@end
