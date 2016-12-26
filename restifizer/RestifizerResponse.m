//
//  RestifizerResponce.m
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import "RestifizerResponse.h"

@implementation RestifizerResponse

- (instancetype)initWithRequest:(RestifizerRequest *)request withContent:(NSObject*)responseContent andError:(RestifizerError*)error {
    if (self = [super init]) {
        self.responseContent = responseContent;
        self.error = error;
        self.request = request;
    }
    
    return self;
}

@end
