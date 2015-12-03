//
//  BenefitTableViewCell.h
//  DemoCDA
//
//  Created by SGBPty-002 on 12/3/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BenefitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoader;
@property (weak, nonatomic) IBOutlet UILabel *benefitTitle;
@property (weak, nonatomic) IBOutlet UILabel *benefitSubTitle;
@end
