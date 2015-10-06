//
//  ViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/5/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()


@end

@implementation DashboardViewController

static NSString *SERVICE_URL = @"http://localhost:8084/DemoCDA/resources/demo/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"bancaPlusLogoWhite"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat customWidth = 1.0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:51.0/255.0 green:53.0/255.0 blue:96.0/255.0 alpha:1.0];

    
    self.slotView1.layer.borderWidth = customWidth;
    self.slotView1.layer.borderColor = [borderColor CGColor];

    self.slotView2.layer.borderWidth = customWidth;
    self.slotView2.layer.borderColor = [borderColor CGColor];
    
    self.slotView3.layer.borderWidth = customWidth;
    self.slotView3.layer.borderColor = [borderColor CGColor];
    
    self.slotView4.layer.borderWidth = customWidth;
    self.slotView4.layer.borderColor = [borderColor CGColor];
    
    self.slotView5.layer.borderWidth = customWidth;
    self.slotView5.layer.borderColor = [borderColor CGColor];
    
    self.slotView6.layer.borderWidth = customWidth;
    self.slotView6.layer.borderColor = [borderColor CGColor];
    
    self.slotView7.layer.borderWidth = customWidth;
    self.slotView7.layer.borderColor = [borderColor CGColor];
    
    self.slotView8.layer.borderWidth = customWidth;
    self.slotView8.layer.borderColor = [borderColor CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

+ (NSString *)getServiceURL {
    return SERVICE_URL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
