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


- (NSArray *)sortedListsArray
{
    NSArray *result = nil;

    NSUInteger count = self.lists.count;
    if (count == 1) {
        result = [NSArray arrayWithObject:self.lists.anyObject];
    } else if (count > 1) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"index"
                                                                   ascending:YES];
        result = [self.lists sortedArrayUsingDescriptors:@[descriptor]];
    }

    return result;
}

- (List *)firstList
{
    NSArray *sortedList = [self sortedListsArray];
    if (sortedList != nil) {
        return [sortedList objectAtIndex:0];
    }

    return nil;
}

@end
