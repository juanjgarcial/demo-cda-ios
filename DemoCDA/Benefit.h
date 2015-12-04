//
//  Benefit.h
//  DemoCDA
//
//  Created by SGBPty-002 on 12/3/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface Benefit : JSONModel

@property NSString *bText;
@property NSString *bPicture;
@property NSString *bDetail;
@property NSString *bpictureDetail;
@property BOOL bActive;
@property UIImage *thumbnailImage;

@end
