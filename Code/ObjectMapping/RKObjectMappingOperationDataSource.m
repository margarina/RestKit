//
//  RKObjectMappingOperationDataSource.m
//  RestKit
//
//  Created by Blake Watters on 7/3/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RKObjectMappingOperationDataSource.h"
#import "../../../Social/WebService/BCWebServiceManager.h"

@implementation RKObjectMappingOperationDataSource

- (id)mappingOperation:(RKMappingOperation *)mappingOperation targetObjectForRepresentation:(NSDictionary *)representation withMapping:(RKObjectMapping *)mapping
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // TODO: Think on a better/cleaner solution.
    //    if ([representation respondsToSelector:@selector(objectForKey:)] && [representation objectForKey:@"__type"])
    //    {
    //        return [[BCWebServiceManager sharedInstance] objectForType:[representation objectForKey:@"__type"]];
    //    }

    // TODO: Cleanup/remove.
    if ([representation respondsToSelector:@selector(objectForKey:)] && [representation objectForKey:@"$type"])
    {
        NSString *entity = [representation objectForKey:@"$type"];
        NSArray *components = [entity componentsSeparatedByString:@","];
        if ([components count]>0)
        {
            entity = [components objectAtIndex:0];
        }
        components = [entity componentsSeparatedByString:@"."];
        if ([components count]>0)
        {
            entity = [components lastObject];
        }

        BCWebServiceManager *sharedManager = [BCWebServiceManager sharedInstance];

        if ([sharedManager customMappingEntity:entity])
        {
            id instance = [sharedManager classInstanceForEntity:entity];
            if (instance) {
                return instance;
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////

    return [mapping.objectClass new];
}

@end
