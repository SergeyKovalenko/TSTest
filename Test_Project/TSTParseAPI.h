//
//  TSTParseAPI.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/26/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSTNetworkClient.h"

@class TSTUser;

typedef void (^TSTParseAPICompletionHandler)(id response, NSError *error);

@interface TSTParseAPI : NSObject

+ (instancetype)api;

@end

@interface TSTParseAPI (Users)

- (id <TSTNetworkOperation>)registerNewUserWithUsername:(NSString *)username
                                               password:(NSString *)password
                                             completion:(TSTParseAPICompletionHandler)completion;

- (id <TSTNetworkOperation>)loginWithUsername:(NSString *)username
                                     password:(NSString *)password
                                   completion:(TSTParseAPICompletionHandler)completion;

- (id <TSTNetworkOperation>)updateUser:(TSTUser *)user
                            completion:(TSTParseAPICompletionHandler)completion;
@end
