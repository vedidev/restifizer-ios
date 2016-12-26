//
//  RestifizerManager.h
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestifizerRequest.h"
#import "RestifizerAuthParams.h"

@interface RestifizerManager : NSObject

+ (instancetype)sharedManager;

- (void)configBaseUrl:(NSString*)path;

- (void)configClientAuth:(NSString*)clientId andSecret:(NSString*)clientSecret;

- (void)configBearerAuth:(NSString*)accessToken;

- (RestifizerRequest*)resourceAt:(NSString*)path;

@end
