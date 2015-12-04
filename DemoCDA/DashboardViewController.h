//
//  ViewController.h
//  DemoCDA
//
//  Created by SGBPty-002 on 10/5/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

#import "ServiceResponse.h"
#import "Ad.h"

@interface DashboardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *slotView1;
@property (weak, nonatomic) IBOutlet UIView *slotView2;
@property (weak, nonatomic) IBOutlet UIView *slotView3;
@property (weak, nonatomic) IBOutlet UIView *slotView4;
@property (weak, nonatomic) IBOutlet UIView *slotView5;
@property (weak, nonatomic) IBOutlet UIView *slotView6;
@property (weak, nonatomic) IBOutlet UIView *slotView7;
@property (weak, nonatomic) IBOutlet UIView *slotView8;

@property NSMutableArray<Ad *> *adsArray;

+ (NSString *)getServiceURL;
+ (NSCache *)getCacheManager;

@end

