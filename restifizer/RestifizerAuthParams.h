//
//  RestifizerAuthParams.h
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestifizerAuthParams : NSObject

- (instancetype)initWithBearer:(NSString*)accessToken clientId:(NSString*)clientId andClientSecret:(NSString*)secret;

- (NSString*)encodedBasicAuth;
- (NSString*)accessToken;

@end
