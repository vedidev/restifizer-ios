//
//  RestifizerRequest.h
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestifizerAuthParams.h"
#import "RestifizerError.h"
#import "RestifizerResponse.h"

typedef void (^RestifizerCompletion)(RestifizerResponse*);

@interface RestifizerRequest : NSObject

- (instancetype)initWithPath:(NSString*)path andAuthParameters:(RestifizerAuthParams*)params;

// HTTP Methods

- (void)get:(RestifizerCompletion)completion;
- (void)post:(NSDictionary*)parameters completion:(RestifizerCompletion)completion;
- (void)put:(NSDictionary*)parameters completion:(RestifizerCompletion)completion;
- (void)patch:(NSDictionary*)parameters completion:(RestifizerCompletion)completion;
- (void)del:(NSDictionary*)parameters completion:(RestifizerCompletion)completion;

// Auth

- (instancetype)withClientAuth;

- (instancetype)withBearerAuth;

// Data Type

- (instancetype)withStringParameters;

// Supporting methods

- (instancetype)withTag:(NSString*)tag;

- (instancetype)one:(NSString*)objectId;

- (instancetype)list:(NSString*)path;

- (instancetype)page:(NSInteger)pageNumber;
- (instancetype)definePageSize:(NSInteger)pageSize;
- (instancetype)page:(NSInteger)pageNumber withPageSize:(NSInteger)pageSize;

- (instancetype)filter:(NSString*)key value:(id)value;

- (instancetype)query:(NSString*)key value:(id)value;

@end
