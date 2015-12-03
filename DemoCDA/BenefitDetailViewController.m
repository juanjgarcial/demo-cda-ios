//
//  BenefitDetailViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 12/3/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "BenefitDetailViewController.h"

@interface BenefitDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoader;

@property (weak, nonatomic) IBOutlet UILabel *benefitTitle;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@end

@implementation BenefitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDetailsValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Detalle Beneficio"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Setting Methods

- (void)setDetailsValues {
    [[self benefitTitle] setText:[self benefitTitleText]];
    [[self detailTextView] setText:[self benefitSubTitle]];
}

@end
