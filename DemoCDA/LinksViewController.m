//
//  SitesViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "LinksViewController.h"

@interface LinksViewController ()

@property NSMutableArray<Site *> *sites;
@property NSMutableArray<Term *> *terms;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property NSInteger selectedRow;

@end

@implementation LinksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrieveAndSetSites];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.showingSites) {
        [[self navigationItem] setTitle:@"Sitios de interés"];
    } else {
        [[self navigationItem] setTitle:@"Términos y condiciones"];
    }
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
    if (self.showingSites) {
        NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"sites"];
        [self callServiceSites:url];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"terms"];
        [self callServiceTerms:url];
    }
    
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showingSites) {
        return self.sites.count;
    } else {
        return self.terms.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SitesTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"sitesCell"];
    
    if (self.showingSites) {
        cell.siteTitle.text = [[self.sites objectAtIndex:indexPath.row] eTitle];
    } else {
        cell.siteTitle.text = [[self.terms objectAtIndex:indexPath.row] tNombre];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedRow:indexPath.row];
    [self performSegueWithIdentifier:@"showSiteDetail" sender:self];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *urlToLoad = @"";
    NSString *titleToView = @"";
    
    if (self.showingSites) {
        urlToLoad = [[[self sites] objectAtIndex:[self selectedRow]] eHiperlink];
        titleToView = [[[self sites] objectAtIndex:[self selectedRow]] eTitle];
    } else {
        urlToLoad = [[[self terms] objectAtIndex:[self selectedRow]] tLink];
        titleToView = [[[self terms] objectAtIndex:[self selectedRow]] tNombre];
    }
    
    [((WebViewController *)[segue destinationViewController]) setUrlToLoad:urlToLoad];
    [((WebViewController *)[segue destinationViewController]) setPageTitle:titleToView];

}

#pragma mark - Other Methods

- (void)callServiceSites:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceSites = [[NSMutableArray alloc] initWithArray:response.sites];
        self.sites = [[NSMutableArray alloc] initWithCapacity:serviceSites.count];
        for (NSDictionary *site in serviceSites) {
            Site *s = [[Site alloc] initWithDictionary:site error:&err];
            if (s.eActive) {
                [self.sites addObject:s];
            }
            
        }
        [self.sitesTableView reloadData];
        [self showLoader:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showLoader:NO];
    }];
}

-  (void)callServiceTerms:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceTerms = [[NSMutableArray alloc] initWithArray:response.terms];
        self.terms = [[NSMutableArray alloc] initWithCapacity:serviceTerms.count];
        for (NSDictionary *term in serviceTerms) {
            Term *t = [[Term alloc] initWithDictionary:term error:&err];
            if (t.tActive) {
                [self.terms addObject:t];
            }
            
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
    self.loader.hidden = !show;
    if (show) {
        [self.loader startAnimating];
    } else {
        [self.loader stopAnimating];
    }
}

@end
