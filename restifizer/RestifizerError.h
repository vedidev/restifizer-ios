//
//  RestifizerError.h
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestifizerError : NSObject

- (instancetype)initWithError:(NSError*)error andStatusCode:(NSInteger)code;

- (NSString*)errorDescription;

- (NSInteger)statusCode;

@end
