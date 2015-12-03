//
//  NewsViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "NewsViewController.h"

#import "DashboardViewController.h"
#import "NewsTableViewCell.h"
#import "WebViewController.h"

@interface NewsViewController ()

@property NSMutableArray<News *> *news;

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property NSInteger selectedRow;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrieveAndSetNews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Noticias"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationItem] setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Methods

- (void)retrieveAndSetNews {
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"news"];
    [self callService:url];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    cell.newsTitle.text = [[self.news objectAtIndex:indexPath.row] nText];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedRow:indexPath.row];
    [self performSegueWithIdentifier:@"pushNewsDetail" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushNewsDetail"]) {
        NSString *urlToLoad = [[[self news] objectAtIndex:[self selectedRow]] nLink];
        [((WebViewController *)[segue destinationViewController]) setUrlToLoad:urlToLoad];
        NSString *titleToView = [[[self news] objectAtIndex:[self selectedRow]] nText];
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
        NSMutableArray *serviceNews = [[NSMutableArray alloc] initWithArray:response.news];
        self.news = [[NSMutableArray alloc] initWithCapacity:serviceNews.count];
        for (NSDictionary *site in serviceNews) {
            News *n = [[News alloc] initWithDictionary:site error:&err];
            if (n.nActive) {
                [self.news addObject:n];
            }
        }
        
        [self.newsTableView reloadData];
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
