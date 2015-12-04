//
//  BenefitDetailViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 12/3/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "BenefitDetailViewController.h"

#import "DashboardViewController.h"

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
    
    [[self imageLoader] setHidden:NO];
    [[self imageLoader] startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *cachedImage = [[DashboardViewController getCacheManager] objectForKey:[self benefitImageTitle]];
        if (cachedImage != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self coverImage] setImage:cachedImage];
                [[self imageLoader] stopAnimating];
                [[self imageLoader] setHidden:YES];
            });
        } else {
            NSURL *imageURL = [NSURL URLWithString:[self benefitImageTitle]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *imageToSet;
                if (imageData != nil) {
                    imageToSet = [UIImage imageWithData:imageData];
                    [[DashboardViewController getCacheManager] setObject:imageToSet forKey:[self benefitImageTitle]];
                } else {
                    imageToSet = [UIImage imageNamed:@"offersImage"];
                }
                [[self coverImage] setImage:imageToSet];
                [[self imageLoader] stopAnimating];
                [[self imageLoader] setHidden:YES];
            });
            
        }
    });
}

@end
