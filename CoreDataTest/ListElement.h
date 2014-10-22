//
//  ListElement.h
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/22.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ListElement : NSManagedObject

@property (strong, nonatomic) NSNumber *groupType;
@property (strong, nonatomic) NSString *elementDescription;

@end
