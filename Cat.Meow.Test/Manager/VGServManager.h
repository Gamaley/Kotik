//
//  VGServManager.h
//  Cat.Meow.Test
//
//  Created by Vladyslav on 26.10.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGServManager : NSObject

+(VGServManager*) sharedManager;

-(void) getCatOnSuccess:(void(^)(NSString* cat)) success onFailure:(void(^)(NSError* error)) failure;

-(void) postCat:(NSString*)cat onSuccess:(void(^)(NSURLResponse* responce)) success onFailure:(void(^)(NSError* error)) failure;
@end
