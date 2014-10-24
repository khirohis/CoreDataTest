//
//  ListOwner.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/24.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class List;
@class ListElement;

@interface ListOwner : NSObject

@property (strong, nonatomic) NSNumber *groupType;
@property (strong, nonatomic) ListElement *listElement;
@property (strong, nonatomic) NSSet *lists;

- (List *)firstList;

@end
