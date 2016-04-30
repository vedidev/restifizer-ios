//
//  RestifizerRequest.m
//  Restifizer
//
//  Created by Nikita Pankiv on 4/29/16.
//  Copyright © 2016 VedideV. All rights reserved.
//

#import "RestifizerRequest.h"

typedef enum : NSUInteger {
    AuthTypeNone,
    AuthTypeClient,
    AuthTypeBearer
} AuthType;

typedef enum : NSUInteger {
    RequestTypeGet,
    RequestTypePost,
    RequestTypePut,
    RequestTypePatch,
    RequestTypeDelete,
} RequestType;

@interface RestifizerRequest() <NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSString *path;
@property (nonatomic) AuthType authType;
@property (nonatomic) RequestType requestType;
@property (nonatomic) RestifizerAuthParams *authParams;
@property (nonatomic, strong) RestifizerCompletion completion;

@property (nonatomic) BOOL fetchList;
@property (nonatomic, strong) NSString *tag;

@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSMutableDictionary *filterParameters;
@property (nonatomic, strong) NSMutableDictionary *extraQuery;

@property (nonatomic) NSInteger pageNumber;
@property (nonatomic) NSInteger pageSize;

@property (nonatomic, strong) NSMutableURLRequest *urlRequest;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic) long long contentLength;
@property (nonatomic, strong) NSMutableData *contentData;
@property (nonatomic) UInt16 statusCode;

@end

static NSDictionary *authTypeNames;

@implementation RestifizerRequest

- (instancetype)initWithPath:(NSString*)path andAuthParameters:(RestifizerAuthParams*)params {
    if (self = [super init]) {
        self.authParams = params;
        self.path = path;
        
        // Set static dictionary
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            authTypeNames = @{@(RequestTypeGet):@"GET",
                              @(RequestTypeDelete):@"DELETE",
                              @(RequestTypePatch):@"PATCH",
                              @(RequestTypePut):@"PUT",
                              @(RequestTypePost):@"POST"};
        });
    }
    return self;
}

#pragma mark - Auth

- (instancetype)withBearerAuth {
    self.authType = AuthTypeBearer;
    return self;
}

- (instancetype)withClientAuth {
    self.authType = AuthTypeClient;
    return self;
}

#pragma mark - Requests

- (void)get:(RestifizerCompletion)completion {
    self.requestType = RequestTypeGet;
    self.parameters = nil;
    self.completion = completion;
    
    [self executeRequest];
}
- (void)post:(NSDictionary*)parameters completion:(RestifizerCompletion)completion {
    self.requestType = RequestTypePost;
    self.parameters = parameters;
    self.completion = completion;
    
    [self executeRequest];
}
- (void)put:(NSDictionary*)parameters completion:(RestifizerCompletion)completion {
    self.requestType = RequestTypePut;
    self.parameters = parameters;
    self.completion = completion;
    
    [self executeRequest];
}
- (void)patch:(NSDictionary*)parameters completion:(RestifizerCompletion)completion {
    self.requestType = RequestTypePatch;
    self.parameters = parameters;
    self.completion = completion;
    
    [self executeRequest];
}
- (void)del:(NSDictionary*)parameters completion:(RestifizerCompletion)completion {
    self.requestType = RequestTypeDelete;
    self.parameters = parameters;
    self.completion = completion;
    
    [self executeRequest];
}

#pragma mark - Private Methods

- (void)executeRequest {
    self.urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.path]];
    
    // Method
    self.urlRequest.HTTPMethod = authTypeNames[@(self.requestType)];
    
    // Authorization
    NSString *authString;
    switch(self.authType) {
        case AuthTypeClient:
            authString = [NSString stringWithFormat:@"Basic %@", self.authParams.encodedBasicAuth];
            [self.urlRequest setValue:authString forHTTPHeaderField:@"Authorization"];
            break;
        case AuthTypeBearer:
            authString = [NSString stringWithFormat:@"Bearer %@", self.authParams.accessToken];
            [self.urlRequest setValue:authString forHTTPHeaderField:@"Authorization"];
            break;
        default:
            break;
    }
    
    // Parameters
    NSError *error;
    NSData *parametersData = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    self.urlRequest.HTTPBody = parametersData;

    self.connection = [[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self startImmediately:true];
}

#pragma mark - Supporting methods

- (instancetype)withTag:(NSString *)tag {
    self.tag = tag;
    
    return self;
}

- (instancetype)one:(NSString *)objectId {

    self.path = [NSString stringWithFormat:@"%@/%@",self.path, objectId];
    self.fetchList = NO;
    
    return self;
}

- (instancetype)list:(NSString *)path {
    self.path = [self.path stringByAppendingPathComponent:path];
    self.fetchList = YES;
    
    return self;
}

- (instancetype)page:(NSInteger)pageNumber {
    self.pageNumber = pageNumber;
    
    return self;
}

- (instancetype)page:(NSInteger)pageNumber withPageSize:(NSInteger)pageSize {
    self.pageNumber = pageNumber;
    self.pageSize = pageSize;
    
    return self;
}

- (instancetype)definePageSize:(NSInteger)pageSize {
    self.pageSize = pageSize;
    
    return self;
}

- (instancetype)query:(NSString *)key value:(id)value {
    if (self.extraQuery == nil) {
        self.extraQuery = [[NSMutableDictionary alloc] init];
    }
    self.extraQuery[key] = value;
    
    return self;
}

- (instancetype)filter:(NSString *)key value:(id)value {
    return [self filter:key value:value quoted:[value isKindOfClass:[NSString class]]];
}

- (instancetype)filter:(NSString *)key value:(id)value quoted:(BOOL)quoted {
    if (self.filterParameters == nil) {
        self.filterParameters = [[NSMutableDictionary alloc] init];
    }
    
    if (quoted) {
        NSString *quotedValue = [NSString stringWithFormat:@"/%@/", value];
        self.filterParameters[key] = quotedValue;
    } else {
        self.filterParameters[key] = value;
    }
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.contentLength = response.expectedContentLength;
    self.contentData.length = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        self.statusCode = httpResponse.statusCode;
    }
    NSLog(@"Request started to fetch data from %@", self.urlRequest.URL);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.contentData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ((self.statusCode / 100) != 2) {
        NSError *error;
        NSObject *json = [NSJSONSerialization JSONObjectWithData:self.contentData options:0 error:&error];
        RestifizerError *restifizerError;
        if (error) {
            NSLog(@"%@", error);
            restifizerError = [[RestifizerError alloc] initWithError:error andStatusCode:self.statusCode];
        }
        RestifizerResponse *response = [[RestifizerResponse alloc] initWithRequest:self withContent:json andError:restifizerError];
        self.completion(response);
    } else {
        // Error
        RestifizerError *error = [[RestifizerError alloc] initWithError:nil andStatusCode:self.statusCode];
        RestifizerResponse *response = [[RestifizerResponse alloc] initWithRequest:self withContent:nil andError:error];
        self.completion(response);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    }
    RestifizerError *restError =[[RestifizerError alloc] initWithError:error andStatusCode:self.statusCode];
    RestifizerResponse *response = [[RestifizerResponse alloc] initWithRequest:self withContent:nil andError:restError];
    self.completion(response);
}

@end
