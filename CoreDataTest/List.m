//
//  List.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/24.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "List.h"

@implementation List

@dynamic index;
@dynamic groupType;

@dynamic listOwner;
@dynamic listElements;


- (NSArray *)sortedListElementsArray
{
    NSArray *result = nil;

    NSUInteger count = self.listElements.count;
    if (count == 0) {
        result = [NSArray arrayWithObject:self.listElements.anyObject];
    } else if (count > 1) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"index"
                                                                   ascending:YES];
        result = [self.listElements sortedArrayUsingDescriptors:@[descriptor]];
    }

    return result;
}

@end
