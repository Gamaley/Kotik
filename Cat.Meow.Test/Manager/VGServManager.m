//
//  VGServManager.m
//  Cat.Meow.Test
//
//  Created by Vladyslav on 26.10.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGServManager.h"
#import "AFNetworking.h"

static NSString* meow = @"http://random.cat/meow";
static NSString* postCat = @"https://api.parse.com/1/classes/Logs";

@interface VGServManager ()

@property (strong,nonatomic) NSString* catURLstr;

@end



@implementation VGServManager


+(VGServManager*) sharedManager {
    
    static VGServManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VGServManager alloc] init];
    });
    
    return manager;
}


-(void) postCat:(NSString*)cat onSuccess:(void(^)(NSURLResponse* responce)) success
               onFailure:(void(^)(NSError* error)) failure {
    
    NSURL* url = [NSURL URLWithString:@"https://api.parse.com/1/classes/Logs"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    [request setValue:@"JSON" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"wGuKBRFghDRy3K2JuL9IkCwBssmQ2K0qR2noI5Qx" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:@"qlAavQKuwnUeCl2L1FcCPUfMMkHJPL75cJjDLsQb" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSDictionary* dict = @{@"userID" : @"Vladyslav", @"catURL" : cat};
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //NSLog(@"%@", [request allHTTPHeaderFields]);
    
    NSURLSessionUploadTask* uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                success(response);
                
            } else {
                failure(error);
              
            }
        });
    }];
    
    [uploadTask resume];
    
    
}



-(void) getCatOnSuccess:(void(^)(NSString* cat)) success
              onFailure:(void(^)(NSError* error)) failure {
    
    
    NSURL* url = [NSURL URLWithString:meow];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        if (data) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString* dataStr = [dict objectForKey:@"file"];
            self.catURLstr = dataStr;
       
            success(dataStr);
        } else {
            failure(error);
        }
            
       });
    }];
  
    [dataTask resume];
    
    
    

//////////////////////////////////////////AFNetworking version GET\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    
    
  /*
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:meow parameters:nil success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObject) {
        
        NSString* catStr = [responseObject objectForKey:@"file"];
        
        NSLog(@"%@",responseObject);
        
        if (success) {
            success(catStr);
        }
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
  */
}

@end
