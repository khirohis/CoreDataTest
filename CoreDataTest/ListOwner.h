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

@interface ListOwner : NSManagedObject

@property (strong, nonatomic) NSNumber *groupType;

@property (strong, nonatomic) ListElement *listElement;
@property (strong, nonatomic) NSSet *lists;

- (NSArray *)sortedListsArray;
- (List *)firstList;

@end


@interface ListOwner (CoreDataGeneratedAccessors)

- (void)addListsObject:(List *)value;
- (void)removeListsObject:(List *)value;
- (void)addLists:(NSSet *)values;
- (void)removeLists:(NSSet *)values;

@end
