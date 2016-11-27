//
//  CFAPIClient.h
//  ChineseFit
//
//  Created by Eason Feng on 13-8-12.
//  Copyright (c) 2013年 Eason Feng. All rights reserved.
//

#import "AFHTTPClient.h"


typedef void (^JSONResponseBlock) (NSDictionary* json);
typedef void (^ImageResponseBlock) (UIImage* image);

@interface CFAPIClient : AFHTTPClient

+(CFAPIClient *)sharedInstance;
+(CFAPIClient *)sharedInstanceWeiXin;
//send an API command to the server
-(void)requestWexinURL:(NSString *)url andMethod:(NSString *)method withPath:(NSString *)path withParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock;

-(void)requestWithMethod:(NSString*)method withPath:(NSString*)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

- (void)downloadImageWithidentifier:(NSString *)identifier onCompletionBlock:(ImageResponseBlock)completionBlock;
- (void)downloadImageWithNoDownloadidentifier:(NSString *) identifier onCompletionBlock:(ImageResponseBlock)completionBlock;
- (void)downloadImageWithidentifier2:(NSString *)identifier onCompletionBlock:(ImageResponseBlock)completionBlock;
@end
