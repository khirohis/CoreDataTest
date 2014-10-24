//
//  ListElement.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/22.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <CoreData/CoreData.h>


@class ListOwner;
@class List;

@interface ListElement : NSManagedObject

@property (strong, nonatomic) NSNumber *elementId;
@property (strong, nonatomic) NSNumber *index;
@property (strong, nonatomic) NSNumber *groupType;
@property (strong, nonatomic) NSString *elementDescription;

@property (strong, nonatomic) List *list;
@property (strong, nonatomic) ListOwner *listOwner;

@end
