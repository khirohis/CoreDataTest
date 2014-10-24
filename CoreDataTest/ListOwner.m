//
//  ListOwner.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/24.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "ListOwner.h"

@implementation ListOwner

@dynamic groupType;
@dynamic listElement;
@dynamic lists;


- (List *)firstList
{
    NSUInteger count = self.lists.count;
    if (count == 1) {
        return [self.lists anyObject];
    } else if (count > 1) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"index"
                                                                   ascending:YES];
        NSArray *array = [self.lists sortedArrayUsingDescriptors:@[descriptor]];

        return [array objectAtIndex:0];
    }

    return nil;
}

@end
