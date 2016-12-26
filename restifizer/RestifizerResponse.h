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

@property (nonatomic, strong) NSObject *responseContent;
@property (nonatomic, strong) RestifizerError *error;
@property (nonatomic, strong) RestifizerRequest *request;

- (instancetype)initWithRequest:(RestifizerRequest *)request withContent:(NSObject*)responseContent andError:(RestifizerError*)error;

@end
