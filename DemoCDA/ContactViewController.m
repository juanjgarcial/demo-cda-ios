//
//  ContactViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/7/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelAddres;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UITableView *socialtable;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property NSMutableArray<Social *> *socialNets;
@property Contact *contactInfo;
@property NSInteger selectedRow;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"contact-info"];
    
    [self callService:url];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Contáctenos"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationItem] setTitle:@""];
}

- (void)initLabels {
    self.labelAddres.text = self.contactInfo.cAddress;
    self.labelEmail.text = self.contactInfo.cEmail;
    self.labelPhone.text = self.contactInfo.cPhone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.socialNets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SocialTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"socialCell"];
    
    cell.socialTitle.text = [[self.socialNets objectAtIndex:indexPath.row] name];
    
    NSString *type = [[self.socialNets objectAtIndex:indexPath.row] type];
    
    if ([type.lowercaseString isEqualToString:@"facebook"]) {
        cell.socialImage.image = [UIImage imageNamed:@"facebook"];
    } else if ([type.lowercaseString isEqualToString:@"twitter"]) {
        cell.socialImage.image = [UIImage imageNamed:@"twitter"];
    } else if ([type.lowercaseString isEqualToString:@"instagram"]) {
        cell.socialImage.image = [UIImage imageNamed:@"instagram"];
    } else if ([type.lowercaseString isEqualToString:@"linkedin"]) {
        cell.socialImage.image = [UIImage imageNamed:@"linkedin"];
    } else if ([type.lowercaseString isEqualToString:@"googleplus"]) {
        cell.socialImage.image = [UIImage imageNamed:@"googleplus"];
    } else {
        cell.socialImage.image = [UIImage imageNamed:@"social"];
    }
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedRow:indexPath.row];
    [self performSegueWithIdentifier:@"pushWebFromSocial" sender:self];
}

- (void)callService:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        
        self.contactInfo = response.contact;
//        self.contactInfo = [[Contact alloc] initWithDictionary:response.contact error:&err];
        
        NSMutableArray *serviceSocial = [[NSMutableArray alloc] initWithArray:response.social];
        self.socialNets = [[NSMutableArray alloc] initWithCapacity:serviceSocial.count];
        for (NSDictionary *social in serviceSocial) {
            [self.socialNets addObject:[[Social alloc] initWithDictionary:social error:&err]];
        }
        [self.socialtable reloadData];
        
        [self initLabels];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushWebFromSocial"]) {
        NSString *urlToLoad = [[[self socialNets] objectAtIndex:[self selectedRow]] url];
        [((WebViewController *)[segue destinationViewController]) setUrlToLoad:urlToLoad];
        NSString *titleToView = [[[self socialNets] objectAtIndex:[self selectedRow]] name];
        [((WebViewController *)[segue destinationViewController]) setPageTitle:titleToView];
    }
}


@end
