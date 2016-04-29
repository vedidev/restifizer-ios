//
//  RestifizerManager.m
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import "RestifizerManager.h"

@interface RestifizerManager()

@property (nonatomic, strong) NSString* basePath;

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;

@end

@implementation RestifizerManager

+ (instancetype)sharedManager
{
    static RestifizerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RestifizerManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Base Path

- (void)configBaseUrl:(NSString *)path {
    self.basePath = path;
}

#pragma mark - Auth

- (void)configBearerAuth:(NSString *)accessToken {
    self.accessToken = accessToken;
}

- (void)configClientAuth:(NSString *)clientId andSecret:(NSString *)clientSecret {
    self.clientId = clientId;
    self.clientSecret = clientSecret;
}

#pragma mark - Request Creation

- (RestifizerRequest *)resourceAt:(NSString *)path {
    if(path == nil) {
        [NSException raise:@"No base path set" format:@"Set base path in -configBaseUrl: method before creating request"];
    }
    
    NSString *combinedPath = [self.basePath stringByAppendingString:path];
    
    RestifizerAuthParams *params = [[RestifizerAuthParams alloc] initWithBearer:self.accessToken clientId:self.clientId andClientSecret:self.clientSecret];
    RestifizerRequest *request = [[RestifizerRequest alloc] initWithPath:combinedPath andAuthParameters:params];
    
    return request;
}

@end
