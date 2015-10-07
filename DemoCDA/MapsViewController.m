//
//  MapsViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "MapsViewController.h"

@interface MapsViewController ()

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *branchDetailView;
@property (weak, nonatomic) IBOutlet UILabel *branchTitle;
@property (weak, nonatomic) IBOutlet UILabel *branchType;
@property (weak, nonatomic) IBOutlet UILabel *branchAddress;
@property (weak, nonatomic) IBOutlet UILabel *branchHours;
@property (weak, nonatomic) IBOutlet UILabel *branchPhone;

@property NSMutableArray<Branch *> *branches;

@end

@implementation MapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"branches"];
    [self callService:url];

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 8.9903;
    zoomLocation.longitude = -79.5219;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisDetail)];
    [self.mapView addGestureRecognizer:tap];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    Branch *branch = (Branch *)annotation;
    NSString *identifier = branch.sAddress;

    MKAnnotationView *view;
    
    MKAnnotationView *dequeuedView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if(dequeuedView == nil) {
        dequeuedView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    dequeuedView.image = [UIImage imageNamed:@"mapPin"];
    dequeuedView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 30, 30);
    
    return dequeuedView;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    Branch *selectedBranch = (Branch *)view.annotation;
    
    self.branchTitle.text = selectedBranch.sName;
    self.branchType.text = selectedBranch.stypeEstablishment;
    self.branchAddress.text = selectedBranch.sAddress;
    self.branchPhone.text = @"+507-123-4567";
    
    NSString *dateString = selectedBranch.shoursFrom;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy hh:mm:ss aaa"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"hh:mm aaa"];
    NSString *openHour = [dateFormatter stringFromDate:dateFromString];
    NSLog(@"%@", openHour);
    
    dateString = selectedBranch.shoursUntil;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy hh:mm:ss aaa"];
    dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"hh:mm aaa"];
    NSString *closeHour = [dateFormatter stringFromDate:dateFromString];
    NSLog(@"%@", closeHour);
    
    self.branchHours.text = [NSString stringWithFormat:@"%@ - %@",openHour, closeHour];
    
    self.branchDetailView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callService:(NSString *)serviceUrl {
    [self showLoader:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceSites = [[NSMutableArray alloc] initWithArray:response.branches];
        self.branches = [[NSMutableArray alloc] initWithCapacity:serviceSites.count];
        for (NSDictionary *branche in serviceSites) {
            [self.branches addObject:[[Branch alloc] initWithDictionary:branche error:&err]];
        }
        for (Branch *b in self.branches) {
            CLLocationCoordinate2D coordinate = {[b.sLatitude doubleValue], [b.sLength doubleValue]};
            [b setCoordinate:coordinate];
            [self.mapView addAnnotation:b];
        }
        [self showLoader:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showLoader:NO];
    }];
}

- (void)dissmisDetail {
    self.branchDetailView.hidden = YES;
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
