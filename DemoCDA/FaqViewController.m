//
//  FaqViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 12/4/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "FaqViewController.h"

#import "DashboardViewController.h"
#import "FaqTableViewCell.h"
#import "Faq.h"

@interface FaqViewController ()

@property NSMutableArray<Faq *> *faqs;

@property (strong, nonatomic) IBOutlet UITableView *faqTableView;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.faqTableView setEstimatedRowHeight:100];
    [self.faqTableView setRowHeight:UITableViewAutomaticDimension];
    
    [self retrieveFaqs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Methods

- (void)retrieveFaqs {
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"faq"];
    [self callService:url];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.faqs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FaqTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"faqCell"];
    
    cell.question.text = [[self.faqs objectAtIndex:indexPath.row] pfQuestion];
    cell.answer.text = [[self.faqs objectAtIndex:indexPath.row] pfAnswer];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - Other Methods

- (void)callService:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceFaqs = [[NSMutableArray alloc] initWithArray:response.faq];
        self.faqs = [[NSMutableArray alloc] initWithCapacity:serviceFaqs.count];
        for (NSDictionary *faq in serviceFaqs) {
            Faq *f = [[Faq alloc] initWithDictionary:faq error:&err];
            if (f.pfActive) {
                [self.faqs addObject:f];
            }
        }
        [self.faqTableView reloadData];
        [self showLoader:NO];
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
