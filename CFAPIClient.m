//
//  CFAPIClient.m
//  ChineseFit
//
//

#import "CFAPIClient.h"

@implementation CFAPIClient

+(CFAPIClient *)sharedInstance {
    static CFAPIClient *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
       
        [sharedInstance registerHTTPOperationClass:[AFJSONRequestOperation class]];
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [sharedInstance setDefaultHeader:@"Accept" value:@"application/json"];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    });
    
    return sharedInstance;
}

+(CFAPIClient *)sharedInstanceWeiXin {
    static CFAPIClient *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
        
        [sharedInstance registerHTTPOperationClass:[AFJSONRequestOperation class]];
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [sharedInstance setDefaultHeader:@"Accept" value:@"application/json"];
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        [AFJSONRequestOperation acceptableContentTypes];
    });
    
    return sharedInstance;
}
-(void)requestWexinURL:(NSString *)url andMethod:(NSString *)method withPath:(NSString *)path withParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock
    {
        
        
        
        NSMutableURLRequest *request;
        if ([method isEqualToString:HTTPGETMETHOD]) {
            request = [self requestWithMethod:method path:path parameters:params];
        }else{
//            NSData* uploadFile = nil;
//            if ([params objectForKey:@"file"]) {
//                uploadFile = (NSData*)[params objectForKey:@"file"];
//                [params removeObjectForKey:@"file"];
//            }
//            request = [self multipartFormRequestWithMethod:method path:path parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//                if (uploadFile) {
//                    [formData appendPartWithFileData:uploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//                }
//            }];
            
            NSObject *uploadFile = nil;
            if ([params objectForKey:@"file"]) {
                uploadFile = [params objectForKey:@"file"];
            }
            request = [self multipartFormRequestWithMethod:method path:path parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                if (uploadFile) {
                    if ([uploadFile isKindOfClass:[NSData class]]) {
                        NSData *realUploadFile = (NSData *)uploadFile;
                        if (realUploadFile) {
                        [formData appendPartWithFileData:realUploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                        }
                    }else if([uploadFile isKindOfClass:[NSMutableArray class]] ||[uploadFile isKindOfClass:[NSArray class]]){
                        NSArray *uploadFileArray = (NSArray *)uploadFile;
                        if (uploadFileArray && uploadFileArray.count) {
                            for (NSData *realData in uploadFileArray) {
                                [formData appendPartWithFileData:realData name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                            }
                        }
                    }
                }
            }];
            
        }
        [request setTimeoutInterval:500];
        debugLog(@"request url %@",request.URL);
        NSURL *urlurl = [NSURL URLWithString:url];
        [request setURL:urlurl];;
        debugLog(@"request url %@",request.URL);
        
        AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
        }];
        

        [operation start];
        
    }


-(void)requestWithMethod:(NSString *)method withPath:(NSString *)path withParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSMutableURLRequest *request;
    if ([method isEqualToString:HTTPGETMETHOD]) {
        request = [self requestWithMethod:method path:path parameters:params];
    }else{
//        NSData* uploadFile = nil;
//        if ([params objectForKey:@"file"]) {
//            uploadFile = (NSData*)[params objectForKey:@"file"];
//            [params removeObjectForKey:@"file"];
//        }
//        request = [self multipartFormRequestWithMethod:method path:path parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//            if (uploadFile) {
//                [formData appendPartWithFileData:uploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//            }
//        }];
        NSObject *uploadFile = nil;
        if ([params objectForKey:@"file"]) {
            uploadFile = [params objectForKey:@"file"];
        }
        request = [self multipartFormRequestWithMethod:method path:path parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            if (uploadFile) {
                if ([uploadFile isKindOfClass:[NSData class]]) {
                    NSData *realUploadFile = (NSData *)uploadFile;
                    if (realUploadFile) {
                        [formData appendPartWithFileData:realUploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                    }
                }else if([uploadFile isKindOfClass:[NSMutableArray class]] ||[uploadFile isKindOfClass:[NSArray class]]){
                    NSArray *uploadFileArray = (NSArray *)uploadFile;
                    if (uploadFileArray && uploadFileArray.count) {
                        for (NSData *realData in uploadFileArray) {
                            [formData appendPartWithFileData:realData name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                        }
                    }
                }
            }
        }];
        
    }
    [request setTimeoutInterval:120];
    debugLog(@"request url %@",request.URL);
    NSLog(@"request=%@",request);
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [operation start];
    
}

- (void)downloadImageWithidentifier:(NSString *)identifier onCompletionBlock:(ImageResponseBlock)completionBlock
  {
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",kAPIHost,kAPIDownloadImage, identifier];
    
    AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] imageProcessingBlock:nil
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
        completionBlock(image);                                                   
    }failure:nil];
    [operation start];
}
// add by star by 20150506 for promote cover
-(void)downloadImageWithNoDownloadidentifier:(NSString *)identifier onCompletionBlock:(ImageResponseBlock)completionBlock{
    NSString* urlString = [NSString stringWithFormat:@"%@%@",kAPIHost, identifier];
    
    AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                          {
                                              completionBlock(image);
                                          }failure:nil];
    [operation start];
    
}// hsu jay
- (void)downloadImageWithidentifier2:(NSString *)identifier onCompletionBlock:(ImageResponseBlock)completionBlock
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",kAPIHost,kWEBGetHealthReport
, identifier];
    
    AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                          {
                                              completionBlock(image);
                                          }failure:nil];
    [operation start];
}


@end
