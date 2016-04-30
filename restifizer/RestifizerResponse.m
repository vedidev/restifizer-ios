//
//  RestifizerResponce.m
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import "RestifizerResponse.h"

@implementation RestifizerResponse

- (instancetype)initWithRequest:(RestifizerRequest*)request withData:(NSData*)data andError:(RestifizerError*)error {
    if (self = [super init]) {
        self.contentData = data;
        self.error = error;
        self.request = request;
    }
    
    return self;
}

@end
