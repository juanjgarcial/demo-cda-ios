//
//  SitesViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "SitesViewController.h"

@interface SitesViewController ()

@property NSMutableArray<Site *> *sites;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property NSInteger selectedRow;

@end

@implementation SitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrieveAndSetSites];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Sitios de Interés"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationItem] setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Methods

- (void)retrieveAndSetSites {
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"sites"];
    [self callService:url];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SitesTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"sitesCell"];
    
    cell.siteTitle.text = [[self.sites objectAtIndex:indexPath.row] eTitle];
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedRow:indexPath.row];
    [self performSegueWithIdentifier:@"showSiteDetail" sender:self];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSiteDetail"]) {
        NSString *urlToLoad = [[[self sites] objectAtIndex:[self selectedRow]] eHiperlink];
        [((WebViewController *)[segue destinationViewController]) setUrlToLoad:urlToLoad];
        NSString *titleToView = [[[self sites] objectAtIndex:[self selectedRow]] eTitle];
        [((WebViewController *)[segue destinationViewController]) setPageTitle:titleToView];
    }
}

#pragma mark - Other Methods

- (void)callService:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceSites = [[NSMutableArray alloc] initWithArray:response.sites];
        self.sites = [[NSMutableArray alloc] initWithCapacity:serviceSites.count];
        for (NSDictionary *site in serviceSites) {
            [self.sites addObject:[[Site alloc] initWithDictionary:site error:&err]];
        }
        [self.sitesTableView reloadData];
        [self showLoader:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showLoader:NO];
    }];
}

- (void)showLoader:(BOOL)show {
    self.loaderView.hidden = !show;
    if (show) {
        [self.loader startAnimating];
    } else {
        [self.loader stopAnimating];
    }
}

@end
