//
//  RestifizerResponce.h
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestifizerError.h"

@class RestifizerRequest;

@interface RestifizerResponse : NSObject

- (instancetype)initWithRequest:(RestifizerRequest *)request withData:(NSData*)data andError:(RestifizerError*)error;

@end