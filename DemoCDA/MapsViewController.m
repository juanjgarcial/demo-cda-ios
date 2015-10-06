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

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
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

- (void)showLoader:(BOOL)show {
    self.loaderView.hidden = !show;
    if (show) {
        [self.loader startAnimating];
    } else {
        [self.loader stopAnimating];
    }
}

@end
