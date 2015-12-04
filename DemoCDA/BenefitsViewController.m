//
//  BenefitsViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 12/3/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "BenefitsViewController.h"

#import <AFNetworking/AFNetworking.h>

#import "BenefitDetailViewController.h"
#import "DashboardViewController.h"
#import "BenefitTableViewCell.h"
#import "ServiceResponse.h"
#import "Benefit.h"

@interface BenefitsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *benefitsTableView;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property NSMutableArray<Benefit *> *benefits;

@property NSInteger selectedRow;

@end

@implementation BenefitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrieveAndSetBenefits];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Beneficios"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationItem] setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Methods

- (void)retrieveAndSetBenefits {
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"benefits"];
    [self callService:url];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.benefits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BenefitTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"benefitCell"];
    
    cell.benefitTitle.text = [[self.benefits objectAtIndex:indexPath.row] bText];
    cell.benefitSubTitle.text = [[self.benefits objectAtIndex:indexPath.row] bDetail];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImage *benefitImage = [[self.benefits objectAtIndex:indexPath.row] thumbnailImage];
    if (benefitImage != nil) {
        cell.thumbnailImage.image = benefitImage;
        cell.imageLoader.hidden = true;
        [cell.imageLoader stopAnimating];
    } else {
        [cell.imageLoader startAnimating];
        cell.imageLoader.hidden = false;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedRow:indexPath.row];
    [self performSegueWithIdentifier:@"showBenefitDetail" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *detailTitle = [[[self benefits] objectAtIndex:[self selectedRow]] bText];
    NSString *detailSubTitle = [[[self benefits] objectAtIndex:[self selectedRow]] bDetail];
    NSString *detailImage = [[[self benefits] objectAtIndex:[self selectedRow]] bpictureDetail];
    
    [((BenefitDetailViewController *)[segue destinationViewController]) setBenefitTitleText:detailTitle];
    [((BenefitDetailViewController *)[segue destinationViewController]) setBenefitSubTitle:detailSubTitle];
    [((BenefitDetailViewController *)[segue destinationViewController]) setBenefitImageTitle:detailImage];
}


#pragma mark - Other Methods

- (void)callService:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceBenefits = [[NSMutableArray alloc] initWithArray:response.benefits];
        self.benefits = [[NSMutableArray alloc] initWithCapacity:serviceBenefits.count];
        for (NSDictionary *benefit in serviceBenefits) {
            Benefit *b = [[Benefit alloc] initWithDictionary:benefit error:&err];
            if (b.bActive) {
                [self.benefits addObject:b];
            }
        }
        [self.benefitsTableView reloadData];
        [self showLoader:NO];
        
        for (Benefit *b in self.benefits) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *cachedImage = [[DashboardViewController getCacheManager] objectForKey:b.bPicture];
                if (cachedImage != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [b setThumbnailImage:cachedImage];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.benefits indexOfObject:b] inSection:0];
                        NSArray *myIPs = [[NSArray alloc] initWithObjects:indexPath, nil];
                        [self.benefitsTableView reloadRowsAtIndexPaths:myIPs withRowAnimation:UITableViewRowAnimationFade];
                    });
                } else {
                    NSURL *urlImage = [NSURL URLWithString:b.bPicture];
                    NSData *imageData = [NSData dataWithContentsOfURL:urlImage];
                    UIImage *imageToSet;
                    if (imageData != nil) {
                        imageToSet = [UIImage imageWithData:imageData];
                        [[DashboardViewController getCacheManager] setObject:imageToSet forKey:b.bPicture];
                    } else {
                        imageToSet = [UIImage imageNamed:@"offersImage"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [b setThumbnailImage:imageToSet];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.benefits indexOfObject:b] inSection:0];
                        NSArray *myIPs = [[NSArray alloc] initWithObjects:indexPath, nil];
                        [self.benefitsTableView reloadRowsAtIndexPaths:myIPs withRowAnimation:UITableViewRowAnimationFade];
                    });
                }
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showLoader:NO];
    }];
}

- (void)showLoader:(BOOL)show {
    self.loaderView.hidden = !show;
    self.loader.hidden = !show;
    if (show) {
        [self.loader startAnimating];
    } else {
        [self.loader stopAnimating];
    }
}

@end
