//
//  SitesViewController.h
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

#import "SitesTableViewCell.h"
#import "ServiceResponse.h"
#import "DashboardViewController.h"
#import "WebViewController.h"

@interface LinksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sitesTableView;

- (void)showLoader:(BOOL)show;

@end
