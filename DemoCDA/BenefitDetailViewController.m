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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
