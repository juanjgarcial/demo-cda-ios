//
//  WebViewController.m
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:[self pageTitle]];
    
    NSURL *url = [[NSURL alloc] initWithString:[self urlToLoad]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [[self contentWebView] loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoader:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self showLoader:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showLoader:(BOOL)show {
    if (show) {
        [[self loader] setHidden:NO];
        [[self loader] startAnimating];
    } else {
        [[self loader] setHidden:YES];
        [[self loader] stopAnimating];
    }
}

@end
