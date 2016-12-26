//
//  RestifizerError.m
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import "RestifizerError.h"
@interface RestifizerError()

@property (nonatomic, strong) NSError *error;
@property (nonatomic) NSInteger statusCode;

@end


@implementation RestifizerError

- (instancetype)initWithError:(NSError*)error andStatusCode:(NSInteger)code {
    if (self = [super init]) {
        self.error = error;
        self.statusCode = code;
    }
    
    return self;
}

- (NSString*)errorDescription {
    return self.error.description;
}

- (NSInteger)statusCode {
    return self.statusCode;
}


@end
