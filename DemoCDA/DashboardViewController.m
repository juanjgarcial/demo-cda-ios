//
//  ViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/5/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "DashboardViewController.h"

#import "LinksViewController.h"

@interface DashboardViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *adLoader;
@property (weak, nonatomic) IBOutlet UIImageView *adImage;

@end

@implementation DashboardViewController

static int currentAd = 0;
static bool readyToAd = NO;
static bool showSites = NO;
static NSCache *cacheManager;

//static NSString *SERVICE_URL = @"http://localhost:8084/DemoCDA/resources/demo/";
//static NSString *SERVICE_URL = @"http://192.168.0.104:8084/DemoCDA/resources/demo/";
static NSString *SERVICE_URL = @"http://190.216.251.147:8080/DemoCDA-1.0/resources/demo/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [DashboardViewController getServiceURL], @"ads"];
    [self showLoader:YES];
    [self callService:url];
    
    UIImage *image = [UIImage imageNamed:@"bancaPlusLogoWhite"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat customWidth = 1.0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:51.0/255.0 green:53.0/255.0 blue:96.0/255.0 alpha:1.0];

    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(rotateAds) userInfo:nil repeats:YES];

    self.slotView1.layer.borderWidth = customWidth;
    self.slotView1.layer.borderColor = [borderColor CGColor];

    self.slotView2.layer.borderWidth = customWidth;
    self.slotView2.layer.borderColor = [borderColor CGColor];
    
    self.slotView3.layer.borderWidth = customWidth;
    self.slotView3.layer.borderColor = [borderColor CGColor];
    
    self.slotView4.layer.borderWidth = customWidth;
    self.slotView4.layer.borderColor = [borderColor CGColor];
    
    self.slotView5.layer.borderWidth = customWidth;
    self.slotView5.layer.borderColor = [borderColor CGColor];
    
    self.slotView6.layer.borderWidth = customWidth;
    self.slotView6.layer.borderColor = [borderColor CGColor];
    
    self.slotView7.layer.borderWidth = customWidth;
    self.slotView7.layer.borderColor = [borderColor CGColor];
    
    self.slotView8.layer.borderWidth = customWidth;
    self.slotView8.layer.borderColor = [borderColor CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

+ (NSString *)getServiceURL {
    return SERVICE_URL;
}

- (void)callService:(NSString *)serviceUrl {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serviceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        ServiceResponse *response = [[ServiceResponse alloc] initWithDictionary:responseObject error:&err];
        NSMutableArray *serviceAds = [[NSMutableArray alloc] initWithArray:response.ads];
        self.adsArray = [[NSMutableArray alloc] initWithCapacity:serviceAds.count];
        for (NSDictionary *ad in serviceAds) {
            Ad *a = [[Ad alloc] initWithDictionary:ad error:&err];
            if (a.pActive) {
                [self.adsArray addObject:a];
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            for (Ad *ad in self.adsArray) {
                NSURL *urlImage = [[NSURL alloc] initWithString:ad.pPicture];
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:urlImage];
                [ad setAdImage:[[UIImage alloc] initWithData:imageData]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLoader:NO];
                readyToAd = YES;
                [self rotateAds];
            });
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)rotateAds {
    if (readyToAd) {
        int j = currentAd % self.adsArray.count;
        self.adImage.image = [[self.adsArray objectAtIndex:j] adImage];
        currentAd++;
    }
}

- (IBAction)pushSites:(id)sender {
    showSites = YES;
    [self performSegueWithIdentifier:@"pushLink" sender:self];
}

- (IBAction)pushTerms:(id)sender {
    showSites = NO;
    [self performSegueWithIdentifier:@"pushLink" sender:self];
}

- (void)showLoader:(BOOL)show {
    self.adLoader.hidden = !show;
    if (show) {
        [self.adLoader startAnimating];
    } else {
        [self.adLoader stopAnimating];
    }
}

+ (NSCache *)getCacheManager {
    if (cacheManager == nil) {
        cacheManager = [[NSCache alloc] init];
    }
    return cacheManager;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushLink"]) {
        [((LinksViewController *)[segue destinationViewController]) setShowingSites:showSites];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
