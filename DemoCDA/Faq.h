//
//  Faq.h
//  DemoCDA
//
//  Created by SGBPty-002 on 12/4/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "JSONModel.h"

@interface Faq : JSONModel

@property NSString *pfQuestion;
@property NSString *pfAnswer;
@property BOOL pfActive;

@end
