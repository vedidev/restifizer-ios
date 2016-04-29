//
//  RestifizerAuthParams.m
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import "RestifizerAuthParams.h"
@interface RestifizerAuthParams()

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;

@end

@implementation RestifizerAuthParams

- (instancetype)initWithBearer:(NSString *)accessToken clientId:(NSString *)clientId andClientSecret:(NSString *)secret {
    if (self = [super init]) {
        self.accessToken = accessToken;
        self.clientId = clientId;
        self.clientSecret = secret;
    }
    return self;
}

- (NSString *)encodedBasicAuth {
    if (self.clientId != nil && self.clientSecret != nil) {
        NSData *stringData = [[self.clientId stringByAppendingString:self.clientSecret] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64 = [stringData base64EncodedStringWithOptions:0];
        return base64;
    } else {
        [NSException raise:@"Client auth not set" format:@"Set client auth to work with it"];
        // redundant
        return nil;
    }
}

- (NSString *)accessToken {
    if (self.accessToken == nil) {
        [NSException raise:@"Acess token not set" format:@"Set access token at first"];
    }
    
    return self.accessToken;
}

@end
