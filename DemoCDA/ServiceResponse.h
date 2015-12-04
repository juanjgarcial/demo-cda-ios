//
//  ServiceResponse.h
//  DemoCDA
//
//  Created by SGBPty-002 on 10/6/15.
//  Copyright © 2015 Synergy Global Business. All rights reserved.
//

#import "JSONModel.h"
#import "Ad.h"
#import "Contact.h"
#import "News.h"
#import "Branch.h"
#import "Site.h"
#import "Social.h"
#import "Benefit.h"
#import "Term.h"
#import "Faq.h"
#import "WebServiceStatus.h"

@interface ServiceResponse : JSONModel

@property (nonatomic, retain) NSArray<Ad *> <Optional> *ads;
@property (nonatomic, retain) Contact <Optional> *contact;
@property (nonatomic, retain) NSArray<Social *> <Optional> *social;
@property (nonatomic, retain) NSArray<News *> <Optional> *news;
@property (nonatomic, retain) NSArray<Branch *> <Optional> *branches;
@property (nonatomic, retain) NSArray<Site *> <Optional> *sites;
@property (nonatomic, retain) NSArray<Benefit *> <Optional> *benefits;
@property (nonatomic, retain) NSArray<Faq *> <Optional> *faq;
@property (nonatomic, retain) NSArray<Term *> <Optional> *terms;
@property (nonatomic, retain) WebServiceStatus *status;

@end
