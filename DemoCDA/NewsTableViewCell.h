//
//  NewsTableViewCell.h
//  DemoCDA
//
//  Created by SGBPty-002 on 12/2/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoader;

@end
