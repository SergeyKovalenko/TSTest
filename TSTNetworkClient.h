//
//  TSTNetworkClient.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/26/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TSTNetworkOperation;

typedef void(^TSTResponseBlock)(id <TSTNetworkOperation> operation, id response);
//typedef

@protocol TSTNetworkBackingFramework;

@protocol TSTNetworkOperation <NSObject>

- (void)cancel;

@end

@class TSTNetworkRequest;

@interface TSTNetworkClient : NSObject

- (id)initWithBackingFramework:(id <TSTNetworkBackingFramework>)backingFramework;

- (id <TSTNetworkOperation>)rawDataWithNetworkRequest:(TSTNetworkRequest *)reques
                                             response:(TSTResponseBlock)response
                                                error:(void(^)(id <TSTNetworkOperation> operation, id response, NSError *error))error;
@end
