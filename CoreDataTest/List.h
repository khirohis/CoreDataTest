//
//  List.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/24.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ListElement;
@class ListOwner;

@interface List : NSManagedObject

@property (strong, nonatomic) NSNumber *index;
@property (strong, nonatomic) NSNumber *groupType;

@property (strong, nonatomic) ListOwner *listOwner;
@property (strong, nonatomic) NSSet *listElements;

- (NSArray *)sortedListElementsArray;

@end


@interface List (CoreDataGeneratedAccessors)

- (void)addListElementsObject:(ListElement *)value;
- (void)removeListElementsObject:(ListElement *)value;
- (void)addListElements:(NSSet *)values;
- (void)removeListElements:(NSSet *)values;

@end
